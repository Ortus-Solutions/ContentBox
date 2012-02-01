/**
* Visit page hierarchies and create breadcrumbs
*/
component singleton="true"{
	
	PageBreadcrumbVisitor function init(){
		
		// Plugin Properties
		setPluginName("PageBreadcrumbVisitor");
		setPluginVersion("1.0");
		setPluginDescription("Visit page hierarchies and create breadcrumbs");
		setPluginAuthor("Luis Majano");
		setPluginAuthorURL("http://www.ortussolutions.com");
		
		return this;
	}
	
	// visit
	function visit(page,link){
		var bc 		= "";
		
		if( arguments.page.hasParent() ){
			bc &= visit( arguments.page.getParent(), arguments.link );
		}
		
		bc &= '> <a href="#arguments.link#/parent/#arguments.page.getContentID()#">#arguments.page.getTitle()#</a>';
		
		return bc;
	}
	
}
