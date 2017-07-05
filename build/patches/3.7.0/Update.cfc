/**
********************************************************************************
* ContentBox - A Modular Content Platform
* Copyright 2012 by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Updater for 3.7.0
*
* DB Structure Changes Comment Below
*
* Remove Interface for conversion from 3.X.X -> 3.7.0
*
* ---
* Start Commit Hash: 9bc15e16b76557af87c39b618fa331ceb0ef9372
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
		variables.version 				= "3.7.0";
		variables.currentVersion 		= replace( variables.coldbox.getSetting( "modules" ).contentbox.version, ".", "", "all" );
		variables.thisPath				= getDirectoryFromPath( getMetadata( this ).path );
		variables.appPath 				= coldbox.getSetting( "ApplicationPath" );
		variables.contentBoxPath 		= coldbox.getSetting( "modules" )[ "contentbox" ].path;
		variables.contentBoxAdmimPath 	= coldbox.getSetting( "modules" )[ "contentbox-admin" ].path;
		variables.contentBoxUIPath 		= coldbox.getSetting( "modules" )[ "contentbox-ui" ].path;
	}

	/**
	* pre installation:
	* This happens before file removals and file updates. Last chance before code changes.
	* @log java.lang.StringBuilder
	*/
	function preInstallation( required log ){
		try{

			arguments.log.append( "About to begin #variables.version# patching" );

			/****************************** MOVE ADMIN/UI INTO CONTENTBOX MODULES ******************************/

			// This is our new layout of modules

			if( !directoryExists( contentBoxPath & "/modules/contentbox-admin" ) ){
				directoryRename( contentBoxAdmimPath , contentBoxPath & "/modules/contentbox-admin" );
			}
			if( !directoryExists( contentBoxPath & "/modules/contentbox-ui" ) ){
				directoryRename( contentBoxUIPath , contentBoxPath & "/modules/contentbox-ui" );
			}

			/****************************** UPDATE SECURITY RULES ******************************/

			var aRules = securityRuleService.getAll();
			for( var oRule in aRules ){
				if( findNoCase( "AUTHOR_ADMIN", oRule.getPermissions() ) ){
					oRule.setSecureList( "^contentbox-admin:authors\\.(remove|removePermission|savePermission|doPasswordReset)" );
					securityRuleService.save( entity=oRule );
					arguments.log.append( "Updated author security rules" );
				}
			}

			arguments.log.append( "Finalized #variables.version# preInstallation patching" );
		} catch( Any e ) {
			ORMClearSession();
			arguments.log.append( "Error doing #variables.version# patch preInstallation. #e.message# #e.detail# #e.stacktrace#" );
			rethrow;
		}

	}

	/**
	* post installation
	* @log java.lang.StringBuilder
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

			// Log setup in flash + messagebox
			flash.put( "updateLog", arguments.log );

			savecontent variable="local.updateMessage"{
				writeOutput( "
					Update Applied Correctly! Please do the following manual actions:
					<ul>
						<li>Stop your CFML Engine</li>
						<li>Remove the folder or archive it: <code>/coldbox/system/modules_bak</code></li>
						<li>
							Remove the following folders if still on disk: <code>/modules/contentbox-admin, /modules/contentbox-ui</code>.
							These have now been migrated into the core folder: <code>/modules/contentbox/modules</code>
						</li>
						<li>
							Open your <code>Application.cfc</code> and look for the <code>this.mappings[ 'cborm' ]</code> definition and change the location to the code shown below:
							<br>
							<code>this.mappings[ '/cborm' ] = this.mappings[ '/contentbox-deps' ] & '/modules/cborm';</code>
						</li>
						<li>Start your CFML Engine</li>
						<li>Enjoy your update!</li>
					</ul>
				" );
			}

			// Update Application.cfc for ORM base
			try{
				var appCFC 			= fileRead( variables.appPath & "Application.cfc" );
				var ORMTarget 		= 'this.mappings[ "/coldbox" ] & "/system/modules/cborm";';
				var ORMNewTarget	= 'this.mappings[ "/contentbox" ] & "/modules/contentbox-deps/modules/cborm";';
				appCFC 				= replaceNoCase(
					appCFC,
					ORMTarget,
					ORMTarget
				);
			} catch( Any e ) {
				arguments.log.append( "Error auto-updating Application.cfc mappings, you will have to update it manually. #chr( 13 )#" );
			}

			// Move modules to backup for new dependency approach
			var modulesPath 	= expandPath( "/coldbox/system/modules" );
			var modulesBakPath 	= expandPath( "/coldbox/system" ) & "/modules_bak";
			if( directoryExists( expandPath( "/coldbox/system/modules" ) ) ){
				try{
					directoryRename( modulesPath , modulesBakPath );
					cbMessagebox.info( local.updateMessage );
				} catch( any e ){
					// If we failed, it might be a file lock nothing we can do here but stop the engine.
					cbMessagebox.info( local.updateMessage );
				}
			}

			// stop application
			applicationstop();

			// Hard Redirect
			coldbox.setNextEvent( "cbadmin.autoupdates" );

		} catch( Any e ) {
			ORMClearSession();
			arguments.log.append( "Error doing #variables.version# patch postInstallation. Details: #e.message# #e.detail# #chr( 13 )#" );
			arguments.log.append( "Stacktrace: #e.stacktrace# #chr( 13 )#" );
			arguments.log.append( "TagContext: #e.tagContext.toString()# #chr( 13 )#" );
			rethrow;
		}
	}

	/************************************** PRIVATE *********************************************/

	private function updateAdmin(){
		var oRole = roleService.findWhere( { role = "Administrator" } );
		// Create new Permissions
		var perms = [
			"MAINTENANCE_MODE_VIEWER",
			"EMAIL_TEMPLATE_ADMIN"
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
			"MAINTENANCE_MODE_VIEWER",
			"EMAIL_TEMPLATE_ADMIN"
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
			"MAINTENANCE_MODE_VIEWER" 		= "Ability to view the Website front end, even while the site is in maintenance mode.",
			"EMAIL_TEMPLATE_ADMIN"			= "Ability to admin and preview email templates"
		};

		for( var key in perms ){
			addPermission( key, perms[ key ] );
		}
	}

	private function updateSettings(){
		// Add new settings
		addSetting( "cb_site_sitemap", "true" );
		addSetting( "cb_site_adminbar", "true" );
		addSetting( "cb_security_rate_limiter_redirectURL", "" );
		addSetting( "cb_security_rate_limiter_logging", "true" );
		addSetting( "cb_security_min_password_length", "8" );

		// Update dashboard settings
		var oSetting = settingService.findWhere( { name="cb_dashboard_welcome_title" } );
		if( !isNull( oSetting ) ){
			oSetting.setValue( "Dashboard" );
			settingService.save( entity=oSetting );
		}

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

	private function addSetting( name, value, isCore=true ){
		var oSetting = settingService.findWhere( { name = arguments.name } );
		if( isNull( oSetting ) ){
			oSetting = settingService.new( {
				name 	= arguments.name,
				value 	= trim( arguments.value ),
				isCore 	= arguments.isCore
			} );
			settingService.save( entity=oSetting );
			log.info( "Added #arguments.name# setting" );
		} else {
			log.info( "Skipped #arguments.name# setting, already there" );
		}

		return this;
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
