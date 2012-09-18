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
This is an updater cfc for contentbox to version 1.0.5

Start Commit Hash: cdb2386
End Commit Hash: 1d30a65

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
				var q = new Query(datasource=getDatasource());
				q.setSQL( "ALTER TABLE cb_author ADD COLUMN preferences #getLongTextColumn()# NULL;" );
				q.execute();
				
				// update settings
				updateSettings();
			}
		}
		catch(Any e){
			ORMClearSession();
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
			rethrow;
		}
	}
	
	function updateSettings(){
		// Create New setting
		var blogSetting = settingService.findWhere({name="cb_site_blog_entrypoint"});
		blogSetting.setValue( "blog" );
		settingService.save(entity=blogSetting, transactional=false);
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
		return new coldbox.system.orm.hibernate.ORMUtilFactory().getORMUtil().getDefaultDatasource();
	}

}