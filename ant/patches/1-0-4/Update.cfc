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
This is an updater cfc for contentbox to version 1.0.4

Start Commit Hash:
End Commit Hash:



*/
component implements="contentbox.model.updates.IUpdate"{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="permissionService" 		inject="permissionService@cb";
	property name="roleService" 			inject="roleService@cb";
	property name="securityRuleService"		inject="securityRuleService@cb";

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

		/**
		Migrate Database FIRST



		*/

		ORMReload();

		/************************************** CREATE NEW SETTINGS *********************************************/

		try{
			transaction{
				// update permissions
				updatePermissions();
				// update AdminR Role
				updateAdmin();
				// update security rules
				securityRuleService.resetRules();
			}
		}
		catch(Any e){
			ORMClearSession();
			rethrow;
		}
	}

	function updatePermissions(){
		var perms = {
			"MODULES_ADMIN" = "Ability to manage ContentBox Modules"
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

	function updateAdmin(){
		var oRole = roleService.findWhere({role="Administrator"});
		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="MODULES_ADMIN"}) );
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}

}