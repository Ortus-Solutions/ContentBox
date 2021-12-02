/**
 * Manage Themes
 */
component extends="baseHandler" {

	// Dependencies
	property name="themeService" inject="themeService@contentbox";
	property name="contentService" inject="contentService@contentbox";

	/**
	 * Active Theme
	 */
	function active( event, rc, prc ){
		// exit Handlers
		prc.xehPreview      = "#prc.cbEntryPoint#.__preview";
		prc.xehSaveSettings = "#prc.cbAdminEntryPoint#.themes.saveSettings";

		// Get them info
		prc.activeTheme  = variables.themeService.getActiveTheme();
		prc.themeService = variables.themeService;

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
		prc.xehThemes        = "#prc.cbAdminEntryPoint#.themes.index";
		prc.xehThemeRemove   = "#prc.cbAdminEntryPoint#.themes.remove";
		prc.xehThemeUpload   = "#prc.cbAdminEntryPoint#.themes.upload";
		prc.xehFlushRegistry = "#prc.cbAdminEntryPoint#.themes.rebuildRegistry";
		prc.xehActivate      = "#prc.cbAdminEntryPoint#.themes.activate";
		prc.xehPreview       = "#prc.cbEntryPoint#.__preview";
		prc.xehSaveSettings  = "#prc.cbAdminEntryPoint#.themes.saveSettings";

		// Rescan if newly installed theme?
		if ( event.getValue( "rescan", false ) ) {
			variables.themeService.buildThemeRegistry();
		}

		// Get all layouts
		prc.themes       = variables.themeService.getThemes();
		prc.activeTheme  = variables.themeService.getActiveTheme();
		prc.themeService = variables.themeService;

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
		var vResults       = validate(
			target     : rc,
			constraints: variables.themeService.getSettingsConstraints( rc.themeName )
		);

		// Validate results
		if ( vResults.hasErrors() ) {
			variables.cbMessagebox.error( vResults.getAllErrors() );
			return index( argumentCollection = arguments );
		}

		// Announce event
		announce( "cbadmin_preThemeSettingsSave", { name : rc.themeName } );

		// Results validated, save settings
		variables.themeService.saveThemeSettings( name = rc.themeName, settings = rc );
		variables.settingservice.flushSettingsCache();
		variables.cbMessagebox.info( message = "Theme settings saved!" );

		// Announce event
		announce( "cbadmin_postThemeSettingsSave", { name : rc.themeName } );

		// Relocate
		relocate( prc.xehActiveTheme );
	}

	/**
	 * Activate a theme for the site
	 */
	function activate( event, rc, prc ){
		// Activate the theme
		variables.themeService.activateTheme( rc.themeName );
		// clear caches
		variables.contentService.clearAllCaches();
		// messages
		variables.cbMessagebox.info( "#rc.themeName# Activated!" );
		// Relocate
		relocate( prc.xehThemes );
	}

	/**
	 * Rebuild theme registry
	 */
	function rebuildRegistry( event, rc, prc ){
		variables.themeService.buildThemeRegistry();
		variables.cbMessagebox.info( "Themes re-scanned and registered!" );
		relocate( prc.xehThemes );
	}

	/**
	 * Remove a theme
	 */
	function remove( event, rc, prc ){
		if ( variables.themeService.removeTheme( rc.themeName ) ) {
			variables.cbMessagebox.info( "Theme Removed Forever!" );
		} else {
			variables.cbMessagebox.error( "Error removing theme, please check your logs for more information!" );
		}
		relocate( prc.xehThemes );
	}

}
