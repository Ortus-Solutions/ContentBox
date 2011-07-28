/**
* This simulates the onRequest start for the UI interface
*/
component extends="coldbox.system.Interceptor"{

	property name="settingService"  inject="id:settingService@bb";

	/**
	* Configure BB Request
	*/ 
	function configure(){}

	/**
	* Fired on blogbox requests
	*/
	function preProcess(event, interceptData) eventPattern="^blogbox-ui"{
		var prc = event.getCollection(private=true);
		var rc	= event.getCollection();
		
		// store module root	
		prc.bbRoot = event.getModuleRoot();
		// store module entry point
		prc.bbEntryPoint = getProperty("entryPoint");
		// Place global bb options on scope
		prc.bbSettings = settingService.getAllSettings(asStruct=true);
		// Place layout on scope
		prc.bbLayout = prc.bbSettings.bb_site_layout;
		// Place layout root location
		prc.bbLayoutRoot = prc.bbRoot & "/layouts/" & prc.bbLayout;
	}	
	
	/*
	* Renderer helper injection
	*/
	function afterPluginCreation(event,interceptData){
		var prc = event.getCollection(private=true);
		// Only for blogbox-ui
		if( !event.getCurrentModule() eq "blogbox-ui" ){ return; }
		
		// check for renderer
		if( isInstanceOf(arguments.interceptData.oPlugin,"coldbox.system.plugins.Renderer") ){
			// decorate it
			arguments.interceptData.oPlugin.bb = getMyPlugin(plugin="BBHelper",module="blogbox-ui");
			arguments.interceptData.oPlugin.includeUDF(prc.bbRoot & "/plugins/BBHelperInject.cfm");
		}		
	}
				
}