/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
*/
component accessors="true" threadSafe singleton{
	// Dependencies
	property name="settingService"		inject="id:settingService@cb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
	property name="interceptorService"	inject="coldbox:interceptorService";
	property name="zipUtil"				inject="zipUtil@cb";
	property name="log"					inject="logbox:logger:{this}";
	property name="wirebox"				inject="wirebox";
	property name="html"				inject="coldbox:plugin:HTMLHelper";
	property name="cbHelper"			inject="provider:CBHelper@cb";

	// The location in disk of the layouts
	property name="layoutsPath";
	// The include path for the layouts
	property name="layoutsIncludePath";
	// The instantiation path for the layouts
	property name="layoutsInvocationPath";
	// The layout registry of records
	property name="layoutRegistry";
	// The layout CFC registry
	property name="layoutCFCRegistry";
	// The cache of widgets for the active layout
	property name="layoutWidgetCache" type="struct";

	/**
	* Constructor
	*/
	LayoutService function init(){
		setLayoutRegistry('');
		setLayoutCFCRegistry({});
		setLayoutsPath('');
		setLayoutsIncludePath('');
		setLayoutsInvocationPath('');
		setLayoutWidgetCache({});
		return this;
	}

	/**
	* onDIComplete startup the layouting services
	*/
	void function onDIComplete(){
		// setup location paths
		setLayoutsPath( moduleSettings["contentbox"].path & "/layouts" );
		setLayoutsIncludePath( moduleSettings["contentbox"].mapping & "/layouts" );
		setLayoutsInvocationPath( moduleSettings["contentbox"].invocationPath & ".layouts" );
		// Register all layouts
		buildLayoutRegistry();
	}
	
	/**
	* Does theme have a maintenance view
	*/
	boolean function themeMaintenanceViewExists(){
		return fileExists( expandPath( CBHelper.layoutRoot() & "/views/maintenance.cfm" ) );
	}
	
	/**
	* Get the current theme's maintenance layout
	*/
	string function getThemeMaintenanceLayout(){
		var layout = "pages";
		
		// verify existence of convention
		if( fileExists( expandPath( CBHelper.layoutRoot() & "/layouts/maintenance.cfm" ) ) ){
			layout = "maintenance";
		}
		
		return layout;
	}
	
	/**
	* Get the current theme's search layout
	*/
	string function getThemeSearchLayout(){
		var layout = "pages";
		
		// verify existence of convention
		if( fileExists( expandPath( CBHelper.layoutRoot() & "/layouts/search.cfm" ) ) ){
			layout = "search";
		}
		
		return layout;
	}

	/**
	 * Returns path for the requested widget from layout service's layout cache
	 * @widgetName {String}}
	 * return String
	 */
	string function getLayoutWidgetPath( required string widgetName ) {
		var path = "";
		var parsedName =  replaceNoCase( arguments.widgetName, "~", "", "one" );
		// if requested widget exists in the cache, return the path
		if( structKeyExists( layoutWidgetCache, parsedName ) ) {
			path = layoutWidgetCache[ parsedName ];
		}
		else {
			log.error("Could not find #parsedName# widget in the currently active layout.");	
		}
		return path;
	}

	/**
	* Startup Active Layout procedures
	*/
	function startupActiveLayout(){
		// get layout setting.
		var layout = settingService.findWhere({name="cb_site_layout"});
		if( !isNull(layout) ){
			// Get layout record
			var oLayout = layoutCFCRegistry[ layout.getValue() ];
			// Register layout description as an interceptor with custom points
			interceptorService.registerInterceptor(interceptorObject=oLayout,
												   interceptorName="cblayout-#layout.getValue()#",
												   customPoints=getLayoutRecord( layout.getValue() ).customInterceptionPoints);
			// Register layout settings?
			if( structKeyExists( oLayout, "settings") ){
				registerLayoutSettings(name=layout.getValue(), settings=oLayout.settings );
			}
			
			// Prepare layout activation event
			var iData = {
				layoutName = layout.getValue(),
				layoutRecord = getLayoutRecord( layout.getValue() )
			};
			
			// build widget cache for active layout
			for( var i=1; i <= listLen( iData.layoutRecord.widgets ); i++ ) {
				var widgetName = replaceNoCase( listGetAt( iData.layoutRecord.widgets, i ), ".cfc", "", "one" );
				var widgetPath = "#getLayoutsInvocationPath()#.#layout.getValue()#.widgets.#widgetName#";
				layoutWidgetCache[ widgetName ] = widgetPath;
			}

			// Announce layout activation
			interceptorService.processState("cbadmin_onLayoutActivation", iData);
			
			// Call Layout Callback: onActivation
			if( structKeyExists( layoutCFCRegistry[ layout.getValue() ], "onActivation" ) ){
				layoutCFCRegistry[ layout.getValue() ].onActivation();
			}
		}
	}
	
	// save layout settings
	public function saveLayoutSettings(required name, required struct settings) transactional{
		var oLayout = layoutCFCRegistry[ arguments.name ];
		// iterate and save layout settings
		for( var thisSetting in oLayout.settings ){
			// retrieve it first
			var oSetting = settingService.findWhere( { name="cb_layout_#arguments.name#_#thisSetting.name#" } );
			oSetting.setValue( settings[ thisSetting.name ] );
			settingService.save( oSetting );
		}
	}
	
	// Register layout settings
	private function registerLayoutSettings(required name, required array settings) transactional{
		// iterate and register layout settings
		for( var thisSetting in arguments.settings ){
			// try to retrieve it first
			var oSetting = settingService.findWhere( { name="cb_layout_#arguments.name#_#thisSetting.name#" } );
			// If not found, then register it
			if( isNull( oSetting ) ){
				var args = { name="cb_layout_#arguments.name#_#thisSetting.name#", value=thisSetting.defaultValue };
				settingService.save( settingService.new(properties=args) );
			}
		}
	}
	
	// Unregister layout settings
	private function unregisterLayoutSettings(required array settings) transactional{
		// iterate and register layout settings
		for( var thisSetting in arguments.settings ){
			// try to retrieve it first
			var oSetting = settingService.findWhere( { name="cb_layout_#arguments.name#_#thisSetting.name#" } );
			// If not found, then register it
			if( !isNull( oSetting ) ){
				settingService.delete( oSetting );
			}
		}
	}

	/**
	* Get active layout record
	*/
	query function getActiveLayout(){
		var activeLayout = settingService.getSetting("cb_site_layout");
		return new Query(dbtype="query",sql="SELECT * from layoutRegistry WHERE name='#activeLayout#'",layoutRegistry=getLayoutRegistry()).execute().getResult();
	}

	/**
	* Get a layout record from the registry by name
	*/
	query function getLayoutRecord(required layoutName){
		return new Query(dbtype="query",sql="SELECT * from layoutRegistry WHERE name='#arguments.layoutName#'",layoutRegistry=getLayoutRegistry()).execute().getResult();
	}

	/**
	* Is active layout check
	*/
	boolean function isActiveLayout(required layoutName){
		return ( compareNoCase( getActiveLayout().name, arguments.layoutName ) EQ 0 );
	}

	/**
	* Activate the current layout in the settings
	*/
	function activateLayout(required layoutName) transactional{
		// Get the current layout setting
		var layout = settingService.findWhere({name="cb_site_layout"});
		// Call deactivation event
		var iData = {
			layoutName = layout.getValue(),
			layoutRecord = getLayoutRecord( layout.getValue() )
		};
		interceptorService.processState("cbadmin_onLayoutDeactivation", iData);
		// Call Layout Callback: onDeactivation
		if( structKeyExists(layoutCFCRegistry[ layout.getValue() ], "onDeactivation") ){
			layoutCFCRegistry[ layout.getValue() ].onDeactivation();
		}
		// Unregister Layout Descriptor Interceptor
		interceptorService.unregister(interceptorName="cblayout-#layout.getValue()#");
		
		// setup the new layout value
		layout.setValue( arguments.layoutName );
		// save the new layout setting
		settingService.save( layout );
		// register layout interception points as we just activated it
		startupActiveLayout();
		// flush the settings
		settingService.flushSettingsCache();
		return this;
	}

	/**
	* Get all registered layouts
	*/
	query function getLayouts(){
		if( isSimpleValue( getLayoutRegistry() ) ){
			return buildLayoutRegistry();
		}
		return getLayoutRegistry();
	}

	/**
	* Build layout registry
	*/
	query function buildLayoutRegistry(){
		var rawLayouts 	= directoryList(getLayoutsPath(),false,"query");
		// filter layout folders only
		var rawLayouts 	= new Query(dbtype="query", sql="SELECT directory,name from rawLayouts WHERE type = 'Dir'", rawlayouts=rawlayouts).execute().getResult();

		// exclude .* files from layouts
		if( left( rawLayouts.name[ x ], 1 ) eq '.' )
			continue;
		
		// Add Columns
		QueryAddColumn(rawLayouts,"layoutName",[]);
		QueryAddColumn(rawLayouts,"isValid",[]);
		QueryAddColumn(rawLayouts,"description",[]);
		QueryAddColumn(rawLayouts,"version",[]);
		QueryAddColumn(rawLayouts,"author",[]);
		QueryAddColumn(rawLayouts,"authorURL",[]);
		QueryAddColumn(rawLayouts,"screenShotURL",[]);
		QueryAddColumn(rawLayouts,"forgeBoxSlug",[]);
		QueryAddColumn(rawLayouts,"customInterceptionPoints",[]);
		QueryAddColumn(rawLayouts,"layouts",[]);
		QueryAddColumn(rawLayouts,"settings",[]);
		QueryAddColumn(rawLayouts,"widgets",[]);

			
		// Register each layout CFC
		for(var x=1; x lte rawLayouts.recordCount; x++){
			var layoutName 	= rawLayouts.name[x];

			// Check if valid layout
			if( !fileExists( getLayoutsPath() & "/#layoutName#/#layoutName#.cfc") ){
				log.warn("The layout: #layoutName# is an invalid layout, skipping.");
				rawLayouts.isValid[ x ] = false;
				continue;
			}
			// construct layout descriptor via WireBox
			var config = wirebox.getInstance( getLayoutsInvocationPath() & ".#layoutName#.#layoutName#" );

			// Add custom descriptions
			rawLayouts.isValid[x] = true;
			rawLayouts.layoutName[x] = config.name;
			rawLayouts.description[x] = config.description;
			rawLayouts.version[x] = config.version;
			rawLayouts.author[x] = config.author;
			rawLayouts.authorURL[x] = config.authorURL;
			// Screenshot
			if( structKeyExists(config, "screenShotURL") ){
				rawLayouts.screenShotURL[x] = getLayoutsIncludePath() & "/#layoutName#/" & config.screenShotURL;
			}
			else{
				rawLayouts.screenShotURL[x] = "";
			}
			// ForgeBox slug
			if( structKeyExists(config, "forgeBoxSlug") ){
				rawLayouts.forgeBoxSlug[x] = config.forgeBoxSlug;
			}
			else{
				rawLayouts.forgeBoxSlug[x] = "";
			}
			// Custom Interception Point
			if( structKeyExists(config, "customInterceptionPoints") ){
				rawLayouts.customInterceptionPoints[x] = config.customInterceptionPoints;
			}
			else{
				rawLayouts.customInterceptionPoints[x] = "";
			}
			// Settings
			if( structKeyExists(config, "settings") ){
				rawLayouts.settings[x] = serializeJSON( config.settings );
			}
			else{
				rawLayouts.settings[x] = "";
			}
			// Theme Widgets
			if( directoryExists( getLayoutsPath() & "/#layoutName#/widgets" ) ){
				var thisWidgets = directoryList( getLayoutsPath() & "/#layoutName#/widgets", false, "query", "*.cfc", "name asc" );
				rawLayouts.widgets[x] = replacenocase( valueList( thisWidgets.name ), ".cfm", "", "all" );
			}
			else{
				rawLayouts.widgets[x] = "";
			}
			
			// Theme layouts
			var thisLayouts = directoryList( getLayoutsPath() & "/#layoutName#/layouts", false, "query", "*.cfm", "name asc" );
			rawLayouts.layouts[x] = replacenocase( valueList( thisLayouts.name ), ".cfm", "", "all" );
			
			// Store layout configuration CFC
			layoutCFCRegistry[ layoutName ] = config;
		}

		var rawLayouts 	= new Query(dbtype="query",sql="SELECT * from rawLayouts WHERE isValid='true'", rawlayouts=rawlayouts).execute().getResult();
		// store raw layouts
		setLayoutRegistry( rawLayouts );

		return rawLayouts;
	}

	/**
	* Remove layout
	*/
	boolean function removeLayout(required layoutName){
		// verify name
		if( !len( arguments.layoutName ) ){ return false; }
		// Call onDelete on Layout
		if( structKeyExists( layoutCFCRegistry[ arguments.layoutName ], "onDelete") ){
			layoutCFCRegistry[ arguments.layoutName ].onDelete();
		}
		// Remove settings
		if( structKeyExists( layoutCFCRegistry[ arguments.layoutName ], "settings" ) ){
			unregisterLayoutSettings( name=arguments.layoutName, settings=layoutCFCRegistry[ arguments.layoutName ].settings );
		}
		// Remove from registry
		structDelete( layoutCFCRegistry, arguments.layoutName );
		// verify location and remove it
		var lPath = getLayoutsPath() & "/" & arguments.layoutName;
		if( directoryExists( lPath ) ){ 
			// delete layout
			directoryDelete( lPath, true );
			// issue rebuild
			buildLayoutRegistry();
			return true; 
		}
		// return
		return false;
	}

	/**
	* Upload Layout, returns [error:boolean,messages:string]
	*/
	struct function uploadLayout(required fileField){
		var destination = getLayoutsPath();
		var results = {
			error = false, messages = ""
		};

		// upload file
		try{
			var fInfo 		= fileUpload(destination,arguments.fileField,"","overwrite");
			var fFilePath 	= fInfo.serverDirectory & "/" & fInfo.serverFile;
		}
		catch(any e){
			log.error("Error uploading layout package",e);
			results.error = true;
			results.messages = "Error uploading layout package. #e.message# #e.detail#";
			return results;
		}

		try{
			// check if zip file
			if( fInfo.serverFileExt eq "zip" ){
				// Expand it
				zipUtil.extract(zipFilePath=fFilePath, extractPath=destination, useFolderName=true);
				// Removal of Mac stuff
				if( directoryExists( destination & "/__MACOSX" ) ){
					directoryDelete( destination & "/__MACOSX", true);
				}
				// rebuild the registry now that it is installed
				buildLayoutRegistry();
			}
		}
		catch(Any e){
			log.error("Error expanding layout package: #fInfo.toString()#",e);
			results.error = true;
			results.messages = "Error expanding layout package. #e.message# #e.detail#";
		}
		finally{
			// remove zip file
			fileDelete( fFilePath );
		}

		return results;
	}
	
	function getSettingsConstraints(required layoutName){
		// Get layout registry
		var oLayout = layoutCFCRegistry[ arguments.layoutName ];
		// Verify it has settings, else return empty struct
		if( !structKeyExists( oLayout, "settings" ) OR !arrayLen( oLayout.settings ) ){ return {}; }
		
		var constraints = {};
		
		// iterate and build
		for( var thisSetting in oLayout.settings ){
			// Check if required
			if( structKeyExists( thisSetting, "required" ) and thisSetting.required ){ 
				constraints[ thisSetting.name ] = {
					required = true
				};
			}
		}
		
		return constraints;
	}
	
	function buildSettingsForm(required activeLayout){
		// Get layout registry
		var oLayout = layoutCFCRegistry[ arguments.activeLayout.name ];
		var settingForm = "";
		
		// Build Form by iteration over items
		if( !structKeyExists( oLayout, "settings" ) OR !arrayLen( oLayout.settings ) ){ return settingForm; }

		savecontent variable="settingForm"{

			for(var x=1; x lte arrayLen( oLayout.settings ); x++){
				var thisSetting = oLayout.settings[ x ];
				var requiredText = "";
				var requiredValidator = "";
				// get actual setting value which should be guaranteed to exist
				var oSetting = settingService.findWhere( { name="cb_layout_#arguments.activeLayout.name#_#thisSetting.name#" } );
				thisSetting.defaultValue = oSetting.getValue();
				
				// Default values for settings
				if( !structKeyExists(thisSetting,"required") ){ thisSetting.required = false; }
				if( !structKeyExists(thisSetting,"label") ){ thisSetting.label = thisSetting.name; }
				if( !structKeyExists(thisSetting,"type") ){ thisSetting.type = "text"; }
				if( !structKeyExists(thisSetting,"title") ){ thisSetting.title = ""; }

				// required stuff
				if( thisSetting.required ){
					requiredText = "<span class='textRed'>*Required</span>";
					requiredValidator = "required";
				}
				// writeout control wrapper
				writeOutput( '<div class="control-group">' );
					// write out label
					writeOutput( html.label(field=thisSetting.name, content="#thisSetting.label# #requiredText#") );
					writeOutput( '<div class="controls">' );
    				// write out control
    				switch( thisSetting.type ){
    					case "boolean" : {
    						writeOutput( html.select(name=thisSetting.name, options="true,false", selectedValue=thisSetting.defaultValue, title=thisSetting.title) );
    						break;
    					}
    					case "select" : {
    						writeOutput( html.select(name=thisSetting.name, options=thisSetting.options, selectedValue=thisSetting.defaultValue, title=thisSetting.title) );
    						break;
    					}
    					case "textarea" : {
    						writeOutput( html.textarea(name=thisSetting.name, required=requiredValidator, title=thisSetting.title, value=thisSetting.defaultValue) );
    						break;
    					}
    					default:{
    						writeOutput( html.textfield(name=thisSetting.name, size="55", class="textfield", required=requiredValidator, title=thisSetting.title, value=thisSetting.defaultValue) );
    					}
    				}
    				writeOutput( '</div>' );
				writeOutput( '</div>' );
			}
		}
		
		return settingForm;
	}

}
