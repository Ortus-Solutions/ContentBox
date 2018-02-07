/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox security handler
*/
component{

	// DI
	property name="securityService" 	inject="securityService@cb";
	property name="authorService" 		inject="authorService@cb";
	property name="cb"					inject="cbhelper@cb";
	property name="messagebox"			inject="messagebox@cbMessagebox";
	property name="twoFactorService" 	inject="twoFactorService@cb";

	/**
	* Pre handler
	*/
	function preHandler( event, currentAction, rc, prc ){
		prc.langs 		= getModuleSettings( "contentbox" ).languages;
		prc.xehLang 	= event.buildLink( "#prc.cbAdminEntryPoint#/language" );
	}

}