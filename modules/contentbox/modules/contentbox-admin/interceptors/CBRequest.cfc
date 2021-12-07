/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This simulates the onRequest start for the admin interface
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="securityService" inject="securityService@contentbox";
	property name="settingService" inject="settingService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="adminMenuService" inject="adminMenuService@contentbox";
	property name="cbHelper" inject="CBHelper@contentbox";

	/**
	 * Configure CB Request
	 */
	function configure(){
		variables.childModulesRegex = arrayToList( getModuleConfig( "contentbox-admin" ).childModules, "|" );
	}

	/**
	 * Fired on ContentBox Admin and Child Module requests
	 */
	function preProcess( event, data, rc, prc ){
		// Only execute for admin or child modules
		if ( !reFindNoCase( "^(contentbox-admin|#variables.childModulesRegex#)", event.getCurrentEvent() ) ) {
			return;
		}

		// Verify ContentBox installer has been ran?
		if ( !settingService.isCBReady() ) {
			relocate( "cbInstaller" );
		}

		/************************************** SETUP CONTEXT REQUEST *********************************************/

		// store module root
		prc.cbRoot                  = getContextRoot() & event.getModuleRoot( "contentbox-admin" );
		// cb helper
		prc.CBHelper                = variables.cbHelper;
		// store admin module entry point
		prc.cbAdminEntryPoint       = getModuleConfig( "contentbox-admin" ).entryPoint;
		// store filebrowser entry point
		prc.cbFileBrowserEntryPoint = getModuleConfig( "contentbox-filebrowser" ).entryPoint;
		// store site entry point if loaded
		if ( structKeyExists( getSetting( "modules" ), "contentbox-ui" ) ) {
			prc.cbEntryPoint = getModuleConfig( "contentbox-ui" ).entryPoint;
		} else {
			prc.cbEntryPoint = "";
		}
		// Place user in prc
		prc.oCurrentAuthor   = variables.securityService.getAuthorSession();
		// Place all sites in prc for usage by the UI switcher
		prc.allSites         = variables.siteService.getAllFlat( isActive: true );
		// Get the current working site object on PRC
		prc.oCurrentSite     = variables.siteService.getCurrentWorkingSite();
		// Place global cb options on scope
		prc.cbSettings       = variables.settingService.getAllSettings();
		prc.cbSiteSettings   = variables.settingService.getAllSiteSettings( prc.oCurrentSite.getSlug() );
		// Place widgets root location
		prc.cbWidgetRoot     = getContextRoot() & event.getModuleRoot( "contentbox" ) & "/widgets";
		// store admin menu service
		prc.adminMenuService = variables.adminMenuService;
		// Sidemenu collapsed
		prc.sideMenuClass    = "";

		// Is sidemenu collapsed for user?
		if ( prc.oCurrentAuthor.getPreference( "sidemenuCollapse", false ) == "true" ) {
			prc.sideMenuClass = "sidebar-mini";
		}

		/************************************** FORCE SSL *********************************************/

		if ( prc.cbSettings.cb_admin_ssl and !event.isSSL() ) {
			relocate( event = event.getCurrentRoutedURL(), ssl = true );
		}

		/************************************** FORCE PASSWORD RESET *********************************************/

		if (
			!findNoCase( "contentbox-security:security", event.getCurrentEvent() )
			&&
			prc.oCurrentAuthor.getIsPasswordReset()
		) {
			var token = securityService.generateResetToken( prc.oCurrentAuthor );
			getInstance( "messagebox@cbMessagebox" ).info(
				prc.CBHelper.r( "messages.password_reset_detected@security" )
			);
			relocate( event = "#prc.cbAdminEntryPoint#.security.verifyReset", queryString = "token=#token#" );
			return;
		}

		/************************************** NAVIGATION EXIT HANDLERS *********************************************/

		// Global Admin Exit Handlers
		prc.xehDashboard             = "#prc.cbAdminEntryPoint#.dashboard";
		prc.xehAbout                 = "#prc.cbAdminEntryPoint#.dashboard.about";
		// Entries Tab
		prc.xehEntries               = "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntriesEditor         = "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehCategories            = "#prc.cbAdminEntryPoint#.categories";
		// Content Tab
		prc.xehPages                 = "#prc.cbAdminEntryPoint#.pages";
		prc.xehPagesEditor           = "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehContentStore          = "#prc.cbAdminEntryPoint#.contentStore";
		prc.xehContentStoreEditor    = "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehMediaManager          = "#prc.cbAdminEntryPoint#.mediamanager";
		prc.xehMenuManager           = "#prc.cbAdminEntryPoint#.menus";
		prc.xehMenuManagerEditor     = "#prc.cbAdminEntryPoint#.menus.editor";
		// Comments Tab
		prc.xehComments              = "#prc.cbAdminEntryPoint#.comments";
		prc.xehCommentsettings       = "#prc.cbAdminEntryPoint#.comments.settings";
		// Look and Feel Tab
		prc.xehThemes                = "#prc.cbAdminEntryPoint#.themes";
		prc.xehWidgets               = "#prc.cbAdminEntryPoint#.widgets";
		prc.xehGlobalHTML            = "#prc.cbAdminEntryPoint#.globalHTML";
		// Modules
		prc.xehModules               = "#prc.cbAdminEntryPoint#.modules";
		// Authors Tab
		prc.xehAuthors               = "#prc.cbAdminEntryPoint#.authors";
		prc.xehAuthorNew             = "#prc.cbAdminEntryPoint#.authors.new";
		prc.xehAuthorEditor          = "#prc.cbAdminEntryPoint#.authors.editor";
		prc.xehPermissions           = "#prc.cbAdminEntryPoint#.permissions";
		prc.xehPermissionGroups      = "#prc.cbAdminEntryPoint#.permissionGroups";
		prc.xehRoles                 = "#prc.cbAdminEntryPoint#.roles";
		prc.xehSavePreference        = "#prc.cbAdminEntryPoint#.authors.saveSinglePreference";
		// Tools
		prc.xehToolsImport           = "#prc.cbAdminEntryPoint#.tools.importer";
		// System
		prc.xehSettings              = "#prc.cbAdminEntryPoint#.settings";
		prc.xehSitesManager          = "#prc.cbAdminEntryPoint#.sites";
		prc.xehChangeSite            = "#prc.cbAdminEntryPoint#.sites.changeSite";
		prc.xehSecurityRules         = "#prc.cbAdminEntryPoint#.securityrules";
		prc.xehRawSettings           = "#prc.cbAdminEntryPoint#.settings.raw";
		// Stats
		prc.xehSubscribers           = "#prc.cbAdminEntryPoint#.subscribers";
		// Login/Logout
		prc.xehDoLogout              = "#prc.cbAdminEntryPoint#.security.doLogout";
		prc.xehLogin                 = "#prc.cbAdminEntryPoint#.security.login";
		// CK Editor Integration Handlers For usage with the Quick Post
		prc.xehCKFileBrowserURL      = "#prc.cbAdminEntryPoint#/ckfilebrowser/";
		prc.xehCKFileBrowserURLImage = "#prc.cbAdminEntryPoint#/ckfilebrowser/";
		prc.xehCKFileBrowserURLFlash = "#prc.cbAdminEntryPoint#/ckfilebrowser/";
		// Search global
		prc.xehSearchGlobal          = "#prc.cbAdminEntryPoint#.content.search";
		// Prepare Admin Actions
		prc.xehAdminAction           = "#prc.cbAdminEntryPoint#.dashboard.reload";
		// Installer Check
		prc.installerCheck           = variables.settingService.isInstallationPresent();
	}

}
