/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Renders any view in your ColdBox application
 */
component extends="contentbox.models.ui.BaseWidget" {

	function init(){
		// Widget Properties
		setName( "Renderview" );
		setVersion( "1.0" );
		setDescription( "Renders any view within the deployed ColdBox application." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setCategory( "ColdBox" );
		setIcon( "file" );
		return this;
	}

	/**
	 * Render the widget out
	 *
	 * @view                   The named path of the view to render
	 * @cache                  Cache the contents of the render view or not, by default it is false
	 * @cacheTimeout           The cache timeout in minutes
	 * @cacheLastAccessTimeout The cache idle timeout in minutes
	 * @cacheSuffix            A suffix for the cache entry
	 * @module                 The name of the module to render the view from
	 * @args                   The arguments to pass to the view, this should be a comma delimitted list of name value pairs. Ex: widget=true,name=Test
	 * @prePostExempt          If true, pre/post view interceptors will not be fired. By default they do fire
	 */
	any function renderIt(
		required string view,
		boolean cache = false,
		cacheTimeout,
		cacheLastAccessTimeout,
		string cacheSuffix,
		string module,
		string args           = "",
		boolean prePostExempt = false
	){
		// If the view is empty, then return a message.
		if ( !len( arguments.view ) ) {
			return "Please pass in a view to render";
		}

		// Inflate args string to struct
		var viewArgs = arguments.args
			.listToArray()
			.reduce( function( results, item ){
				results[ listFirst( arguments.item, "=" ) ] = getToken( arguments.item, 2, "=" );
				return results;
			}, {} );

		// Replace with inflated data
		arguments.args = viewArgs;

		// Clean up incoming arguments
		structDelete( arguments, "event" );

		// Execute rendering
		return renderView( argumentCollection = arguments );
	}

}
