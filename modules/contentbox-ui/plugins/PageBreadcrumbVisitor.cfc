/**
* Visit page hierarchies and create breadcrumbs
*/
component singleton="true"{
	
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
	function visit(required page,string separator=">",required string homePage){
		var bc	= "";
		// recursive lookup
		if( arguments.page.hasParent() ){
			bc &= visit( arguments.page.getParent() );
		}
		
		// check if page slug is home, to ignore it
		if( arguments.page.getSlug() NEQ arguments.homePage ){
			bc &= '#arguments.separator# <a href="#CBHelper.linkPage(arguments.page)#">#arguments.page.getTitle()#</a> ';
		}
		
		return bc;
	}
	
}
