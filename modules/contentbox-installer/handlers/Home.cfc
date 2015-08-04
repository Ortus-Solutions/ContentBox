/**
* The ContentBox installer handler
*/
component cache="false"{

	// DI
	property name="installerService" 	inject="installerService@cbi";
	property name="settingService" 	 	inject="settingService@cb";
	property name="cb"					inject="cbhelper@cb";
	
	function preHandler( event, currentAction, rc, prc ){
		// setup asset root from administrator as that is the holder of 
		// all things assets :)
		prc.assetRoot 		= getContextRoot() & getModuleConfig( "contentbox-admin" ).mapping;
		prc.adminEntryPoint = getModuleConfig( "contentbox-admin" ).entryPoint;
		prc.uiEntryPoint 	= getModuleConfig( "contentbox-ui" ).entryPoint;
		prc.langs 			= getModuleSettings( "contentbox" ).languages;
	}

	function index( event, rc, prc ){
		prc.xehLang = event.buildLink( "cbInstaller/language" );
		event.setView( "home/index" );
	}
	
	function changeLang( event, rc, prc ){
		event.paramValue( "lang", "en_US" );
		setFWLocale( rc.lang );
		setNextEvent( "cbInstaller" );
	}
	
	function install( event, rc, prc ){
		// Verify installed?
		if( settingService.isCBReady() ){
			getModel( "messagebox@cbMessagebox" ).warn( cb.r( "validation.alreadyinstalled@installer" ) );
			setNextEvent(  prc.adminEntryPoint );
		}
		// start installation
		installerService.execute( populateModel( "SetupBean@cbi" ) );
		// start up fresh in next request
		applicationStop();
		// Take them to the finalized screen
		setNextEvent( "cbinstaller/finished" );
	}
	
	function finished( event, rc, prc ){
		prc.xehAdmin = prc.adminEntryPoint;
		prc.xehSite  = prc.uiEntryPoint;
		prc.xehLang  = event.buildLink( "cbInstaller/language" );
		
		event.setView( "home/finished" );
	}

}