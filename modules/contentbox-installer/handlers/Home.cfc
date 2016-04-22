/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* The ContentBox installer handler
* Not cached, as it can be wiped after installation
*/
component cache=false{

	// DI
	property name="installerService" 	inject="installerService@cbi";
	property name="settingService" 	 	inject="settingService@cb";
	property name="cb"					inject="cbhelper@cb";
	
	/**
	* Pre Handler
	*/
	function preHandler( event, currentAction, rc, prc ){
		// setup asset root from administrator as that is the holder of 
		// all things assets :)
		prc.assetRoot 		= getContextRoot() & getModuleConfig( "contentbox-admin" ).mapping;
		prc.cbroot 			= prc.assetroot;
		prc.adminEntryPoint = getModuleConfig( "contentbox-admin" ).entryPoint;
		prc.uiEntryPoint 	= getModuleConfig( "contentbox-ui" ).entryPoint;
		prc.langs 			= getModuleSettings( "contentbox" ).languages;
	}

	/**
	* Index action
	*/
	function index( event, rc, prc ){
		prc.xehLang = event.buildLink( "cbInstaller/language" );
		event.setView( "home/index" );
	}
	
	/**
	* Change language
	*/
	function changeLang( event, rc, prc ){
		event.paramValue( "lang", "en_US" );
		setFWLocale( rc.lang );
		setNextEvent( "cbInstaller" );
	}
	
	/**
	* Do Installation
	*/
	function install( event, rc, prc ){
		// Verify installed?
		if( settingService.isCBReady() ){
			getModel( "messagebox@cbMessagebox" ).warn( cb.r( "validation.alreadyinstalled@installer" ) );
			setNextEvent(  prc.adminEntryPoint );
		}
		// start installation
		installerService.execute( populateModel( "Setup@cbi" ) );
		// start up fresh in next request
		applicationStop();
		// Take them to the finalized screen
		setNextEvent( "cbinstaller/finished" );
	}
	
	/**
	* Finished installer
	*/
	function finished( event, rc, prc ){
		prc.xehAdmin = prc.adminEntryPoint;
		prc.xehSite  = prc.uiEntryPoint;
		prc.xehLang  = event.buildLink( "cbInstaller/language" );
		
		event.setView( "home/finished" );
	}

}