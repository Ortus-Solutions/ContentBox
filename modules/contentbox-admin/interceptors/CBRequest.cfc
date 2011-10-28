/**
* This simulates the onRequest start for the admin interface
*/
component extends="coldbox.system.Interceptor"{

	// DI
	property name="securityService" inject="id:securityService@cb";
	property name="settingService"  inject="id:settingService@cb";

	/**
	* Configure CB Request
	*/ 
	function configure(){}

	/**
	* Fired on contentbox requests
	*/
	function preProcess(event, interceptData) eventPattern="^contentbox-admin"{
		var prc = event.getCollection(private=true);
		var rc	= event.getCollection();
		
		// store module root	
		prc.cbRoot = event.getModuleRoot();
		// cb helper
		prc.CBHelper = getMyPlugin(plugin="CBHelper",module="contentbox");
		// store admin module entry point
		prc.cbAdminEntryPoint = getProperty("entryPoint");
		// store site entry point
		prc.cbEntryPoint = getModuleSettings("contentbox-ui").entryPoint;
		// Place user in prc
		prc.oAuthor = securityService.getAuthorSession();
		// Place global cb options on scope
		prc.cbSettings = settingService.getAllSettings(asStruct=true);
		
		/************************************** NAVIGATION EXIT HANDLERS *********************************************/
		
		// Global Admin Exit Handlers
		prc.xehDashboard 	= "#prc.cbAdminEntryPoint#.dashboard";
		
		// Entries Tab
		prc.xehEntries		= "#prc.cbAdminEntryPoint#.entries";
		prc.xehBlogEditor 	= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehCategories	= "#prc.cbAdminEntryPoint#.categories";
		
		// Pages Tab
		prc.xehPages		= "#prc.cbAdminEntryPoint#.pages";
		prc.xehPagesEditor	= "#prc.cbAdminEntryPoint#.pages.editor";
		
		// Comments Tab
		prc.xehComments			= "#prc.cbAdminEntryPoint#.comments";
		prc.xehCommentsettings	= "#prc.cbAdminEntryPoint#.comments.settings";
		
		// Site Tab
		prc.xehLayouts		= "#prc.cbAdminEntryPoint#.layouts";
		prc.xehCustomHTML	= "#prc.cbAdminEntryPoint#.customHTML";
		prc.xehWidgets		= "#prc.cbAdminEntryPoint#.widgets";
		
		// Authors Tab
		prc.xehAuthors		= "#prc.cbAdminEntryPoint#.authors";
		prc.xehAuthorEditor	= "#prc.cbAdminEntryPoint#.authors.editor";
		
		// Tools
		prc.xehToolsImport	= "#prc.cbAdminEntryPoint#.tools.importer";
		
		// System
		prc.xehSettings		= "#prc.cbAdminEntryPoint#.settings";
		prc.xehRawSettings	= "#prc.cbAdminEntryPoint#.settings.raw";
		
		// Login/Logout
		prc.xehDoLogout 	= "#prc.cbAdminEntryPoint#.security.doLogout";
		prc.xehLogin 		= "#prc.cbAdminEntryPoint#.security.login";
		
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