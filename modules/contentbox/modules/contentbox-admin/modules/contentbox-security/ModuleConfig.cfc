/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox Security module configuration
*/
component {

	// Module Properties
	this.title 				= "ContentBox Security";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "ContentBox Security Module";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbadmin/security";
	this.dependencies 		= [ "contentbox-admin" ];

	function configure(){

		// Layout Settings
		layoutSettings = { defaultLayout = "simple.cfm" };

		// i18n
		i18n = {
			resourceBundles = {
		    	"security" = "#moduleMapping#/includes/i18n/security"
		  	}
		};

		// SES Routes
		routes = [
			{ pattern="/", handler="security", action="login" },
			{ pattern="/twofactor/:action?", handler="twofactor" },
			{ pattern="/twofactorEnrollment/:action?", handler="twofactorEnrollment" },
			{ pattern="/language/:lang", handler="security", action="changelang" },
			{ pattern="/:action", handler="security" },
			{ pattern="/:handler/:action?" }
		];

		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints = [
				// Login Layout HTML points
				"cbadmin_beforeLoginHeadEnd", "cbadmin_afterLoginBodyStart", "cbadmin_beforeLoginBodyEnd",
				"cbadmin_loginFooter", "cbadmin_beforeLoginContent", "cbadmin_afterLoginContent",
				// Login Form
				"cbadmin_beforeLoginForm", "cbadmin_afterLoginForm",
				// Lost Password
				"cbadmin_afterLostPasswordForm", "cbadmin_afterBackToLogin",
				// Security events
				"cbadmin_preLogin","cbadmin_onLogin","cbadmin_onBadLogin","cbadmin_onLogout",
				"cbadmin_onPasswordReminder","cbadmin_onInvalidPasswordReminder",
				"cbadmin_onPasswordReset", "cbadmin_onInvalidPasswordReset",
				// Two Factor Events
				"cbadmin_beforeTwoFactorForm","cbadmin_afterTwoFactorForm", "cbadmin_onInvalidTwoFactor", "cbadmin_onValidTwoFactor"
			]
		};

		// interceptors
		interceptors = [
			// ContentBox security via cbSecurity Module
			{
				class 		= "cbsecurity.interceptors.Security",
			  	name 		= "cbSecurity",
			  	properties 	= {
			 		rulesSource 		= "model",
			 		rulesModel			= "securityRuleService@cb",
			 		rulesModelMethod 	= "getSecurityRules",
			 		validatorModel 		= "securityService@cb"
			 	}
			}
            ,{
                class = "#moduleMapping#.interceptors.CheckForForceTwoFactorEnrollment",
                name = "CheckForForceTwoFactorEnrollment"
			}
		];

	}

}
