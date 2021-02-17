/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox Security module configuration
 */
component {

	// Module Properties
	this.title              = "ContentBox Security";
	this.author             = "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.description        = "ContentBox Security Module";
	this.viewParentLookup   = true;
	this.layoutParentLookup = true;
	this.entryPoint         = "cbadmin/security";
	this.dependencies       = [ "contentbox-admin" ];

	function configure(){
		// Layout Settings
		layoutSettings = { defaultLayout : "simple.cfm" };

		// i18n
		cbi18n = {
			resourceBundles : {
				"security" : "#moduleMapping#/includes/i18n/security"
			}
		};

		// SES Routes
		routes = [
			{ pattern : "/", handler : "security", action : "login" },
			{ pattern : "/twofactor/:action?", handler : "twofactor" },
			{
				pattern : "/twofactorEnrollment/:action?",
				handler : "twofactorEnrollment"
			},
			{
				pattern : "/language/:lang",
				handler : "security",
				action  : "changelang"
			},
			{ pattern : "/:action", handler : "security" },
			{ pattern : "/:handler/:action?" }
		];

		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints : [
				// Login Layout HTML points
				"cbadmin_beforeLoginHeadEnd",
				"cbadmin_afterLoginBodyStart",
				"cbadmin_beforeLoginBodyEnd",
				"cbadmin_loginFooter",
				"cbadmin_beforeLoginContent",
				"cbadmin_afterLoginContent",
				// Login Form
				"cbadmin_beforeLoginForm",
				"cbadmin_afterLoginForm",
				// Lost Password
				"cbadmin_afterLostPasswordForm",
				"cbadmin_afterBackToLogin",
				// Security events
				"cbadmin_preLogin",
				"cbadmin_onLogin",
				"cbadmin_onBadLogin",
				"cbadmin_onLogout",
				"cbadmin_onPasswordReminder",
				"cbadmin_onInvalidPasswordReminder",
				"cbadmin_onPasswordReset",
				"cbadmin_onInvalidPasswordReset",
				// Two Factor Events
				"cbadmin_beforeTwoFactorForm",
				"cbadmin_afterTwoFactorForm",
				"cbadmin_onInvalidTwoFactor",
				"cbadmin_onValidTwoFactor"
			]
		};

		// interceptors
		interceptors = [
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
			}
		];
	}

}
