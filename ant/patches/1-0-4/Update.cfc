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

Start Commit Hash: 79c11db
End Commit Hash: 996f2c3



*/
component implements="contentbox.model.updates.IUpdate"{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="permissionService" 		inject="permissionService@cb";
	property name="roleService" 			inject="roleService@cb";
	property name="securityRuleService"		inject="securityRuleService@cb";
	property name="pageService"				inject="pageService@cb";

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

		// Modules Content
		CREATE TABLE `cb_module` (
		  `moduleID` int(11) NOT NULL AUTO_INCREMENT,
		  `name` varchar(255) NOT NULL,
		  `title` varchar(255) DEFAULT NULL,
		  `version` varchar(255) DEFAULT NULL,
		  `entryPoint` varchar(255) DEFAULT NULL,
		  `author` varchar(255) DEFAULT NULL,
		  `webURL` longtext,
		  `forgeBoxSlug` varchar(255) DEFAULT NULL,
		  `description` longtext,
		  `isActive` bit(1) NOT NULL DEFAULT b'0',
		  PRIMARY KEY (`moduleID`),
		  KEY `idx_active` (`isActive`),
		  KEY `idx_entryPoint` (`entryPoint`),
		  KEY `idx_moduleName` (`name`)
		) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

		// Cache layout bits
		ALTER TABLE cb_content ADD COLUMN cacheLayout BIT NULL DEFAULT b'1';
		CREATE INDEX idx_cachelayout ON cb_content(cacheLayout);

		// Create new columns custom HTML
		ALTER TABLE cb_customHTML ADD COLUMN cache BIT NULL DEFAULT b'1';
		ALTER TABLE cb_customHTML ADD COLUMN cacheTimeout INT NOT NULL DEFAULT 0;
		ALTER TABLE cb_customHTML ADD COLUMN cacheLastAccessTimeout INT NOT NULL DEFAULT 0;

		// Create indexes for those new columns
		CREATE INDEX idx_cache ON cb_customHTML(cache);
		CREATE INDEX idx_cachetimeout ON cb_customHTML(cacheTimeout);
		CREATE INDEX idx_cachelastaccesstimeout ON cb_customHTML(cacheLastAccessTimeout);



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
				// Update all page slugs to new format
				var allPages = pageService.getAll(sortOrder="parent");
				var slugMap = {};
				for(var thisPage in allPages){
					slugMap[ thisPage.getContentID() ] = reReplaceNoCase(thisPage.getRecursiveSlug(), "^\/","");
				}
				for(var thisSlug in slugMap){
					var newPage = pageService.get( thisSlug );
					newPage.setSlug( slugMap[thisSlug] );
					pageService.save( newPage );
				}
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