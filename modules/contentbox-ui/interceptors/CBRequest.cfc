/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages ContentBox UI Module Requests
*/
component extends="coldbox.system.Interceptor"{

	property name="settingService"  inject="id:settingService@cb";
	property name="CBHelper"  		inject="id:CBHelper@cb";

	/**
	* Configure CB Request
	*/
	function configure(){}

	/**
	* Fired on contentbox requests
	*/
	function preProcess( event, interceptData, buffer ) eventPattern="^contentbox-ui"{
		// Verify ContentBox installer has been ran?
		if( !settingService.isCBReady() ){
			setNextEvent( "cbInstaller" );
		}
		
		// Prepare UI Request
		CBHelper.prepareUIRequest();
	}

	/**
	* Fired on contentbox requests
	*/
	function postProcess(  event, interceptData, buffer ) eventPattern="^contentbox-ui"{
		// announce event
		announceInterception( "cbui_postRequest" );
	}

	/*
	* Renderer helper injection
	*/
	function afterInstanceCreation( event, interceptData, buffer ){
		// check for renderer instance only
		if( isInstanceOf( arguments.interceptData.target, "coldbox.system.web.Renderer" ) ){
			var prc = event.getCollection( private=true );
			// decorate it
			arguments.interceptData.target.cb 			= CBHelper;
			arguments.interceptData.target.$cbInject 	= variables.$cbInject;
			arguments.interceptData.target.$cbInject();
			// re-broadcast event
			announceInterception( 
				"cbui_onRendererDecoration",
				{ renderer=arguments.interceptData.target, CBHelper=arguments.interceptData.target.cb } 
			);
		}
	}

	/**
	* private inject
	*/
	function $cbinject(){
		variables.cb = this.cb;
	}

}