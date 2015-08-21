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
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "ContentBox Security Module";
	this.version			= "3.0.0-beta+@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "/cbadmin/security";
	this.dependencies 		= [];

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
				"cbadmin_loginFooter", "cbadmin_beforeLoginContent", "cbadmin_afterLoginContent"
			]
		};
		
		// interceptors
		interceptors = [
			// ContentBox security via cbSecurity Module
			{ 
				class 		= "cbsecurity.interceptors.Security",
			  	name 		= "security@cb",
			  	properties 	= {
			 		rulesSource 		= "model",
			 		rulesModel			= "securityRuleService@cb",
			 		rulesModelMethod 	= "getSecurityRules",
			 		validatorModel 		= "securityService@cb" 
			 	}
			}
		];

	}

}