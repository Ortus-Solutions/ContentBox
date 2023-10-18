/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Provider for Content-type menu items
 */
component
	implements="contentbox.models.menu.providers.IMenuItemProvider"
	extends   ="contentbox.models.menu.providers.BaseProvider"
	accessors =true
{

	/* *********************************************************************
	 **                      DI
	 ********************************************************************* */

	property name="contentService" inject="id:contentService@contentbox";
	property name="CBHelper" inject="id:CBHelper@contentbox";
	property name="requestService" inject="coldbox:requestService";

	/* *********************************************************************
	 **                      PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	public ContentProvider function init(){
		setName( "Content" );
		setType( "Content" );
		setIconClass( "fa fa-archive" );
		setEntityName( "cbContentMenuItem" );
		setDescription( "A menu item based on existing content items" );
		return this;
	}

	/**
	 * Retrieves template for use in admin screens for this type of menu item provider
	 *
	 * @menuItem The menu item object
	 * @options  Additional arguments to be used in the method
	 */
	string function getAdminTemplate( required any menuItem, required struct options = {} ){
		var prc   = requestService.getContext().getPrivateCollection();
		var title = "";
		var slug  = "";

		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		if ( !isNull( arguments.menuItem.getContentSlug() ) ) {
			var content = contentService.findBySlug(
				slug   = arguments.menuItem.getContentSlug(),
				siteID = arguments.menuItem.getMenu().getSiteID()
			);
			if ( !isNull( content ) ) {
				title = content.getTitle();
				slug  = arguments.menuItem.getContentSlug();
			}
		}

		return variables.renderer.view(
			view   = "menus/providers/content/admin",
			module = "contentbox-admin",
			args   = {
				menuItem           : arguments.menuItem,
				xehContentSelector : "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector",
				title              : title,
				slug               : slug
			}
		);
	}

	/**
	 * Retrieves template for use in rendering menu item on the site
	 *
	 * @menuItem The menu item object
	 * @options  Additional arguments to be used in the method
	 */
	string function getDisplayTemplate( required any menuItem, required struct options = {} ){
		var content = variables.contentService.findBySlug(
			slug   = arguments.menuItem.getContentSlug(),
			siteID = arguments.menuItem.getMenu().getSiteID()
		);

		return variables.renderer.externalView(
			view   = "/contentbox/models/menu/views/content/display",
			module = "contentbox",
			args   = {
				menuItem    : arguments.menuItem,
				contentLink : variables.CBHelper.linkContent( content: content ),
				data        : arguments.menuItem.getMemento()
			}
		);
	}

}
