<!-----------------------------------------------------------------------
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
*/
----------------------------------------------------------------------->
<cfcomponent output="false">
	<!--- APPLICATION CFC PROPERTIES --->
	<cfset this.name = "ContentBoxTestingSuite" & hash(getCurrentTemplatePath())>
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,0,30)>
	<cfset this.setClientCookies = true>

	<cfscript>
	// ORM Settings
	this.ormEnabled = true;
	// FILL OUT: THE DATASOURCE OF CONTENTBOX
	this.datasource = "contentbox";
	// FILL OUT: THE LOCATION OF THE CONTENTBOX MODULE
	rootPath = replacenocase(replacenocase(getDirectoryFromPath(getCurrentTemplatePath()),"test\",""),"test/","");

	this.mappings["/root"]   = rootPath;
	this.mappings["/contentbox-test"] 	= getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings["/contentbox"] 		= rootPath & "/modules/contentbox" ;
	this.mappings["/contentbox-ui"] 	= rootPath & "modules/contentbox-ui";
	this.mappings["/contentbox-admin"] 	= rootPath & "modules/contentbox-admin";
	this.mappings["/contentbox-modules"] = rootPath & "modules/contentbox-modules";
	this.mappings["/coldbox"] 			= rootPath & "/coldbox" ;

	this.ormSettings = {
		cfclocation=["../modules/contentbox"],
		logSQL 				= true,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		eventHandling 		= true,
		eventHandler		= "contentbox.model.system.EventHandler",
		skipCFCWithError	= true,
		secondarycacheenabled = true,
		cacheprovider		= "ehCache"
	};

	public boolean function onRequestStart(String targetPage){
		// ORM Reload
		ormReload();

		return true;
	}
	</cfscript>
</cfcomponent>