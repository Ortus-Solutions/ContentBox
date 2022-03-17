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
		setIconClass( "fas fa-box" );
		setEntityName( "cbContentMenuItem" );
		setDescription( "A menu item based on existing pages or blog entries" );
		return this;
	}

	/**
	 * Retrieves template for use in admin screens for this type of menu item provider
	 *
	 * @menuItem.hint The menu item object
	 * @options.hint  Additional arguments to be used in the method
	 */
	public string function getAdminTemplate( required any menuItem, required struct options = {} ){
		var prc                       = requestService.getContext().getCollection( private = true );
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		var title                     = "";
		var slug                      = "";
		if ( !isNull( arguments.menuItem.getContentSlug() ) ) {
			var content = contentService.findBySlug( slug = arguments.menuItem.getContentSlug() );
			if ( !isNull( content ) ) {
				title = content.getTitle();
				slug  = arguments.menuItem.getContentSlug();
			}
		}
		var viewArgs = {
			menuItem           : arguments.menuItem,
			xehContentSelector : "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector",
			title              : title,
			slug               : slug
		};
		return variables.renderer.renderView(
			view   = "menus/providers/content/admin",
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
		var content  = contentService.findBySlug( arguments.menuItem.getContentSlug() );
		var viewArgs = {
			menuItem    : arguments.menuItem,
			contentLink : CBHelper.linkContent( content = content ),
			data        : arguments.menuItem.getMemento()
		};
		return variables.renderer.renderExternalView(
			view   = "/contentbox/models/menu/views/content/display",
			module = "contentbox",
			args   = viewArgs
		);
	}

}
