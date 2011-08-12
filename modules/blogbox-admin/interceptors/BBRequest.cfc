/**
* This simulates the onRequest start for the admin interface
*/
component extends="coldbox.system.Interceptor"{

	// DI
	property name="securityService" inject="id:securityService@bb";
	property name="settingService"  inject="id:settingService@bb";

	/**
	* Configure BB Request
	*/ 
	function configure(){}

	/**
	* Fired on blogbox requests
	*/
	function preProcess(event, interceptData) eventPattern="^blogbox-admin"{
		var prc = event.getCollection(private=true);
		var rc	= event.getCollection();
		
		// store module root	
		prc.bbRoot = event.getModuleRoot();
		// bb helper
		prc.bbHelper = getMyPlugin(plugin="BBHelper",module="blogbox");
		// store admin module entry point
		prc.bbAdminEntryPoint = getProperty("entryPoint");
		// store site entry point
		prc.bbEntryPoint = getModuleSettings("blogbox-ui").entryPoint;
		// Place user in prc
		prc.oAuthor = securityService.getAuthorSession();
		// Place global bb options on scope
		prc.bbSettings = settingService.getAllSettings(asStruct=true);
		
		/************************************** NAVIGATION EXIT HANDLERS *********************************************/
		
		// Global Admin Exit Handlers
		prc.xehDashboard 	= "#prc.bbAdminEntryPoint#.dashboard";
		
		// Entries Tab
		prc.xehEntries		= "#prc.bbAdminEntryPoint#.entries";
		prc.xehBlogEditor 	= "#prc.bbAdminEntryPoint#.entries.editor";
		prc.xehCategories	= "#prc.bbAdminEntryPoint#.categories";
		
		// Pages Tab
		prc.xehPages		= "#prc.bbAdminEntryPoint#.pages";
		prc.xehPagesEditor	= "#prc.bbAdminEntryPoint#.pages.editor";
		
		// Comments Tab
		prc.xehComments			= "#prc.bbAdminEntryPoint#.comments";
		prc.xehCommentsettings	= "#prc.bbAdminEntryPoint#.comments.settings";
		
		// Site Tab
		prc.xehLayouts		= "#prc.bbAdminEntryPoint#.layouts";
		prc.xehCustomHTML	= "#prc.bbAdminEntryPoint#.customHTML";
		prc.xehWidgets		= "#prc.bbAdminEntryPoint#.widgets";
		
		// Authors Tab
		prc.xehAuthors		= "#prc.bbAdminEntryPoint#.authors";
		prc.xehAuthorEditor	= "#prc.bbAdminEntryPoint#.authors.editor";
		
		// Tools
		prc.xehToolsImport	= "#prc.bbAdminEntryPoint#.tools.importer";
		
		// System
		prc.xehSettings		= "#prc.bbAdminEntryPoint#.settings";
		prc.xehRawSettings	= "#prc.bbAdminEntryPoint#.settings.raw";
		
		// Login/Logout
		prc.xehDoLogout 	= "#prc.bbAdminEntryPoint#.security.doLogout";
		prc.xehLogin 		= "#prc.bbAdminEntryPoint#.security.login";
		
		/************************************** NAVIGATION TABS *********************************************/
		event.paramValue(name="tabDashboard",value=false,private=true);
		event.paramValue(name="tabEntries",value=false,private=true);
		event.paramValue(name="tabPages",value=false,private=true);
		event.paramValue(name="tabComments",value=false,private=true);
		event.paramValue(name="tabAuthors",value=false,private=true);
		event.paramValue(name="tabSite",value=false,private=true);
		event.paramValue(name="tabTools",value=false,private=true);
		event.paramValue(name="tabSystem",value=false,private=true);		
	}	
				
}