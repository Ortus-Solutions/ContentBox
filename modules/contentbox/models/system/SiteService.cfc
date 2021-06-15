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
	property name="loadedModules" inject="coldbox:setting:modules";
	property name="requestService" inject="coldbox:requestService";
	property name="settingService" inject="provider:settingService@cb";
	property name="categoryService" inject="provider:categoryService@cb";
	property name="contentService" inject="provider:contentService@cb";
	property name="themeService" inject="provider:themeService@cb";
	property name="mediaService" inject="provider:mediaService@cb";

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
		variables.cacheStorage.set( "adminCurrentSite", arguments.siteID );
		return this;
	}

	/**
	 * Get the current working site in the admin UI. We look in the cache first,
	 * if none is set, we use the `default` site.
	 */
	function getCurrentWorkingsiteID(){
		return variables.cacheStorage.get(
			name        : "adminCurrentSite",
			defaultValue: getDefaultsiteID()
		);
	}

	/**
	 * Get the current working site in the admin UI. We look in the cache first,
	 * if none is set, we use the `default` site.
	 */
	Site function getCurrentWorkingSite(){
		return newCriteria().isEq( "siteID", getCurrentWorkingsiteID() ).get();
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
	 * @site A persisted or new site object
	 */
	Site function save( required site ){
		transaction {
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
							return result;
						}, [] )
				);
			}

			// Persist the site
			try {
				super.save( arguments.site );
			} catch ( any e ) {
				writeDump( var = arguments.site, top = 5 );
				abort;
			}

			// Activate the site's theme
			variables.themeService.startupTheme(
				name: arguments.site.getActiveTheme(),
				site: arguments.site
			);

			// Create media root folder
			ensureSiteMediaFolder( arguments.site );
		}
		// end transaction

		// flush cache to rebuild site settings
		variables.settingService.flushSettingsCache();

		return arguments.site;
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
			}
			arguments.site
				.removeAllSettings()
				.removeAllEntries()
				.removeAllPages()
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

		throw(
			type   : "EntityNotFound",
			message: "No site with ID #arguments.siteID.toString()# found"
		);
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

		throw(
			type   : "EntityNotFound",
			message: "No site with slug #arguments.slug.toString()# found"
		);
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
			findNoCase(
				variables.loadedModules[ "contentbox-admin" ].entryPoint,
				event.getCurrentRoutedUrl()
			)
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
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The json file to import
	 * @override Override content if found in the database, defaults to false
	 *
	 * @throws InvalidImportFormat
	 *
	 * @return The console log of the import
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw(
				message: "Cannot import file as the contents is not JSON",
				type   : "InvalidImportFormat"
			);
		}

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
	 * @override Override content if found in the database, defaults to false
	 * @importLog The import log buffer
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

		transaction {
			// iterate and import
			for ( var thisSite in arguments.importData ) {
				var oSite = this.findBySlug( slug: thisSite.slug );
				oSite     = ( isNull( oSite ) ? new () : oSite );

				// if new or persisted with override then save.
				if ( !oSite.isLoaded() ) {
					arguments.importLog.append( "New site will be imported: #thisSite.slug#<br>" );
					importSite(
						site     : oSite,
						memento  : thisSite,
						importLog: arguments.importLog
					);
				} else if ( oSite.isLoaded() and arguments.override ) {
					arguments.importLog.append( "Overiding site: #thisSite.slug#<br>" );
					importSite(
						site     : oSite,
						memento  : thisSite,
						importLog: arguments.importLog
					);
				} else {
					arguments.importLog.append( "Skipping persisted site: #thisSite.slug#<br>" );
				}
			}
			// end import loop

			// Final Report
			if ( arrayLen( arguments.importData ) ) {
				arguments.importLog.append( "Saved all imported and overriden content!" );
			} else {
				arguments.importLog.append(
					"No content imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end transaction

		return arguments.importLog.toString();
	}

	/**
	 * Import a site into ContentBox.
	 *
	 * @site The site object that will be used to import
	 * @memento The site memento that we will import
	 * @importLog The string buffer that represents the import log
	 */
	function importSite(
		required site,
		required memento,
		required importLog
	){
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

			// IMPORT CATEGORIES
			if ( arrayLen( siteData.categories ) ) {
				oSite.setCategories(
					siteData.categories.map( function( thisCategory ){
						if ( oSite.isLoaded() ) {
							return variables.categoryService.getOrCreateBySlug(
								category: thisCategory.slug,
								site    : oSite
							);
						}
						return variables.categoryService.new( {
							category : arguments.thisCategory.slug,
							slug     : arguments.thisCategory.slug,
							site     : oSite
						} );
					} )
				);
			}

			// Note it for persistence so we can do the rest of the relationships
			this.save( oSite );

			// IMPORT ENTRIES
			importSiteContentFromData(
				contentType: "entry",
				service    : getWireBox().getInstance( "entryService@cb" ),
				data       : siteData.entries,
				site       : oSite
			);

			// IMPORT PAGES
			importSiteContentFromData(
				contentType: "page",
				service    : getWireBox().getInstance( "pageService@cb" ),
				data       : siteData.pages,
				site       : oSite
			);

			// IMPORT CONTENTSTORE
			importSiteContentFromData(
				contentType: "contentstore",
				service    : getWireBox().getInstance( "contentStoreService@cb" ),
				data       : siteData.contentStore,
				site       : oSite
			);
		}
		// end site transaction
	}

	/**
	 * Import content objects from raw data
	 *
	 * @contentType The content type we are importing
	 * @service the content service
	 * @data The raw data struct
	 * @site The site we are importing into
	 */
	function importSiteContentFromData(
		required contentType,
		required service,
		required data,
		required site
	){
		arguments.data.each( function( thisContent ){
			var results = arguments.service.inflateFromStruct(
				contentData: arguments.thisContent,
				importLog  : arguments.importLog,
				site       : oSite
			);
			// continue to next record if author not found
			if ( !results.authorFound ) {
				return;
			}
			// if new or persisted with override then save.
			if ( !results.content.isLoaded() ) {
				arguments.importLog.append(
					"New #arguments.contentType# imported: #thisContent.slug#<br>"
				);
				entitySave( results.content );
			} else if ( inflatedResults.content.isLoaded() and arguments.override ) {
				arguments.importLog.append(
					"Persisted #arguments.contentType# overriden: #thisContent.slug#<br>"
				);
				entitySave( results.content );
			} else {
				arguments.importLog.append(
					"Skipping persisted #arguments.contentType#: #thisContent.slug#<br>"
				);
			}
		} );
		return this;
	}

}
