/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Visit page hierarchies and create breadcrumbs
 */
component singleton {

	/**
	 * Constructor
	 */
	PageBreadcrumbVisitor function init(){
		return this;
	}

	/**
	 * Visit a page and build hierarchy list
	 *
	 * @page The page content object
	 */
	function visit( required page ){
		var bc = "";

		if ( arguments.page.hasParent() ) {
			bc &= visit( arguments.page.getParent() );
		}

		// cfformat-ignore-start
		if ( len( arguments.page.getTitle() ) ) {
			bc &= "<span class=""fas fa-chevron-right mr5 ml5""></span>
				<a href=""javascript:contentListHelper.contentDrilldown( '#arguments.page.getContentID()#' )"">
					#arguments.page.getTitle()#
				</a>";
		}
		// cfformat-ignore-end

		return bc;
	}

}
