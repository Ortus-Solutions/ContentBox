/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A widget that renders content store objects
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	ContentStore function init(){
		// Widget Properties
		setName( "ContentStore" );
		setVersion( "1.0" );
		setDescription( "A widget that renders ContentStore content anywhere you like." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "hdd-o" );
		setCategory( "Content" );

		return this;
	}

	/**
	* Renders a published ContentStore object, if no default value is used, this throws an exception
	* @slug.hint The content store slug to render
	* @slug.optionsUDF getSlugList
	* @defaultValue.hint The string to show if the contentstore snippet does not exist
	*/
	any function renderIt(required string slug, string defaultValue){

		var content = contentStoreService.findBySlug( arguments.slug );

		// Return if loaded 
		if( content.isLoaded() ){
			return content.renderContent();
		}

		// default value
		if( structKeyExists( arguments, "defaultValue" ) ){
			return arguments.defaultValue;
		}

		// else throw
		throw(message="The content slug '#arguments.slug#' does not exist", type="InvalidContentStoreException" );
	}

	/**
	* Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
	* @cbignore
	*/ 
	array function getSlugList(){
		return contentStoreService.getAllFlatSlugs();
	}

}
