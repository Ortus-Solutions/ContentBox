<cfcomponent output="false">
	<cfscript>
	this.name = "ContentBox-Docs" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan(0,0,1,0);
	this.setClientCookies 	= true;

	// API Root
	API_ROOT = getDirectoryFromPath( getCurrentTemplatePath() );

	// Core Mappings
	this.mappings[ "/colddoc" ]  	= API_ROOT & "colddoc";
	// Standlone mappings
	this.mappings[ "/coldbox" ]  	= expandPath( "../../coldbox" );
	this.mappings[ "/contentbox" ]  = API_ROOT & "contentbox";


	function onRequestStart( required targetPage ){
		return true;
	}
	</cfscript>
</cfcomponent>