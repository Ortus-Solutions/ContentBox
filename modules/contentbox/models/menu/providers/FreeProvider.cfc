/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Provider for Free-type menu items
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
	public FreeProvider function init(){
		setName( "Free" );
		setType( "Free" );
		setIconClass( "far fa-eye" );
		setEntityName( "cbFreeMenuItem" );
		setDescription( "A menu item which creates a free-text menu item" );
		return this;
	}

	/**
	 * Retrieves template for use in admin screens for this type of menu item provider
	 *
	 * @menuItem.hint The menu item object
	 * @options.hint  Additional arguments to be used in the method
	 */
	public string function getAdminTemplate( required any menuItem, required struct options = {} ){
		return "";
	}

	/**
	 * Retrieves template for use in rendering menu item on the site
	 *
	 * @menuItem.hint The menu item object
	 * @options.hint  Additional arguments to be used in the method
	 */
	public string function getDisplayTemplate( required any menuItem, required struct options = {} ){
		var viewArgs = {
			menuItem : arguments.menuItem,
			data     : arguments.menuItem.getMemento()
		};
		return variables.renderer.renderExternalView(
			view   = "/contentbox/models/menu/views/free/display",
			module = "contentbox",
			args   = viewArgs
		);
	}

}
