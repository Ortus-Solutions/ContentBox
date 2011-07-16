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
		rc.xehComments		= "#prc.bbEntryPoint#.comments";
		
		// Authors Tab
		rc.xehAuthors			= "#prc.bbEntryPoint#.authors";
		rc.xehAuthorEditor		= "#prc.bbEntryPoint#.authors.editor";
		rc.xehAuthorsProfile	= "#prc.bbEntryPoint#.authors.profile";
		
		// System
		rc.xehSettings		= "#prc.bbEntryPoint#.settings";
		rc.xehDoLogout 		= "#prc.bbEntryPoint#.security.doLogout";
		rc.xehLogin 		= "#prc.bbEntryPoint#.security.login";
		
		/************************************** NAVIGATION TABS *********************************************/
		event.paramValue(name="tabDashboard",value=false,private=true);
		event.paramValue(name="tabEntries",value=false,private=true);
		event.paramValue(name="tabAuthors",value=false,private=true);
		event.paramValue(name="tabSystem",value=false,private=true);		
	}	
				
}