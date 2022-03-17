/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages ContentBox themes
 */
component accessors="true" threadSafe singleton {

	// DI
	property name="settingService" inject="settingService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	// Provide this one in, due to chicken and the egg issues.
	property name="widgetService" inject="provider:widgetService@contentbox";
	property name="moduleSettings" inject="coldbox:setting:modules";
	property name="interceptorService" inject="coldbox:interceptorService";
	property name="log" inject="logbox:logger:{this}";
	property name="wirebox" inject="wirebox";
	property name="html" inject="HTMLHelper@coldbox";
	property name="cbHelper" inject="provider:CBHelper@contentbox";
	property name="moduleService" inject="coldbox:moduleService";

	/**
	 * The location of core themes on disk: Defaults to /modules/contentbox/themes
	 */
	property name="coreThemesPath";

	/**
	 * The location of custom themes on disk: Defaults to /modules_app/contentbox-custom/_themes
	 */
	property name="customThemesPath";

	/**
	 * The theme registry of records
	 */
	property name="themeRegistry" type="struct";

	/**
	 * The cache of widgets for the active theme
	 */
	property name="widgetCache" type="struct";

	/**
	 * Constructor
	 */
	ThemeService function init(){
		// init properties
		variables.themeRegistry    = {};
		variables.coreThemesPath   = "";
		variables.customThemesPath = "";
		variables.widgetCache      = {};

		return this;
	}

	/**
	 * onDIComplete startup the theming services according to loaded module data
	 */
	void function onDIComplete(){
		// setup location paths
		variables.coreThemesPath   = variables.moduleSettings[ "contentbox" ].path & "/themes";
		variables.customThemesPath = variables.moduleSettings[ "contentbox-custom" ].path & "/_themes";

		// Register all themes
		buildThemeRegistry();
	}

	/**
	 * Does the current active theme have a maintenance view
	 */
	boolean function themeMaintenanceViewExists(){
		return fileExists( expandPath( variables.CBHelper.themeRoot() & "/views/maintenance.cfm" ) );
	}

	/**
	 * Get the current active theme's maintenance layout
	 */
	string function getThemeMaintenanceLayout(){
		var layout = "pages";

		// verify existence of convention
		if ( fileExists( expandPath( variables.CBHelper.themeRoot() & "/layouts/maintenance.cfm" ) ) ) {
			layout = "maintenance";
		}

		return layout;
	}

	/**
	 * Get the current theme's print layouts in ColdBox layout string format
	 *
	 * @format export format
	 * @layout layout name
	 */
	string function getThemePrintLayout( required format, required layout ){
		// some cleanup, just in case
		arguments.layout = replaceNoCase( arguments.layout, ".cfm", "" );
		// verify existence of convention
		if (
			fileExists(
				expandPath( variables.CBHelper.themeRoot() & "/layouts/#arguments.layout#_#arguments.format#.cfm" )
			)
		) {
			return "#arguments.layout#_#arguments.format#";
		}

		return "#arguments.layout#";
	}

	/**
	 * Get the current theme's search layout
	 */
	string function getThemeSearchLayout(){
		var layout = "pages";

		// verify existence of convention
		if ( fileExists( expandPath( variables.CBHelper.themeRoot() & "/layouts/search.cfm" ) ) ) {
			layout = "search";
		}

		return layout;
	}

	/**
	 * Returns the invocation path for the requested widget from themes service's layout cache
	 *
	 * @widgetName The name of the widget
	 */
	string function getThemeWidgetInvocationPath( required string widgetName ){
		var path       = "";
		var parsedName = replaceNoCase( arguments.widgetName, "~", "", "one" );
		// if requested widget exists in the cache, return the path
		if ( structKeyExists( variables.widgetCache, parsedName ) ) {
			path = variables.widgetCache[ parsedName ].invocationPath;
		} else {
			log.error( "Could not find '#parsedName#' widget in the currently active theme." );
		}
		return path;
	}

	/**
	 * This method is called from the UI module to make sure all site themes are online before
	 * serving requets
	 */
	function startupSiteThemes(){
		// Startup the themes
		variables.siteService
			.getAllSiteThemes()
			.each( function( record ){
				startupTheme( name: arguments.record[ "activeTheme" ], site: arguments.record[ "siteID" ] );
			} );

		// Flush the settings now
		variables.settingService.flushSettingsCache();
	}

	/**
	 * Startup a theme in the system, processes interceptions, modules, widgets, etc
	 *
	 * @name           The name of the theme to activate
	 * @processWidgets Process widget registration on activation, defaults to true.
	 * @site           The site id or object we are starting up this theme for
	 */
	function startupTheme(
		required name,
		boolean processWidgets = true,
		any site               = ""
	){
		// Get theme record information
		var themeRecord = getThemeRecord( arguments.name );
		var oTheme      = themeRecord.descriptor;
		// Determine object or id
		if ( isSimpleValue( arguments.site ) ) {
			arguments.site = variables.siteService.getOrFail( arguments.site );
		}

		// Register description as an interceptor with custom points
		variables.interceptorService.registerInterceptor(
			interceptorObject: oTheme,
			interceptorName  : "cbtheme-#arguments.name#-#arguments.site.getsiteID()#",
			customPoints     : themeRecord.customInterceptionPoints
		);

		// Register theme settings?
		if ( structKeyExists( oTheme, "settings" ) ) {
			registerThemeSettings(
				name    : arguments.name,
				settings: oTheme.settings,
				site    : arguments.site
			);
		}

		// build widget cache for active theme
		for ( var thisWidget in themeRecord.widgets.listToArray() ) {
			var widgetName                      = replaceNoCase( thisWidget, ".cfc", "", "one" );
			variables.widgetCache[ widgetName ] = {
				name           : widgetName,
				invocationPath : "#themeRecord.invocationPath#.widgets.#widgetName#",
				path           : "#themeRecord.path#/#arguments.name#/widgets/#thisWidget#",
				theme          : arguments.name
			};
		}

		// activate theme modules
		for ( var thisModule in themeRecord.modules.listToArray() ) {
			variables.moduleService.registerAndActivateModule(
				moduleName    : thisModule,
				invocationPath: "#themeRecord.invocationPath#.modules"
			);
		}

		// Register all widgets
		if ( arguments.processWidgets ) {
			variables.widgetService.processThemeWidgets();
		}

		// Announce theme activation
		variables.interceptorService.announce(
			"cbadmin_onThemeActivation",
			{
				themeName   : arguments.name,
				themeRecord : themeRecord,
				site        : arguments.site
			}
		);

		// Call Theme Callbacks: onActivation
		if ( structKeyExists( oTheme, "onActivation" ) ) {
			oTheme.onActivation();
		}
	}

	/**
	 * Save theme settings as they are coming from form submissions as a struct with a common prefix
	 * cb_theme_{themeName}_{settingName}
	 *
	 * @name     The theme name
	 * @settings The settings struct
	 *
	 * @return ThemeService
	 */
	function saveThemeSettings( required name, required struct settings ){
		var oSite = variables.siteService.getCurrentWorkingSite();

		transaction {
			// Filter out settings that are not theme based
			arguments.settings
				.filter( function( key, value ){
					return ( findNoCase( "cb_theme_#name#_", key ) ? true : false );
				} )
				.each( function( key, value ){
					var oSetting = variables.settingService.findSiteSetting( oSite, key );

					if ( isNull( oSetting ) ) {
						oSetting = variables.settingService.new( { name : key } );
					}

					oSetting.setValue( value );
					oSetting.setSite( oSite );

					variables.settingService.save( oSetting );
				} );
		}

		return this;
	}

	/**
	 * Get the current active theme record for the current working site
	 */
	struct function getActiveTheme(){
		return getThemeRecord( variables.siteService.getCurrentWorkingSite().getActiveTheme() );
	}

	/**
	 * Get a theme record from the registry by name.
	 *
	 * @themeName The name of the theme
	 */
	struct function getThemeRecord( required themeName ){
		return variables.themeRegistry[ arguments.themeName ];
	}

	/**
	 * Verify if the passed theme name is the currently working site active theme
	 *
	 * @themeName The name of the theme to check
	 */
	boolean function isActiveTheme( required themeName ){
		return ( compareNoCase( getActiveTheme().name, arguments.themeName ) EQ 0 );
	}

	/**
	 * Activate a specific theme for the current working site
	 *
	 * @themeName The theme name to activate
	 */
	function activateTheme( required themeName ){
		transaction {
			var currentSite = variables.siteService.getCurrentWorkingSite();
			var themeRecord = getThemeRecord( currentSite.getActiveTheme() );

			// Call deactivation event for the previous active theme
			variables.interceptorService.announce(
				"cbadmin_onThemeDeactivation",
				{
					themeName   : currentSite.getActiveTheme(),
					themeRecord : themeRecord,
					site        : currentSite
				}
			);

			// Call Old Theme Callback: onDeactivation
			if ( structKeyExists( themeRecord.descriptor, "onDeactivation" ) ) {
				themeRecord.descriptor.onDeactivation();
			}

			// Unload old theme modules
			for ( var thisModule in themeRecord.modules.listToArray() ) {
				variables.moduleService.unload( thisModule );
			}

			// Unregister theme Descriptor Interceptor
			variables.interceptorService.unregister(
				interceptorName = "cbTheme-#currentSite.getActiveTheme()#-#currentSite.getsiteID()#"
			);

			// Setup the new chosen theme for the site
			currentSite.setActiveTheme( arguments.themeName );
			variables.siteService.save( currentSite );

			// Force Recreation of all Widgets, since we need to deactivate the old widgets
			variables.widgetService.getWidgets( reload = true );
		}

		// Flush the settings from the cache, now that they are persisted
		variables.settingService.flushSettingsCache();

		return this;
	}

	/**
	 * Get all registered themes via the registry.
	 */
	struct function getThemes(){
		if ( isSimpleValue( variables.themeRegistry ) ) {
			buildThemeRegistry();
		}
		return variables.themeRegistry;
	}

	/**
	 * Get all registered custom themes via the registry.
	 */
	struct function getCustomThemes(){
		if ( isSimpleValue( variables.themeRegistry ) ) {
			buildThemeRegistry();
		}
		return variables.themeRegistry.filter( function( item, contents ){
			return ( contents.type == "custom" ? true : false );
		} );
	}

	/**
	 * Build the theme registry via discovery
	 */
	ThemeService function buildThemeRegistry(){
		// Get Core Themes and Process Them
		getThemesOnDisk( variables.coreThemesPath ).each( function( item ){
			processThemeRecord(
				name           = arguments.item,
				path           = variables.coreThemesPath,
				invocationPath = variables.moduleSettings[ "contentbox" ].invocationPath & ".themes",
				includePath    = variables.moduleSettings[ "contentbox" ].mapping & "/themes",
				type           = "core",
				module         = "contentbox"
			);
		} );

		// Get Custom Themes and Process Them
		getThemesOnDisk( variables.customThemesPath ).each( function( item ){
			processThemeRecord(
				name           = arguments.item,
				path           = variables.customThemesPath,
				invocationPath = variables.moduleSettings[ "contentbox-custom" ].invocationPath & "._themes",
				includePath    = variables.moduleSettings[ "contentbox-custom" ].mapping & "/_themes",
				type           = "custom",
				module         = "contentbox-custom"
			);
		} );

		return this;
	}

	/**
	 * Process a theme record and store appropriate data and cfc registries
	 *
	 * @name           The name of the theme on disk
	 * @path           The path of the theme
	 * @invocationPath The invocation path of the theme
	 * @includePath    The include path of the theme
	 * @type           The type of theme it is: core, custom
	 * @module         The module this theme exists under
	 */
	function processThemeRecord(
		name,
		path,
		invocationPath,
		includePath,
		type,
		module
	){
		var record = {
			"name"                     : arguments.name,
			"descriptor"               : "",
			"type"                     : arguments.type,
			"module"                   : arguments.module,
			"isValid"                  : false,
			"path"                     : arguments.path,
			"invocationPath"           : arguments.invocationPath & "." & arguments.name,
			"includePath"              : arguments.includePath & "/" & arguments.name,
			"themeName"                : "",
			"description"              : "",
			"version"                  : "",
			"author"                   : "",
			"authorURL"                : "",
			"screenShotURL"            : "",
			"forgeBoxSlug"             : "",
			"customInterceptionPoints" : "",
			"layouts"                  : "",
			"settings"                 : "",
			"widgets"                  : "",
			"modules"                  : ""
		};

		// Check for theme descriptor by 'theme.cfc' or '#themeName#.cfc'
		var descriptorPath     = arguments.path & "/#arguments.name#/Theme.cfc";
		var descriptorInstance = arguments.invocationPath & ".#arguments.name#.Theme";
		if ( !fileExists( descriptorPath ) ) {
			// try by theme name instead
			descriptorPath     = arguments.path & "/#arguments.name#/#arguments.name#.cfc";
			descriptorInstance = arguments.invocationPath & ".#arguments.name#.#arguments.name#";
			if ( !fileExists( descriptorPath ) ) {
				log.warn( "The theme: #arguments.name# has no theme descriptor, skipping registration." );
				variables.themeRegistry[ arguments.name ] = record;
				return;
			}
		}

		// construct descriptor via WireBox
		var oThemeConfig = wirebox.getInstance( descriptorInstance );

		// Populate Record with it
		record.descriptor  = oThemeConfig;
		record.isValid     = true;
		record.themeName   = oThemeConfig.name;
		record.description = oThemeConfig.description;
		record.version     = oThemeConfig.version;
		record.author      = oThemeConfig.author;
		record.authorURL   = oThemeConfig.authorURL;
		// Screenshot
		if ( structKeyExists( oThemeConfig, "screenShotURL" ) ) {
			record.screenShotURL = arguments.includePath & "/#arguments.name#/" & oThemeConfig.screenShotURL;
		}

		// ForgeBox slug
		if ( structKeyExists( oThemeConfig, "forgeBoxSlug" ) ) {
			record.forgeBoxSlug = oThemeConfig.forgeBoxSlug;
		}

		// Custom Interception Point
		if ( structKeyExists( oThemeConfig, "customInterceptionPoints" ) ) {
			record.customInterceptionPoints = oThemeConfig.customInterceptionPoints;
		}

		// Settings
		if ( structKeyExists( oThemeConfig, "settings" ) ) {
			record.settings = oThemeConfig.settings;
		}

		// Theme Widgets
		if ( directoryExists( arguments.path & "/#arguments.name#/widgets" ) ) {
			var thisWidgets = directoryList(
				arguments.path & "/#arguments.name#/widgets",
				false,
				"query",
				"*.cfc",
				"name asc"
			);
			record.widgets = replaceNoCase(
				valueList( thisWidgets.name ),
				".cfm",
				"",
				"all"
			);
		}

		// Theme Modules
		if ( directoryExists( arguments.path & "/#arguments.name#/modules" ) ) {
			var thisModules = directoryList(
				arguments.path & "/#arguments.name#/modules",
				false,
				"query"
			);
			record.modules = valueList( thisModules.name );
		}

		// Theme layouts
		var thisLayouts = directoryList(
			arguments.path & "/#arguments.name#/layouts",
			false,
			"query",
			"*.cfm",
			"name asc"
		);
		record.layouts = replaceNoCase(
			valueList( thisLayouts.name ),
			".cfm",
			"",
			"all"
		);

		// Store layout oThemeConfiguration CFC and theme metadata record
		variables.themeCFCRegistry[ arguments.name ] = oThemeConfig;
		variables.themeRegistry[ arguments.name ]    = record;
	};

	/**
	 * Remove a custom theme only.
	 *
	 * @themeName The theme to remove
	 */
	boolean function removeTheme( required themeName ){
		// verify name or even if it exists
		if ( !len( arguments.themeName ) || !variables.themeRegistry.keyExists( arguments.themeName ) ) {
			return false;
		}
		// Get themeRecord
		var themeRecord = variables.themeRegistry[ arguments.themeName ];

		// Only remove custom themes
		if ( themeRecord.type != "Custom" ) {
			return false;
		}

		// Call onDelete on theme
		if ( structKeyExists( themeRecord.descriptor, "onDelete" ) ) {
			themeRecord.descriptor.onDelete();
		}

		// Remove settings
		if ( structKeyExists( themeRecord.descriptor, "settings" ) ) {
			unregisterThemeSettings( settings: themeRecord.descriptor.settings );
		}

		// Remove from registry
		structDelete( variables.themeRegistry, arguments.themeName );

		// verify location and remove it
		var lPath = themeRecord.path & "/" & arguments.themeName;
		if ( directoryExists( lPath ) ) {
			// delete theme
			directoryDelete( lPath, true );
			// issue rebuild
			buildThemeRegistry();
			return true;
		}

		// return
		return false;
	}

	/**
	 * Get constraints for setting fields
	 *
	 * @themeName The name of the theme
	 */
	struct function getSettingsConstraints( required themeName ){
		// Get theme CFC
		var oTheme = variables.themeRegistry[ arguments.themeName ].descriptor;
		// Verify it has settings, else return empty struct
		if ( !structKeyExists( oTheme, "settings" ) OR !arrayLen( oTheme.settings ) ) {
			return {};
		}

		// iterate and build
		var constraints = {};
		for ( var thisSetting in oTheme.settings ) {
			// Check if required
			if ( structKeyExists( thisSetting, "required" ) and thisSetting.required ) {
				constraints[ thisSetting.name ] = { required : true };
			}
		}

		return constraints;
	}

	/**
	 * Build out the settings form HTML
	 *
	 * @activeTheme The active theme struct
	 */
	function buildSettingsForm( required struct activeTheme ){
		// Get theme CFC
		var oTheme      = variables.themeRegistry[ arguments.activeTheme.name ].descriptor;
		var oSite       = variables.siteService.getCurrentWorkingSite();
		var settingForm = "";

		// Build Form by iteration over items
		if ( !structKeyExists( oTheme, "settings" ) OR !arrayLen( oTheme.settings ) ) {
			return settingForm;
		}

		// cfformat-ignore-start

		savecontent variable="settingForm"{

			// Write out panel container
			writeOutput( '<div id="settings-accordion" class="panel-group accordion">' );

			// Iterate and create settings
			var lastGroup = "NeverHadAGroup";
			var firstPanel= true;
			for( var x=1; x lte arrayLen( oTheme.settings ); x++ ){
				var thisSettingMD     = oTheme.settings[ x ];
				var requiredText      = "";
				var requiredValidator = "";

				// get actual setting value which should be guaranteed to exist
				var settingName = "cb_theme_#arguments.activeTheme.name#_#thisSettingMD.name#";
				var oSetting    = settingService.findSiteSetting( oSite, settingName );

				thisSettingMD.defaultValue = oSetting.getValue();

				// Default values for settings
				if( !structKeyExists( thisSettingMD, "required" ) ){ thisSettingMD.required = false; }
				if( !structKeyExists( thisSettingMD, "label" ) ){ thisSettingMD.label = thisSettingMD.name; }
				if( !structKeyExists( thisSettingMD, "type" ) ){ thisSettingMD.type = "text"; }
				if( !structKeyExists( thisSettingMD, "title" ) ){ thisSettingMD.title = ""; }
				if( !structKeyExists( thisSettingMD, "group" ) ){ thisSettingMD.group = "Main"; }
				if( !structKeyExists( thisSettingMD, "groupIntro" ) ){ thisSettingMD.groupIntro = ""; }
				if( !structKeyExists( thisSettingMD, "fieldHelp" ) ){ thisSettingMD.fieldHelp = ""; }
				if( !structKeyExists( thisSettingMD, "fieldDescription" ) ){ thisSettingMD.fieldDescription = ""; }

				// required static strings
				if( thisSettingMD.required ){
					requiredText      = "<span class='text-danger'>*Required</span>";
					requiredValidator = "required";
				}

				// Starting a group panel?
				if ( thisSettingMD.group != lastGroup ){

					// Close out previous group panel-body
					if ( lastGroup != "NeverHadAGroup" ){
						writeOutput( "</div></div></div>" );
					}

					// Write out group panel header
					writeOutput( '<div class="panel panel-default">' );
  						if ( thisSettingMD.group != "" ){
  							writeOutput( '
  								<div class="panel-heading">
  									<h4 class="panel-title">
										<a 	class="accordion-toggle"
											data-toggle="collapse"
											data-parent="##settings-accordion"
											href="##settingtab-#hash( thisSettingMD.group )#"
											style="display: block"
										>
											#thisSettingMD.group#
										</a>
  									</h4>
  								</div>
  							');
  						}

					// Start group body panel
					writeOutput( '
						<div id="settingtab-#hash( thisSettingMD.group )#" class="panel-collapse collapse #firstPanel ? 'in' : ''#" role="tabpanel">
							<div class="panel-body">
					' );

					// Show group intro if there is one
					if( len( thisSettingMD.groupIntro ) ){
						writeOutput( '<div class="themeGroupInfo">' & thisSettingMD.groupIntro & '</div>' );
					}

					// Set this as the last group
					lastGroup  = thisSettingMD.group;
					firstpanel = false;
				}

				// writeout control wrapper
				writeOutput( '<div class="form-group marginTop25">' );

				// write out label
				writeOutput( html.label( field=settingName, content="#thisSettingMD.label# #requiredText#" ) );

				// Generate question mark icon for field Help to open modal
				if( len( thisSettingMD.fieldHelp ) ){
					writeOutput( ' <a data-toggle="modal" data-target="##help_#settingName#"><i class="fa fa-question-circle"></i></a>' );
				}


				// write out field description
				if( len( thisSettingMD.fieldDescription ) ){
					writeOutput( '<div class="pb5">' & thisSettingMD.fieldDescription & '</div>' );
				}

				// write out control
				switch( thisSettingMD.type ){
					case "boolean" : {
						writeOutput(
							html.select(
								name         = settingName,
								options      = "true,false",
								selectedValue= thisSettingMD.defaultValue,
								title        = thisSettingMD.title,
								class        = "form-control input-lg"
							)
						);
						break;
					}
					case "select" : {
						var options = "";
						// Check options UDF
						if( structKeyExists( thisSettingMD, "optionsUDF" ) ){
							options = invoke( oTheme, thisSettingMD.optionsUDF );
						} else if( structKeyExists( thisSettingMD, "options" ) ){
							options = thisSettingMD.options;
						}
						writeOutput(
							html.select(
								name         = settingName,
								options      = options,
								selectedValue= thisSettingMD.defaultValue,
								title        = thisSettingMD.title,
								class        = "form-control input-lg"
							)
						);
						break;
					}
					case "textarea" : {
						writeOutput(
							html.textarea(
								name    = settingName,
								required= requiredValidator,
								title   = thisSettingMD.title,
								value   = thisSettingMD.defaultValue,
								class   = "form-control",
								rows    = 5
							)
						);
						break;
					}
					case "color" : {
						writeOutput(
							html.inputField(
								name    = settingName,
								class   = "textfield",
								required= requiredValidator,
								title   = thisSettingMD.title,
								value   = thisSettingMD.defaultValue,
								class   = "form-control",
								type    = "color"
							)
						);
						break;
					}
					default:{
						writeOutput(
							html.textfield(
								name    = settingName,
								class   = "textfield",
								required= requiredValidator,
								title   = thisSettingMD.title,
								value   = thisSettingMD.defaultValue,
								class   = "form-control"
							)
						);
					}
				}

    			// End form group
    			writeOutput( '</div>' );

				// Generate modal for field Help
				if( len( thisSettingMD.fieldHelp ) ){
					writeOutput( generateModal( settingName, thisSettingMD ) );
				}

			} // end looping over theme settings

			// Finalize Group Panel: In case we only had one setting in this group.
			if ( lastGroup != "NeverHadAGroup" ){
				writeOutput( '</div></div></div>' );
			}

			// Finalize Container
			writeOutput( "</div>" );
		}

		// cfformat-ignore-end

		return settingForm;
	}

	/**
	 * generateModal - Generate the modal for Theme Setting Help
	 *
	 * @settingName   - The name of the setting the Theme Setting Help modal will be created for
	 * @thisSettingMD - The setting struct itself
	 */
	function generateModal( required settingName, required thisSettingMD ){
		// cfformat-ignore-start
		return '<div class="modal fade" tabindex="-1" role="dialog" id="help_#arguments.settingName#">
				  <div class="modal-dialog" role="document">
				    <div class="modal-content">
				      <div class="modal-header">
				        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				        <h4 class="modal-title">#arguments.thisSettingMD.label#</h4>
				      </div>
				      <div class="modal-body">
				       #arguments.thisSettingMD.fieldHelp#
				      </div>
				      <div class="modal-footer">
				        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				      </div>
				    </div><!-- /.modal-content -->
				  </div><!-- /.modal-dialog -->
				</div><!-- /.modal -->';
		// cfformat-ignore-end
	}

	/************************************ PRIVATE ************************************************/

	/**
	 * Get all themes loaded on disk path, only returns directories
	 *
	 * @path The path to check
	 */
	private array function getThemesOnDisk( required path ){
		return directoryList( arguments.path, false, "name", "", "name asc" ).filter( function( item ){
			// exclude .*
			if ( left( item, 1 ) eq "." ) {
				return false;
			}
			// exclude files
			return ( directoryExists( path & "/" & item ) ? true : false );
		} );
	}

	/**
	 * Unregister theme settings
	 *
	 * @settings The settings to unregister
	 *
	 * @return ThemeService
	 */
	private function unregisterThemeSettings( required array settings ){
		transaction {
			// iterate and register theme settings
			for ( var thisSetting in arguments.settings ) {
				// try to retrieve the collection
				var aSettings = variables.settingService
					.newCriteria()
					.isEq( "name", "cb_theme_#arguments.name#_#thisSetting.name#" )
					.list();

				// If not found, then unregister it
				if ( arrayLen( aSettings ) ) {
					variables.settingService.delete( aSettings );
				}
			}
		}

		return this;
	}

	/**
	 * Register a theme's settings
	 *
	 * @name     The theme name
	 * @settings The settings struct
	 * @site     The site this theme is activated on
	 *
	 * @return ThemeService
	 */
	private any function registerThemeSettings(
		required name,
		required array settings,
		required site
	){
		// Get all core, non-deleted setting names
		var loadedSiteSettings = variables.settingService
			.newCriteria()
			.isFalse( "isDeleted" )
			.isEq( "site", arguments.site )
			.withProjections( property: "name" )
			.list( sortOrder = "name" );

		// Check what's missing
		transaction {
			arguments.settings
				// only load defaults that do not exist
				.filter( function( thisSetting ){
					return !arrayContainsNoCase( loadedSiteSettings, "cb_theme_#name#_#thisSetting.name#" );
				} )
				// Create the missing setting
				.each( function( thisSetting ){
					variables.settingService.save(
						variables.settingService
							.new( {
								name  : "cb_theme_#name#_#thisSetting.name#",
								value : thisSetting.defaultValue
							} )
							.setSite( site )
					);
				} );
		}

		return this;
	}

}
