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
		name   ="name"
		ormtype="string"
		notnull="true"
		length ="255"
		default="";

	property
		name   ="slug"
		ormtype="string"
		notnull="true"
		length ="255"
		unique ="true"
		default=""
		index  ="idx_siteSlug";

	property
		name   ="description"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="keywords"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="domain"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="domainRegex"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="tagline"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="homepage"
		ormtype="string"
		notnull="false"
		default="cbBlog"
		length ="255";

	property
		name     ="isBlogEnabled"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="isSitemapEnabled"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="poweredByHeader"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="adminBar"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="isSSL"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="false"
		dbdefault="false";

	property
		name   ="activeTheme"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="notificationEmails"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name     ="notifyOnEntries"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="notifyOnPages"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="notifyOnContentStore"
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
		fkcolumn    ="FK_siteId"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	/* *********************************************************************
	 **							CALUCLATED FIELDS
	 ********************************************************************* */

	/* *********************************************************************
	 **							CONSTRAINTS
	 ********************************************************************* */

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
	 * Get memento representation
	 * @excludes Property excludes
	 */
	function getMemento( excludes = "" ){
		var pList = [
			"name",
			"slug",
			"description",
			"keywords",
			"domain",
			"domainRegex",
			"tagline",
			"homepage",
			"isBlogEnabled",
			"isSitemapEnabled",
			"poweredByHeader",
			"adminBar",
			"isSSL",
			"activeTheme"
		];
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		return result;
	}

	/**
	 * Get the total number of content items in this site
	 */
	numeric function getNumberOfContent(){
		return variables.contentService.getTotalContentCount( getSiteId() );
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

}
