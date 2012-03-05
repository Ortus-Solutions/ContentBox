/**
* Renders any view in your ColdBox application
*/
component extends="contentbox.model.ui.BaseWidget"{

	function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("Renderview");
		setPluginVersion("1.0");
		setPluginDescription("Renders any view in your ColdBox application");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("http://www.ortussolutions.com");

		return this;
	}

	/**
	* Render the widget out
	* @view.hint The named path of the view to render
	* @cache.hint Cache the contents of the render view or not, by default it is false
	* @cacheTimeout.hint The cache timeout in minutes
	* @cacheLastAccessTimeout.hint The cache idle timeout in minutes
	* @cacheSuffix.hint A suffix for the cache entry
	* @module.hint The name of the module to render the view from
	* @args.hint A JSON structure that will be converted to a native struct to pass as arguments into the view
	*/
	any function renderIt(required string view,boolean cache=false, cacheTimeout, cacheLastAccessTimeout, cacheSuffix, module, args=structNew()){
		if( isSimpleValue(arguments.args) and isJSON(arguments.args) ){
			arguments.args = deserializeJSON( arguments.args );
		}
		return renderView(argumentCollection=arguments);
	}

}
