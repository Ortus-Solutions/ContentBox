/**
********************************************************************************
* ContentBox - A Modular Content Platform
* Copyright 2012 by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Updater for 3.0.0 RC
* 
* DB Structure Changes Comment Below
* 
* Remove Interface for conversion from 3.0.0 -> 3.1.0
*
* ---
* Start Commit Hash: e1e8f96c1e8c56f852b7af057b9e55cdaa7caf22
*/
component {

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="permissionService" 		inject="permissionService@cb";
	property name="authorService"			inject="id:authorService@cb";
	property name="roleService" 			inject="roleService@cb";
	property name="securityRuleService"		inject="securityRuleService@cb";
	property name="pageService"				inject="pageService@cb";
	property name="contentService" 			inject="contentService@cb";
	property name="log"						inject="logbox:logger:{this}";
	property name="wirebox"					inject="wirebox";
	property name="coldbox"					inject="coldbox";
	property name="securityService" 		inject="id:securityService@cb";
	property name="flash"					inject="coldbox:flash";
	property name="cbMessagebox" 			inject="id:messagebox@cbmessagebox";

	/**
	* Constructor
	*/
	function init(){
		setting requestTimeout="999999";
		return this;
	}

	/**
	* On DI Complete
	*/
	function onDIComplete(){
		// setup update variables that are used globally
		variables.version 			= "3.1.0";
		variables.currentVersion 	= replace( variables.coldbox.getSetting( "modules" ).contentbox.version, ".", "", "all" );
		variables.thisPath			= getDirectoryFromPath( getMetadata( this ).path );
		variables.contentBoxPath 	= coldbox.getSetting( "modules" )[ "contentbox" ].path;
	}

	/**
	* pre installation:
	* This happens before file removals and file updates. Last chance before code changes.
	*/
	function preInstallation( required log ){
		try{

			arguments.log.append("About to begin #version# patching");

			arguments.log.append( "Finalized #version# preInstallation patching" );
		}
		catch(Any e){
			ORMClearSession();
			arguments.log.append( "Error doing #version# patch preInstallation. #e.message# #e.detail# #e.stacktrace#", e );
			rethrow;
		}

	}

	/**
	* post installation
	*/
	function postInstallation( required log ){
		try{
			// Make changes on disk take effect
			ORMCloseSession();
			ORMReload();

			// Update new settings
			updateSettings();
			// Update Permissions
			updatePermissions();
			// Update Roles with new permissions
			updateAdmin();
			updateEditor();

			// stop application
			applicationstop();
			// Log setup in flash + messagebox
			flash.put( "updateLog", arguments.log );
			cbMessagebox.info( "Update Applied!" );
			// Hard Redirect
			coldbox.setNextEvent( "cbadmin.autoupdates" );
			
		} catch( Any e ) {
			ORMClearSession();
			arguments.log.append( "Error doing #version# patch postInstallation. #e.message# #e.detail#", e );
			rethrow;
		}
	}

	/************************************** PRIVATE *********************************************/

	private function updateAdmin(){
		var oRole = roleService.findWhere( { role = "Administrator" } );
		// Create new Permissions
		var perms = [
			"MAINTENANCE_MODE_VIEWER"
		];

		// iterate and add
		for( var thisPermTitle in perms ){
			var local.thisPerm = permissionService.findWhere( { permission=thisPermTitle } );
			if( structKeyExists( local, "thisPerm" ) and !oRole.hasPermission( local.thisPerm ) ){
				oRole.addPermission( local.thisPerm );
				log.info( "Added #thisPermTitle# permission to admin role" );
			} else {
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
			"MAINTENANCE_MODE_VIEWER"
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
			"MAINTENANCE_MODE_VIEWER" = "Ability to view the Website front end, even while the site is in maintenance mode."
		};

		for( var key in perms ){
			addPermission( key, perms[ key ] );
		}
	}

	private function updateSettings(){
		// Add new settings
		//addSetting( "cb_site_settings_cache", "Template" );
		
		// Update ckeditor plugins
		var pluginList = listToArray( "justify,colorbutton,showblocks,find,div,smiley,specialchar,iframe" );
		var oldPluginsSetting = settingService.findWhere( { name="cb_editors_ckeditor_extraplugins" } );
		if( !isNull( oldPluginsSetting ) ){
			var aPlugins = listToArray( oldPluginsSetting.getValue() );
			// Verify the new plugin list
			for( var thisPlugin in pluginList ){
				if( !arrayFindNoCase( aPlugins, thisPlugin ) ){
					arrayAppend( aPlugins, thisPlugin );
				}
			}
			// Save new list
			oldPluginsSetting.setValue( arrayToList( aPlugins ) );
			settingService.save( entity=oldPluginsSetting );
		}
	}

	private function addPermission( permission, description ){
		var props = { permission=arguments.permission, description=arguments.description };
		// only add if not found
		if( isNull( permissionService.findWhere( { permission=props.permission } ) ) ){
			permissionService.save( entity=permissionService.new( properties=props ) );
			log.info( "Added #arguments.permission# permission" );
		} else {
			log.info( "Skipped #arguments.permission# permission addition as it was already in system" );
		}
	}

	private function addSetting( name, value ){
		var setting = settingService.findWhere( { name = arguments.name } );
		if( isNull( setting ) ){
			setting = settingService.new();
			setting.setValue( trim( arguments.value ) );
			setting.setName( arguments.name );
			settingService.save( entity=setting );
			log.info( "Added #arguments.name# setting" );
		} else {
			log.info( "Skipped #arguments.name# setting, already there" );
		}

		return this;
	}

	private function updateTimestampFields(){
		
		var tables = [
			"cb_author",
			"cb_category",
			"cb_comment",
			"cb_content",
			"cb_contentVersion",
			"cb_customfield",
			"cb_loginAttempts",
			"cb_menu",
			"cb_menuItem",
			"cb_module",
			"cb_permission",
			"cb_role",
			"cb_securityRule",
			"cb_setting",
			"cb_stats",
			"cb_subscribers",
			"cb_subscriptions"
		];

		for( var thisTable in tables ){
			var q = new Query( sql = "update #thisTable# set modifiedDate = :modifiedDate" );
			q.addParam( name="modifiedDate", value ="#createODBCDateTime( now() )#", cfsqltype="CF_SQL_TIMESTAMP" );
			var results = q.execute().getResult();
			log.info( "Update #thisTable# modified date", results );	
		}
		
		// Creation tables now
		tables = [
			"cb_category",
			"cb_customfield",
			"cb_menu",
			"cb_menuItem",
			"cb_module",
			"cb_permission",
			"cb_role",
			"cb_securityRule",
			"cb_setting",
			"cb_stats",
			"cb_subscribers"
		];
		for( var thisTable in tables ){
			var q = new Query( sql = "update #thisTable# set createdDate = :createdDate" );
			q.addParam( name="createdDate", value ="#createODBCDateTime( now() )#", cfsqltype="CF_SQL_TIMESTAMP" );
			var results = q.execute().getResult();
			log.info( "Update #thisTable# created date", results );	
		}
			
	}

	private function updateCKEditorPlugins(){
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
		if( structkeyexists( server, "lucee" ) || structKeyExists( server, "railo" ) ){
			return new DBInfo().getTableColumns( datasource=getDatasource(), table=arguments.table );
		}
		return new dbinfo( datasource=getDatasource(), table=arguments.table ).columns();
	}

	// Get the database type
	private function getDatabaseType(){
		if( structkeyexists( server, "lucee" ) || structKeyExists( server, "railo" ) ){
			return new DBInfo().getDatabaseType(datasource=getDatasource()).database_productName;
		}
		return new dbinfo(datasource=getDatasource()).version().database_productName;
	}

	// Get the default datasource
	private function getDatasource(){
		try{
			return new cborm.models.util.ORMUtilFactory().getORMUtil().getDefaultDatasource();
		} catch( any e ){
			return new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil().getDefaultDatasource();
		}
		
	}

}