/**
* A widget that can render out ContentBox blog entries inline
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	EntryInclude function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName( "EntryInclude" );
		setPluginVersion( "1.0" );
		setPluginDescription( "A widget that can render out ContentBox blog entries inline" );
		setPluginAuthor( "Ortus Solutions" );
		setPluginAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "notebook.png" );
		setCategory( "Blog" );
		return this;
	}

	/**
	* Renders a ContentBox page by slug name
	* @slug.hint The page slug to render
	* @slug.optionsUDF getSlugList
	* @defaultValue.hint The string to show if the page does not exist
	*/
	any function renderIt(required string slug, string defaultValue){
		var entry = entryService.findWhere( {slug=arguments.slug} );

		if( !isNull(entry) ){
			return entry.renderContent();
		}

		// default value
		if( structKeyExists(arguments, "defaultValue" ) ){
			return arguments.defaultValue;
		}

		throw(message="The content slug '#arguments.slug#' does not exist",type="EntryIncludeWidget.InvalidEntrySlug" );
	}

	/**
	* Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
	* @cbignore
	*/ 
	array function getSlugList(){
		return entryService.getAllFlatSlugs();
	}
}
