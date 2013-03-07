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
Update for 1.2.0 release

Start Commit Hash: c4c67e7bdd9fb8c49a763b8192b38c66ae42b9c8
End Commit Hash: 975931815ac01691d8647c734f8c3f7c27250a81

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
		version = "1.2.0";
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){

		try{
			transaction{

				log.info("About to beggin #version# patching");
				
				updateSettings();
				updatePermissions();
				updateAdmin();
				updateEditor();
				
				log.info("Finalized #version# patching");
			}
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing #version# patch preInstallation. #e.message# #e.detail#", e);
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
			log.error("Error doing #version# patch postInstallation. #e.message# #e.detail#", e);
			rethrow;
		}
	}
	
	/************************************** PRIVATE *********************************************/
	
	function updateAdmin(){
		var oRole = roleService.findWhere( { role = "Administrator" } );
		// Add in new permissions
		var thisPerm = permissionService.findWhere({permission="EDITORS_EDITOR_SELECTOR"});
		if( !oRole.hasPermission( thisPerm ) ){ oRole.addPermission( thisPerm ); }
		log.info("Added EDITORS_EDITOR_SELECTOR permission to admin role");
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}
	
	function updateEditor(){
		var oRole = roleService.findWhere({role="Editor"});
		// Add in new permissions
		var thisPerm = permissionService.findWhere({permission="EDITORS_EDITOR_SELECTOR"});
		if( !oRole.hasPermission( thisPerm ) ){ oRole.addPermission( thisPerm ); }
		log.info("Added EDITORS_EDITOR_SELECTOR permission to editor role");
		// save role
		roleService.save(entity=oRole, transactional=false);

		return oRole;
	}
	
	function updatePermissions(){
		var perms = {
			"EDITORS_EDITOR_SELECTOR" = "Ability to change the editor to another registered online editor"
		};

		var allperms = [];
		for(var key in perms){
			var props = {permission=key, description=perms[ key ]};
			// only add if not found
			if( isNull( permissionService.findWhere( {permission=props.permission} ) ) ){
				permissions[ key ] = permissionService.new(properties=props);
				arrayAppend(allPerms, permissions[ key ] );
				log.info("Added #key# permission");
			}
			else{
				log.info("Skipped #key# permission addition as it was already in system");
			}
		}
		permissionService.saveAll(entities=allPerms,transactional=false);
	}
	
	private function updateSettings(){
		// Create New settings
		addSetting( "cb_admin_ssl", "false" );
		addSetting( "cb_site_ssl", "false" );
		addSetting( "cb_versions_commit_mandatory", "false" );
	}
	
	private function addSetting(name, value){
		var setting = settingService.findWhere({name=arguments.name});
		if( isNull( setting ) ){
			setting = settingService.new();
			setting.setValue( arguments.value );
			setting.setName( arguments.name );
			settingService.save(entity=setting, transactional=false);
			log.info("Added #arguments.name# setting");
		}
		else{
			log.info("Skipped #arguments.name# setting, already there");
		}
	}
	
	private function getVarcharType(){
		var dbType = getDatabaseType();
		
		switch( dbType ){
			case "PostgreSQL" : {
				return "varchar";
			}
			case "MySQL" : {
				return "varchar";
			}
			case "Microsoft SQL Server" : {
				return "varchar";
			}
			case "Oracle" :{
				return "varchar2";
			}
			default : {
				return "varchar";
			}
		}
	}
	
	private function getDatabaseType(){
		return new dbinfo(datasource=getDatasource()).version().database_productName;
	}
	
	private function getDatasource(){
		return new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil().getDefaultDatasource();
	}
}