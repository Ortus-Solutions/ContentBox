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
End Commit Hash: ae71470c7e644628f5a43f0288ec7fc570551979

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
		version = "1.5.6.ContentStoreMigration";
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
			
			// Migrate Custom HTML to ContentStore
			migrateCustomHTML();
			
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
		
	}
	
	/************************************** PRIVATE *********************************************/
	
	private function migrateCustomHTML(){
		// get author session
		var oAuthor = securityService.getAuthorSession();
		// get contentStoreService manually
		var contentStoreService = wirebox.getInstance( "ContentStoreService@cb" );

		// Update security rules from customHTML to contentStore
		var aRules = securityRuleService.getAll();
		for( var oRule in aRules ){
			if( findNoCase( "customHTML", oRule.getSecureList() ) ){
				oRule.setSecureList( replaceNoCase( oRule.getSecureList(), "customHTML", "contentStore", "all" ) );
			}
			if( findNoCase( "CUSTOMHTML", oRule.getPermissions() ) ){
				oRule.setPermissions( replaceNoCase( oRule.getPermissions(), "CUSTOMHTML", "CONTENTSTORE", "all" ) );
			}
			securityRuleService.save( oRule );
		}

		// Migrate customHTML to contentstore now
		var qAllContent = new Query(sql="select * from cb_customHTML" ).execute().getResult();
		for( var x=1; x lte qAllContent.recordCount; x++ ){
			// get actual author
			var thisAuthor = authorService.get( qAllContent.FK_authorid[ x ] );
			if( isNull( thisAuthor ) ){ thisAuthor = oAuthor; }
			
			// verify slug and if migrated, just continue.
			var thisContent = contentStoreService.findBySlug( qAllContent.slug[ x ], true );
			if( thisContent.isLoaded() ){
				log.info("Slug: #qAllContent.slug[ x ]# already migrated, skipping");
				continue;
			}
			
			// build contentStore
			var oContentStore = contentStoreService.new( properties={
				title = qAllContent.title[ x ],
				slug = qAllContent.slug[ x ],
				publishedDate = qAllContent.publishedDate[ x ],
				expireDate = qAllContent.expireDate[ x ],
				isPublished = qAllContent.isPublished[ x ],
				allowComments = false,
				passwordProtection='',
				description = qAllContent.description[ x ]
			} );
			oContentStore.setCreator( thisAuthor );
			oContentStore.addNewContentVersion(content=qAllContent.content[ x ],
									  		   changelog="Migrated Content",
									  		   author=thisAuthor);
			contentStoreService.saveContent( oContentStore );
			
			log.info("Slug: #qAllContent.slug[ x ]# migrated and saved.");
		}

	}
	
	/************************************** DB MIGRATION OPERATIONS *********************************************/
	
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