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
This is an updater cfc for contentbox to version 1.0.3

Start Commit Hash: 38be608
End Commit Hash: 78df717

Update Your Application.cfc Manually:

// LOCATION MAPPINGS
this.mappings["/contentbox"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox";
this.mappings["/contentbox-ui"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox-ui";
this.mappings["/contentbox-admin"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox-admin";
this.mappings["/contentbox-modules"] = COLDBOX_APP_ROOT_PATH & "modules/contentbox-modules";
// THE LOCATION OF COLDBOX
this.mappings["/coldbox"] 	 = expandPath("/coldbox");

// CONTENTBOX ORM SETTINGS
this.ormEnabled = true;
this.ormSettings = {
	// ENTITY LOCATIONS, ADD MORE LOCATIONS AS YOU SEE FIT
	cfclocation=["model","/contentbox/model","/contentbox-modules"],
	// THE DIALECT OF YOUR DATABASE OR LET HIBERNATE FIGURE IT OUT, UP TO YOU
	//dialect 			= "MySQLwithInnoDB",
	// DO NOT REMOVE THE FOLLOWING LINE OR AUTO-UPDATES MIGHT FAIL.
	dbcreate = "update",
	// FILL OUT: IF YOU WANT CHANGE SECONDARY CACHE, PLEASE UPDATE HERE
	secondarycacheenabled = true,
	cacheprovider		= "ehCache",
	// ORM SESSION MANAGEMENT SETTINGS, DO NOT CHANGE
	logSQL 				= true,
	flushAtRequestEnd 	= false,
	autoManageSession	= false,
	// ORM EVENTS MUST BE TURNED ON FOR CONTENTBOX TO WORK
	eventHandling 		= true,
	eventHandler		= "modules.contentbox.model.system.EventHandler",
	// THIS IS ADDED SO OTHER CFML ENGINES CAN WORK WITH CONTENTBOX
	skipCFCWithError	= true
};

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

		// create new cb_contentCategories
		CREATE TABLE `cb_contentCategories` (
		  `FK_contentID` int(11) NOT NULL,
		  `FK_categoryID` int(11) NOT NULL,
		  KEY `FKD96A0F95F10ECD0` (`FK_categoryID`),
		  KEY `FKD96A0F9591F58374` (`FK_contentID`),
		  CONSTRAINT `FKD96A0F9591F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`),
		  CONSTRAINT `FKD96A0F95F10ECD0` FOREIGN KEY (`FK_categoryID`) REFERENCES `cb_category` (`categoryID`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		// Migrate previous blog categories into new content categories
		insert into cb_contentCategories select * from cb_entryCategories

		// Drop the table now
		drop table `cb_entryCategories`

		// Create new columns base content
		ALTER TABLE `cb_content` ADD COLUMN `cache` BIT NULL DEFAULT b'1';
		ALTER TABLE `cb_content` ADD COLUMN `cacheTimeout` INT NOT NULL DEFAULT 0;
		ALTER TABLE `cb_content` ADD COLUMN `cacheLastAccessTimeout` INT NOT NULL DEFAULT 0;
		ALTER TABLE `cb_content` ADD COLUMN `expireDate` datetime DEFAULT NULL,

		// Create indexes for those new columns
		CREATE INDEX `idx_expireDate` ON `cb_content`(`expireDate`);
		CREATE INDEX `idx_cache` ON `cb_content`(`cache`);
		CREATE INDEX `idx_cachetimeout` ON `cb_content`(`cacheTimeout`);
		CREATE INDEX `idx_cachelastaccesstimeout` ON `cb_content`(`cacheLastAccessTimeout`);

		*/

		ORMReload();

		/************************************** CREATE NEW SETTINGS *********************************************/

		try{
			transaction{
				// Create Search Settings
				var settings = {
					// Search Settings
					"cb_search_adapter" = "contentbox.model.search.DBSearch",
					"cb_search_maxResults" = "20",
					// site settings
					"cb_site_maintenance_message" = "<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>",
					"cb_site_maintenance" = "false",
					"cb_site_disable_blog" = "false",
					// Mail Settings
					"cb_site_mail_server" = "",
					"cb_site_mail_username" = "",
					"cb_site_mail_password" = "",
					"cb_site_mail_smtp" = "25",
					"cb_site_mail_tls" = "false",
					"cb_site_mail_ssl" = "false"
				};

				// Create setting objects and save
				var aSettings = [];
				for(var key in settings){
					var props = {name=key,value=settings[key]};
					arrayAppend( aSettings, settingService.new(properties=props) );
				}
				// save search settings
				settingService.saveAll(entities=aSettings,transactional=false);

				// update permissions
				updatePermissions();

				// update Editor role
				updateEditor();

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
			"PAGES_EDITOR" = "Ability to manage content pages but not publish pages",
			"ENTRIES_EDITOR" = "Ability to manage blog entries but not publish entries"
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

	function updateEditor(){
		// Create Editor
		var oRole = roleService.findWhere({role="Editor"});

		// remove permissions
		var adminperm  = permissionService.findWhere({permission="PAGES_ADMIN"});
		var adminperm2 = permissionService.findWhere({permission="ENTRIES_ADMIN"});

		oRole.removePermission( adminperm );
		oRole.removePermission( adminperm2 );

		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="PAGES_EDITOR"}) );
		oRole.addPermission( permissionService.findWhere({permission="ENTRIES_EDITOR"}) );

		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}

}