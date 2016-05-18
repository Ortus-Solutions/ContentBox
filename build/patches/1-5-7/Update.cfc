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
Update for 1.5.6 release

DB Structure Changes


Start Commit Hash: 3aac5c50a512c893e774257c033c7e235863ad98
End Commit Hash: 5dda4f24d539c6d031cbb02fe15f2c94949de680

*/
component implements="contentbox.model.updates.IUpdate"{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="permissionService" 		inject="permissionService@cb";
	property name="authorService"			inject="id:authorService@cb";
	property name="roleService" 			inject="roleService@cb";
	property name="securityRuleService"		inject="securityRuleService@cb";
	property name="pageService"				inject="pageService@cb";
	property name="coldbox"					inject="coldbox";
	property name="fileUtils"				inject="coldbox:plugin:FileUtils";
	property name="log"						inject="logbox:logger:{this}";
	property name="contentService" 			inject="contentService@cb";
	property name="wirebox"					inject="wirebox";
	property name="securityService" 		inject="id:securityService@cb";
	
	function init(){
		version = "1.5.7";
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){
		var thisPath = getDirectoryFromPath( getMetadata( this ).path );
		try{
			var currentVersion = replace( coldbox.getSetting( "modules" ).contentbox.version, ".", "", "all" );
			
			log.info("About to begin #version# patching");
			
			// update CKEditor Plugins
			updateCKEditorPlugins();
			
			// Check for System Salt, else create it
			updateSalt();
			
			// Update security rules
			if( replace( currentVersion, ".", "", "all" )  LTE 152 ){
				securityRuleService.resetRules();	
			}
			// Update new settings
			updateSettings();
			// create caching directory
			var cacheDir = coldbox.getSetting("modules")["contentbox-admin"].path & "/includes/cache";
			if( !directoryExists( cacheDir ) ){
				directoryCreate( cacheDir );
			}
			// Update Content Creators
			updateContentCreators();
			
			// Update Permissions
			updatePermissions();
						
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
		var thisPath = getDirectoryFromPath( getMetadata( this ).path );
		try{
			// Make changes on disk take effect
			ORMREload();
			
			// Do a-la-carte mappings
			wirebox.getBinder().map("SystemUtil@cb").to( "coldbox.system.core.util.Util" );
			
			// Update custom HTML creators
			updateCustomHTML();
			
			// Update Editor
			updateEditor();
			// Update Admin
			updateAdmin();
			
			// Import new security rules
			securityRuleService.importFromFile( thisPath & "rules.json.cfm" );
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing #version# patch postInstallation. #e.message# #e.detail#", e);
			rethrow;
		}
	}
	
	/************************************** PRIVATE *********************************************/
	
	private function updateCKEditorPlugins(){
		// Update extra plugins
		var setting = settingService.findWhere( { name = "cb_editors_ckeditor_extraplugins" } );
		if( !isNull( setting ) ){
			var plugins = listToArray( setting.getValue() );
			// key bindings
			if( !arrayFindNoCase( plugins, "cbKeyBinding") ){
				arrayAppend( plugins, "cbKeyBinding" );
			}
			// Custom HTML replaced by content store
			var index = arrayFindNoCase( plugins, "cbCustomHTML" );
			if( index ){
				plugins[ index ] = "cbContentStore";
			}
			// save back
			setting.setValue( arrayToList( plugins ) );
			// save it
			settingService.save( entity=setting, transactional=false );
		}
		// Update Toolbars
		var setting = settingService.findWhere( { name = "cb_editors_ckeditor_toolbar" } );
		if( !isNull( setting ) ){
			var value = replaceNoCase( setting.getValue(), "cbCustomHTML", "cbContentStore", "all" );
			// save back
			setting.setValue( value );
			// save it
			settingService.save( entity=setting, transactional=false );
		}
		// Update Excerpt Toolbars
		var setting = settingService.findWhere( { name = "cb_editors_ckeditor_excerpt_toolbar" } );
		if( !isNull( setting ) ){
			var value = replaceNoCase( setting.getValue(), "cbCustomHTML", "cbContentStore", "all" );
			// save back
			setting.setValue( value );
		}
			
	}

	private function updateCustomHTML(){
		var oAuthor = securityService.getAuthorSession();
		
		// Update all content now with published info
		var qAllContent = new Query(sql="update cb_customHTML set publishedDate = :today" );
		qAllContent.addParam(name="today", value=dateFormat( now(), "mm-dd-yyyy" ), cfsqltype=getDateTimeDBType());
		qAllContent.execute();
		
		// Update all content now with logged in user
		qAllContent = new Query(sql="select contentID, FK_authorID from cb_customHTML" ).execute().getResult();
		for( var x=1; x lte qAllContent.recordCount; x++ ){
			// update author if none found in row
			if( !len( qAllContent.FK_authorID[ x ] ) ){
				var q = new Query(sql="update cb_customHTML set FK_authorid = :authorID where contentID = :contentID" );
				q.addParam(name="contentID", value=qAllContent.contentID[ x ], cfsqltype="numeric");
				q.addParam(name="authorID", value=oAuthor.getAuthorID(), cfsqltype="numeric");
				q.execute();
			}
		}
	}
	
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
		// Create new Permissions
		var perms = [
			"EDITORS_EDITOR_SELECTOR",
			"TOOLS_EXPORT",
			"MEDIAMANAGER_LIBRARY_SWITCHER"
		];
		// iterate and add
		for( var thisPermTitle in perms ){
			var local.thisPerm = permissionService.findWhere( {permission=thisPermTitle} );
			if( structKeyExists( local, "thisPerm" ) and !oRole.hasPermission( local.thisPerm ) ){ 
				oRole.addPermission( local.thisPerm ); 
				log.info("Added #thisPermTitle# permission to admin role");
			}			
		}
		
		// save role
		roleService.save(entity=oRole, transactional=false);

		return oRole;
	}
	
	private function updateEditor(){
		var oRole = roleService.findWhere({role="Editor"});
		// Create new Permissions
		var perms = [
			"EDITORS_EDITOR_SELECTOR",
			"CONTENTSTORE_EDITOR"
		];
		// iterate and add
		for( var thisPermTitle in perms ){
			var local.thisPerm = permissionService.findWhere( {permission=thisPermTitle} );
			if( structKeyExists( local, "thisPerm" ) and !oRole.hasPermission( local.thisPerm ) ){ 
				oRole.addPermission( local.thisPerm ); 
				log.info("Added #thisPermTitle# permission to editor role");
			}			
		}
		
		// Remove ADMIN Perm for Custom HTML	
		local.thisPerm = permissionService.findWhere({permission="CONTENTSTORE_ADMIN"});
		// Remove it
		if( structKeyExists(local, "thisPerm") ){
			oRole.removePermission( local.thisPerm );
		}
		
		// save role
		roleService.save(entity=oRole, transactional=false);

		return oRole;
	}
	
	private function updatePermissions(){
		
		// Create new Permissions
		var perms = {
			"EDITORS_EDITOR_SELECTOR" = "Ability to change the editor to another registered online editor",
			"TOOLS_EXPORT" = "Ability to export data from ContentBox",
			"CUSTOMHTML_EDITOR" = "Ability to manage custom HTML elements but not publish them",
			"MEDIAMANAGER_LIBRARY_SWITCHER" = "Ability to switch media manager libraries for management"
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
		permissionService.saveAll(entities=allPerms, transactional=false);
		
		// Update CustomHTML Permissions
		var perm = permissionService.findWhere( {permission="CUSTOMHTML_ADMIN"} );
		if( !isNull( perm ) ){
			perm.setPermission( "CONTENTSTORE_ADMIN" );
			perm.setDescription( "Ability to manage the content store, default is view only" );
			permissionService.save( entity=perm, transactional=false );
		}
		var perm = permissionService.findWhere( {permission="CUSTOMHTML_EDITOR"} );
		if( !isNull( perm ) ){
			perm.setPermission( "CONTENTSTORE_EDITOR" );
			perm.setDescription( "Ability to manage content store elements but not publish them" );
			permissionService.save( entity=perm, transactional=false );
		}
	}
	
	private function updateSalt(){
		// Create New setting if does not exist.
		addSetting( "cb_salt", hash( createUUID() & getTickCount() & now(), "SHA-512" ) );
	}
	
	private function updateSettings(){
		// Create New settings
		addSetting( "cb_media_provider", "CFContentMediaProvider" );
		addSetting( "cb_media_provider_caching", "true" );
		addSetting( "cb_dashboard_newsfeed", "http://www.gocontentbox.org/blog/rss" );
		addSetting( "cb_dashboard_newsfeed_count", "5" );
		addSetting( "cb_media_html5uploads_maxFileSize", "100" );
		addSetting( "cb_media_html5uploads_maxFiles", "25" );
		addSetting( "cb_page_excerpts", "false" );
		addSetting( "cb_content_uiexport", "true" );
		addSetting( "cb_dashboard_recentcontentstore", "5" );
		addSetting( "cb_admin_theme", "contentbox-default" );
		
		// Update contentstore settings
		var setting = settingService.findWhere( { name = "cb_customHTML_caching" } );
		if( !isNull( setting ) ){
			setting.setName( "cb_contentstore_caching" );
			settingService.save( entity=setting, transactional=false );
		}
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
		var cols = getTableColumns( arguments.table );
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
	
	// Get a DB specific datetime type
	private function getDateTimeDBType(){
		var dbType = getDatabaseType();

		switch( dbType ){
			case "PostgreSQL" : {
				return "cf_sql_timestamp";
			}
			case "MySQL" : {
				return "cf_sql_timestamp";
			}
			case "Microsoft SQL Server" : {
				return "cf_sql_date";
			}
			case "Oracle" :{
				return "cf_sql_timestamp";
			}
			default : {
				return "cf_sql_timestamp";
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
	
	// get Columns
	private function getTableColumns(required table){
		if( structkeyexists( server, "railo") ){
			return new RailoDBInfo().getTableColumns(datasource=getDatasource(), table=arguments.table);
		}
		return new dbinfo(datasource=getDatasource(), table=arguments.table).columns();
	}
	
	// Get the database type
	private function getDatabaseType(){
		if( structkeyexists( server, "railo") ){
			return new RailoDBInfo().getDatabaseType(datasource=getDatasource()).database_productName;
		}
		return new dbinfo(datasource=getDatasource()).version().database_productName;
	}
	
	// Get the default datasource
	private function getDatasource(){
		return new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil().getDefaultDatasource();
	}
}