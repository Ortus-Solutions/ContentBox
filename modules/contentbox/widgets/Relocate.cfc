/**
* Issues a relocation on a page with a 302 header
*/
component extends="contentbox.models.ui.BaseWidget"{

	function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("Relocate");
		setPluginVersion("1.0");
		setPluginDescription("Issues 302 relocations once it is executed on any content page.");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("http://www.ortussolutions.com");
		setCategory( "Utilities" );
		setIcon( "replay.png" );
		return this;
	}

	/**
	* Relocate a page
	* @page.hint The page to relocate to
	* @url.hint The full URL to relocate to
	* @ssl.hint Relocate using SSL or not, default is false.
	* @statusCode.hint The status code, default is 302
	*/
	any function renderIt(
		string page,
		string URL,
		boolean ssl=false,
		numeric statusCode="302"
	){
		var to = "";

		if( structKeyExists( arguments, "page" ) ){
			to = cb.linkPage( arguments.page );
		}
		if( structKeyExists( arguments, "URL" ) ){
			to = arguments.URL;
		}

		// relocate only if rendering a page on the front end.
		if( cb.isEntryView() || cb.isPageView() ){
			setNextEvent( URL=to, ssl=arguments.ssl, statusCode=arguments.statusCode );
		}
	}

}
