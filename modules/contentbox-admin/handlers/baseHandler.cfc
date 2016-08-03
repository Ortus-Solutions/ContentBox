/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* The admin cb handler base
*/
component{
	
	// Global Used DI
	property name="settingService"	inject="id:settingService@cb";
	property name="cbMessagebox" 	inject="id:messagebox@cbmessagebox";
}