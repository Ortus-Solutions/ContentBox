/**
* This simulates the onRequest start for the admin interface
*/
component extends="coldbox.system.Interceptor"{

	// DI
	property name="securityService" inject="id:securityService@cb";
	property name="settingService"  inject="id:settingService@cb";
	property name="adminMenuService"  inject="id:adminMenuService@cb";

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

		// Verify ContentBox installer has been ran?
		if( !settingService.isCBReady() ){
			setNextEvent('cbInstaller');
		}

		// store module root
		prc.cbRoot = event.getModuleRoot('contentbox-admin');
		// cb helper
		prc.CBHelper = getMyPlugin(plugin="CBHelper",module="contentbox");
		// store admin module entry point
		prc.cbAdminEntryPoint = getProperty("entryPoint");
		// store site entry point
		prc.cbEntryPoint = getModuleSettings("contentbox-ui").entryPoint;
		// store filebrowser entry point
		prc.cbFileBrowserEntryPoint = getModuleSettings("contentbox-filebrowser").entryPoint;
		// Place user in prc
		prc.oAuthor = securityService.getAuthorSession();
		// Place global cb options on scope
		prc.cbSettings = settingService.getAllSettings(asStruct=true);
		// store admin menu service
		prc.adminMenuService = adminMenuService;

		/************************************** NAVIGATION EXIT HANDLERS *********************************************/

		// Global Admin Exit Handlers
		prc.xehDashboard 	= "#prc.cbAdminEntryPoint#.dashboard";
		prc.xehAbout		= "#prc.cbAdminEntryPoint#.dashboard.about";

		// Entries Tab
		prc.xehEntries		= "#prc.cbAdminEntryPoint#.entries";
		prc.xehBlogEditor 	= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehCategories	= "#prc.cbAdminEntryPoint#.categories";

		// Content Tab
		prc.xehPages		= "#prc.cbAdminEntryPoint#.pages";
		prc.xehPagesEditor	= "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehCustomHTML	= "#prc.cbAdminEntryPoint#.customHTML";
		prc.xehMediaManager	= "#prc.cbAdminEntryPoint#.mediamanager";

		// Comments Tab
		prc.xehComments			= "#prc.cbAdminEntryPoint#.comments";
		prc.xehCommentsettings	= "#prc.cbAdminEntryPoint#.comments.settings";

		// Look and Feel Tab
		prc.xehLayouts		= "#prc.cbAdminEntryPoint#.layouts";
		prc.xehWidgets		= "#prc.cbAdminEntryPoint#.widgets";
		prc.xehGlobalHTML	= "#prc.cbAdminEntryPoint#.globalHTML";

		// Modules
		prc.xehModules = "#prc.cbAdminEntryPoint#.modules";

		// Authors Tab
		prc.xehAuthors		= "#prc.cbAdminEntryPoint#.authors";
		prc.xehAuthorEditor	= "#prc.cbAdminEntryPoint#.authors.editor";
		prc.xehPermissions		= "#prc.cbAdminEntryPoint#.permissions";
		prc.xehRoles			= "#prc.cbAdminEntryPoint#.roles";

		// Tools
		prc.xehToolsImport	= "#prc.cbAdminEntryPoint#.tools.importer";
		prc.xehApiDocs		= "#prc.cbAdminEntryPoint#.apidocs";

		// System
		prc.xehSettings			= "#prc.cbAdminEntryPoint#.settings";
		prc.xehSecurityRules	= "#prc.cbAdminEntryPoint#.securityrules";
		prc.xehRawSettings		= "#prc.cbAdminEntryPoint#.settings.raw";
		prc.xehEmailTemplates   = "#prc.cbAdminEntryPoint#.emailtemplates";
		prc.xehAutoUpdater	    = "#prc.cbAdminEntryPoint#.autoupdates";

		// Login/Logout
		prc.xehDoLogout 	= "#prc.cbAdminEntryPoint#.security.doLogout";
		prc.xehLogin 		= "#prc.cbAdminEntryPoint#.security.login";

		// CK Editor Integration Handlers
		prc.xehCKFileBrowserURL			= "#prc.cbAdminEntryPoint#/ckfilebrowser/";
		prc.xehCKFileBrowserURLImage	= "#prc.cbAdminEntryPoint#/ckfilebrowser/";
		prc.xehCKFileBrowserURLFlash	= "#prc.cbAdminEntryPoint#/ckfilebrowser/";


	}

}