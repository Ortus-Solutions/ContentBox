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
Update for 1.6.0

DB Structure Changes


Start Commit Hash: 2169574b2273d57bbf8da8fc04df1d3a7c4b06c1
End Commit Hash: 23fb81a8de0a9fa95ec547d421769085926b8492

*/
component implements="contentbox.model.updates.IUpdate"{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="permissionService" 		inject="permissionService@cb";
	property name="authorService"			inject="id:authorService@cb";
	property name="roleService" 			inject="roleService@cb";
	property name="securityRuleService"		inject="securityRuleService@cb";
	property name="pageService"				inject="pageService@cb";
	property name="fileUtils"				inject="coldbox:plugin:FileUtils";
	property name="contentService" 			inject="contentService@cb";
	property name="log"						inject="logbox:logger:{this}";
	property name="wirebox"					inject="wirebox";
	property name="coldbox"					inject="coldbox";
	property name="securityService" 		inject="id:securityService@cb";
	
	/**
	* Constructor
	*/
	function init(){
		return this;
	}
	
	function onDIComplete(){
		// setup update variables.
		variables.version 			= "1.6.0";
		variables.currentVersion 	= replace( variables.coldbox.getSetting( "modules" ).contentbox.version, ".", "", "all" );
		variables.thisPath			= getDirectoryFromPath( getMetadata( this ).path );
	}

	/**
	* pre installation
	*/
	function preInstallation(){
		try{

			log.info("About to begin #version# patching");
			
			// Verify if less than 1.5.7 with message
			if( !isValidInstall() ){ return; }
			
			// Update new settings
			updateSettings();
			// Update Permissions
			updatePermissions();
			// Update Roles with new permissions
			updateAdmin();
			updateEditor();

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
			// Verify if less than 1.5.7 with message
			if( !isValidInstall() ){ return; }
			
			// Make changes on disk take effect
			ORMREload();
			
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing #version# patch postInstallation. #e.message# #e.detail#", e);
			rethrow;
		}
	}
	
	/************************************** PRIVATE *********************************************/
	
	private function isValidInstall(){
		// Verify if less than 1.5.7 with message
		if( replace( currentVersion, ".", "", "all" )  LT 157 ){
			log.info( "Cannot patch this installation until you upgrade to 1.5.7 first. You can find all of our patches here available for download: https://github.com/Ortus-Solutions/ContentBox/tree/master/workbench/patches. Then apply this patch." );
			return false;
		}
		return true;
	}
	
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

	private function updateAdmin(){
		var oRole = roleService.findWhere( { role = "Administrator" } );
		// Create new Permissions
		var perms = [
			"EDITORS_CUSTOM_FIELDS",
			"GLOBAL_SEARCH"
		];

		// iterate and add
		for( var thisPermTitle in perms ){
			var local.thisPerm = permissionService.findWhere( { permission=thisPermTitle } );
			if( structKeyExists( local, "thisPerm" ) and !oRole.hasPermission( local.thisPerm ) ){ 
				oRole.addPermission( local.thisPerm ); 
				log.info( "Added #thisPermTitle# permission to admin role" );
			}			
			else{
				log.info( "Skipped #thisPermTitle# permission to admin role" );
			}
		}
		
		// save role
		roleService.save( entity=oRole );

		return oRole;
	}
	
	private function updateEditor(){
		var oRole = roleService.findWhere({role="Editor"});
		
		// Setup Permissions
		var perms = [
			"EDITORS_CUSTOM_FIELDS",
			"GLOBAL_SEARCH"
		];

		// iterate and add
		for( var thisPermTitle in perms ){
			var local.thisPerm = permissionService.findWhere( {permission=thisPermTitle} );
			if( structKeyExists( local, "thisPerm" ) and !oRole.hasPermission( local.thisPerm ) ){ 
				oRole.addPermission( local.thisPerm ); 
				log.info("Added #thisPermTitle# permission to editor role");
			} else {
				log.info("Skipped #thisPermTitle# permission to editor role");
			}
		}
		
		// save role
		roleService.save( entity=oRole );

		return oRole;
	}
	
	private function updatePermissions(){
		
		// Create new Permissions
		var perms = {
			"EDITORS_CUSTOM_FIELDS" = "Ability to manage custom fields in any content editors",
			"GLOBAL_SEARCH" = "Ability to do global searches in the ContentBox Admin"
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
		permissionService.saveAll( entities=allPerms, transactional=false );
		
	}
	
	private function updateSettings(){
		// Create New settings
		addSetting( "cb_contentstore_caching", "true" );
		addSetting( "cb_notify_contentstore", "true" );
		addSetting( "cb_comments_moderation_expiration", "30" );
		addSetting( "cb_dashboard_welcome_title", "Welcome To Your ContentBox Dashboard" );
		addSetting( "cb_dashboard_welcome_body", "" );
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