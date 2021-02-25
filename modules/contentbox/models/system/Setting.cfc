/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a system setting. A system setting can be core or non-core.  The difference is that core
 * settings cannot be deleted from the geek settings UI to prevent caos.  Admins would have
 * to remove core settings via the DB only as a precautionary measure.
 */
component
	persistent="true"
	entityname="cbSetting"
	table     ="cb_setting"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbSetting"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="settingID"
		fieldtype="id"
		generator="native"
		setter   ="false"
		params   ="{ allocationSize = 1, sequence = 'settingID_seq' }";

	property
		name   ="name"
		notnull="true"
		length ="100";

	property
		name   ="value"
		notnull="true"
		ormtype="text";

	property
		name     ="isCore"
		ormtype  ="boolean"
		sqlType  ="tinyInt"
		notnull  ="true"
		default  ="false"
		dbdefault="0"
		index    ="idx_core";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="false"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteId"
		lazy     ="true";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "settingID";

	this.constraints = {
		"name"  : { required : true, size : "1..100" },
		"value" : { required : true }
	};

	/* *********************************************************************
	 **							PUBLIC METHODS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.isCore = false;

		super.init();

		return this;
	}

	/**
	 * Get memento representation
	 * @excludes Property excludes
	 */
	function getMemento( excludes = "" ){
		var pList  = listToArray( "name,value,isCore" );
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		// Site Snapshot
		result[ "site" ] = {};
		if ( hasSite() ) {
			result.site[ "siteId" ] = getSite().getSiteId();
			result.site[ "name" ]   = getSite().getName();
			result.site[ "slug" ]   = getSite().getSlug();
		}

		return result;
	}

	/**
	 * Shortcut to get the site id associated with this setting
	 *
	 * @return The associated site id or empty if none
	 */
	function getSiteId(){
		if ( hasSite() ) {
			return getSite().getSiteId();
		}
		return "";
	}

}
