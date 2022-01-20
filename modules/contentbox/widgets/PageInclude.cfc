/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A widget that can render out ContentBox pages inline
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	PageInclude function init(){
		// Widget Properties
		setName( "PageInclude" );
		setVersion( "1.0" );
		setDescription( "A widget that can render out a ContentBox page anywhere you like." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "arrow-circle-left" );
		setCategory( "Content" );
		return this;
	}

	/**
	 * Renders a ContentBox page by slug name
	 *
	 * @slug.hint         The page slug to render
	 * @slug.optionsUDF   getSlugList
	 * @defaultValue.hint The string to show if the page does not exist
	 */
	any function renderIt( required string slug, string defaultValue ){
		var page = pageService.findWhere( { slug : arguments.slug } );

		if ( !isNull( page ) ) {
			return page.renderContent();
		}

		// default value
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}

		throw(
			message = "The content slug '#arguments.slug#' does not exist",
			type    = "PageIncludeWidget.InvalidPageSlug"
		);
	}

	/**
	 * Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
	 *
	 * @cbignore
	 */
	array function getSlugList(){
		return pageService.getAllFlatSlugs();
	}

}
