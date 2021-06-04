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
		inject    ="provider:contentService@cb"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="siteID"
		column   ="siteID"
		fieldtype="id"
		generator="uuid"
		ormtype  ="string"
		setter   ="false"
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
		name     ="isBlogEnabled"
		column   ="isBlogEnabled"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="isSitemapEnabled"
		column   ="isSitemapEnabled"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="poweredByHeader"
		column   ="poweredByHeader"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="adminBar"
		column   ="adminBar"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="isSSL"
		column   ="isSSL"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="false"
		dbdefault="false";

	property
		name     ="isActive"
		column   ="isActive"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

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
		name     ="notifyOnEntries"
		column   ="notifyOnEntries"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="notifyOnPages"
		column   ="notifyOnPages"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="notifyOnContentStore"
		column   ="notifyOnContentStore"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// O2M -> Settings
	property
		name        ="settings"
		singularName="setting"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		orderby     ="name"
		cfc         ="contentbox.models.system.Setting"
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
		defaultExcludes : [ "settings" ]
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
		"activeTheme"      : { required : false, size : "0..255" }
	};

	/* *********************************************************************
	 **							PUBLIC METHODS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.settings = [];

		super.init();

		return this;
	}

	/**
	 * Get the total number of content items in this site
	 */
	numeric function getNumberOfContent(){
		return variables.contentService.getTotalContentCount( getsiteID() );
	}

	/*
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
	 * Get the site root URL as defined per the settings
	 */
	String function getSiteRoot(){
		// Return the appropriate site Uri
		return "http"
		& ( this.getIsSSL() ? "s" : "" ) // SSL or not
		& "://"
		& this.getDomain() // Site Domain
		& ( cgi.server_port != 80 ? ":#cgi.server_port#" : "" ); // The right port
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

}
