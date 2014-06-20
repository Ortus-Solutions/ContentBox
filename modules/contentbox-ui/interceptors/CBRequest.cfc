/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Manages ContentBox Requests
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
	function afterPluginCreation( event, interceptData, buffer ){
		var prc = event.getCollection(private=true);
		
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