/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I model a ContentBox site for multi-site support
 */
component
	persistent="true"
	entityname="cbSite"
	table     ="cb_site"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbSite"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							DI
	 ********************************************************************* */

	property
		name      ="contentService"
		inject    ="provider:contentService@contentbox"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="siteID"
		column   ="siteID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="name"
		column ="name"
		ormtype="string"
		notnull="true"
		length ="255"
		default="";

	property
		name   ="slug"
		column ="slug"
		ormtype="string"
		notnull="true"
		length ="255"
		unique ="true"
		default=""
		index  ="idx_siteSlug";

	property
		name   ="description"
		column ="description"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="keywords"
		column ="keywords"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="domain"
		column ="domain"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="domainRegex"
		column ="domainRegex"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="tagline"
		column ="tagline"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="homepage"
		column ="homepage"
		ormtype="string"
		notnull="false"
		default="cbBlog"
		length ="255";

	property
		name   ="isBlogEnabled"
		column ="isBlogEnabled"
		ormtype="boolean"
		notnull="true"
		default="true";

	property
		name   ="isSitemapEnabled"
		column ="isSitemapEnabled"
		ormtype="boolean"
		notnull="true"
		default="true";

	property
		name   ="poweredByHeader"
		column ="poweredByHeader"
		ormtype="boolean"
		notnull="true"
		default="true";

	property
		name   ="adminBar"
		column ="adminBar"
		ormtype="boolean"
		notnull="true"
		default="true";

	property
		name   ="isSSL"
		column ="isSSL"
		ormtype="boolean"
		notnull="true"
		default="false";

	property
		name   ="isActive"
		column ="isActive"
		ormtype="boolean"
		notnull="true"
		default="true";

	property
		name   ="activeTheme"
		column ="activeTheme"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="notificationEmails"
		column ="notificationEmails"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="notifyOnEntries"
		column ="notifyOnEntries"
		ormtype="boolean"
		notnull="true"
		default="true";

	property
		name   ="notifyOnPages"
		column ="notifyOnPages"
		ormtype="boolean"
		notnull="true"
		default="true";

	property
		name   ="notifyOnContentStore"
		column ="notifyOnContentStore"
		ormtype="boolean"
		notnull="true"
		default="true";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// O2M -> Settings
	property
		name        ="settings"
		singularName="setting"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		orderby     ="name"
		cfc         ="contentbox.models.system.Setting"
		fkcolumn    ="FK_siteID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> Categories
	property
		name        ="categories"
		singularName="category"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		orderby     ="slug"
		cfc         ="contentbox.models.content.Category"
		fkcolumn    ="FK_siteID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> Entries
	property
		name        ="entries"
		singularName="entry"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		orderby     ="createdDate desc"
		cfc         ="contentbox.models.content.Entry"
		fkcolumn    ="FK_siteID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> Pages
	property
		name        ="pages"
		singularName="page"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		orderby     ="parent"
		cfc         ="contentbox.models.content.Page"
		fkcolumn    ="FK_siteID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> ContentStore
	property
		name     ="contentStore"
		fieldtype="one-to-many"
		type     ="array"
		lazy     ="true"
		orderby  ="parent"
		cfc      ="contentbox.models.content.ContentStore"
		fkcolumn ="FK_siteID"
		inverse  ="true"
		cascade  ="all-delete-orphan";

	// O2M -> menus
	property
		name        ="menus"
		singularName="menu"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		orderby     ="createdDate desc"
		cfc         ="contentbox.models.menu.Menu"
		fkcolumn    ="FK_siteID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	/* *********************************************************************
	 **							CALUCLATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfEntries"
		formula="select count(*)
				from cb_entry as entry, cb_content as content
				where entry.contentID=content.contentID
					and content.FK_siteID = siteID";

	property
		name   ="numberOfPages"
		formula="select count(*)
				from cb_page as page, cb_content as content
				where page.contentID=content.contentID
					and content.FK_siteID = siteID";

	property
		name   ="numberOfContentStore"
		formula="select count(*)
				from cb_contentStore as contentStore, cb_content as content
				where contentStore.contentID=content.contentID
					and content.FK_siteID = siteID";

	property
		name   ="numberOfMenus"
		formula="select count(*)
		from cb_menu as menu
		where menu.FK_siteID = siteID";

	property
		name   ="numberOfCategories"
		formula="select count(*)
		from cb_category as category
		where category.FK_siteID = siteID";

	/* *********************************************************************
	 **							PK + CONSTRAINTS + MEMENTO
	 ********************************************************************* */

	this.pk = "siteID";

	this.memento = {
		defaultIncludes : [
			"activeTheme",
			"adminBar",
			"description",
			"domain",
			"domainregex",
			"homepage",
			"isActive",
			"isBlogEnabled",
			"isSitemapEnabled",
			"isSSL",
			"keywords",
			"name",
			"notificationEmails",
			"notifyOnContentStore",
			"notifyOnEntries",
			"notifyOnPages",
			"numberOfCategories",
			"numberOfContentStore",
			"numberOfEntries",
			"numberOfMenus",
			"numberOfPages",
			"poweredByHeader",
			"slug",
			"tagline"
		],
		defaultExcludes : [
			"categories",
			"contentStore",
			"entries",
			"menus",
			"pages",
			"settings"
		],
		profiles : {
			export : {
				defaultIncludes : [
					"categories",
					"contentStore",
					"entries",
					"menus",
					"pages",
					"settings"
				],
				defaultExcludes : [
					"settings.siteSnapshot",
					"menus.siteSnapshot:site"
				]
			}
		}
	};

	this.constraints = {
		"name" : { required : true, size : "2..255" },
		"slug" : {
			required  : true,
			size      : "2..255",
			validator : "UniqueValidator@cborm"
		},
		"description"      : { required : false, size : "0..500" },
		"keywords"         : { required : false, size : "0..255" },
		"domain"           : { required : true, size : "1..255" },
		"domainRegex"      : { required : true, size : "1..255" },
		"tagline"          : { required : false, size : "0..255" },
		"homepage"         : { required : false, size : "0..255" },
		"isBlogEnabled"    : { required : true, type : "boolean" },
		"isSitemapEnabled" : { required : true, type : "boolean" },
		"poweredByHeader"  : { required : true, type : "boolean" },
		"adminBar"         : { required : true, type : "boolean" },
		"isSSL"            : { required : true, type : "boolean" },
		"isActive"         : { required : true, type : "boolean" },
		"activeTheme"      : { required : true, size : "0..255" }
	};

	/* *********************************************************************
	 **							PUBLIC METHODS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.settings     = [];
		variables.categories   = [];
		variables.entries      = [];
		variables.pages        = [];
		variables.contentStore = [];

		super.init();

		// Incorporate all includes to the export profile
		this.memento.profiles.export.defaultIncludes.append( this.memento.defaultIncludes, true );

		return this;
	}

	/**
	 * Get the total number of content items in this site
	 */
	numeric function getNumberOfContent(){
		return variables.contentService.getTotalContentCount( getsiteID() );
	}

	/**
	 * I remove all setting associations
	 */
	Site function removeAllSettings(){
		if ( hasSetting() ) {
			variables.settings.clear();
		} else {
			variables.settings = [];
		}
		return this;
	}

	/**
	 * I remove all category associations
	 */
	Site function removeAllCategories(){
		if ( hasCategory() ) {
			variables.categories.clear();
		} else {
			variables.categories = [];
		}
		return this;
	}

	/**
	 * I remove all entry associations
	 */
	Site function removeAllEntries(){
		if ( hasEntry() ) {
			variables.entries.clear();
		} else {
			variables.entries = [];
		}
		return this;
	}

	/**
	 * I remove all menu associations
	 */
	Site function removeAllMenus(){
		if ( hasMenu() ) {
			variables.menus.clear();
		} else {
			variables.menus = [];
		}
		return this;
	}

	/**
	 * I remove all page associations
	 */
	Site function removeAllPages(){
		if ( hasPage() ) {
			variables.pages.clear();
		} else {
			variables.pages = [];
		}
		return this;
	}

	/**
	 * I remove all contentStore associations
	 */
	Site function removeAllContentStore(){
		if ( hasContentStore() ) {
			variables.contentStore.clear();
		} else {
			variables.contentStore = [];
		}
		return this;
	}

	/**
	 * Get the site root URL as defined per the settings
	 */
	String function getSiteRoot(){
		var serverPort = getServerPort();
		// Return the appropriate site Uri
		return "http"
		& ( this.getIsSSL() ? "s" : "" ) // SSL or not
		& "://"
		& this.getDomain() // Site Domain
		& ( listFind( "80,443", serverPort ) ? "" : ":#serverPort#" ); // The right port
	}

	/**
	 * Get the server port according to lookup order
	 * 1. x-forwarded-port header
	 * 2. cgi.server_port
	 */
	private function getServerPort(){
		var headers = getHTTPRequestData( false ).headers;
		if ( structKeyExists( headers, "x-forwarded-port" ) && len( headers[ "x-forwarded-port" ] ) ) {
			return headers[ "x-forwarded-port" ];
		}
		return cgi.server_port;
	}

	/**
	 * A nice snapshot of this entity used for mementifications
	 */
	struct function getInfoSnapshot(){
		if ( isLoaded() ) {
			return {
				"siteID" : getId(),
				"slug"   : getSlug(),
				"name"   : getName()
			};
		}
		return {};
	}

	/**
	 * Tries to get a category object by slug if assigned to this site
	 *
	 * @return The category object or null if not found
	 */
	function getCategory( required slug ){
		if ( hasCategory() ) {
			var aFound = variables.categories.filter( function( thisCategory ){
				return arguments.thisCategory.getSlug() == slug;
			} );
			if ( aFound.len() ) {
				return aFound[ 1 ];
			}
		}
	}

	/**
	 * We make sure we only return pages that have no parent to simulate the root hierarchy.
	 *
	 * @override
	 * @root     Show only root level pages if enabled
	 */
	function getPages( boolean root = true ){
		if ( !arguments.root ) {
			return variables.pages;
		}
		return variables.pages.filter( function( thisPage ){
			return !arguments.thisPage.hasParent();
		} );
	}

	/**
	 * We make sure we only return contentStore that have no parent to simulate the root hierarchy.
	 *
	 * @override
	 * @root     Show only root level contentStore if enabled
	 */
	function getContentStore( boolean root = true ){
		if ( !arguments.root ) {
			return variables.contentStore;
		}
		return variables.contentStore.filter( function( thisContent ){
			return !arguments.thisContent.hasParent();
		} );
	}

}
