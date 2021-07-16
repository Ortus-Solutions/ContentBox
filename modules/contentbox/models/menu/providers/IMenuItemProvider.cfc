/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Interface for menu item providers
 */
interface {

	public string function getName();

	public string function getEntityName();

	public string function getType();

	public string function getDescription();

	public string function getAdminTemplate( required any menuItem, required struct options );

	public string function getDisplayTemplate( required any menuItem, required struct options );

}
