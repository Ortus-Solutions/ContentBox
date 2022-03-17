/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Issues a relocation on a page with a 302 header
 */
component extends="contentbox.models.ui.BaseWidget" {

	function init(){
		// Widget Properties
		setName( "Relocate" );
		setVersion( "1.0" );
		setDescription( "Issues 302 relocations once it is executed on any content page." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setCategory( "Utilities" );
		setIcon( "repeat" );
		return this;
	}

	/**
	 * Relocate a page
	 *
	 * @page       The page to relocate to
	 * @url        The full URL to relocate to
	 * @ssl        Relocate using SSL or not, default is to use what the user is on
	 * @statusCode The status code, default is 302
	 */
	any function renderIt(
		string page,
		string url,
		boolean ssl        = getRequestContext().isSSL(),
		numeric statusCode = "302"
	){
		var to = "";

		if ( !isNull( arguments.page ) && len( arguments.page ) ) {
			to = variables.cb.linkPage( arguments.page );
		}
		if ( !isNull( arguments.url ) && len( arguments.url ) ) {
			to = arguments.url;
		}

		// relocate only if rendering a page on the front end.
		if ( variables.cb.isEntryView() || variables.cb.isPageView() ) {
			relocate(
				url       : to,
				ssl       : arguments.ssl,
				statusCode: arguments.statusCode
			);
		}
		// Return empty content
		return "";
	}

}
