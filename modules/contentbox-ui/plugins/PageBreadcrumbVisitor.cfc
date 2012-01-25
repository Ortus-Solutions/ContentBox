/**
* Visit page hierarchies and create breadcrumbs
*/
component singleton="true"{

	// DI	
	property name="CBHelper" inject="CBHelper@cb";
	
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
	function visit(required page,string separator=">"){
		var bc	= "";
		// recursive lookup
		if( arguments.page.hasParent() ){
			bc &= visit( arguments.page.getParent() );
		}
		
		// check if page slug is home, to ignore it
		if( arguments.page.getSlug() NEQ CBHelper.getHomePage() ){
			bc &= '#arguments.separator# <a href="#CBHelper.linkPage(arguments.page)#">#arguments.page.getTitle()#</a> ';
		}
		
		return bc;
	}
	
}
