/**
* Manages ContentBox Requests
*/
component extends="coldbox.system.Interceptor"{

	property name="settingService"  inject="id:settingService@cb";

	/**
	* Configure CB Request
	*/
	function configure(){}

	/**
	* Fired on contentbox requests
	*/
	function preProcess(event, interceptData) eventPattern="^contentbox-ui"{
		var prc = event.getCollection(private=true);
		var rc	= event.getCollection();
		
		// Verify ContentBox installer has been ran?
		if( !settingService.isCBReady() ){
			setNextEvent('cbInstaller');
		}
		
		// store module root
		prc.cbRoot = event.getModuleRoot('contentbox-ui');
		// store module entry point
		prc.cbEntryPoint = getProperty("entryPoint");
		// store site entry point
		prc.cbAdminEntryPoint = getModuleSettings("contentbox-admin").entryPoint;
		// Place global cb options on scope
		prc.cbSettings = settingService.getAllSettings(asStruct=true);
		// Place layout on scope
		prc.cbLayout = prc.cbSettings.cb_site_layout;
		// Place layout root location
		prc.cbLayoutRoot = prc.cbRoot & "/layouts/" & prc.cbLayout;
		// Place widget root location
		prc.cbWidgetRoot = prc.cbRoot & "/plugins/widgets";
		// announce event
		announceInterception("cbui_preRequest");
	}

	/**
	* Fired on contentbox requests
	*/
	function postProcess(event, interceptData) eventPattern="^contentbox-ui"{
		var prc = event.getCollection(private=true);
		var rc	= event.getCollection();

		// announce event
		announceInterception("cbui_postRequest");
	}

	/*
	* Renderer helper injection
	*/
	function afterPluginCreation(event,interceptData){
		var prc = event.getCollection(private=true);
		// Only for contentbox-ui
		if( !event.getCurrentModule() eq "contentbox-ui" ){ return; }

		// check for renderer
		if( isInstanceOf(arguments.interceptData.oPlugin,"coldbox.system.plugins.Renderer") ){
			// decorate it
			arguments.interceptData.oPlugin.cb = getMyPlugin(plugin="CBHelper",module="contentbox");
			arguments.interceptData.oPlugin.$cbInject = variables.$cbInject;
			arguments.interceptData.oPlugin.$cbInject();
			// announce event
			announceInterception("cbui_onRendererDecoration",{renderer=arguments.interceptData.oPlugin,CBHelper=arguments.interceptData.oPlugin.cb});
		}
	}

	/**
	* private inject
	*/
	function $cbinject(){
		variables.cb = this.cb;
	}

}