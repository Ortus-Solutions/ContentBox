/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A JavaScript-based Menu Item
 */
component
	persistent        ="true"
	entityName        ="cbJSMenuItem"
	table             ="cb_menuItem"
	extends           ="contentbox.models.menu.item.BaseMenuItem"
	discriminatorValue="JS"
{

	/* *********************************************************************
	 **                          DI
	 ********************************************************************* */

	property
		name      ="provider"
		persistent="false"
		inject    ="provider:contentbox.models.menu.providers.JSProvider";

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	property
		name   ="js"
		column ="js"
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

	this.constraints[ "js" ]       = { required : false, size : "1..255" };
	this.constraints[ "urlClass" ] = { required : false, size : "1..255" };

	/* *********************************************************************
	 **                          PUBLIC FUNCTIONS
	 ********************************************************************* */

	function init(){
		super.init();

		appendToMemento( [ "js", "urlClass" ], "defaultIncludes" );

		return this;
	}

}
