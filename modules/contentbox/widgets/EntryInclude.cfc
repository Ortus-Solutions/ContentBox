/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A widget that can render out ContentBox blog entries inline
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	EntryInclude function init(){
		// Widget Properties
		setName( "EntryInclude" );
		setVersion( "1.0" );
		setDescription( "A widget that can render out ContentBox blog entries inline" );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "arrow-circle-left" );
		setCategory( "Blog" );
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
		var entry = entryService.findWhere( { slug : arguments.slug } );

		if ( !isNull( entry ) ) {
			return entry.renderContent();
		}

		// default value
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}

		throw(
			message = "The content slug '#arguments.slug#' does not exist",
			type    = "EntryIncludeWidget.InvalidEntrySlug"
		);
	}

	/**
	 * Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
	 *
	 * @cbignore
	 */
	array function getSlugList(){
		return entryService.getAllFlatSlugs();
	}

}
