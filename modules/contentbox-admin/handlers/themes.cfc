/**
* Manage Themes
*/
component extends="baseHandler"{

	// Dependencies
	property name="themeService"	inject="id:themeService@cb";
	property name="settingService"	inject="id:settingService@cb";
	property name="contentService"	inject="id:contentService@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabLookAndFeel = true;
	}

	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehThemes 			= "#prc.cbAdminEntryPoint#.themes.index";
		prc.xehThemeRemove 		= "#prc.cbAdminEntryPoint#.themes.remove";
		prc.xehThemeUpload  	= "#prc.cbAdminEntryPoint#.themes.upload";
		prc.xehFlushRegistry 	= "#prc.cbAdminEntryPoint#.themes.rebuildRegistry";
		prc.xehActivate			= "#prc.cbAdminEntryPoint#.themes.activate";
		prc.xehPreview			= "#prc.cbEntryPoint#.__preview";
		prc.xehForgeBox			= "#prc.cbAdminEntryPoint#.forgebox.index";
		prc.xehSaveSettings 	= "#prc.cbAdminEntryPoint#.themes.saveSettings";

		// Rescan if newly installed theme?
		if( event.getValue( "rescan", false ) ){
			themeService.buildThemeRegistry();
		}

		// Get all layouts
		prc.themes 			= themeService.getThemes();
		prc.themesPath 		= themeService.getThemesPath();
		prc.activeTheme 	= themeService.getActiveTheme();
		prc.themeService	= themeService;

		// ForgeBox Entry URL
		prc.forgeBoxEntryURL = getModuleSettings( "contentbox-admin" ).forgeBoxEntryURL;
		// ForgeBox Stuff
		prc.forgeBoxSlug 		= "contentbox-layouts";
		prc.forgeBoxInstallDir 	= URLEncodedFormat( themeService.getThemesPath() );
		prc.forgeboxReturnURL 	= URLEncodedFormat( event.buildLink( linkto=prc.xehThemes, querystring="rescan=true##managePane" ) );

		// Tab
		prc.tabLookAndFeel_themes = true;
		// view
		event.setView( "themes/index" );
	}
	
	// save Settings
	function saveSettings(event,rc,prc){
		var vResults = validateModel( target=rc, constraints=themeService.getSettingsConstraints( rc.themeName ) );
		// Validate results
		if( vResults.hasErrors() ){
			getModel( "messagebox@cbMessagebox" ).error(messageArray=vResults.getAllErrors());
			return index( argumentCollection=arguments );
		}
		
		// Results validated, save settings
		themeService.saveThemeSettings( name=rc.themeName, settings=rc );
		settingservice.flushSettingsCache();
		getModel( "messagebox@cbMessagebox" ).info(message="Theme settings saved!" );
		// Relocate
		setNextEvent(event=prc.xehThemes);
	}

	// activate theme
	function activate(event,rc,prc){
		// Activate the theme
		themeService.activateTheme( rc.themeName );
		// clear caches
		contentService.clearAllCaches();
		// messages
		getModel( "messagebox@cbMessagebox" ).info( "#rc.themeName# Activated!" );
		// Relocate
		setNextEvent(prc.xehThemes);
	}

	// rebuild registry
	function rebuildRegistry(event,rc,prc){
		themeService.buildThemeRegistry();
		getModel( "messagebox@cbMessagebox" ).info( "Themes re-scanned and registered!" );
		setNextEvent(event=prc.xehThemes, queryString="##themesPane" );
	}

	//Remove
	function remove(event,rc,prc){
		if( themeService.removeTheme( rc.themeName ) ){
			getModel( "messagebox@cbMessagebox" ).info( "Theme Removed Forever!" );
		}
		else{
			getModel( "messagebox@cbMessagebox" ).error( "Error removing theme, please check your logs for more information!" );
		}
		setNextEvent(event=prc.xehThemes, queryString="##themesPane" );
	}

	//upload
	function upload(event,rc,prc){
		var fp = event.getTrimValue( "fileTheme","" );

		// Verify
		if( len( fp ) eq 0){
			getModel( "messagebox@cbMessagebox" ).setMessage(type="warning", message="Please choose a file to upload" );
		}
		else{
			// Upload File
			try{
				var results = themeService.uploadTheme( "fileTheme" );

				if( !results.error ){
					// Good
					getModel( "messagebox@cbMessagebox" ).setMessage(type="info", message="Theme Installed Successfully" );
				}
				else{
					// Bad
					getModel( "messagebox@cbMessagebox" ).error(results.messages);
				}
			}
			catch(Any e){
				getModel( "messagebox@cbMessagebox" ).error( "Error uploading file: #e.detail# #e.message#" );
			}
		}

		setNextEvent(event=prc.xehThemes, queryString="##themesPane" );
	}
}
