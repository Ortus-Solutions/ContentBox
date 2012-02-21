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
This is an updater cfc for contentbox
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
		
		/************************************** CREATE NEW SETTINGS *********************************************/
		
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
		settingService.saveAll( aSettings );	
		
		// update permissions
		updatePermissions();
		
		// update Editor role
		updateEditor();
		
		// update security rules
		securityRuleService.resetRules();
		
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
		permissionService.saveAll( allPerms );	
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
		roleService.save( oRole );
		
		return oRole;		
	}

}