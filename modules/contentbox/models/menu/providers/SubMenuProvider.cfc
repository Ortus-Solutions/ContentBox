/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Provider for SubMenu-type menu items
 */
component
	implements="contentbox.models.menu.providers.IMenuItemProvider"
	extends   ="contentbox.models.menu.providers.BaseProvider"
	accessors =true
{

	/* *********************************************************************
	 **                      DI
	 ********************************************************************* */

	property name="menuService" inject="id:menuService@contentbox";
	property name="requestService" inject="coldbox:requestService";

	/* *********************************************************************
	 **                      PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	public SubMenuProvider function init(){
		setName( "SubMenu" );
		setType( "SubMenu" );
		setIconClass( "fas fa-bars" );
		setEntityName( "cbSubMenuItem" );
		setDescription( "A menu item which encapsulates another menu" );
		return this;
	}
	/**
	 * Retrieves template for use in admin screens for this type of menu item provider
	 *
	 * @menuItem.hint The menu item object
	 * @options.hint  Additional arguments to be used in the method
	 */
	public string function getAdminTemplate( required any menuItem, required struct options = {} ){
		var rc           = requestService.getContext().getCollection();
		var criteria     = menuService.newCriteria();
		var existingSlug = "";
		if ( structKeyExists( rc, "menuID" ) && len( rc.menuID ) ) {
			criteria.ne( "menuID", rc.menuID );
		}
		if ( !isNull( arguments.menuItem.getMenuSlug() ) ) {
			existingSlug = arguments.menuItem.getMenuSlug();
		}
		var menus    = criteria.list( sortOrder = "title ASC" );
		var viewArgs = { menus : menus, existingSlug : existingSlug };
		return variables.renderer.renderView(
			view   = "menus/providers/submenu/admin",
			module = "contentbox-admin",
			args   = viewArgs
		);
	}
	/**
	 * Retrieves template for use in rendering menu item on the site
	 *
	 * @menuItem.hint The menu item object
	 * @options.hint  Additional arguments to be used in the method
	 */
	public string function getDisplayTemplate( required any menuItem, required struct options = {} ){
		var viewArgs = {
			menuItem  : arguments.menuItem,
			data      : arguments.menuItem.getMemento(),
			slugCache : arguments.options.slugCache
		};
		return variables.renderer.renderExternalView(
			view   = "/contentbox/models/menu/views/submenu/display",
			module = "contentbox",
			args   = viewArgs
		);
	}

}
