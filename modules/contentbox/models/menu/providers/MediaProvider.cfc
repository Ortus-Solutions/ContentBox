/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Provider for Media-type menu items
 */
component
	implements="contentbox.models.menu.providers.IMenuItemProvider"
	extends   ="contentbox.models.menu.providers.BaseProvider"
	accessors =true
{

	/* *********************************************************************
	 **                      DI
	 ********************************************************************* */

	property name="requestService" inject="coldbox:requestService";

	/* *********************************************************************
	 **                      PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	public MediaProvider function init(){
		setName( "Media" );
		setType( "Media" );
		setIconClass( "fas fa-photo-video" );
		setEntityName( "cbMediaMenuItem" );
		setDescription( "A menu item to a media item" );
		return this;
	}
	/**
	 * Retrieves template for use in admin screens for this type of menu item provider
	 *
	 * @menuItem.hint The menu item object
	 * @options.hint  Additional arguments to be used in the method
	 */
	public string function getAdminTemplate( required any menuItem, required struct options = {} ){
		var viewArgs = {
			menuItem         : arguments.menuItem,
			xehMediaSelector : "#requestService.getContext().buildLink( to = "cbadmin.menus.filebrowser" )#"
		};
		return variables.renderer.renderView(
			view   = "menus/providers/media/admin",
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
			view   = "/contentbox/models/menu/views/media/display",
			module = "contentbox",
			args   = viewArgs
		);
	}

}
