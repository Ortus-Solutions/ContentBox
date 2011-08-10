/**
* This simulates the onRequest start for the admin interface
*/
component extends="coldbox.system.Interceptor"{

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
		// store module entry point
		prc.bbEntryPoint = getProperty("entryPoint");
		// store site entry point
		prc.bbSiteEntryPoint = getModuleSettings("blogbox-ui").entryPoint;
		// Place user in prc
		prc.oAuthor = securityService.getAuthorSession();
		// Place global bb options on scope
		prc.bbSettings = settingService.getAllSettings(asStruct=true);
		
		/************************************** NAVIGATION EXIT HANDLERS *********************************************/
		
		// Global Admin Exit Handlers
		prc.xehDashboard 	= "#prc.bbEntryPoint#.dashboard";
		
		// Entries Tab
		prc.xehEntries		= "#prc.bbEntryPoint#.entries";
		prc.xehBlogEditor 	= "#prc.bbEntryPoint#.entries.editor";
		prc.xehCategories	= "#prc.bbEntryPoint#.categories";
		
		// Comments Tab
		prc.xehComments			= "#prc.bbEntryPoint#.comments";
		prc.xehCommentsettings	= "#prc.bbEntryPoint#.comments.settings";
		
		// Site Tab
		prc.xehLayouts		= "#prc.bbEntryPoint#.layouts";
		prc.xehCustomHTML	= "#prc.bbEntryPoint#.customHTML";
		prc.xehWidgets		= "#prc.bbEntryPoint#.widgets";
		
		// Authors Tab
		prc.xehAuthors		= "#prc.bbEntryPoint#.authors";
		prc.xehAuthorEditor	= "#prc.bbEntryPoint#.authors.editor";
		
		// Tools
		prc.xehToolsImport	= "#prc.bbEntryPoint#.tools.importer";
		
		// System
		prc.xehSettings		= "#prc.bbEntryPoint#.settings";
		prc.xehRawSettings	= "#prc.bbEntryPoint#.settings.raw";
		
		// Login/Logout
		prc.xehDoLogout 	= "#prc.bbEntryPoint#.security.doLogout";
		prc.xehLogin 		= "#prc.bbEntryPoint#.security.login";
		
		/************************************** NAVIGATION TABS *********************************************/
		event.paramValue(name="tabDashboard",value=false,private=true);
		event.paramValue(name="tabEntries",value=false,private=true);
		event.paramValue(name="tabComments",value=false,private=true);
		event.paramValue(name="tabAuthors",value=false,private=true);
		event.paramValue(name="tabSite",value=false,private=true);
		event.paramValue(name="tabTools",value=false,private=true);
		event.paramValue(name="tabSystem",value=false,private=true);		
	}	
				
}