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
	
	private function updateSettings(){
		// Create New setting
		var setting = settingService.findWhere({name="cb_admin_ssl"});
		if( isNull( setting ) ){
			setting = settingService.new();
			setting.setValue( "false" );
			setting.setName( "cb_admin_ssl" );
			settingService.save(entity=setting, transactional=false);
			log.info("Added cb_admin_ssl setting");
		}
		else{
			log.info("Skipped cb_admin_ssl setting, already there");
		}
		
		var setting = settingService.findWhere({name="cb_site_ssl"});
		if( isNull( setting ) ){
			setting = settingService.new();
			setting.setValue( "false" );
			setting.setName( "cb_site_ssl" );
			settingService.save(entity=setting, transactional=false);
			log.info("Added cb_site_ssl setting");
		}
		else{
			log.info("Skipped cb_site_ssl setting, already there");
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