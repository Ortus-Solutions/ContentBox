/**
* A widget that can render out ContentBox blog entries inline
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	EntryInclude function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("EntryInclude");
		setPluginVersion("1.0");
		setPluginDescription("A widget that can render out ContentBox blog entries inline");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Renders a ContentBox page by slug name
	* @slug.hint The page slug to render
	* @defaultValue.hint The string to show if the page does not exist
	*/
	any function renderIt(required string slug, string defaultValue){
		var entry = entryService.findWhere({slug=arguments.slug});

		if( !isNull(entry) ){
			return entry.renderContent();
		}

		// default value
		if( structKeyExists(arguments, "defaultValue") ){
			return arguments.defaultValue;
		}

		throw(message="The content slug '#arguments.slug#' does not exist",type="CustomHTMLWidget.InvalidEntrySlug");
	}

}
