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
Update for 1.1.0 release

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
		version = "1.1.0";
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){

		try{
			transaction{

				log.info("About to beggin #version# patching");
				// update mobile layout column
				updateMobileLayout();
				// update settings
				updatePermissions();
				// update AdminR Role
				updateAdmin();
				// update Editor Role
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
	
	function updateAdmin(){
		var oRole = roleService.findWhere({role="Administrator"});
		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_DISPLAY_OPTIONS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_MODIFIERS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CACHING"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CATEGORIES"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_HTML_ATTRIBUTES"}) );
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}
	
	function updateEditor(){
		var oRole = roleService.findWhere({role="Editor"});
		// Add in new permissions
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_DISPLAY_OPTIONS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_MODIFIERS"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CACHING"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_CATEGORIES"}) );
		oRole.addPermission( permissionService.findWhere({permission="EDITORS_HTML_ATTRIBUTES"}) );
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}
	
	function updatePermissions(){
		var perms = {
			"EDITORS_DISPLAY_OPTIONS" = "Ability to view the content display options panel",
			"EDITORS_MODIFIERS" = "Ability to view the content modifiers panel",
			"EDITORS_CACHING" = "Ability to view the content caching panel",
			"EDITORS_CATEGORIES" = "Ability to view the content categories panel",
			"EDITORS_HTML_ATTRIBUTES" = "Ability to view the content HTML attributes panel"
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

	private function updateMobileLayout(){
		// Ensure column exists?
		var colFound = false;
		var cols = new dbInfo(datasource=getDatasource(), table="cb_page").columns();
		for( var x=1; x lte cols.recordcount; x++ ){
			if( cols[ "column_name"][x] eq "mobileLayout"){
				colFound = true;
			}
		}
		if( !colFound ){
			var q = new Query(datasource=getDatasource());
			q.setSQL( "ALTER TABLE cb_page ADD mobileLayout #getVarcharType()#(200) NULL;" );
			q.execute();
			
			log.info("Added column for page mobile layouts");
		}
		else{
			log.info("Column for page mobile layouts already in DB, skipping.");
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