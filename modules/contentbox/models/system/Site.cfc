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
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="siteId"
		fieldtype="id"
		generator="native"
		setter   ="false"
		params   ="{ allocationSize = 1, sequence = 'siteId_seq' }";

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
		sqltype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="isSitemapEnabled"
		ormtype  ="boolean"
		sqltype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="poweredByHeader"
		ormtype  ="boolean"
		sqltype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="adminBar"
		ormtype  ="boolean"
		sqltype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="isSSL"
		ormtype  ="boolean"
		sqltype  ="boolean"
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
		sqltype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="notifyOnPages"
		ormtype  ="boolean"
		sqltype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	property
		name     ="notifyOnContentStore"
		ormtype  ="boolean"
		sqltype  ="boolean"
		notnull  ="true"
		default  ="true"
		dbdefault="true";

	/* *********************************************************************
	 **							CALUCLATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfContent"
		formula="select count(*) from cb_content as content where content.FK_siteId=siteId";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "siteId";

	this.constraints = {
		"name" : { required : true, size : "2..255" },
		"slug" : {
			required  : true,
			size      : "2..255",
			validator : "UniqueValidator@cborm"
		},
		"description"      : { required : false, size : "0..500" },
		"keywords"         : { required : false, size : "0..255" },
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
		super.init();

		return this;
	}

	/**
	 * Get memento representation
	 * @excludes Property excludes
	 */
	function getMemento( excludes = "" ){
		var pList  = listToArray( "name,slug,description,domainRegex" );
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		return result;
	}

}
