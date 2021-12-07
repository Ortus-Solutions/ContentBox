/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A Heading-based Menu Item
 */
component
	persistent        ="true"
	entityName        ="cbFreeMenuItem"
	table             ="cb_menuItem"
	extends           ="contentbox.models.menu.item.BaseMenuItem"
	discriminatorValue="Free"
{

	/* *********************************************************************
	 **                          DI
	 ********************************************************************* */

	property
		name      ="provider"
		persistent="false"
		inject    ="provider:contentbox.models.menu.providers.FreeProvider";

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	/* *********************************************************************
	 **                          PUBLIC FUNCTIONS
	 ********************************************************************* */

}
