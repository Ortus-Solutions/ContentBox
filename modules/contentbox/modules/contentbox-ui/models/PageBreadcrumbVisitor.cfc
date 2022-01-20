/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Visit page hierarchies and create breadcrumbs
 */
component singleton {

	// DI
	property name="CBHelper" inject="CBHelper@contentbox";

	/**
	 * Constructor
	 */
	PageBreadcrumbVisitor function init(){
		return this;
	}

	/**
	 * Visit and build out bread crumbs
	 *
	 * @page      The page object
	 * @separator The separator to use, defaults to '>'
	 */
	function visit( required page, string separator = ">" ){
		var bc = "";
		// recursive lookup
		if ( arguments.page.hasParent() ) {
			bc &= visit( arguments.page.getParent(), arguments.separator );
		}

		// check if page slug is home, to ignore it
		if ( arguments.page.getSlug() NEQ CBHelper.getHomePage() ) {
			bc &= "#( len( bc ) ? arguments.separator : "" )# <a href=""#CBHelper.linkPage( arguments.page )#"">#arguments.page.getTitle()#</a>
";
		}

		return bc;
	}

}
