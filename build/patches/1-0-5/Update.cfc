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
This is an updater cfc for contentbox to version 1.0.5

Start Commit Hash: cdb2386
End Commit Hash: 1d30a65

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
				if( !directoryExists( destWidgets ) ){
					directoryCreate( destWidgets );
				}
				fileUtils.directoryCopy(source=srcWidgets, destination=destWidgets);
				// Remove old widgets
				directoryDelete( srcWidgets, true );

				// Copy layouts to new location
				var srcLayouts 	= coldbox.getSetting("modules")["contentbox-ui"].path & "/layouts";
				var destLayouts = coldbox.getSetting("modules")["contentbox"].path & "/layouts";
				if( !directoryExists( destLayouts ) ){
					directoryCreate( destLayouts );
				}
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

		/************************************** CREATE NEW SETTINGS *********************************************/

		try{
			transaction{

				// Process patches migrations
				var srcUpdates 	= coldbox.getSetting("modules")["contentbox"].path & "/model/updates/patches";
				var destUpdates = coldbox.getSetting("modules")["contentbox"].path & "/updates";
				if( !directoryExists( destUpdates ) ){
					directoryCreate( destUpdates );
				}
				fileUtils.directoryCopy(source=srcUpdates, destination=destUpdates);
				directoryDelete( srcUpdates, true );

				// update new settings
				updateSettings();
				// update permissions
				updatePermissions();
				// update roles
				updateRoles();
				// update security rules
				securityRuleService.resetRules();

			}
		}
		catch(Any e){
			ORMClearSession();
			rethrow;
		}
	}

	function updateSettings(){
		// Create New Settings
		var settings = {
			"cb_versions_max_history" = ""
		};

		// Create setting objects and save
		var aSettings = [];
		for(var key in settings){
			var props = {name=key,value=settings[key]};

			if( isNull( settingService.findWhere({name=props.name}) ) ){
				arrayAppend( aSettings, settingService.new(properties=props) );
			}
		}

		if( arrayLen( aSettings ) ){
			// save search settings
			settingService.saveAll(entities=aSettings,transactional=false);
		}
	}

	function updatePermissions(){
		var perms = {
			"CONTENTBOX_ADMIN" = "Access to the enter the ContentBox administrator console"
		};

		var allperms = [];
		for(var key in perms){
			var props = {permission=key, description=perms[key]};

			if( isNull( permissionService.findWhere({permission=props.permission}) ) ){
				permissions[ key ] = permissionService.new(properties=props);
				arrayAppend(allPerms, permissions[ key ] );
			}
		}
		permissionService.saveAll(entities=allPerms,transactional=false);
	}

	function updateRoles(){
		// update core roles
		var oRole = roleService.findWhere({role="Administrator"});
		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="CONTENTBOX_ADMIN"}) );
		// save role
		roleService.save(entity=oRole,transactional=false);

		// update core roles
		oRole = roleService.findWhere({role="Editor"});
		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="CONTENTBOX_ADMIN"}) );
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}


}