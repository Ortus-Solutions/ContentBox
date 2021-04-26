/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox Admin Module
 */
component {

	// Module Properties
	this.title              = "ContentBox Admin";
	this.author             = "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.version            = "@version.number@+@build.number@";
	this.description        = "ContentBox Administration Module";
	this.viewParentLookup   = true;
	this.layoutParentLookup = true;
	this.entryPoint         = "cbadmin";
	this.modelNamespace     = "cbadmin";
	this.cfmapping          = "cbadmin";
	this.dependencies       = [];

	/**
	 * Configure Module
	 */
	function configure(){
		// Layout Settings
		layoutSettings = { defaultLayout : "admin.cfm" };

		// Module Settings
		settings = {};

		// i18n
		cbi18n = { resourceBundles : { "admin" : "#moduleMapping#/includes/i18n/admin" } };

		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints : [
				// Admin Layout HTML points
				"cbadmin_beforeHeadEnd",
				"cbadmin_afterBodyStart",
				"cbadmin_beforeBodyEnd",
				"cbadmin_footer",
				"cbadmin_beforeContent",
				"cbadmin_afterContent",
				"cbadmin_onTagLine",
				"cbadmin_onTopBar",
				// Entry Events
				"cbadmin_preEntrySave",
				"cbadmin_postEntrySave",
				"cbadmin_preEntryRemove",
				"cbadmin_postEntryRemove",
				"cbadmin_onEntryStatusUpdate",
				"cbadmin_entryEditorSidebar",
				"cbadmin_entryEditorSidebarAccordion",
				"cbadmin_entryEditorSidebarFooter",
				"cbadmin_entryEditorFooter",
				"cbadmin_entryEditorInBody",
				"cbadmin_entryEditorNav",
				"cbadmin_entryEditorNavContent",
				// ContentStore Events
				"cbadmin_preContentStoreSave",
				"cbadmin_postContentStoreSave",
				"cbadmin_preContentStoreRemove",
				"cbadmin_postContentStoreRemove",
				"cbadmin_onContentStoreStatusUpdate",
				"cbadmin_ContentStoreEditorSidebar",
				"cbadmin_ContentStoreEditorSidebarAccordion",
				"cbadmin_ContentStoreEditorSidebarFooter",
				"cbadmin_ContentStoreEditorFooter",
				"cbadmin_ContentStoreEditorInBody",
				"cbadmin_ContentStoreEditorNav",
				"cbadmin_contentStoreEditorNavContent",
				// Page Events
				"cbadmin_prePageSave",
				"cbadmin_postPageSave",
				"cbadmin_prePageRemove",
				"cbadmin_postPageRemove",
				"cbadmin_onPageStatusUpdate",
				"cbadmin_pageEditorSidebar",
				"cbadmin_pageEditorSidebarAccordion",
				"cbadmin_pageEditorSidebarFooter",
				"cbadmin_pageEditorFooter",
				"cbadmin_pageEditorInBody",
				"cbadmin_pageEditorNav",
				"cbadmin_pageEditorNavContent",
				// Author Events
				"cbadmin_preAuthorSave",
				"cbadmin_postAuthorSave",
				"cbadmin_onAuthorPasswordChange",
				"cbadmin_preAuthorRemove",
				"cbadmin_postAuthorRemove",
				"cbadmin_preAuthorPreferencesSave",
				"cbadmin_postAuthorPreferencesSave",
				"cbadmin_UserPreferencePanel",
				"cbadmin_onAuthorEditorNav",
				"cbadmin_onAuthorEditorContent",
				"cbadmin_onAuthorEditorSidebar",
				"cbadmin_onAuthorEditorActions",
				"cbadmin_onPasswordReset",
				"cbadmin_onGlobalPasswordReset",
				"cbadmin_onNewAuthorForm",
				"cbadmin_onNewAuthorActions",
				"cbadmin_preNewAuthorSave",
				"cbadmin_postNewAuthorSave",
				// Category Events
				"cbadmin_preCategorySave",
				"cbadmin_postCategorySave",
				"cbadmin_preCategoryRemove",
				"cbadmin_postCategoryRemove",
				// Comment Events
				"cbadmin_onCommentStatusUpdate",
				"cbadmin_preCommentSave",
				"cbadmin_postCommentSave",
				"cbadmin_preCommentRemove",
				"cbadmin_postCommentRemove",
				"cbadmin_preCommentRemoveAllModerated",
				"cbadmin_postCommentRemoveAllModerated",
				"cbadmin_preCommentSettingsSave",
				"cbadmin_postCommentSettingsSave",
				"cbadmin_onCommentSettingsNav",
				"cbadmin_onCommentSettingsContent",
				// Permission events
				"cbadmin_prePermissionSave",
				"cbadmin_postPermissionSave",
				"cbadmin_prePermissionRemove",
				"cbadmin_postPermissionRemove",
				// PermissionGroup events
				"cbadmin_prePermissionGroupSave",
				"cbadmin_postPermissionGroupSave",
				"cbadmin_prePermissionGroupRemove",
				"cbadmin_postPermissionGroupRemove",
				// Roles events
				"cbadmin_preRoleSave",
				"cbadmin_postRoleSave",
				"cbadmin_preRoleRemove",
				"cbadmin_postRoleRemove",
				// Dashboard events
				"cbadmin_onDashboard",
				"cbadmin_preDashboardContent",
				"cbadmin_postDashboardContent",
				"cbadmin_preDashboardSideBar",
				"cbadmin_postDashboardSideBar",
				"cbadmin_onDashboardTabNav",
				"cbadmin_preDashboardTabContent",
				"cbadmin_postDashboardTabContent",
				// Settings events
				"cbadmin_preSettingsSave",
				"cbadmin_postSettingsSave",
				"cbadmin_preSettingRemove",
				"cbadmin_postSettingRemove",
				"cbadmin_onSettingsNav",
				"cbadmin_onSettingsContent",
				// Global HTML Events
				"cbadmin_preGlobalHTMLSave",
				"cbadmin_postGlobalHTMLSave",
				// Security Rules Events
				"cbadmin_preSecurityRulesSave",
				"cbadmin_postSecurityRulesSave",
				"cbadmin_preSecurityRulesRemove",
				"cbadmin_postSecurityRulesRemove",
				"cbadmin_onResetSecurityRules",
				// Themes
				"cbadmin_onThemeActivation",
				"cbadmin_onThemeDeactivation",
				"cbadmin_preThemeSettingsSave",
				"cbadmin_postThemeSettingsSave",
				"cbadmin_onThemeSettings",
				"cbadmin_onThemeInfo",
				// Version Control
				"cbadmin_preContentVersionRemove",
				"cbadmin_postContentVersionRemove",
				"cbadmin_preContentVersionRollback",
				"cbadmin_postContentVersionRollback",
				// Version Screens
				"cbadmin_onVersionIndex",
				"cbadmin_onVersionDiff",
				// Menu events
				"cbadmin_preMenuSave",
				"cbadmin_postMenuSave",
				"cbadmin_preMenuRemove",
				"cbadmin_postMenuRemove",
				// Global Search
				"onGlobalSearchRequest",
				"onGlobalSearchDisplay",
				// Static Site Exporters,
				"cbadmin_preStaticSiteExport",
				"cbadmin_postStaticSiteExport",
				// Two Factor Events
				"cbadmin_onTwoFactorSettingsPanel",
				"cbadmin_onAuthorTwoFactorOptions",
				"cbadmin_onAuthorTwoFactorSaveOptions",
				// Site Events
				"cbadmin_preSiteRemove",
				"cbadmin_postSiteRemove",
				"cbadmin_preSiteSave",
				"cbadmin_postSiteSave"
			]
		};

		// Custom Declared Interceptors
		interceptors = [
			// CB Admin Request Interceptor
			{
				class      : "#moduleMapping#.interceptors.CBRequest",
				properties : { entryPoint : this.entryPoint },
				name       : "CBRequest@cbAdmin"
			},
			// Login Tracker and Preventer
			{
				class : "contentbox.models.security.LoginTracker",
				name  : "LoginTracker@cbAdmin"
			},
			// Admin Notification services
			{
				class : "contentbox.models.system.NotificationService",
				name  : "NotificationService@cbAdmin"
			},
			// Admin MenuBuilder Cleanups
			{
				class : "#moduleMapping#.interceptors.MenuCleanup",
				name  : "MenuCleanup@cbAdmin"
			},
			// ContentBox security via cbSecurity Module
			{
				class      : "cbsecurity.interceptors.Security",
				name       : "cbSecurity",
				properties : {
					// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
					"invalidAuthenticationEvent"  : "cbadmin/security/login",
					// Default Auhtentication Action: override or redirect when a user has not logged in
					"defaultAuthenticationAction" : "redirect",
					// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
					"invalidAuthorizationEvent"   : "cbadmin",
					// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
					"defaultAuthorizationAction"  : "redirect",
					// You can define your security rules here or externally via a source
					// specify an array for inline, or a string (db|json|xml|model) for externally
					"rules"                       : "model",
					// If source is model, the wirebox Id to use for retrieving the rules
					"rulesModel"                  : "securityRuleService@cb",
					"rulesModelMethod"            : "getSecurityRules",
					// The validator is an object that will validate rules and annotations and provide feedback on either authentication or authorization issues.
					"validator"                   : "SecurityService@cb",
					// The WireBox ID of the authentication service to use in cbSecurity which must adhere to the cbsecurity.interfaces.IAuthService interface.
					"authenticationService"       : "SecurityService@cb",
					// WireBox ID of the user service to use
					"userService"                 : "AuthorService@cb",
					// The name of the variable to use to store an authenticated user in prc scope if using a validator that supports it.
					"prcUserVariable"             : "oCurrentAuthor",
					// Use regex in rules
					"useRegex"                    : true,
					// Use SSL
					"useSSL"                      : false,
					// Enable annotation security as well
					"handlerAnnotationSecurity"   : true,
					// JWT Settings
					"jwt"                         : {
						// The issuer authority for the tokens, placed in the `iss` claim
						"issuer"              : "contentbox",
						// The jwt secret encoding key to use
						"secretKey"           : getSystemSetting( "JWT_SECRET", "" ),
						// by default it uses the authorization bearer header, but you can also pass a custom one as well or as an rc variable.
						"customAuthHeader"    : "x-auth-token",
						// The expiration in minutes for the jwt tokens
						"expiration"          : 60,
						// If true, enables refresh tokens, longer lived tokens (not implemented yet)
						"enableRefreshTokens" : false,
						// The default expiration for refresh tokens, defaults to 30 days
						"refreshExpiration"   : 43200,
						// encryption algorithm to use, valid algorithms are: HS256, HS384, and HS512
						"algorithm"           : "HS512",
						// Which claims neds to be present on the jwt token or `TokenInvalidException` upon verification and decoding
						"requiredClaims"      : [],
						// The token storage settings
						"tokenStorage"        : {
							// enable or not, default is true
							"enabled"    : true,
							// A cache key prefix to use when storing the tokens
							"keyPrefix"  : "cbjwt_",
							// The driver to use: db, cachebox or a WireBox ID
							"driver"     : "db",
							// Driver specific properties
							"properties" : {
								"table"             : "cb_jwt",
								"autoCreate"        : true,
								"rotationDays"      : 7,
								"rotationFrequency" : 60
							}
						}
					} // end jwt config
				} // end security config
			},
			// Two Factor Authentication Enrollment Verifier
			{
				class : "#moduleMapping#.interceptors.CheckForForceTwoFactorEnrollment",
				name  : "CheckForForceTwoFactorEnrollment"
			},
			// Unenroll Two Factor on Provider Change
			{
				class : "#moduleMapping#.interceptors.UnenrollTwoFactorOnProviderChange",
				name  : "UnenrollTwoFactorOnProviderChange@cbAdmin"
			}
		];
	}

	/*
	 * On Module Load
	 */
	function onLoad(){
		// Startup the Editor Service, needed for markup translations support
		wirebox.getInstance( "EditorService@cb" );

		// Messagebox overrides for admin
		wirebox
			.getInstance( "messagebox@cbmessagebox" )
			.setStyleOverride( true )
			.setTemplate( "/contentbox/models/ui/templates/messagebox.cfm" );
	}

}
