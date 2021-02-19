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
	 * @siteId The site to store as the current working one
	 */
	SiteService function setCurrentWorkingSiteId( required siteId ){
		variables.cacheStorage.set( "adminCurrentSite", arguments.siteId );
		return this;
	}

	/**
	 * Get the current working site in the admin UI. We look in the cache first,
	 * if none is set, we use the `default` site.
	 */
	function getCurrentWorkingSiteId(){
		return variables.cacheStorage.get(
			name        : "adminCurrentSite",
			defaultValue: getDefaultSiteId()
		);
	}

	/**
	 * Get the current working site in the admin UI. We look in the cache first,
	 * if none is set, we use the `default` site.
	 */
	Site function getCurrentWorkingSite(){
		return newCriteria().isEq( "siteId", javacast( "int", getCurrentWorkingSiteId() ) ).get();
	}

	/**
	 * Get the default site Identifier
	 */
	string function getDefaultSiteId(){
		return newCriteria()
			.isEq( "slug", "default" )
			.withProjections( property: "siteId" )
			.get();
	}

	/**
	 * Get the default site object
	 */
	Site function getDefaultSite(){
		return newCriteria().isEq( "slug", "default" ).get();
	}

	/**
	 * Get an array/struct representation of all sites in the system
	 */
	array function getAllFlat(){
		return newCriteria()
			.withProjections( property: "siteId,name,slug,domainRegex" )
			.asStruct()
			.list( sortOrder = "name" );
	}

	/**
	 * Returns a collection of all the themes that are used in all active sites
	 *
	 * @return array of { activeTheme:string, siteId:numeric }
	 */
	array function getAllSiteThemes(){
		return newCriteria()
			.isFalse( "isDeleted" )
			.withProjections( distinct: "activeTheme,siteId" )
			.asStruct()
			.list( sortOrder = "siteId" );
	}

	/**
	 * Get an id or fail
	 *
	 * @id The identifier
	 *
	 * @throws EntityNotFound
	 */
	function getOrFail( required siteId ){
		var site = newCriteria().isEq( "siteId", javacast( "int", arguments.siteId ) ).get();

		if ( !isNull( site ) ) {
			return site;
		}

		throw(
			type   : "EntityNotFound",
			message: "No site with ID #arguments.siteId.toString()# found"
		);
	}

	/**
	 * This method discovers which site you are on and returns it depending on the following markers:
	 *
	 * - Are we in the admin, use the current working site
	 * - incoming `siteId` (rc)
	 * - incoming `siteSlug` (rc)
	 * - incoming header: `x-contentbox-site`
	 * - cgi.server_name
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

		// Do we have an incoming site header, which should contain the siteId
		var siteId = event.getValue( "siteId", event.getHTTPHeader( "x-contentbox-site", "" ) );
		if ( len( siteId ) ) {
			return getOrFail( siteId );
		}

		// Do we have an incoming siteSlug in the RC
		if ( event.valueExists( "siteSlug" ) ) {
			return newCriteria().isEq( "slug", event.getValue( "siteSlug" ) ).get();
		}

		// Try to discover using the requested full URL including host + path + query string for added flexibility
		var matchedSite = getAllFlat().filter( function( thisSite ){
			return reFindNoCase( thisSite[ "domainRegex" ], event.getFullUrl() );
		} );

		// Return the first matched site
		if ( arrayLen( matchedSite ) ) {
			return getOrFail( matchedSite[ 1 ][ "siteId" ] );
		}

		// Default to the default site
		return getDefaultSite();
	}

}
