/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Setting Service for contentbox
*/
component extends="cborm.models.VirtualEntityService" accessors="true" threadsafe singleton{

	// DI properties
	property name="cachebox" 		inject="cachebox";
	property name="moduleSettings"	inject="coldbox:setting:modules";
	property name="appMapping"		inject="coldbox:setting:appMapping";
	property name="requestService"	inject="coldbox:requestService";
	property name="dateUtil"        inject="DateUtil@cb";

	/**
	* The cache provider name to use for settings caching. Defaults to 'template' cache.
	* This can also be set in the global ContentBox settings page to any CacheBox cache.
	*/
	property name="cacheProviderName" default="template";

	/**
	* Constructor
	*/
	SettingService function init(){
		// init it
		super.init( entityName="cbSetting" );
		// load cache provider 
		loadCacheProviderName();
		
		return this;
	}

	/**
	* Retrieve a multi-tenant settings cache key
	*/
	string function getSettingsCacheKey(){
		return "cb-settings-#cgi.http_host#";
	}
	
	/**
	* Check if the installer and dsn creator modules are present
	*/
	struct function isInstallationPresent(){
		var results = { installer = false, dsncreator = false };
		
		if( structKeyExists( moduleSettings, "contentbox-installer" ) AND
		    directoryExists( moduleSettings[ "contentbox-installer" ].path ) ){
			results.installer = true;
		}
		
		if( structKeyExists( moduleSettings, "contentbox-dsncreator" ) AND
		    directoryExists( moduleSettings[ "contentbox-dsncreator" ].path ) ){
			results.dsncreator = true;
		}
		
		return results;
	}
	
	/**
	* Delete the installer module
	*/
	boolean function deleteInstaller(){
		if( structKeyExists( moduleSettings, "contentbox-installer" ) AND
		    directoryExists( moduleSettings[ "contentbox-installer" ].path ) ){
			directoryDelete( moduleSettings[ "contentbox-installer" ].path, true );
			return true;
		}
		return false;
	}
	
	/**
	* Delete the dsn creator module
	*/
	boolean function deleteDSNCreator(){
		if( structKeyExists( moduleSettings, "contentbox-dsncreator" ) AND
		    directoryExists( moduleSettings[ "contentbox-dsncreator" ].path ) ){
			directoryDelete( moduleSettings[ "contentbox-dsncreator" ].path, true );
			return true;
		}
		return false;
	}

	/**
	* Check if contentbox has been installed by checking if there are no settings and no cb_active ONLY
	*/
	boolean function isCBReady(){
		var thisCount = newCriteria()
			.isEq( "name", "cb_active" )
			.count();
		return( thisCount > 0 ? true : false );
	}

	/**
	* Mark cb as ready to serve
	*/
	function activateCB(){
		var s = new( properties={ name="cb_active", value="true" } );
		save( s );
		return this;
	}

	/**
	* Get a setting
	* @name The name of the seting
	* @defaultValue The default value if setting not found.
	*/
	function getSetting( required name, defaultValue ){
		var s = getAllSettings( asStruct=true );
		if( structKeyExists( s, arguments.name ) ){
			return s[ arguments.name ];
		}
		if( structKeyExists( arguments, "defaultValue" ) ){
			return arguments.defaultValue;
		}
		throw(
			message = "Setting #arguments.name# not found in settings collection",
			detail 	= "Registered settings are: #structKeyList(s)#",
			type 	= "contentbox.SettingService.SettingNotFound" 
		);
	}

	/**
	* Get all settings
	* @asStruct Indicator if we should return structs or array of objects
	* 
	* @return struct or array of objects
	*/
	function getAllSettings( boolean asStruct=false ){
		var cache 		= getSettingsCacheProvider();
		var cacheKey 	= getSettingsCacheKey();
		// retrieve all settings from cache
		var settings = cache.get( getSettingsCacheKey() );

		// found in cache?
		if( isNull( settings ) ){
			// not found, so query db
			var settings = list( sortOrder="name" );
			// cache them for 5 days, usually app timeout
			cache.set( cacheKey, settings, 7200 );
		}

		// convert to struct if a query, else return it.
		if( arguments.asStruct and isQuery( settings ) ){
			var s = {};
			for( var x=1; x lte settings.recordcount; x++ ){
				s[ settings.name[ x ] ] = settings.value[ x ];
			}
			return s;
		}

		return settings;
	}

	/**
	* This will store the incoming structure as the settings in cache.
	* Usually this method is used for major overrides.
	*/
	SettingService function storeSettings( struct settings ){
		// cache them for 5 days, usually app timeout
		getSettingsCacheProvider()
			.set( getSettingsCacheKey(), arguments.settings, 7200 );
		return this;
	}

	/**
	* flush settings cache for current multi-tenant host
	*/
	SettingService function flushSettingsCache(){
		// Clear out the settings cache
		getSettingsCacheProvider().clear( getSettingsCacheKey() );
		// Re-load cache provider name, in case user changed it
		loadCacheProviderName();
		return this;
	}

	/**
	* Bulk saving of options using a memento structure of options
	* This is usually done from the settings display manager
	* @memento The struct of settings
	*/
	SettingService function bulkSave( struct memento ){
		var settings 	= getAllSettings( asStruct=true );
		var oOption  	= "";
		var newOptions 	= [];

		// iterate over settings
		for( var key in settings ){
			// save only sent in setting keys
			if( structKeyExists( memento, key ) ){
				oOption = findWhere( { name=key } );
				oOption.setValue( memento[ key ] );
				arrayAppend( newOptions, oOption );
			}
		}

		// save new settings and flush cache
		saveAll( newOptions );
		flushSettingsCache();

		return this;
	}

	/**
	* Build file browser settings structure
	*/
	struct function buildFileBrowserSettings(){
		var cbSettings = getAllSettings(asStruct=true);
		var settings = {
			directoryRoot	= expandPath( cbSettings.cb_media_directoryRoot ),
			createFolders	= cbSettings.cb_media_createFolders,
			deleteStuff		= cbSettings.cb_media_allowDelete,
			allowDownload	= cbSettings.cb_media_allowDownloads,
			allowUploads	= cbSettings.cb_media_allowUploads,
			acceptMimeTypes	= cbSettings.cb_media_acceptMimeTypes,
			quickViewWidth	= cbSettings.cb_media_quickViewWidth,
			loadJQuery 		= false,
			useMediaPath	= true,
			html5uploads = {
				maxFileSize = cbSettings.cb_media_html5uploads_maxFileSize,
				maxFiles	= cbSettings.cb_media_html5uploads_maxFiles
			}
		};
		
		// Base MediaPath
		var mediaPath = ( len( AppMapping ) ? AppMapping : "" ) & "/";
		if( findNoCase( "index.cfm", requestService.getContext().getSESBaseURL() ) ){
			mediaPath = "index.cfm" & mediaPath;;
		}
		
		// add the entry point
		var entryPoint = moduleSettings[ "contentbox-ui" ].entryPoint;
		mediaPath &= ( len( entryPoint ) ? "#entryPoint#/" : "" ) & "__media";
		// Store it
		mediaPath = ( left( mediaPath,1 ) == '/' ? mediaPath : "/" & mediaPath );
		settings.mediaPath =mediaPath;
		
		return settings;
	}
	
	/**
	* setting search returns struct with keys [settings,count]
	*/
	struct function search( search="", max=0, offset=0, sortOrder="name asc" ){
		var results = {};
		// criteria queries
		var c = newCriteria();
		// Search Criteria	
		if( len(arguments.search) ){
			c.like( "name","%#arguments.search#%" );
		}
		// run criteria query and projections count
		results.count 		= c.count( "settingID" );
		results.settings 	= c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
								.list(offset=arguments.offset, max=arguments.max, sortOrder=sortOrder, asQuery=false);
		return results;
	}
	
	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		var c = newCriteria();
		
		return c.withProjections( property="settingID,name,value,createdDate,modifiedDate,isDeleted" )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder="name" );
			 
	}
	
	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile(required importFile, boolean override=false){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );
		
		if( !isJSON( data ) ){
			throw(message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
		}
		
		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );
		
	}
	
	/**
	* Import data from an array of structures of settings 
	*/
	string function importFromData(required importData, boolean override=false, importLog){
		var allSettings = [];
		
		// iterate and import
		for( var thisSetting in arguments.importData ){
			var args = { name = thisSetting.name };
			var oSetting = findWhere( criteria=args );

			// date cleanups, just in case.
			var badDateRegex  	= " -\d{4}$";
			thisSetting.createdDate 	= reReplace( thisSetting.createdDate, badDateRegex, "" );
			thisSetting.modifiedDate 	= reReplace( thisSetting.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisSetting.createdDate 	= dateUtil.epochToLocal( thisSetting.createdDate );
			thisSetting.modifiedDate 	= dateUtil.epochToLocal( thisSetting.modifiedDate );

			// if null, then create it
			if( isNull( oSetting ) ){
				var args = { 
					name 			= thisSetting.name, 
					value 			= javaCast( "string", thisSetting.value ),
					createdDate 	= thisSetting.createdDate,
					modifiedDate 	= thisSetting.modifiedDate,
					isDeleted 		= thisSetting.isDeleted
				};
				arrayAppend( allSettings, new( properties=args ) );
				// logs
				importLog.append( "New setting imported: #thisSetting.name#<br>" );
			}
			// else only override if true
			else if( arguments.override ){
				oSetting.setValue( javaCast( "string", thisSetting.value ) );
				oSetting.setIsDeleted( thisSetting.isDeleted );
				arrayAppend( allSettings, oSetting );
				importLog.append( "Overriding setting: #thisSetting.name#<br>" );
			} else {
				importLog.append( "Skipping setting: #thisSetting.name#<br>" );
			}
		}
		
		// Save them?
		if( arrayLen( allSettings ) ){
			saveAll( allSettings );
			importLog.append( "Saved all imported and overriden settings!" );
		} else {
			importLog.append( "No settings imported as none where found or able to be overriden from the import file." );
		}
		
		return importLog.toString(); 
	}

	/**
	* Get the cache provider object to be used for settings
	* @return coldbox.system.cache.ICacheProvider
	*/
	function getSettingsCacheProvider(){
		// Return the cache to use
		return cacheBox.getCache( variables.cacheProviderName );
	}

	/******************************** PRIVATE ************************************************/

	/**
	* Load the cache provider name from DB or default value
	*/
	private SettingService function loadCacheProviderName(){
		// query db for cache name
		var oProvider = newCriteria()
			.isEq( "name", "cb_site_settings_cache" )
			.get();
		// Check if setting in DB already, else default it
		if( !isNull( cacheProvider ) ){
			variables.cacheProviderName = oProvider.getValue();
		} else {
			// default cache provider name
			variables.cacheProviderName = "template";
		}
		return this;
	}

}
