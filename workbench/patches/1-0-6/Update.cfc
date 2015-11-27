/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
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
This is an updater cfc for contentbox to version 1.0.6

Start Commit Hash: d4f587c
End Commit Hash: 62fb1cc

*/
component implements="contentbox.model.updates.IUpdate"{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="permissionService" 		inject="permissionService@cb";
	property name="roleService" 			inject="roleService@cb";
	property name="securityRuleService"		inject="securityRuleService@cb";
	property name="pageService"				inject="pageService@cb";
	property name="coldbox"					inject="coldbox";
	property name="fileUtils"				inject="coldbox:plugin:FileUtils";

	function init(){
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){
	}

	/**
	* post installation
	*/
	function postInstallation(){

		/************************************** CREATE/UPDATE SETTINGS *********************************************/

		try{
			transaction{

				// update settings
				updateSettings();

			}
		}
		catch(Any e){
			ORMClearSession();
			rethrow;
		}
	}

	function updateSettings(){
		// Create New Settings
		var mediaSetting = settingService.findWhere({name="cb_media_directoryRoot"});
		mediaSetting.setValue( "/contentbox/content" );
		settingService.save(entity=mediaSetting, transactional=false);
	}


}