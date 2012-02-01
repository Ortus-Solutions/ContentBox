<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	10/16/2007
Description :
	This is the Application.cfc for usage withing the ColdBox Framework.
	Make sure that it extends the coldbox object:
	coldbox.system.Coldbox
	
	So if you have refactored your framework, make sure it extends coldbox.
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
	this.mappings["/contentbox-shell"] 	= replacenocase(getDirectoryFromPath(getCurrentTemplatePath()),"test/","");
	this.mappings["/contentbox-test"] 	= getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings["/contentbox"] 		= this.mappings["/contentbox-shell"] & "/modules/contentbox" ;
	this.mappings["/coldbox"] 			= this.mappings["/contentbox-shell"] & "/coldbox" ;
	
	this.ormSettings = {
		cfclocation=["/contentbox-shell/modules"],
		logSQL 				= true,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		eventHandling 		= true,
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