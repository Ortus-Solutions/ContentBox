/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Issues a relocation on a page with a 302 header
*/
component extends="contentbox.models.ui.BaseWidget"{

	function init(){
		// Widget Properties
		setName( "Relocate" );
		setVersion( "1.0" );
		setDescription( "Issues 302 relocations once it is executed on any content page." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setCategory( "Utilities" );
		setIcon( "repeat" );
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
		// Return empty content
		return "";
	}

}
