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
		return newCriteria().isEq( "siteId", autoCast( "siteId", getCurrentWorkingSiteId() ) ).get();
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
	 * This method discovers which site you are on and returns it depending on the following markers:
	 * - incoming `siteSlug` (rc)
	 * - incoming header: `x-contentbox-site`
	 * - cgi.server_name
	 */
	function discoverSite(){
		return getDefaultSite();
	}

}
