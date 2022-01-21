/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A widget that can render out ContentBox menus
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	Menu function init(){
		// Widget Properties
		setName( "Menu" );
		setVersion( "1.0" );
		setDescription( "A widget that can render out a ContentBox menu anywhere you like." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "bars" );
		setCategory( "Content" );
		return this;
	}

	/**
	 * Renders a ContentBox menu by slug name
	 *
	 * @slug.hint         The menu slug to render
	 * @slug.optionsUDF   getSlugList
	 * @defaultValue.hint The string to show if the menu does not exist
	 */
	any function renderIt( string slug = "EmptyMenuList", string defaultValue ){
		var menu = menuService.findWhere( { slug : arguments.slug } );

		if ( !isNull( menu ) ) {
			try {
				savecontent variable="menuContent" {
					writeOutput( "#cb.menu( slug = arguments.slug, type = "html" )#" );
				}
			} catch ( any e ) {
				return arguments.defaultValue;
			}
			return menuContent;
		}

		if ( isNull( menu ) ) {
			return "Menu Items Not Found.Create Menu Items to Use as a widget. ";
		}

		// default value
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}

		throw( message = "The menu slug '#arguments.slug#' does not exist", type = "MenuWidget.InvalidMenuSlug" );
	}

	/**
	 * Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
	 *
	 * @cbignore
	 */
	array function getSlugList(){
		return menuService.getAllSlugs();
	}

}
