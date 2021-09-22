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
		column   ="settingID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="name"
		column ="name"
		notnull="true"
		length ="100";

	property
		name   ="value"
		column ="value"
		notnull="true"
		ormtype="text";

	property
		name   ="isCore"
		column ="isCore"
		ormtype="boolean"
		notnull="true"
		default="false"
		index  ="idx_core";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> The site this setting belongs to
	property
		name     ="site"
		notnull  ="false"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteID"
		lazy     ="true"
		fetch    ="join";

	/* *********************************************************************
	 **							PK + CONSTRAINTS + Memento
	 ********************************************************************* */

	this.pk = "settingID";

	this.constraints = {
		"name"  : { required : true, size : "1..100" },
		"value" : { required : true }
	};

	this.memento = {
		defaultIncludes : [ "name", "value", "isCore", "siteSnapshot:site" ],
		defaultExcludes : [ "site" ]
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
	 * Build a site snapshot
	 */
	struct function getSiteSnapshot(){
		return ( hasSite() ? getSite().getInfoSnapshot() : {} );
	}

	/**
	 * Shortcut to get the site id associated with this setting
	 *
	 * @return The associated site id or empty if none
	 */
	function getSiteID(){
		if ( hasSite() ) {
			return getSite().getsiteID();
		}
		return "";
	}

}
