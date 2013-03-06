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
		setPluginDescription("Renders any view within the deployed ColdBox application.");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("http://www.ortussolutions.com");
		setCategory( "ColdBox" );
		setIcon( "book.png" );
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
	* @args.hint The arguments to pass to the view, this should be a comma delimitted list of name value pairs. Ex: widget=true,name=Test
	*/
	any function renderIt(required string view,boolean cache=false, cacheTimeout, cacheLastAccessTimeout, cacheSuffix, module, string args=""){
		var viewArgs = {};
		
		// Inflate args
		if( len( arguments.args ) ){
			var aString = listToArray( arguments.args, "," );
			for( var key in aString ){
				viewArgs[ listFirst( key, "=" ) ] = getToken( key, 2, "=" );
			}
		}
		// Replace with inflated data
		arguments.args = viewArgs;
		// Execute rendering
		return renderView(argumentCollection=arguments);
	}

}
