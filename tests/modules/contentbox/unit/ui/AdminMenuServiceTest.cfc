/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.ui.AdminMenuService"{

	void function setup(){
		super.setup();
		mockContext = getMockRequestContext();
		mockRequestService = getMockBox().createEmptyMock("coldbox.system.web.services.RequestService").$("getContext", mockContext);
		setupRequest( mockContext );

		// init the model object
		model.init(mockRequestService);
	}

	function testgenerateMenu(){
		r = model.generateMenu();
		debug( r );
		assertTrue( len(r) );
	}

	private function setupRequest(mockContext){
		var prc = mockContext.getCollection(private=true);

		// settings
		prc.cbSettings = {
			cb_site_disable_blog = false
		};


		prc.oAuthor = getMockBox().createMock("contentbox.model.security.Author").$("checkPermission",true);
		prc.cbAdminEntryPoint = "cbadmin";

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
