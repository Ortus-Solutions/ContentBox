/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Application Bootstrap
*/
component{
	// Application properties, modify as you see fit
	this.name = "ContentBox DSN Creator" & hash( getCurrentTemplatePath() );

	// LOCATION MAPPINGS
	request.APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );
	request.APP_ROOT_PATH = replacenocase( replace( request.APP_ROOT_PATH, "\", "/", "all" ), "modules/contentbox-dsncreator/", "" );
	
	this.mappings[ "/appShell" ] 	= request.APP_ROOT_PATH;
	this.mappings[ "/contentbox" ] 	= request.APP_ROOT_PATH & "modules/contentbox";
	
	public boolean function onRequestStart( string targetPage ){

		// CF/Railo Helper
		if( server.coldfusion.productName eq "ColdFusion Server" ){
			request.cfHelper = new models.CFHelper(); 
		} else {
			request.cfHelper = new models.LuceeHelper();
		}
		
		return true;
	}
}