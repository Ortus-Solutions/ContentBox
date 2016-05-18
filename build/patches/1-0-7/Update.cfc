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
This is an updater cfc for contentbox to version 1.0.5

Start Commit Hash: 779c3f3
End Commit Hash: 3b9db0f

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
		return this;
	}

	/**
	* pre installation
	*/
	function preInstallation(){

		try{
			transaction{
				/**
				Migrate Database FIRST
		
				// User Preferences
				ALTER TABLE cb_author ADD COLUMN preferences longtext NULL;
				*/
				log.info("About to beggin 1.0.7 patching");
				
				// Update User Preferences
				updateUserPreferences();
				
				// update settings
				updateSettings();
				
				log.info("Finalized 1.0.7 patching");
			}
		}
		catch(Any e){
			ORMClearSession();
			log.error("Error doing 1.0.7 patch preInstallation. #e.message# #e.detail#", e);
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
			log.error("Error doing 1.0.7 patch postInstallation. #e.message# #e.detail#", e);
			rethrow;
		}
	}
	
	private function updateUserPreferences(){
		// Ensure column exists?
		var colFound = false;
		var cols = new dbInfo(datasource=getDatasource(), table="cb_author").columns();
		for( var x=1; x lte cols.recordcount; x++ ){
			if( cols[ "column_name"][x] eq "preferences"){
				colFound = true;
			}
		}
		if( !colFound ){
			var q = new Query(datasource=getDatasource());
			q.setSQL( "ALTER TABLE cb_author ADD preferences #getLongTextColumn()# NULL;" );
			q.execute();
			
			log.info("Added column for user preferences");
		}
		else{
			log.info("Column for user preferences already in DB, skipping.");
		}
	}
	
	private function updateSettings(){
		// Create New setting
		var blogSetting = settingService.findWhere({name="cb_site_blog_entrypoint"});
		if( isNull(blogSetting) ){
			blogSetting = settingService.new();
			blogSetting.setValue( "blog" );
			blogSetting.setName( "cb_site_blog_entrypoint" );
			settingService.save(entity=blogSetting, transactional=false);
			log.info("Added blog entry point setting");
		}
		else{
			log.info("Skipped blog entry point setting, already there");
		}
	}
	
	private function getLongTextColumn(){
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

	private function getDatabaseType(){
		return new dbinfo(datasource=getDatasource()).version().database_productName;
	}
	
	private function getDatasource(){
		return new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil().getDefaultDatasource();
	}

}