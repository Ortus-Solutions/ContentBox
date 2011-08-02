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
		prc.bbSiteEntryPoint = getModuleSettings("blogbox").entryPoint;
		// Place user in prc
		prc.oAuthor = securityService.getAuthorSession();
		// Place global bb options on scope
		prc.bbSettings = settingService.getAllSettings(asStruct=true);
		
		/************************************** NAVIGATION EXIT HANDLERS *********************************************/
		
		// Global Admin Exit Handlers
		rc.xehDashboard 	= "#prc.bbEntryPoint#.dashboard";
		
		// Entries Tab
		rc.xehEntries		= "#prc.bbEntryPoint#.entries";
		rc.xehBlogEditor 	= "#prc.bbEntryPoint#.entries.editor";
		rc.xehCategories	= "#prc.bbEntryPoint#.categories";
		
		// Comments Tab
		rc.xehComments			= "#prc.bbEntryPoint#.comments";
		rc.xehCommentSettings	= "#prc.bbEntryPoint#.comments.settings";
		
		// Site Tab
		rc.xehLayouts			= "#prc.bbEntryPoint#.layouts";
		rc.xehCustomHTML		= "#prc.bbEntryPoint#.customHTML";
		rc.xehWidgets			= "#prc.bbEntryPoint#.widgets";
		
		// Authors Tab
		rc.xehAuthors			= "#prc.bbEntryPoint#.authors";
		rc.xehAuthorEditor		= "#prc.bbEntryPoint#.authors.editor";
		
		// System
		rc.xehSettings		= "#prc.bbEntryPoint#.settings";
		rc.xehRawSettings	= "#prc.bbEntryPoint#.settings.raw";
		
		// Login/Logout
		rc.xehDoLogout 		= "#prc.bbEntryPoint#.security.doLogout";
		rc.xehLogin 		= "#prc.bbEntryPoint#.security.login";
		
		/************************************** NAVIGATION TABS *********************************************/
		event.paramValue(name="tabDashboard",value=false,private=true);
		event.paramValue(name="tabEntries",value=false,private=true);
		event.paramValue(name="tabComments",value=false,private=true);
		event.paramValue(name="tabAuthors",value=false,private=true);
		event.paramValue(name="tabSite",value=false,private=true);
		event.paramValue(name="tabSystem",value=false,private=true);		
	}	
				
}