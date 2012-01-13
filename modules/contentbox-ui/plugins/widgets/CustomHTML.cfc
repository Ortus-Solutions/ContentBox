/**
* A widget that renders Custom HTML in ContentBox
*/
component extends="contentbox.model.ui.BaseWidget" singleton{
	
	CustomHTML function init(controller){
		// super init
		super.init(controller);
		
		// Widget Properties
		setPluginName("CustomHTML");
		setPluginVersion("1.0");
		setPluginDescription("A widget that renders Custom HTML in ContentBox");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");
		setForgeBoxSlug("cbwidget-customhtml");
		
		return this;
	}
	
	/**
	* Renders Custom HTML content
	* @slug The custom HTML slug to render
	* @defaultValue The string to show if the custom HTML snippet does not exist
	*/
	any function renderIt(required slug, defaultValue){
		var content = customHTMLService.findWhere({slug=arguments.slug});
		if( !isNull(content) ){
			return content.renderContent();	
		}
		
		// default value
		if( structKeyExists(arguments, "defaultValue") ){
			return arguments.defaultValue;
		}
		
		throw(message="The content slug '#arguments.slug#' does not exist",type="CustomHTMLWidget.InvalidCustomHTMLSlug");
	}
	
}
