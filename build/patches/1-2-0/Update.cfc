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
Update for 1.2.0 release

Start Commit Hash: 7609786c62bfdd5b0cc8df979a19e76d23fb2fde
End Commit Hash: e70e2c90c2c6b326e3618be42315a78b7894687a

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
				
				// Add Columns
				addColumn(table="cb_content", column="markup", type="varchar", limit="100", nullable=false, defaultValue="HTML");
				addColumn(table="cb_customHTML", column="markup", type="varchar", limit="100", nullable=false, defaultValue="HTML");
				
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
		addSetting( "cb_admin_ssl", "false" );
		addSetting( "cb_admin_quicksearch_max", "5" );
		addSetting( "cb_site_ssl", "false" );
		addSetting( "cb_versions_commit_mandatory", "false" );
		addSetting( "cb_editors_default", "ckeditor");
		addSetting( "cb_editors_markup", "HTML" );
		addSetting( "cb_editors_ckeditor_toolbar" , '[
{ "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
{ "name": "clipboard",   "items" : [ "Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo" ] },
{ "name": "editing",     "items" : [ "Find","Replace","SpellChecker"] },
{ "name": "forms",       "items" : [ "Form", "Checkbox", "Radio", "TextField", "Textarea", "Select", "Button","HiddenField" ] },
"/",
{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript","-","RemoveFormat" ] },
{ "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","-","Blockquote","CreateDiv","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock","-","BidiLtr","BidiRtl" ] },
{ "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
"/",
{ "name": "styles",      "items" : [ "Styles","Format" ] },
{ "name": "colors",      "items" : [ "TextColor","BGColor" ] },
{ "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar","Iframe","InsertPre"] },
{ "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbCustomHTML","cbLinks","cbEntryLinks" ] }
]' );
		addSetting( "cb_editors_ckeditor_excerpt_toolbar" , '
[
    { "name": "document",    "items" : [ "Source","ShowBlocks" ] },
    { "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript"] },
    { "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","CreateDiv"] },
    { "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
    { "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
    { "name": "contentbox",  "items" : [ "MediaEmbed","cbIpsumLorem","cbWidgets","cbCustomHTML","cbLinks","cbEntryLinks" ] }
]' );
		addSetting( "cb_editors_ckeditor_extraplugins", "cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbCustomHTML,cbIpsumLorem,wsc,mediaembed,insertpre" );


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