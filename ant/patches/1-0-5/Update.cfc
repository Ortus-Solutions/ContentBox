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
This is an updater cfc for contentbox to version 1.0.5

Start Commit Hash:
End Commit Hash:



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

		try{
			transaction{
				// Copy widgets to new location
				var srcWidgets 	= coldbox.getSetting("modules")["contentbox-ui"].PluginsPhysicalPath & "/widgets";
				var destWidgets = coldbox.getSetting("modules")["contentbox"].path & "/widgets";
				directoryCreate( destWidgets );
				fileUtils.directoryCopy(source=srcWidgets, destination=destWidgets);
				// Remove old widgets
				directoryDelete( srcWidgets, true );

				// Copy layouts to new location
				var srcLayouts 	= coldbox.getSetting("modules")["contentbox-ui"].path & "/layouts";
				var destLayouts = coldbox.getSetting("modules")["contentbox"].path & "/layouts";
				directoryCreate( destLayouts );
				fileUtils.directoryCopy(source=srcLayouts, destination=destLayouts);
				// Remove old layouts
				directoryDelete( srcLayouts, true );

				// Remove email templates
				var oldTemplates = coldbox.getSetting("modules")["contentbox"].path & "/views";
				directoryDelete( oldTemplates, true );

			}
		}
		catch(Any e){
			ORMClearSession();
			rethrow;
		}

	}

	/**
	* post installation
	*/
	function postInstallation(){

		/**
		Migrate Database FIRST

		// User biography notes
		ALTER TABLE cb_author ADD COLUMN biography text NULL;
		*/

		ORMReload();

		/************************************** CREATE NEW SETTINGS *********************************************/

		try{
			transaction{

			}
		}
		catch(Any e){
			ORMClearSession();
			rethrow;
		}
	}



}