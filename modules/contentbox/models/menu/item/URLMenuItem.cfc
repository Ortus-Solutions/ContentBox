/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A URL-based Menu Item
 */
component
	persistent        ="true"
	entityName        ="cbURLMenuItem"
	table             ="cb_menuItem"
	extends           ="contentbox.models.menu.item.BaseMenuItem"
	discriminatorValue="URL"
{

	/* *********************************************************************
	 **                          DI
	 ********************************************************************* */

	property
		name      ="provider"
		persistent="false"
		inject    ="provider:contentbox.models.menu.providers.URLProvider";

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	property
		name   ="url"
		column ="url"
		notnull="false"
		ormtype="string"
		default="";

	property
		name   ="target"
		column ="target"
		notnull="false"
		ormtype="string"
		default="";

	property
		name   ="urlClass"
		column ="urlClass"
		notnull="false"
		ormtype="string"
		default="";

	/* *********************************************************************
	 **                          PK + CONSTRAINTS
	 ********************************************************************* */

	this.constraints[ "url" ]      = { required : false, size : "1..255" };
	this.constraints[ "target" ]   = { required : false, size : "1..255" };
	this.constraints[ "urlClass" ] = { required : false, size : "1..255" };

	/* *********************************************************************
	 **                          PUBLIC FUNCTIONS
	 ********************************************************************* */

	function init(){
		super.init();

		appendToMemento( [ "target", "url", "urlClass" ], "defaultIncludes" );

		return this;
	}

}
