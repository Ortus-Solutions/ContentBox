/**
* ContentBox Admin module configuration
* Icon Themes: woothemesiconset, duesseldorf
*/
component {
	
	// Module Properties
	this.title 				= "ContentBox-Admin";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A cool blogging engine administrator";
	this.version			= "1.0";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	// Module Entry Point: The SES entry point for contentbox: http://myapp/cbadmin
	this.entryPoint			= "cbadmin";
	
	function configure(){
	
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
			{pattern="/pages/parent/:parent",handler="pages"},
			{pattern="/entries/pager/page/:page",handler="entries",action="pager"},
			{pattern="/comments/page/:page",handler="comments"},
			{pattern="/customHTML/page/:page",handler="customHTML"},
			{pattern="/:handler/:action?"}
		];		
		
		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints = arrayToList([
				// Admin Layout HTML points
				"cbadmin_beforeHeadEnd","cbadmin_afterBodyStart","cbadmin_beforeBodyEnd","cbadmin_footer","cbadmin_beforeContent","cbadmin_afterContent","cbadmin_onTagLine", "cbadmin_onTopBar",
				// Login Layout HTML points
				"cbadmin_beforeLoginHeadEnd","cbadmin_afterLoginBodyStart","cbadmin_beforeLoginBodyEnd","cbadmin_loginFooter","cbadmin_beforeLoginContent","cbadmin_afterLoginContent", 
				// Main Navigation
				"cbadmin_beforeMainNav","cbadmin_afterMainNav",
				// Main Tabs
				"cbadmin_dashboardTab","cbadmin_entriesTab","cbadmin_pagesTab","cbadmin_commentsTab","cbadmin_authorsTab","cbadmin_systemTab","cbadmin_toolsTab", 
				// Entry Events
				"cbadmin_preEntrySave","cbadmin_postEntrySave","cbadmin_preEntryRemove","cbadmin_postEntryRemove",
				// Author Events
				"cbadmin_preAuthorSave","cbadmin_postAuthorSave","cbadmin_onAuthorPasswordChange","cbadmin_preAuthorRemove","cbadmin_postAuthorRemove",
				// Category Events
				"cbadmin_preCategorySave","cbadmin_postCategorySave","cbadmin_preCategoryRemove","cbadmin_postCategoryRemove",
				// Comment eVents
				"cbadmin_onCommentStatusUpdate","cbadmin_preCommentSave","cbadmin_postCommentSave","cbadmin_preCommentRemove","cbadmin_postCommentRemove","cbadmin_preCommentSettingsSave","cbadmin_postCommentSettingsSave",
				"cbadmin_onCommentSettingsNav","cbadmin_onCommentSettingsContent",
				// Dashboard events
				"cbadmin_onDashboard",
				// Security events
				"cbadmin_preLogin","cbadmin_onLogin","cbadmin_onBadLogin","cbadmin_onLogout","cbadmin_onPasswordReminder","cbadmin_onInvalidPasswordReminder",
				// Settings events
				"cbadmin_preSettingsSave","cbadmin_postSettingsSave","cbadmin_preSettingRemove","cbadmin_postSettingRemove","cbadmin_onSettingsNav","cbadmin_onSettingsContent",
				// Custom HTML Events
				"cbadmin_preCustomHTMLSave", "cbadmin_postCustomHTMLSave","cbadmin_preCustomHTMLRemove", "cbadmin_postCustomHTMLRemove"
			])
		};
		
		// Custom Declared Interceptors
		interceptors = [
			// CB Admin Request Interceptor
			{class="#moduleMapping#.interceptors.CBRequest", properties={ entryPoint=this.entryPoint }, name="CBRequest@cbAdmin" },
			// CB Admin security
			{class="coldbox.system.interceptors.Security",properties={rulesSource="xml",rulesFile="#moduleMapping#/config/security.xml.cfm", validatorModel="securityService@cb"} }
		];
		
		// WireBox bindings
		
	}	
}