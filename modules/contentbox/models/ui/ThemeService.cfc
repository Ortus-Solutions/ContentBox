/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages ContentBox themes
*/
component accessors="true" threadSafe singleton{

	// DI
	property name="settingService"		inject="settingService@cb";
	// Provide this one in, due to chicken and the egg issues.
	property name="widgetService"		inject="provider:widgetService@cb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
	property name="interceptorService"	inject="coldbox:interceptorService";
	property name="zipUtil"				inject="zipUtil@cb";
	property name="log"					inject="logbox:logger:{this}";
	property name="wirebox"				inject="wirebox";
	property name="html"				inject="HTMLHelper@coldbox";
	property name="cbHelper"			inject="provider:CBHelper@cb";
	property name="moduleService"		inject="coldbox:moduleService";

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
		variables.themeRegistry 		= {};
		variables.coreThemesPath 		= "";
		variables.customThemesPath 		= "";
		variables.widgetCache 			= {};

		return this;
	}

	/**
	* onDIComplete startup the theming services according to loaded module data
	*/
	void function onDIComplete(){
		// setup location paths
		variables.coreThemesPath		= moduleSettings[ "contentbox" ].path & "/themes";
		variables.customThemesPath 		= moduleSettings[ "contentbox-custom" ].path & "/_themes";

		// Register all themes
		buildThemeRegistry();
	}

	/**
	* Does the current active theme have a maintenance view
	*/
	boolean function themeMaintenanceViewExists(){
		return fileExists( expandPath( CBHelper.themeRoot() & "/views/maintenance.cfm" ) );
	}

	/**
	* Get the current active theme's maintenance layout
	*/
	string function getThemeMaintenanceLayout(){
		var layout = "pages";

		// verify existence of convention
		if( fileExists( expandPath( CBHelper.themeRoot() & "/layouts/maintenance.cfm" ) ) ){
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
		if( fileExists( expandPath( CBHelper.themeRoot() & "/layouts/#arguments.layout#_#arguments.format#.cfm" ) ) ){
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
		if( fileExists( expandPath( CBHelper.themeRoot() & "/layouts/search.cfm" ) ) ){
			layout = "search";
		}

		return layout;
	}

	/**
	 * Returns the invocation path for the requested widget from themes service's layout cache
	 *
	 * @widgetName The name of the widget
	 */
	string function getThemeWidgetInvocationPath( required string widgetName ) {
		var path 		= "";
		var parsedName 	=  replaceNoCase( arguments.widgetName, "~", "", "one" );
		// if requested widget exists in the cache, return the path
		if( structKeyExists( variables.widgetCache, parsedName ) ) {
			path = variables.widgetCache[ parsedName ].invocationPath;
		} else {
			log.error( "Could not find '#parsedName#' widget in the currently active theme." );
		}
		return path;
	}

	/**
	 * Startup Active Theme procedures
	 *
	 * @processWidgets Process widget registration on activation, defaults to true.
	 */
	function startupActiveTheme( boolean processWidgets=true ){
		// get theme setting.
		var thisTheme = settingService.findWhere( { name="cb_site_theme" } );
		if( isNull( thisTheme ) ){ return; }

		// Get theme record information
		var themeName 	= thisTheme.getValue();
		var themeRecord = getThemeRecord( themeName );
		var oTheme 		= themeRecord.descriptor;

		// Register description as an interceptor with custom points
		variables.interceptorService.registerInterceptor(
			interceptorObject	= oTheme,
			interceptorName		= "cbtheme-#themeName#",
			customPoints		= themeRecord.customInterceptionPoints
		);

		// Register theme settings?
		if( structKeyExists( oTheme, "settings" ) ){
			registerThemeSettings( name=themeName, settings=oTheme.settings );
		}

		// Prepare theme activation event
		var iData = {
			themeName 		= themeName,
			themeRecord 	= themeRecord
		};

		// build widget cache for active theme
		for( var thisWidget in themeRecord.widgets.listToArray() ){
			var widgetName = replaceNoCase( thisWidget, ".cfc", "", "one" );
			variables.widgetCache[ widgetName ] = {
				name 			= widgetName,
				invocationPath 	= "#themeRecord.invocationPath#.widgets.#widgetName#",
				path 			= "#themeRecord.path#/#themeName#/widgets/#thisWidget#",
				theme 			= themeName
			};
		}

		// activate theme modules
		for( var thisModule in themeRecord.modules.listToArray() ){
			variables.moduleService.registerAndActivateModule(
				moduleName 		= thisModule,
				invocationPath 	= "#themeRecord.invocationPath#.modules"
			);
		}

		// Register all widgets
		if( arguments.processWidgets ){
			variables.widgetService.processThemeWidgets();
		}

		// Announce theme activation
		variables.interceptorService.processState( "cbadmin_onThemeActivation", iData );

		// Call Theme Callbacks: onActivation
		if( structKeyExists( oTheme, "onActivation" ) ){
			oTheme.onActivation();
		}
	}

	/**
	 * Save theme settings as they are coming from form submissions as a struct with a common prefix
	 * cb_theme_{themeName}_{settingName}
	 * @name 		The theme name
	 * @settings 	The settings struct
	 *
	 * @return ThemeService
	 */
	function saveThemeSettings( required name, required struct settings ){
		transaction{

			// Filter out settings
			arguments.settings.filter( function( key, value ){
				return ( findNoCase( "cb_theme_#name#_", key ) ? true : false );
			} ).each( function( key, value ){
				var oSetting = settingService.findWhere( { name=key } );
				oSetting.setValue( value );
				settingService.save( oSetting );
			} );

		}

		return this;
	}

	/**
	 * Get the current active theme record
	 */
	struct function getActiveTheme(){
		return getThemeRecord( settingService.getSetting( "cb_site_theme" ) );
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
	 * Is active theme check
	 *
	 * @themeName The name of the theme to check
	 */
	boolean function isActiveTheme( required themeName ){
		return ( compareNoCase( getActiveTheme().name, arguments.themeName ) EQ 0 );
	}

	/**
	 * Activate a theme
	 *
	 * @themeName The theme name to activate
	 */
	function activateTheme( required themeName ){
		transaction{
			// Get the current theme setting
			var oTheme 		= settingService.findWhere( { name="cb_site_theme" } );
			var themeRecord = getThemeRecord( oTheme.getValue() );

			// Call deactivation event
			var iData = {
				themeName 		= oTheme.getValue(),
				themeRecord 	= themeRecord
			};
			interceptorService.processState( "cbadmin_onThemeDeactivation", iData );

			// Call Theme Callback: onDeactivation
			if( structKeyExists( themeRecord.descriptor, "onDeactivation" ) ){
				themeRecord.descriptor.onDeactivation();
			}

			// unload theme modules
			for( var thisModule in themeRecord.modules.listToArray() ){
				moduleService.unload( thisModule );
			}

			// Unregister theme Descriptor Interceptor
			interceptorService.unregister( interceptorName="cbTheme-#oTheme.getValue()#" );

			// setup the new theme value
			oTheme.setValue( arguments.themeName );
			// save the new theme setting
			settingService.save( oTheme );

			// Startup active theme
			startupActiveTheme( processWidgets=false );

			// Force Recreation of all Widgets, since we need to deactivate the old widgets
			widgetService.getWidgets( reload=true );

			// flush the settings
			settingService.flushSettingsCache();
		}

		return this;
	}

	/**
	 * Get all registered themes via the registry.
	 */
	struct function getThemes(){
		if( isSimpleValue( variables.themeRegistry ) ){
			buildThemeRegistry();
		}
		return variables.themeRegistry;
	}

	/**
	 * Get all registered custom themes via the registry.
	 */
	struct function getCustomThemes(){
		if( isSimpleValue( variables.themeRegistry ) ){
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

		/**
		 * Process a theme record and store appropriate data and cfc registries
		 *
		 * @name The name of the theme on disk
		 * @path The path of the theme
		 * @invocationPath The invocation path of the theme
		 * @includePath The include path of the theme
		 * @type The type of theme it is: core, custom
		 * @module The module this theme exists under
		 */
		var processThemeRecord = function( name, path, invocationPath, includePath, type, module ){
			var record = {
				"name"		 				= arguments.name,
				"descriptor"				= "",
				"type"						= arguments.type,
				"module"					= arguments.module,
				"isValid" 					= false,
				"path"						= arguments.path,
				"invocationPath"			= arguments.invocationPath & "." & arguments.name,
				"includePath"				= arguments.includePath & "/" & arguments.name,
				"themeName"                	= "",
				"description"              	= "",
				"version"                  	= "",
				"author"                   	= "",
				"authorURL"                	= "",
				"screenShotURL"            	= "",
				"forgeBoxSlug"             	= "",
				"customInterceptionPoints" 	= "",
				"layouts"                  	= "",
				"settings"                 	= "",
				"widgets"                  	= "",
				"modules"                  	= ""
			};

			// Check for theme descriptor by 'theme.cfc' or '#themeName#.cfc'
			var descriptorPath 		= arguments.path & "/#arguments.name#/Theme.cfc";
			var descriptorInstance 	= arguments.invocationPath & ".#arguments.name#.Theme";
			if( !fileExists( descriptorPath ) ){
				// try by theme name instead
				descriptorPath 		= arguments.path & "/#arguments.name#/#arguments.name#.cfc";
				descriptorInstance	= arguments.invocationPath & ".#arguments.name#.#arguments.name#";
				if( !fileExists( descriptorPath ) ){
					log.warn( "The theme: #arguments.name# has no theme descriptor, skipping registration." );
					variables.themeRegistry[ arguments.name ] = record;
					return;
				}
			}

			// construct descriptor via WireBox
			var oThemeConfig = wirebox.getInstance( descriptorInstance );

			// Populate Record with it
			record.descriptor 		= oThemeConfig;
			record.isValid 			= true;
			record.themeName		= oThemeConfig.name;
			record.description 		= oThemeConfig.description;
			record.version			= oThemeConfig.version;
			record.author 			= oThemeConfig.author;
			record.authorURL 		= oThemeConfig.authorURL;
			// Screenshot
			if( structKeyExists( oThemeConfig, "screenShotURL" ) ){
				record.screenShotURL = arguments.includePath & "/#arguments.name#/" & oThemeConfig.screenShotURL;
			}

			// ForgeBox slug
			if( structKeyExists( oThemeConfig, "forgeBoxSlug" ) ){
				record.forgeBoxSlug = oThemeConfig.forgeBoxSlug;
			}

			// Custom Interception Point
			if( structKeyExists( oThemeConfig, "customInterceptionPoints" ) ){
				record.customInterceptionPoints = oThemeConfig.customInterceptionPoints;
			}

			// Settings
			if( structKeyExists( oThemeConfig, "settings" ) ){
				record.settings = oThemeConfig.settings;
			}

			// Theme Widgets
			if( directoryExists( arguments.path & "/#arguments.name#/widgets" ) ){
				var thisWidgets = directoryList( arguments.path & "/#arguments.name#/widgets", false, "query", "*.cfc", "name asc" );
				record.widgets = replacenocase( valueList( thisWidgets.name ), ".cfm", "", "all" );
			}

			// Theme Modules
			if( directoryExists( arguments.path & "/#arguments.name#/modules" ) ){
				var thisModules = directoryList( arguments.path & "/#arguments.name#/modules", false, "query" );
				record.modules = valueList( thisModules.name );
			}

			// Theme layouts
			var thisLayouts = directoryList( arguments.path & "/#arguments.name#/layouts", false, "query", "*.cfm", "name asc" );
			record.layouts = replacenocase( valueList( thisLayouts.name ), ".cfm", "", "all" );

			// Store layout oThemeConfiguration CFC and theme metadata record
			variables.themeCFCRegistry[ arguments.name ] 	= oThemeConfig;
			variables.themeRegistry[ arguments.name ] 		= record;
		};

		// Get Core Themes and Process Them
		getThemesOnDisk( variables.coreThemesPath )
			.each( function( item ){
				processThemeRecord(
					name            = item,
					path	        = variables.coreThemesPath,
					invocationPath  = variables.moduleSettings[ "contentbox" ].invocationPath & ".themes",
					includePath 	= variables.moduleSettings[ "contentbox" ].mapping & "/themes",
					type            =  "core",
					module 			= "contentbox"
				);
			} );

		// Get Custom Themes and Process Them
		getThemesOnDisk( variables.customThemesPath )
			.each( function( item ){
				processThemeRecord(
					name            = item,
					path	        = variables.customThemesPath,
					invocationPath  = variables.moduleSettings[ "contentbox-custom" ].invocationPath & "._themes",
					includePath 	= variables.moduleSettings[ "contentbox-custom" ].mapping & "/_themes",
					type            =  "custom",
					module 			= "contentbox-custom"
				);
			} );

		return this;
	}

	/**
	 * Remove a custom theme only.
	 *
	 * @themeName The theme to remove
	 */
	boolean function removeTheme( required themeName ){
		// verify name or even if it exists
		if( !len( arguments.themeName ) || !variables.themeRegistry.keyExists( arguments.themeName ) ){
			return false;
		}
		// Get themeRecord
		var themeRecord = variables.themeRegistry[ arguments.themeName ];

		// Only remove custom themes
		if( themeRecord.type != "Custom" ){
			return false;
		}

		// Call onDelete on theme
		if( structKeyExists( themeRecord.descriptor, "onDelete" ) ){
			themeRecord.descriptor.onDelete();
		}

		// Remove settings
		if( structKeyExists( themeRecord.descriptor, "settings" ) ){
			unregisterThemeSettings( name=arguments.themeName, settings=themeRecord.descriptor.settings );
		}

		// Remove from registry
		structDelete( variables.themeRegistry, arguments.themeName );

		// verify location and remove it
		var lPath = themeRecord.path & "/" & arguments.themeName;
		if( directoryExists( lPath ) ){
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
	* @themeName The name of the theme
	*/
	struct function getSettingsConstraints( required themeName ){
		// Get theme CFC
		var oTheme = variables.themeRegistry[ arguments.themeName ].descriptor;
		// Verify it has settings, else return empty struct
		if( !structKeyExists( oTheme, "settings" ) OR !arrayLen( oTheme.settings ) ){ return {}; }

		// iterate and build
		var constraints = {};
		for( var thisSetting in oTheme.settings ){
			// Check if required
			if( structKeyExists( thisSetting, "required" ) and thisSetting.required ){
				constraints[ thisSetting.name ] = {
					required = true
				};
			}
		}

		return constraints;
	}

	/**
	 * Build out the settings form HTML
	 * @activeTheme The active theme struct
	 */
	function buildSettingsForm( required struct activeTheme ){
		// Get theme CFC
		var oTheme 		= variables.themeRegistry[ arguments.activeTheme.name ].descriptor;
		var settingForm = "";

		// Build Form by iteration over items
		if( !structKeyExists( oTheme, "settings" ) OR !arrayLen( oTheme.settings ) ){ return settingForm; }

		savecontent variable="settingForm"{

			// Write out panel container
			writeOutput( '<div id="settings-accordion" class="panel-group accordion">' );

			// Iterate and create settings
			var lastGroup 	= "NeverHadAGroup";
			var firstPanel	= true;
			for( var x=1; x lte arrayLen( oTheme.settings ); x++ ){
				var thisSettingMD 		= oTheme.settings[ x ];
				var requiredText 		= "";
				var requiredValidator 	= "";

				// get actual setting value which should be guaranteed to exist
				var settingName = "cb_theme_#arguments.activeTheme.name#_#thisSettingMD.name#";
				var oSetting 	= settingService.findWhere( { name=settingName } );
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
					requiredText 		= "<span class='text-danger'>*Required</span>";
					requiredValidator 	= "required";
				}

				// Starting a group panel?
				if ( thisSettingMD.group != lastGroup ){

					// Close out previous group panel-body
					if ( lastGroup != "NeverHadAGroup" ){
						writeOutput( '</div></div></div>' );
					}

					// Write out group panel header
					writeOutput( '<div class="panel panel-primary">' );
  						if ( thisSettingMD.group != "" ){
  							writeOutput( '
  								<div class="panel-heading">
  									<h4 class="panel-title">
										<a 	class="accordion-toggle"
											data-toggle="collapse"
											data-parent="##settings-accordion"
											href="##settingtab-#hash( thisSettingMD.group )#"
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
					lastGroup 	= thisSettingMD.group;
					firstpanel 	= false;
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
						writeOutput( '<div class="paddingBottom5">' & thisSettingMD.fieldDescription & '</div>' );
					}

    				// write out control
    				switch( thisSettingMD.type ){
    					case "boolean" : {
    						writeOutput(
    							html.select(
	    							name			= settingName,
	    							options			= "true,false",
	    							selectedValue	= thisSettingMD.defaultValue,
	    							title			= thisSettingMD.title,
	    							class 			= "form-control input-lg"
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
    								name 			= settingName,
    								options			= options,
    								selectedValue	= thisSettingMD.defaultValue,
    								title			= thisSettingMD.title,
    								class 			= "form-control input-lg"
    							)
    						);
    						break;
    					}
    					case "textarea" : {
    						writeOutput(
    							html.textarea(
    								name		= settingName,
    								required	= requiredValidator,
    								title		= thisSettingMD.title,
    								value		= thisSettingMD.defaultValue,
    								class 		= "form-control",
    								rows		= 5
    							)
    						);
    						break;
    					}
    					case "color" : {
    						writeOutput(
    							html.inputField(
    								name		= settingName,
    								class		= "textfield",
    								required	= requiredValidator,
    								title		= thisSettingMD.title,
    								value		= thisSettingMD.defaultValue,
    								class 		= "form-control",
    								type		= "color"
    							)
    						);
    						break;
    					}
    					default:{
    						writeOutput(
    							html.textfield(
    								name		= settingName,
    								class		= "textfield",
    								required	= requiredValidator,
    								title		= thisSettingMD.title,
    								value		= thisSettingMD.defaultValue,
    								class 		= "form-control"
    							)
    						);
    					}
    				}

    			// End form group
    			writeOutput( '</div>');

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

		return settingForm;
	}

	/**
	* generateModal - Generate the modal for Theme Setting Help
	* @settingName - The name of the setting the Theme Setting Help modal will be created for
	* @thisSettingMD - The setting struct itself
	*/
	function generateModal( required settingName, required thisSettingMD ){
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
	}

	/************************************ PRIVATE ************************************************/

	/**
	 * Get all themes loaded on disk path, only returns directories
	 *
	 * @path The path to check
	 */
	private array function getThemesOnDisk( required path ){
		return directoryList( arguments.path, false, "name", "", "name asc" )
			.filter( function( item ){
				// exclude .*
				if( left( item, 1 ) eq '.' ){
					return false;
				}
				// exclude files
				return ( directoryExists( path & "/" & item ) ? true : false );
			} );
	}

	/**
	* Unregister theme settings
	* @settings The settings to unregister
	*
	* @return ThemeService
	*/
	private function unregisterThemeSettings( required array settings ){
		transaction{
			// iterate and register theme settings
			for( var thisSetting in arguments.settings ){
				// try to retrieve it first
				var oSetting = settingService.findWhere( { name="cb_theme_#arguments.name#_#thisSetting.name#" } );
				// If not found, then register it
				if( !isNull( oSetting ) ){
					settingService.delete( oSetting );
				}
			}
		}

		return this;
	}

	/**
	 * Register a theme's settings
	 *
	 * @name The theme name
	 * @settings The settings struct
	 *
	 * @return ThemeService
	 */
	private any function registerThemeSettings( required name, required array settings ){
		transaction{
			// iterate and register theme settings
			for( var thisSetting in arguments.settings ){
				// try to retrieve it first
				var oSetting = settingService.findWhere( { name="cb_theme_#arguments.name#_#thisSetting.name#" } );
				// If not found, then register it
				if( isNull( oSetting ) ){
					var args = { name="cb_theme_#arguments.name#_#thisSetting.name#", value=thisSetting.defaultValue };
					settingService.save( settingService.new( properties=args ) );
				}
			}
			settingService.flushSettingsCache();
		}

		return this;
	}

}