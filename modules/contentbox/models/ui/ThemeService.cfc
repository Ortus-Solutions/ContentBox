/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages system themes
*/
component accessors="true" threadSafe singleton{

	// Dependencies
	property name="settingService"		inject="id:settingService@cb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
	property name="interceptorService"	inject="coldbox:interceptorService";
	property name="zipUtil"				inject="zipUtil@cb";
	property name="log"					inject="logbox:logger:{this}";
	property name="wirebox"				inject="wirebox";
	property name="html"				inject="HTMLHelper@coldbox";
	property name="cbHelper"			inject="provider:CBHelper@cb";
	property name="moduleService"		inject="coldbox:moduleService";

	// The location in disk of the themes
	property name="themesPath";
	// The include path for the themes
	property name="themesIncludePath";
	// The instantiation path for the themes
	property name="themesInvocationPath";
	// The theme registry of records
	property name="themeRegistry";
	// The theme CFC registry
	property name="themeCFCRegistry";
	// The cache of widgets for the active theme
	property name="widgetCache" type="struct";

	/**
	* Constructor
	*/
	ThemeService function init(){
		// init properties
		variables.themeRegistry 		= "";
		variables.themeCFCRegistry 		= {};
		variables.themesPath 			= "";		
		variables.themesIncludePath 	= "";
		variables.themesInvocationPath 	= "";
		variables.widgetCache 			= {};

		return this;
	}

	/**
	* onDIComplete startup the theming services according to loaded module data
	*/
	void function onDIComplete(){
		// setup location paths
		variables.themesPath 			= moduleSettings[ "contentbox" ].path & "/themes";
		variables.themesIncludePath 	= moduleSettings[ "contentbox" ].mapping & "/themes";
		variables.themesInvocationPath 	= moduleSettings[ "contentbox" ].invocationPath & ".themes";
		// Register all themes
		buildThemeRegistry();
	}
	
	/**
	* Does theme have a maintenance view
	*/
	boolean function themeMaintenanceViewExists(){
		return fileExists( expandPath( CBHelper.themeRoot() & "/views/maintenance.cfm" ) );
	}
	
	/**
	* Get the current theme's maintenance layout
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
	 * Returns path for the requested widget from themes service's layout cache
	 * @widgetName The name of the widget
	 * return String
	 */
	string function getThemeWidgetPath( required string widgetName ) {
		var path 		= "";
		var parsedName 	=  replaceNoCase( arguments.widgetName, "~", "", "one" );
		// if requested widget exists in the cache, return the path
		if( structKeyExists( variables.widgetCache, parsedName ) ) {
			path = variables.widgetCache[ parsedName ];
		} else {
			log.error( "Could not find '#parsedName#' widget in the currently active theme." );	
		}
		return path;
	}

	/**
	* Startup Active Theme procedures
	*/
	function startupActiveTheme(){
		// get theme setting.
		var thisTheme = settingService.findWhere( { name="cb_site_theme" } );
		if( !isNull( thisTheme ) ){
			// Get theme record
			var themeName 	= thisTheme.getValue();	 
			var themeRecord = getThemeRecord( themeName );
			var oTheme 		= variables.themeCFCRegistry[ themeName ];

			// Register description as an interceptor with custom points
			interceptorService.registerInterceptor(
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
			for( var i=1; i <= listLen( iData.themeRecord.widgets ); i++ ) {
				var widgetName = replaceNoCase( listGetAt( iData.themeRecord.widgets, i ), ".cfc", "", "one" );
				var widgetPath = "#variables.themesInvocationPath#.#themeName#.widgets.#widgetName#";
				variables.widgetCache[ widgetName ] = widgetPath;
			}

			// activate theme modules
			var aModules = listToArray( iData.themeRecord.modules );
			for( var thisModule in aModules ){
				moduleService.registerAndActivateModule( 
					moduleName 		= thisModule, 
					invocationPath 	= "#variables.themesInvocationPath#.#themeName#.modules" 
				);
			}

			// Announce theme activation
			interceptorService.processState( "cbadmin_onThemeActivation", iData );
			
			// Call Theme Callbacks: onActivation
			if( structKeyExists( oTheme, "onActivation" ) ){
				oTheme.onActivation();
			}
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
	public function saveThemeSettings( required name, required struct settings ){
		transaction{
			// iterate and add only keys with the right prefix
			for( var thisSettingName in arguments.settings ){
				if( findNoCase( "cb_theme_#arguments.name#_", thisSettingName ) ){
					var oSetting = settingService.findWhere( { name=thisSettingName } );
					oSetting.setValue( arguments.settings[ thisSettingName ] );
					settingService.save( oSetting );
				}
			}
		}

		return this;
	}
	
	/**
	* Register a theme's settings
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
		}

		return this;
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
	* Get active theme record
	*/
	query function getActiveTheme(){
		var activeTheme = settingService.getSetting( "cb_site_theme" );
		return new Query( 
				dbtype 			= "query", 
				sql 			= "SELECT * from themeRegistry WHERE name='#activeTheme#'",
				themeRegistry 	= variables.themeRegistry
			).execute().getResult();
	}

	/**
	* Get a theme record from the registry by name
	* @themeName The name of the theme
	*/
	query function getThemeRecord( required themeName ){
		return new Query(
				dbtype 			= "query",
				sql 			= "SELECT * from themeRegistry WHERE name='#arguments.themeName#'",
				themeRegistry 	= variables.themeRegistry
			).execute().getResult();
	}

	/**
	* Is active theme check
	* @themeName The name of the theme to check
	*/
	boolean function isActiveTheme( required themeName ){
		return ( compareNoCase( getActiveTheme().name, arguments.themeName ) EQ 0 );
	}

	/**
	* Activate a theme
	* @themeName The theme name to activate
	*/
	function activateTheme( required themeName ){
		transaction{
			// Get the current theme setting
			var oTheme 	= settingService.findWhere( { name="cb_site_theme" } );

			// Call deactivation event
			var iData = {
				themeName 		= oTheme.getValue(),
				themeRecord 	= getThemeRecord( oTheme.getValue() )
			};
			interceptorService.processState( "cbadmin_onThemeDeactivation", iData );

			// Call Theme Callback: onDeactivation
			if( structKeyExists( variables.themeCFCRegistry[ oTheme.getValue() ], "onDeactivation" ) ){
				variables.themeCFCRegistry[ oTheme.getValue() ].onDeactivation();
			}

			// unload theme modules
			var aModules = listToArray( iData.themeRecord.modules );
			for( var thisModule in aModules ){
				moduleService.unload( thisModule );
			}

			// Unregister theme Descriptor Interceptor
			interceptorService.unregister( interceptorName="cbTheme-#oTheme.getValue()#" );

			// setup the new theme value
			oTheme.setValue( arguments.themeName );
			// save the new theme setting
			settingService.save( oTheme );
			// Startup active theme
			startupActiveTheme();
			
			// flush the settings
			settingService.flushSettingsCache();
		}

		return this;
	}

	/**
	* Get all registered themes
	*/
	query function getThemes(){
		if( isSimpleValue( variables.themeRegistry ) ){
			return buildThemeRegistry();
		}
		return variables.themeRegistry;
	}

	/**
	* Build theme registry
	*/
	query function buildThemeRegistry(){
		var rawThemes 	= directoryList( variables.themesPath, false, "query" );
		// filter theme folders only
		var rawThemes 	= new Query( 
				dbtype 		= "query", 
				sql 		= "SELECT directory,name from rawThemes WHERE type = 'Dir'",
				rawThemes 	= rawThemes
			).execute().getResult();

		// Add Columns
		QueryAddColumn( rawThemes, "themeName", [] );
		QueryAddColumn( rawThemes, "isValid", [] );
		QueryAddColumn( rawThemes, "description", [] );
		QueryAddColumn( rawThemes, "version", [] );
		QueryAddColumn( rawThemes, "author", [] );
		QueryAddColumn( rawThemes, "authorURL", [] );
		QueryAddColumn( rawThemes, "screenShotURL", [] );
		QueryAddColumn( rawThemes, "forgeBoxSlug", [] );
		QueryAddColumn( rawThemes, "customInterceptionPoints", [] );
		QueryAddColumn( rawThemes, "layouts", [] );
		QueryAddColumn( rawThemes, "settings", [] );
		QueryAddColumn( rawThemes, "widgets", [] );
		QueryAddColumn( rawThemes, "modules", [] );

		// Register each theme CFC
		for( var x=1; x lte rawThemes.recordCount; x++ ){
			var themeName = rawThemes.name[ x ];
			
			// exclude .* files from layouts
			if( left( themeName, 1 ) eq '.' )
				continue;

			// Check for theme descriptor by 'theme.cfc' or '#themeName#.cfc'
			var descriptorPath 		= variables.themesPath & "/#themeName#/Theme.cfc";
			var descriptorInstance 	= variables.themesInvocationPath & ".#themeName#.Theme";
			if( !fileExists( descriptorPath ) ){
				// try by theme name instead
				descriptorPath 		= variables.themesPath & "/#themeName#/#themeName#.cfc";
				descriptorInstance	= variables.themesInvocationPath & ".#themeName#.#themeName#";
				if( !fileExists( descriptorPath ) ){
					log.warn( "The theme: #themeName# has no theme descriptor, skipping." );
					rawThemes.isValid[ x ] = false;
					continue;
				}
			}
			// construct descriptor via WireBox
			var config = wirebox.getInstance( descriptorInstance );

			// Add custom descriptions
			rawThemes.isValid[ x ] 		= true;
			rawThemes.themeName[ x ] 	= config.name;
			rawThemes.description[ x ] 	= config.description;
			rawThemes.version[ x ] 		= config.version;
			rawThemes.author[ x ] 		= config.author;
			rawThemes.authorURL[ x ] 	= config.authorURL;
			// Screenshot
			if( structKeyExists( config, "screenShotURL" ) ){
				rawThemes.screenShotURL[ x ] = variables.themesIncludePath & "/#themeName#/" & config.screenShotURL;
			} else {
				rawThemes.screenShotURL[ x ] = "";
			}
			// ForgeBox slug
			if( structKeyExists( config, "forgeBoxSlug" ) ){
				rawThemes.forgeBoxSlug[ x ] = config.forgeBoxSlug;
			} else {
				rawThemes.forgeBoxSlug[ x ] = "";
			}
			// Custom Interception Point
			if( structKeyExists( config, "customInterceptionPoints" ) ){
				rawThemes.customInterceptionPoints[ x ] = config.customInterceptionPoints;
			} else {
				rawThemes.customInterceptionPoints[ x ] = "";
			}
			// Settings
			if( structKeyExists( config, "settings" ) ){
				rawThemes.settings[ x ] = serializeJSON( config.settings );
			} else {
				rawThemes.settings[ x ] = "";
			}
			// Theme Widgets
			if( directoryExists( variables.themesPath & "/#themeName#/widgets" ) ){
				var thisWidgets = directoryList( variables.themesPath & "/#themeName#/widgets", false, "query", "*.cfc", "name asc" );
				rawThemes.widgets[ x ] = replacenocase( valueList( thisWidgets.name ), ".cfm", "", "all" );
			} else {
				rawThemes.widgets[ x ] = "";
			}
			// Theme Modules
			if( directoryExists( variables.themesPath & "/#themeName#/modules" ) ){
				var thisModules = directoryList( variables.themesPath & "/#themeName#/modules", false, "query" );
				rawThemes.modules[ x ] = valueList( thisModules.name );
			} else {
				rawThemes.modules[ x ] = "";
			}
			
			// Theme layouts
			var thisLayouts = directoryList( variables.themesPath & "/#themeName#/layouts", false, "query", "*.cfm", "name asc" );
			rawThemes.layouts[ x ] = replacenocase( valueList( thisLayouts.name ), ".cfm", "", "all" );
			
			// Store layout configuration CFC		
			variables.themeCFCRegistry[ themeName ] = config;
		}

		var rawThemes 	= new Query(
				dbtype		= "query",
				sql			= "SELECT * from rawThemes WHERE isValid='true'", 
				rawThemes	= rawThemes
			).execute().getResult();
		// store raw themes now
		setThemeRegistry( rawThemes );

		return rawThemes;
	}

	/**
	* Remove theme
	* @themeName The theme to remove
	*/
	boolean function removeTheme( required themeName ){
		// verify name
		if( !len( arguments.themeName ) ){ return false; }
		// Call onDelete on theme
		if( structKeyExists( variables.themeCFCRegistry[ arguments.themeName ], "onDelete" ) ){
			variables.themeCFCRegistry[ arguments.themeName ].onDelete();
		}
		// Remove settings
		if( structKeyExists( variables.themeCFCRegistry[ arguments.themeName ], "settings" ) ){
			unregisterThemeSettings( name=arguments.themeName, settings=variables.themeCFCRegistry[ arguments.themeName ].settings );
		}
		// Remove from registry
		structDelete( variables.themeCFCRegistry, arguments.themeName );
		// verify location and remove it
		var lPath = variables.themesPath & "/" & arguments.themeName;
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
	* Upload theme
	* @fileField The file uploaded field
	* 
	* @return struct : { error:boolean, messages:string }
	*/
	struct function uploadTheme( required fileField ){
		var tmpPath 	= moduleSettings[ "contentbox" ].path & "/tmp";
		var results = {
			error = false, messages = ""
		};

		// upload file
		try{
			var fInfo 		= fileUpload( tmpPath, arguments.fileField, "", "overwrite" );
			var fFilePath 	= fInfo.serverDirectory & "/" & fInfo.serverFile;
		}
		catch( any e ){
			log.error( "Error uploading theme package",e);
			results.error 		= true;
			results.messages 	= "Error uploading theme package. #e.message# #e.detail#";
			return results;
		}

		try{
			// check if zip file
			if( fInfo.serverFileExt eq "zip" ){
				// Create temp holder
				if( directoryExists( tmpPath & "/theme" ) ){
					directoryDelete( tmpPath & "/theme", true );
				}
				directoryCreate( tmpPath & "/theme" );
				// Expand it
				zipUtil.extract( zipFilePath=fFilePath, extractPath=tmpPath & "/theme" );
				// Removal of Mac stuff
				if( directoryExists( tmpPath & "/theme" & "/__MACOSX" ) ){
					directoryDelete( tmpPath & "/theme" & "/__MACOSX", true );
				}
				// Verify the directory contents to move it
				var qFiles = directoryList( tmpPath & "/theme", false, "query" );
				// If only 1 entry found, we have a nested package
				if( qFiles.recordcount == 1 ){
					for( var thisRow in qFiles ){
						if( thisRow.type == 'dir' ){
							// Time to move it with a slugified version of the name
							var newDestination = variables.themesPath & "/" & replace( thisRow.name, ".", "-", "all" );
							if( directoryExists( newDestination ) ){
								directoryDelete( newDestination, true );
							}
							directoryRename( thisRow.directory & "/" & thisRow.name, newDestination );
						}
					}
				} else {
					var themeName = replacenocase( fInfo.serverFile, ".zip", "" );
					var newDestination = variables.themesPath & "/" & replace( themeName, ".", "-", "all" );
					if( directoryExists( newDestination ) ){
						directoryDelete( newDestination, true );
					}
					directoryRename( tmpPath & "/theme", newDestination );
				}

				// rebuild the registry now that it is installed
				buildThemeRegistry();
			}
		}
		catch( Any e ){
			log.error( "Error expanding theme package: #fInfo.toString()#", e );
			results.error 		= true;
			results.messages 	= "Error expanding theme package. #e.message# #e.detail#";
		}
		finally{
			// Remove zip file
			fileDelete( fFilePath );
			// Remove temp holder
			if( directoryExists( tmpPath & "/theme" ) ){
				directoryDelete( tmpPath & "/theme", true );
			}
		}

		return results;
	}
	
	/**
	* Get constraints for setting fields
	* @themeName The name of the theme
	*/
	struct function getSettingsConstraints( required themeName ){
		// Get theme CFC
		var oTheme = variables.themeCFCRegistry[ arguments.themeName ];
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
	function buildSettingsForm( required query activeTheme ){
		// Get theme CFC
		var oTheme 		= variables.themeCFCRegistry[ arguments.activeTheme.name ];
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
    							options = evaluate( "oTheme.#thisSettingMD.optionsUDF#()" );
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

}
