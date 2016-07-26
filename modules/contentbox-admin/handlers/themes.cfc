/**
* Manage Themes
*/
component extends="baseHandler"{

	// Dependencies
	property name="themeService"	inject="id:themeService@cb";
	property name="contentService"	inject="id:contentService@cb";

	/**
	* Active Theme
	*/
	function active( event, rc, prc ){
		// exit Handlers
		prc.xehPreview			= "#prc.cbEntryPoint#.__preview";
		prc.xehSaveSettings 	= "#prc.cbAdminEntryPoint#.themes.saveSettings";

		// Get them info
		prc.activeTheme 	= themeService.getActiveTheme();
		prc.themeService	= themeService;

		// Tab
		prc.tabLookAndFeel_activeTheme = true;

		// view
		event.setView( "themes/active" );
	}

	/**
	* Manage themes
	*/
	function index( event, rc, prc ){
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
		prc.forgeBoxSlug 		= "contentbox-themes";
		prc.forgeBoxInstallDir 	= URLEncodedFormat( themeService.getThemesPath() );
		prc.forgeboxReturnURL 	= URLEncodedFormat( event.buildLink( linkto=prc.xehThemes, querystring="rescan=true##managePane" ) );

		// Tab
		prc.tabLookAndFeel_themes = true;
		// view
		event.setView( "themes/index" );
	}
	
	/**
	* Save theme settings
	*/
	function saveSettings( event, rc, prc ){
		prc.xehActiveTheme = "#prc.cbAdminEntryPoint#.themes.active";
		var vResults = validateModel( target=rc, constraints=themeService.getSettingsConstraints( rc.themeName ) );
		// Validate results
		if( vResults.hasErrors() ){
			cbMessagebox.error( messageArray=vResults.getAllErrors() );
			return index( argumentCollection=arguments );
		}

		// Announce event
		announceInterception( "cbadmin_preThemeSettingsSave", { name=rc.themeName } );
		
		// Results validated, save settings
		themeService.saveThemeSettings( name=rc.themeName, settings=rc );
		settingservice.flushSettingsCache();
		cbMessagebox.info( message="Theme settings saved!" );

		// Announce event
		announceInterception( "cbadmin_postThemeSettingsSave", { name=rc.themeName } );

		// Relocate
		setNextEvent( event=prc.xehActiveTheme );
	}

	/**
	* Activate a theme
	*/
	function activate( event, rc, prc ){
		// Activate the theme
		themeService.activateTheme( rc.themeName );
		// clear caches
		contentService.clearAllCaches();
		// messages
		cbMessagebox.info( "#rc.themeName# Activated!" );
		// Relocate
		setNextEvent(prc.xehThemes);
	}

	/**
	* Rebuild theme registry
	*/
	function rebuildRegistry( event, rc, prc ){
		themeService.buildThemeRegistry();
		cbMessagebox.info( "Themes re-scanned and registered!" );
		setNextEvent( event=prc.xehThemes, queryString="##themesPane" );
	}

	/**
	* Remove a theme
	*/
	function remove( event, rc, prc ){
		if( themeService.removeTheme( rc.themeName ) ){
			cbMessagebox.info( "Theme Removed Forever!" );
		}
		else{
			cbMessagebox.error( "Error removing theme, please check your logs for more information!" );
		}
		setNextEvent(event=prc.xehThemes, queryString="##themesPane" );
	}

	/**
	* Upload a new theme
	*/
	function upload( event, rc, prc ){
		var fp = event.getTrimValue( "fileTheme","" );

		// Verify
		if( len( fp ) eq 0){
			cbMessagebox.setMessage(type="warning", message="Please choose a file to upload" );
		}
		else{
			// Upload File
			try{
				var results = themeService.uploadTheme( "fileTheme" );

				if( !results.error ){
					// Good
					cbMessagebox.setMessage(type="info", message="Theme Installed Successfully" );
				}
				else{
					// Bad
					cbMessagebox.error(results.messages);
				}
			}
			catch(Any e){
				cbMessagebox.error( "Error uploading file: #e.detail# #e.message#" );
			}
		}

		setNextEvent(event=prc.xehThemes, queryString="##themesPane" );
	}

}