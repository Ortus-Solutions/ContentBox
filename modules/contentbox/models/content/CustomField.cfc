/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a custom field metadata that can be attached to base content in contentbox
 */
component
	persistent="true"
	entityname="cbCustomField"
	table     ="cb_customfield"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbCustomField"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="customFieldID"
		column   ="customFieldID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="key"
		column ="key"
		notnull="true"
		ormtype="string"
		length ="255";

	property
		name   ="value"
		column ="value"
		notnull="true"
		ormtype="text"
		length ="8000";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> Content loaded as a proxy
	property
		name     ="relatedContent"
		notnull  ="false"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="many-to-one"
		fkcolumn ="FK_contentID"
		lazy     ="true"
		fetch    ="join"
		index    ="idx_contentCustomFields";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "customFieldID";

	this.memento = {
		defaultIncludes : [ "key", "value" ],
		defaultExcludes : [ "relatedContent" ],
		neverInclude    : []
	};

	this.constraints = {
		"key"   : { required : true, size : "1..255" },
		"value" : { required : true }
	};

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	function init(){
		super.init();
	}

}
