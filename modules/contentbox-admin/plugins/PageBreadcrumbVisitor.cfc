/**
* Visit page hierarchies and create breadcrumbs
*/
component singleton="true"{
	
	PageBreadcrumbVisitor function init(){
		
		// Plugin Properties
		setPluginName("PageBreadcrumbVisitor");
		setPluginVersion("2.0");
		setPluginDescription("Visit page hierarchies and create breadcrumbs");
		setPluginAuthor("Luis Majano");
		setPluginAuthorURL("http://www.ortussolutions.com");
		
		return this;
	}
	
	// visit hierarchy
	function visit(required page){
		var bc = "";
		
		if( arguments.page.hasParent() ){
			bc &= visit( arguments.page.getParent() );
		}
		
		if( len( arguments.page.getTitle() ) ){
			bc &= '<span class="icon-caret-right"> </span> <a href="javascript:contentDrilldown( ''#arguments.page.getContentID()#'' )">#arguments.page.getTitle()#</a> ';
		}
		
		return bc;
	}
	
}
