/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage sites in ContentBox
 */
component
	extends  ="cborm.models.VirtualEntityService"
	accessors="true"
	threadsafe
	singleton
{

	// DI
	property name="cacheStorage" inject="cacheStorage@cbStorages";
	property name="cookieStorage" inject="cookieStorage@cbStorages";
	property name="requestStorage" inject="requestStorage@cbStorages";
	property name="loadedModules" inject="coldbox:setting:modules";
	property name="requestService" inject="coldbox:requestService";
	property name="settingService" inject="provider:settingService@contentbox";
	property name="categoryService" inject="provider:categoryService@contentbox";
	property name="contentService" inject="provider:contentService@contentbox";
	property name="menuService" inject="provider:menuService@contentbox";
	property name="themeService" inject="provider:themeService@contentbox";
	property name="mediaService" inject="provider:mediaService@contentbox";

	/**
	 * Constructor
	 */
	SiteService function init(){
		// init it
		super.init( entityName = "cbSite" );
		return this;
	}

	/**
	 * Store the current working site in the admin UI
	 *
	 * @siteID The site to store as the current working one
	 */
	SiteService function setCurrentWorkingsiteID( required siteID ){
		variables.cookieStorage.set(
			name   : "contentbox_admin_current_site",
			value  : arguments.siteID,
			expires: "never"
		);
		return this;
	}

	/**
	 * Get the current working site in the admin UI. We look in the cache first,
	 * if none is set, we use the `default` site.
	 */
	function getCurrentWorkingsiteID(){
		return variables.cookieStorage.get( name: "contentbox_admin_current_site", defaultValue: getDefaultsiteID() );
	}

	/**
	 * Get the current working site in the admin UI. We look in the cache first,
	 * if none is set, we use the `default` site.
	 */
	Site function getCurrentWorkingSite(){
		// Use request storage for acceleration
		return variables.requestStorage.getOrSet(
			name   : "contentbox-current-working-site",
			produce: function(){
				var oSite = newCriteria().isEq( "siteID", getCurrentWorkingsiteID() ).get();
				// Check if null, just in case
				return ( !isNull( oSite ) ? oSite : getDefaultSite() );
			}
		);
	}

	/**
	 * Get the default site Identifier
	 */
	string function getDefaultsiteID(){
		return newCriteria()
			.isEq( "slug", "default" )
			.withProjections( property: "siteID" )
			.get();
	}

	/**
	 * Save a site object in the system. If the site is a new site,
	 * we make sure all proper settings are created and configured.
	 *
	 * @site          A persisted or new site object
	 * @transactional Transaction the call or leave as is, useful for imports, bulk saves, etc.
	 */
	Site function save( required site, boolean transactional = true ){
		// Added this due to issue in CFML engines and mixed quuery+orm nested transactions. Remove once issue is fixed
		if ( arguments.transactional ) {
			transaction {
				_save( arguments.site );
			}
		} else {
			_save( arguments.site );
		}

		// flush cache to rebuild site settings
		variables.settingService.flushSettingsCache();

		return arguments.site;
	}

	/**
	 * Save operation called by the transactional `save()` method
	 * Due to transactional issues on Lucee
	 */
	private function _save( required site ){
		// Create all site settings if this is a new site
		if ( !arguments.site.isLoaded() ) {
			variables.settingService.saveAll(
				variables.settingService
					.getSiteSettingDefaults()
					.reduce( function( result, setting, value ){
						arguments.result.append(
							variables.settingService.new( {
								name   : arguments.setting,
								value  : trim( arguments.value ),
								isCore : true,
								site   : site
							} )
						);
						return arguments.result;
					}, [] )
			);
		}

		// Persist the site
		super.save( arguments.site );

		// Activate the site's theme
		variables.themeService.startupTheme( name: arguments.site.getActiveTheme(), site: arguments.site );

		// Create media root folder for the site
		ensureSiteMediaFolder( arguments.site );
	}

	/**
	 * This method makes sure the site has a media root folder by convention in the media library
	 * following the patter: /{root}/sites/{slug}
	 *
	 * @site The site to ensure the media directory for
	 *
	 * @return True if it created it, false if it already existed.
	 */
	boolean function ensureSiteMediaFolder( required site ){
		var siteRoot = variables.mediaService.getCoreMediaRoot( absolute: true ) & "/sites/" & arguments.site.getSlug();
		if ( !directoryExists( siteRoot ) ) {
			directoryCreate( siteRoot );
			return true;
		}
		return false;
	}

	/**
	 * Delete an entire site from the system
	 *
	 * @site The site to remove
	 */
	SiteService function delete( required site ){
		transaction {
			// If on Adobe, run hard deletes due to Hibernate issue with cascade on integration tests.
			if ( !server.keyExists( "lucee" ) ) {
				variables.settingService.deleteWhere( site: arguments.site );
				variables.contentService.deleteWhere( site: arguments.site );
				variables.categoryService.deleteWhere( site: arguments.site );
				variables.menuService.deleteWhere( site: arguments.site );
			}
			arguments.site
				.removeAllSettings()
				.removeAllEntries()
				.removeAllPages()
				.removeAllMenus()
				.removeAllContentStore()
				.removeAllCategories();

			// Now destroy the site
			super.delete( arguments.site );
		}

		return this;
	}

	/**
	 * Get the default site object
	 */
	Site function getDefaultSite(){
		return newCriteria().isEq( "slug", "default" ).get();
	}

	/**
	 * Get an array/struct representation of all sites in the system
	 *
	 * @isActive If passed, bind via this boolean flag
	 *
	 * @return array of { siteID,name,slug,domainRegex,isActive }
	 */
	array function getAllFlat( boolean isActive ){
		return newCriteria()
			.when( !isNull( arguments.isActive ), function( c ){
				arguments.c.isEq( "this.isActive", javacast( "boolean", isActive ) );
			} )
			.withProjections( property: "siteID,name,slug,domainRegex,isActive" )
			.asStruct()
			.list( sortOrder = "name" );
	}

	/**
	 * Returns a collection of all the themes that are used in all active sites
	 *
	 * @return array of { activeTheme:string, siteID:numeric }
	 */
	array function getAllSiteThemes(){
		return newCriteria()
			.isFalse( "isDeleted" )
			.withProjections( distinct: "activeTheme,siteID" )
			.asStruct()
			.list( sortOrder = "siteID" );
	}

	/**
	 * Get an id or fail
	 *
	 * @id The identifier
	 *
	 * @throws EntityNotFound
	 */
	function getOrFail( required siteID ){
		var site = newCriteria().isEq( "siteID", arguments.siteID ).get();

		if ( !isNull( site ) ) {
			return site;
		}

		throw( type: "EntityNotFound", message: "No site with ID #arguments.siteID.toString()# found" );
	}

	/**
	 * Get by slug or fail
	 *
	 * @slug The site slug
	 *
	 * @throws EntityNotFound
	 */
	function getBySlugOrFail( required slug ){
		var site = newCriteria().isEq( "slug", arguments.slug ).get();

		if ( !isNull( site ) ) {
			return site;
		}

		throw( type: "EntityNotFound", message: "No site with slug #arguments.slug.toString()# found" );
	}

	/**
	 * This method discovers which site you are on and returns it depending on the following markers:
	 *
	 * - Are we in the admin, use the current working site
	 * - incoming `siteID` (rc)
	 * - incoming `siteSlug` (rc)
	 * - incoming header: `x-contentbox-site`
	 * - full incoming url
	 *
	 * @return The site object
	 */
	Site function discoverSite(){
		var event = variables.requestService.getContext();

		// Are we in the admin?
		if (
			structKeyExists( variables.loadedModules, "contentbox-admin" )
			&&
			findNoCase( variables.loadedModules[ "contentbox-admin" ].entryPoint, event.getCurrentRoutedUrl() )
		) {
			return getCurrentWorkingSite();
		}

		// Do we have an incoming site header, which should contain the siteID
		// Verify the site is valid, else continue search
		var siteID = event.getValue( "siteID", event.getHTTPHeader( "x-contentbox-site", "" ) );
		if ( len( siteID ) ) {
			var oSite = newCriteria()
				.isEq( "siteID", siteID )
				.isTrue( "isActive" )
				.get();
			if ( !isNull( oSite ) ) {
				return oSite;
			}
		}

		// Do we have an incoming siteSlug in the RC
		// Verify the site is valid, else continue search
		if ( event.valueExists( "siteSlug" ) ) {
			var oSite = newCriteria()
				.isEq( "slug", event.getValue( "siteSlug" ) )
				.isTrue( "isActive" )
				.get();
			if ( !isNull( oSite ) ) {
				return oSite;
			}
		}

		// Try to discover using the requested full URL including host + path + query string for added flexibility
		// Verify the site is valid, else continue search
		var matchedSite = getAllFlat( isActive: true ).filter( function( thisSite ){
			return reFindNoCase( arguments.thisSite[ "domainRegex" ], event.getFullUrl() );
		} );

		// Return the first matched site
		if ( arrayLen( matchedSite ) ) {
			return getOrFail( matchedSite[ 1 ][ "siteID" ] );
		}

		// Default to the default site
		return getDefaultSite();
	}

	/**
	 * Get all sites for export
	 */
	function getAllForExport(){
		return getAll().map( function( thisItem ){
			return thisItem.getMemento( profile: "export" );
		} );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The json file to import
	 * @override   Override content if found in the database, defaults to false
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw( message: "Cannot import file as the contents is not JSON", type: "InvalidImportFormat" );
		}

		variables.logger.info( "Site import from file requested." );

		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures or a single structure of data
	 *
	 * @importData A struct or array of data to import
	 * @override   Override content if found in the database, defaults to false
	 * @importLog  The import log buffer
	 *
	 * @return The console log of the import
	 */
	string function importFromData(
		required any importData,
		boolean override = false,
		required any importLog
	){
		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		variables.logger.info( "+ Site import will try to import (#arrayLen( arguments.importData )#) sites." );

		transaction {
			// iterate and import
			for ( var thisSite in arguments.importData ) {
				var oSite = this.findBySlug( slug: thisSite.slug );
				oSite     = ( isNull( oSite ) ? new () : oSite );

				// if new or persisted with override then save.
				if ( !oSite.isLoaded() ) {
					variables.logger.info( "+ New site will be imported: #thisSite.slug#" );
					arguments.importLog.append( "New site will be imported: #thisSite.slug#<br>" );
					importSite(
						site     : oSite,
						memento  : thisSite,
						importLog: arguments.importLog,
						override : arguments.override
					);
				} else if ( oSite.isLoaded() and arguments.override ) {
					variables.logger.info( "+ Overidding site: #thisSite.slug#" );
					arguments.importLog.append( "Overriding site: #thisSite.slug#<br>" );
					importSite(
						site     : oSite,
						memento  : thisSite,
						importLog: arguments.importLog,
						override : arguments.override
					);
				} else {
					variables.logger.info( "!! Skipping persisted site: #thisSite.slug#" );
					arguments.importLog.append( "Skipping persisted site: #thisSite.slug#<br>" );
				}
			}
			// end import loop

			variables.logger.info( "√ Site import finalized!" );
			arguments.importLog.append( "√ Site import finalized!<br>" );
		}
		// end transaction

		// Rebuild Settings Cache
		variables.settingService.flushSettingsCache();

		return arguments.importLog.toString();
	}

	/**
	 * Import a site into ContentBox.
	 *
	 * @site      The site object that will be used to import
	 * @memento   The site memento that we will import
	 * @importLog The string buffer that represents the import log
	 * @override  Override content if found in the database, defaults to false
	 */
	function importSite(
		required site,
		required memento,
		required importLog,
		required override
	){
		// Setup logging function
		var logThis = function( message ){
			variables.logger.info( arguments.message );
			importLog.append( arguments.message & "<br>" );
		};

		transaction {
			// Aliases
			var oSite          = arguments.site;
			var siteData       = arguments.memento;
			var populator      = getBeanPopulator();
			// populate content from data and ignore relationships, we need to build those manually.
			var excludedFields = [
				"categories",
				"contentStore",
				"entries",
				"menus",
				"pages",
				"siteID",
				"settings"
			];
			populator.populateFromStruct(
				target               = oSite,
				memento              = siteData,
				exclude              = arrayToList( excludedFields ),
				composeRelationships = false
			);

			// Import Settings
			if ( oSite.isLoaded() ) {
				logThis( "!! Overriding site settings for #oSite.getSlug()#" );
				// If persisted, do cleanups
				// If on Adobe, run hard deletes due to Hibernate issue with cascade on integration tests.
				if ( !server.keyExists( "lucee" ) ) {
					variables.settingService.deleteWhere( site: oSite );
				}
				oSite.removeAllSettings();
			}
			oSite.setSettings(
				siteData.settings.map( function( thisSetting ){
					// Avoid the boolean casting to string of hell!!
					arguments.thisSetting.value = toString( arguments.thisSetting.value );
					logThis( "+ Importing setting: (#thisSetting.name#) to site #oSite.getSlug()#" );
					return populator
						.populateFromStruct(
							target               = variables.settingService.new(),
							memento              = thisSetting,
							exclude              = "site",
							composeRelationships = false
						)
						.setSite( oSite );
				} )
			);
			logThis( "+ Site settings for #oSite.getSlug()# imported." );

			// IMPORT CATEGORIES
			if ( arrayLen( siteData.categories ) ) {
				oSite.setCategories(
					siteData.categories.map( function( thisCategory ){
						logThis( "+ Importing category: (#thisCategory.slug#) to site #oSite.getSlug()#" );
						if ( oSite.isLoaded() ) {
							return variables.categoryService.getOrCreateBySlug(
								category: thisCategory.slug,
								site    : oSite
							);
						}
						return variables.categoryService.new( {
							category : arguments.thisCategory.category,
							slug     : arguments.thisCategory.slug,
							site     : oSite
						} );
					} )
				);
				logThis( "+ Site categories for #oSite.getSlug()# imported." );
			}

			// Note it for persistence so we can do the rest of the relationships
			this.save( oSite );
			logThis( "+ Site (#oSite.getSlug()#) saved to session, starting to import content now..." );

			// IMPORT MENUS
			if ( arrayLen( siteData.menus ) ) {
				logThis( "+ Importing menus (#arrayLen( siteData.menus )#) to site #arguments.site.getSlug()#" );
				getWireBox()
					.getInstance( "menuService@contentbox" )
					.importFromData(
						importData: siteData.menus,
						override  : arguments.override,
						importLog : arguments.importLog,
						site      : oSite
					);

				logThis( "+ Imported (#arrayLen( siteData.menus )#) menus to site #arguments.site.getSlug()#" );
			} else {
				logThis( "!! No menus found on import data, skipping..." );
			}

			// IMPORT ENTRIES
			if ( arrayLen( siteData.entries ) ) {
				logThis( "+ Importing entries (#arrayLen( siteData.entries )#) to site #arguments.site.getSlug()#" );
				getWireBox()
					.getInstance( "entryService@contentbox" )
					.importFromData(
						importData: siteData.entries,
						override  : arguments.override,
						importLog : arguments.importLog,
						site      : oSite
					);
				logThis( "+ Imported (#arrayLen( siteData.entries )#) entries to site #arguments.site.getSlug()#" );
			} else {
				logThis( "!! No entries found on import data, skipping..." );
			}

			// IMPORT PAGES
			if ( arrayLen( siteData.pages ) ) {
				logThis( "+ Importing pages (#arrayLen( siteData.pages )#) to site #arguments.site.getSlug()#" );
				getWireBox()
					.getInstance( "pageService@contentbox" )
					.importFromData(
						importData: siteData.pages,
						override  : arguments.override,
						importLog : arguments.importLog,
						site      : oSite
					);

				logThis( "+ Imported (#arrayLen( siteData.pages )#) pages to site #arguments.site.getSlug()#" );
			} else {
				logThis( "!! No pages found on import data, skipping..." );
			}

			// IMPORT CONTENT STORE
			if ( arrayLen( siteData.contentStore ) ) {
				logThis(
					"+ Importing contentStore (#arrayLen( siteData.contentStore )#) to site #arguments.site.getSlug()#"
				);
				getWireBox()
					.getInstance( "contentStoreService@contentbox" )
					.importFromData(
						importData: siteData.contentStore,
						override  : arguments.override,
						importLog : arguments.importLog,
						site      : oSite
					);

				logThis(
					"+ Imported (#arrayLen( siteData.contentStore )#) contentStore to site #arguments.site.getSlug()#"
				);
			} else {
				logThis( "!! No contentStore found on import data, skipping..." );
			}
		}
		// end site transaction
	}

}
