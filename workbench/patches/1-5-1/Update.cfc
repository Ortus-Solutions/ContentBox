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
Update for 1.5.0 release

Start Commit Hash: 3aac5c50a512c893e774257c033c7e235863ad98
End Commit Hash: 6634006c7e10e55a2ad4f7978d7d891599625dd0

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
	property name="contentService" 			inject="contentService@cb";
	property name="wirebox"					inject="wirebox";
	
	function init(){
		version = "1.5.1";
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){

		try{
		
			log.info("About to begin #version# patching");
			
			updateSettings();
			
			// create caching directory
			var cacheDir = coldbox.getSetting("modules")["contentbox-admin"].path & "/includes/cache";
			if( !directoryExists( cacheDir ) ){
				directoryCreate( cacheDir );
			}
			
			// Update Content Creators
			updateContentCreators();
			
			// Clear singletons so they are rebuilt
			coldbox.setColdboxInitiated( false );
			
			log.info("Finalized #version# patching");
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing #version# patch preInstallation. #e.message# #e.detail# #e.stacktrace#", e);
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
	
	private function updateContentCreators(){
		// get all content versions
		var qAllContent = new Query();
		qAllContent.setSQL("select distinct FK_authorID, FK_contentID from cb_contentVersion where isActive = 1");
		var qContent = qAllContent.execute().getResult();
			
		// Update creators	
		for(var x=1; x lte qContent.recordcount; x++ ){
			
			// check uthor not empty
			var authCheck = new Query(sql="SELECT FK_authorID FROM cb_content WHERE contentID = :contentID");
			authCheck.addParam(name="contentID", value=qContent.FK_contentID[ x ], cfsqltype="numeric");
			if( len( authCheck.execute().getResult().FK_authorID ) ){
				log.info("Skipping creator for content id #qContent.FK_contentID[ x ]# as it is already set.");
				continue;
			};
			
			var q = new Query();
			q.setSQL( "UPDATE cb_content SET FK_authorID = :authorID WHERE contentID = :contentID" );
			q.addParam(name="authorID", value=qContent.FK_authorID[ x ], cfsqltype="numeric");
			q.addParam(name="contentID", value=qContent.FK_contentID[ x ], cfsqltype="numeric");
			q.execute();
			log.info("Updated creator for content id #qContent.FK_contentID[ x ]#");
		}
	}
	
	private function updateAdmin(){
		var oRole = roleService.findWhere( { role = "Administrator" } );
		// Add in new permissions
		var thisPerm = permissionService.findWhere({permission="EDITORS_EDITOR_SELECTOR"});
		if( !oRole.hasPermission( thisPerm ) ){ oRole.addPermission( thisPerm ); }
		log.info("Added EDITORS_EDITOR_SELECTOR permission to admin role");
		// save role
		roleService.save(entity=oRole,transactional=false);

		return oRole;
	}
	
	private function updateEditor(){
		var oRole = roleService.findWhere({role="Editor"});
		// Add in new permissions
		var thisPerm = permissionService.findWhere({permission="EDITORS_EDITOR_SELECTOR"});
		if( !oRole.hasPermission( thisPerm ) ){ oRole.addPermission( thisPerm ); }
		log.info("Added EDITORS_EDITOR_SELECTOR permission to editor role");
		// save role
		roleService.save(entity=oRole, transactional=false);

		return oRole;
	}
	
	private function updatePermissions(){
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
		addSetting( "cb_media_provider", "CFContentMediaProvider" );
		addSetting( "cb_media_provider_caching", "true" );
		addSetting( "cb_dashboard_newsfeed", "http://www.gocontentbox.org/blog/rss" );
		addSetting( "cb_dashboard_newsfeed_count", "5" );
		addSetting( "cb_media_html5uploads_maxFileSize", "100" );
		addSetting( "cb_media_html5uploads_maxFiles", "25" );
	}
	
	private function addSetting(name, value){
		var setting = settingService.findWhere( { name = arguments.name } );
		if( isNull( setting ) ){
			setting = settingService.new();
			setting.setValue( trim( arguments.value ) );
			setting.setName( arguments.name );
			settingService.save(entity=setting, transactional=false);
			log.info("Added #arguments.name# setting");
		}
		else{
			log.info("Skipped #arguments.name# setting, already there");
		}
	}
	
	/************************************** DB MIGRATION OPERATIONS *********************************************/
	
	// Add a new column: type=[varchar, boolean, text]
	private function addColumn(required table, required column, required type, required limit, boolean nullable=false, defaultValue){
		if( !columnExists( arguments.table, arguments.column ) ){
			// Nullable string
			var sNullable = ( arguments.nullable ? "NULL" : "NOT NULL" );
			// Type String
			var sType = evaluate( "variables.get#arguments.type#DBType()" );
			// Default String
			var sDefault = "";
			if( structKeyExists( arguments, "defaultValue") ){
				// if null as default
				if( arguments.defaultValue eq "null" ){
					sDefault = " DEFAULT NULL";
				}
				// if boolean default value type
				else if( arguments.type eq "boolean" ){
					sDefault = " DEFAULT #( arguments.defaultValue ? 1 : 0 )#";
				}
				else{
					sDefault = " DEFAULT '#ReplaceNoCase( arguments.defaultValue, "'", "''" )#'";
				}
			}
			
			// Build SQL
			var q = new Query(datasource=getDatasource());
			q.setSQL( "ALTER TABLE #arguments.table# ADD #arguments.column# #arguments.type#(#arguments.limit#) #sNullable##sDefault#;" );
			q.execute();
			log.info("Added column: #arguments.column# to table: #arguments.table#");
		}
		else{
			log.info("Skipping adding column: #arguments.column# to table: #arguments.table# as it already existed");
		}
	}
	
	// Verify if a column exists
	private boolean function columnExists(required table, required column){
		var colFound = false;
		var cols = new dbInfo(datasource=getDatasource(), table=arguments.table).columns();
		for( var x=1; x lte cols.recordcount; x++ ){
			if( cols[ "column_name" ][ x ] eq arguments.column){
				colFound = true;
			}
		}
		return colFound;
	}
	
	// Get a DB specific varchar type
	private function getVarcharDBType(){
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
	
	// Get a DB specific long text type
	private function getTextDBType(){
		var dbType = getDatabaseType();
		
		switch( dbType ){
			case "PostgreSQL" : {
				return "text";
			}
			case "MySQL" : {
				return "longtext";
			}
			case "Microsoft SQL Server" : {
				return "ntext";
			}
			case "Oracle" :{
				return "clob";
			}
			default : {
				return "text";
			}
		}
	}
	
	// Get a DB specific boolean column
	private function getBooleanDBType(){
		var dbType = getDatabaseType();
		
		switch( dbType ){
			case "PostgreSQL" : {
				return "boolean";
			}
			case "MySQL" : {
				return "bit";
			}
			case "Microsoft SQL Server" : {
				return "tinyint";
			}
			case "Oracle" :{
				return "number";
			}
			default : {
				return "bit";
			}
		}
	}
	
	// Get the database type
	private function getDatabaseType(){
		return new dbinfo(datasource=getDatasource()).version().database_productName;
	}
	
	// Get the default datasource
	private function getDatasource(){
		return new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil().getDefaultDatasource();
	}
}