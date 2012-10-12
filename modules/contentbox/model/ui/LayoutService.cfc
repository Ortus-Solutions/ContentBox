﻿/**
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

	/**
	* Constructor
	*/
	LayoutService function init(){
		setLayoutRegistry('');
		setLayoutCFCRegistry({});
		setLayoutsPath('');
		setLayoutsIncludePath('');
		setLayoutsInvocationPath('');
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
		// Startup Active Layout
	}

	/**
	* Startup Active Layout procedures
	*/
	function startupActiveLayout(){
		var layout = settingService.findWhere({name="cb_site_layout"});
		if( !isNull(layout) ){
			// Register layout description as an interceptor with custom points
			interceptorService.registerInterceptor(interceptorObject=layoutCFCRegistry[ layout.getValue() ],
												   interceptorName="cblayout-#layout.getValue()#",
												   customPoints=getLayoutRecord( layout.getName() ).customInterceptionPoints);
			// Call Activation Events
			var iData = {
				layoutName = layout.getValue(),
				layoutRecord = getLayoutRecord( layout.getValue() )
			};
			interceptorService.processState("cbadmin_onLayoutActivation", iData);
			// Call Layout Callback
			if( structKeyExists( layoutCFCRegistry[ layout.getValue() ], "onActivation" ) ){
				layoutCFCRegistry[ layout.getValue() ].onActivation();
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
		// Call Layout Callback
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

		// Register each layout CFC
		for(var x=1; x lte rawLayouts.recordCount; x++){
			var layoutName 	= rawLayouts.name[x];

			// Check if valid layout
			if( !fileExists(getLayoutsPath() & "/#layoutName#/#layoutName#.cfc") ){
				log.warn("The layout: #layoutName# is an invalid layout, skipping.");
				rawLayouts.isValid[x] = false;
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

			// Theme layouts
			var thisLayouts = directoryList( getLayoutsPath() & "/#layoutName#/layouts", false, "query", "*.cfm", "name asc" );
			rawLayouts.layouts[x] = replacenocase( valueList(thisLayouts.name), ".cfm", "", "all" );
			
			// Store layout configuration CFC
			layoutCFCRegistry[ layoutName ] = config;
		}

		var rawLayouts 	= new Query(dbtype="query",sql="SELECT * from rawLayouts WHERE isValid='true'",rawlayouts=rawlayouts).execute().getResult();
		// store raw layouts
		setLayoutRegistry( rawLayouts );

		return rawLayouts;
	}

	/**
	* Remove layout
	*/
	boolean function removeLayout(required layoutName){
		// verify name
		if( !len(arguments.layoutName) ){return false;}
		// Call onDelete on Layout
		if( structKeyExists( layoutCFCRegistry[ arguments.layoutName ], "onDelete") ){
			layoutCFCRegistry[ arguments.layoutName ].onDelete();
		}
		structDelete( layoutCFCRegistry, arguments.layoutName );
		// verify location
		var lPath = getLayoutsPath() & "/" & arguments.layoutName;
		if( directoryExists( lPath ) ){ directoryDelete( lPath,true ); return true; }
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
				// expand it
				zipUtil.extract(zipFilePath=fFilePath, extractPath=destination, useFolderName=true);
				// Removal of Mac stuff
				if( directoryExists( destination & "/__MACOSX" ) ){
					directoryDelete( destination & "/__MACOSX", true);
				}
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

}