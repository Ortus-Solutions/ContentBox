/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Provider for JavaScript-type menu items
 */
component
	implements="contentbox.models.menu.providers.IMenuItemProvider"
	extends   ="contentbox.models.menu.providers.BaseProvider"
	accessors =true
{

	/* *********************************************************************
	 **                      PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	public JSProvider function init(){
		setName( "JS" );
		setType( "JS" );
		setIconClass( "fa fa-code" );
		setEntityName( "cbJSMenuItem" );
		setDescription( "A menu item which executes JavaScript code" );
		return this;
	}
	/**
	 * Retrieves template for use in admin screens for this type of menu item provider
	 *
	 * @menuItem.hint The menu item object
	 * @options.hint  Additional arguments to be used in the method
	 */
	public string function getAdminTemplate( required any menuItem, required struct options = {} ){
		var viewArgs = { menuItem : arguments.menuItem };
		return variables.renderer.renderView(
			view   = "menus/providers/js/admin",
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
		var viewArgs = { menuItem : arguments.menuItem };
		return variables.renderer.renderExternalView(
			view   = "/contentbox/models/menu/views/js/display",
			module = "contentbox",
			args   = viewArgs
		);
	}

}
