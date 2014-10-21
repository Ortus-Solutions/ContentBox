/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* ContentBox UI module configuration
*/
component {

	// Module Properties
	this.title 				= "contentbox-security";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "ContentBox Security Module";
	this.version			= "2.1.0+@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbAdmin/security";

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
				"cbadmin_beforeLoginHeadEnd", "cbadmin_afterLoginBodyStart", "cbadmin_beforeLoginBodyEnd", "cbadmin_loginFooter", "cbadmin_beforeLoginContent", "cbadmin_afterLoginContent"
			]
		};
		
		// interceptors
		interceptors = [
			// ContentBox security
			{ class="coldbox.system.interceptors.Security",
			  name="security@cb",
			  properties={
			 	 rulesSource 	= "model",
			 	 rulesModel		= "securityRuleService@cb",
			 	 rulesModelMethod = "getSecurityRules",
			 	 validatorModel = "securityService@cb" }
			}
		];

	}

}