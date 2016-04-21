/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Visit page hierarchies and create breadcrumbs
*/
component singleton{
	
	/**
	* Constructor
	*/
	PageBreadcrumbVisitor function init(){
		return this;
	}
	
	/**
	* Visit a page and build hierarchy list
	* @page The page content object
	*/
	function visit( required page ){
		var bc = "";
		
		if( arguments.page.hasParent() ){
			bc &= visit( arguments.page.getParent() );
		}
		
		if( len( arguments.page.getTitle() ) ){
			bc &= '<span class="fa fa-caret-right"> </span> <a href="javascript:contentDrilldown( ''#arguments.page.getContentID()#'' )">#arguments.page.getTitle()#</a> ';
		}
		
		return bc;
	}
	
}