<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	10/16/2007
Description :
	Application.cfc for generation API Docs
----------------------------------------------------------------------->
<cfcomponent output="false">

	<!--- APPLICATION CFC PROPERTIES --->
	<cfset this.name = "ContentBox-Docs" & hash(getCurrentTemplatePath())>
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,10,0)>
	<cfset this.setClientCookies = true>

	<!---Mappings --->
	<cfset this.mappings[ "/colddoc" ] 		= getDirectoryFromPath( getCurrentTemplatePath() ) & "/colddoc">
	<cfset this.mappings[ "/contentbox" ] 	= getDirectoryFromPath( getCurrentTemplatePath() ) & "/contentbox">
	<cfset this.mappings[ "/coldbox" ] 		= expandPath( "../../coldbox" )>

	<!---<cfset applicationstop()><cfabort>--->
</cfcomponent>