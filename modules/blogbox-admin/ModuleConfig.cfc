/**
* BlogBox Admin module configuration
* Icon Themes: woothemesiconset, duesseldorf
*/
component {
	
	// Module Properties
	this.title 				= "BlogBox-Admin";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A cool blogging engine administrator";
	this.version			= "1.0";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	// Module Entry Point: The SES entry point for blogbox: http://myapp/bbadmin
	this.entryPoint			= "bbadmin";
	
	function configure(){
	
		// BLOGBOX MODULE LOCATION: CHANGE IF DIFFERENT FROM CONVENTIONS
		var BB_PATH = controller.getSetting("modules").blogbox.invocationPath;
		
		// Layout Settings
		layoutSettings = { defaultLayout = "admin.cfm" };
		
		// Module Settings
		settings = {
			// ForgeBox Settings
			forgeBoxURL 	 = "http://www.coldbox.org/forgebox",
			forgeBoxEntryURL = "http://www.coldbox.org/forgebox/view"
		};
		
		// SES Routes
		routes = [
			// Generic module route
			{pattern="/", handler="dashboard", action="index" },
			{pattern="/dashboard/reload/:targetModule", handler="dashboard", action="reload" },
			{pattern="/authors/page/:page",handler="authors"},
			{pattern="/entries/page/:page",handler="entries"},
			{pattern="/entries/pager/page/:page",handler="entries",action="pager"},
			{pattern="/comments/page/:page",handler="comments"},
			{pattern="/customHTML/page/:page",handler="customHTML"},
			{pattern="/:handler/:action?"}
		];		
		
		// Custom Declared Points
		interceptorSettings = {
			// BB Admin Custom Events
			customInterceptionPoints = arrayToList([
				// Admin Layout HTML points
				"bbadmin_beforeHeadEnd","bbadmin_afterBodyStart","bbadmin_beforeBodyEnd","bbadmin_footer","bbadmin_beforeContent","bbadmin_afterContent","bbadmin_onTagLine", "bbadmin_onTopBar",
				// Login Layout HTML points
				"bbadmin_beforeLoginHeadEnd","bbadmin_afterLoginBodyStart","bbadmin_beforeLoginBodyEnd","bbadmin_loginFooter","bbadmin_beforeLoginContent","bbadmin_afterLoginContent", 
				// Main Navigation
				"bbadmin_beforeMainNav","bbadmin_afterMainNav",
				// Main Tabs
				"bbadmin_dashboardTab","bbadmin_entriesTab","bbadmin_pagesTab","bbadmin_commentsTab","bbadmin_authorsTab","bbadmin_systemTab","bbadmin_toolsTab", 
				// Entry Events
				"bbadmin_preEntrySave","bbadmin_postEntrySave","bbadmin_preEntryRemove","bbadmin_postEntryRemove",
				// Author Events
				"bbadmin_preAuthorSave","bbadmin_postAuthorSave","bbadmin_onAuthorPasswordChange","bbadmin_preAuthorRemove","bbadmin_postAuthorRemove",
				// Category Events
				"bbadmin_preCategorySave","bbadmin_postCategorySave","bbadmin_preCategoryRemove","bbadmin_postCategoryRemove",
				// Comment eVents
				"bbadmin_onCommentStatusUpdate","bbadmin_preCommentSave","bbadmin_postCommentSave","bbadmin_preCommentRemove","bbadmin_postCommentRemove","bbadmin_preCommentSettingsSave","bbadmin_postCommentSettingsSave",
				"bbadmin_onCommentSettingsNav","bbadmin_onCommentSettingsContent",
				// Dashboard events
				"bbadmin_onDashboard",
				// Security events
				"bbadmin_preLogin","bbadmin_onLogin","bbadmin_onBadLogin","bbadmin_onLogout","bbadmin_onPasswordReminder","bbadmin_onInvalidPasswordReminder",
				// Settings events
				"bbadmin_preSettingsSave","bbadmin_postSettingsSave","bbadmin_preSettingRemove","bbadmin_postSettingRemove","bbadmin_onSettingsNav","bbadmin_onSettingsContent",
				// Custom HTML Events
				"bbadmin_preCustomHTMLSave", "bbadmin_postCustomHTMLSave","bbadmin_preCustomHTMLRemove", "bbadmin_postCustomHTMLRemove"
			])
		};
		
		// Custom Declared Interceptors
		interceptors = [
			// BB Admin Request Interceptor
			{class="#moduleMapping#.interceptors.BBRequest", properties={ entryPoint=this.entryPoint }, name="BBRequest@bbAdmin" },
			// BB Admin security
			{class="coldbox.system.interceptors.Security",properties={rulesSource="xml",rulesFile="#moduleMapping#/config/security.xml.cfm", validatorModel="securityService@bb"} }
		];
		
		// WireBox bindings
		
	}	
}