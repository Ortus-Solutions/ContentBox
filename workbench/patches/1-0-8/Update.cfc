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
This is an updater cfc for contentbox to version 1.0.8 with some
cummulative fixes from the erroneous 1.0.7 release

Start Commit Hash: 779c3f3
End Commit Hash: c196e76

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
	property name="log"						inject="logbox:logger:{this}";

	function init(){
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){

		try{
			transaction{
				/**
				Migrate Database FIRST
		
				// User Preferences
				ALTER TABLE cb_author ADD COLUMN preferences longtext NULL;
				*/
				log.info("About to beggin 1.0.8 patching");
				
				log.info("Finalized 1.0.8 patching");
			}
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing 1.0.8 patch preInstallation. #e.message# #e.detail#", e);
			rethrow;
		}

	}

	/**
	* post installation
	*/
	function postInstallation(){
		try{
			transaction{

			}
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing 1.0.8 patch postInstallation. #e.message# #e.detail#", e);
			rethrow;
		}
	}

}