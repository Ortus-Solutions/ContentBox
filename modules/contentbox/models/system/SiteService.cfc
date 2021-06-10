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
			super.save( arguments.site );

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

}
