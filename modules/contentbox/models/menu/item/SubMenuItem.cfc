/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A Submenu-based Menu Item
 */
component
	persistent        ="true"
	entityName        ="cbSubMenuItem"
	table             ="cb_menuItem"
	extends           ="contentbox.models.menu.item.BaseMenuItem"
	discriminatorValue="SubMenu"
{

	/* *********************************************************************
	 **                          DI
	 ********************************************************************* */
	property
		name      ="provider"
		persistent="false"
		inject    ="provider:contentbox.models.menu.providers.SubMenuProvider";

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	property
		name   ="menuSlug"
		column ="menuSlug"
		notnull="false"
		ormtype="string"
		default="";

	/* *********************************************************************
	 **                          PK + CONSTRAINTS
	 ********************************************************************* */

	this.constraints[ "menuSlug" ] = { required : false, size : "1..255" };

	/* *********************************************************************
	 **                          PUBLIC FUNCTIONS
	 ********************************************************************* */

	function init(){
		super.init();

		appendToMemento( [ "menuSlug" ], "defaultIncludes" );

		return this;
	}

	/**
	 * Available precheck to determine display-ability of menu item
	 *
	 * @options.hint Additional arguments to be used in the method
	 */
	public boolean function canDisplay( required struct options = {} ){
		var display = super.canDisplay( argumentCollection = arguments );
		if ( display ) {
			var slug = getMenuSlug();
			return !arrayFindNoCase( options.slugCache, slug ) ? true : false;
		}
		return display;
	}

}
