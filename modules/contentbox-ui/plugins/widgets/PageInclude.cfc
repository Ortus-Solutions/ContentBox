/**
* A widget that can render out ContentBox pages inline
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	PageInclude function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("PageInclude");
		setPluginVersion("1.0");
		setPluginDescription("A widget that can render out ContentBox pages inline");
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
		var page = pageService.findWhere({slug=arguments.slug});

		if( !isNull(page) ){
			return page.renderContent();
		}

		// default value
		if( structKeyExists(arguments, "defaultValue") ){
			return arguments.defaultValue;
		}

		throw(message="The content slug '#arguments.slug#' does not exist",type="CustomHTMLWidget.InvalidPageSlug");
	}

}
