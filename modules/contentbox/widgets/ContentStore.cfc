/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A widget that renders content store objects
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	/**
	 * Constructor
	 */
	ContentStore function init(){
		// Widget Properties
		setName( "ContentStore" );
		setVersion( "1.0" );
		setDescription( "A widget that renders ContentStore content anywhere you like." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "Content" );

		return this;
	}

	/**
	 * Renders a published ContentStore object, if no default value is used, this throws an exception
	 *
	 * @slug            The content store slug to render
	 * @slug.optionsUDF getSlugList
	 * @defaultValue    The string to show if the contentstore snippet does not exist, else an exception is thrown
	 *
	 * @return The contentstore rendered content, empty if content has expired
	 *
	 * @throws InvalidContentStoreException
	 */
	any function renderIt( required string slug, string defaultValue ){
		var content = variables.contentStoreService.findBySlug(
			slug            = arguments.slug,
			showUnpublished = true,
			siteID          = variables.cb.site().getsiteID()
		);

		// Return if loaded and published
		if ( content.isLoaded() && content.isContentPublished() && !content.isExpired() ) {
			return content.renderContent();
		}

		// Return empty if expired
		if ( content.isLoaded() && content.isExpired() ) {
			return "";
		}

		// default value
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}

		// else throw
		throw( message = "The content slug '#arguments.slug#' does not exist", type = "InvalidContentStoreException" );
	}

	/**
	 * Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
	 *
	 * @cbignore
	 */
	array function getSlugList(){
		return variables.contentStoreService.getAllFlatSlugs();
	}

}
