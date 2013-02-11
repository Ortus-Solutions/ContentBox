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
component accessors="true" singleton threadSafe{
	// Dependecnies
	property name="settingService"		inject="id:settingService@cb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
	property name="moduleService"		inject="ModuleService@cb";
	property name="layoutService"		inject="LayoutService@cb";
	property name="coldbox"				inject="coldbox";
	property name="log"					inject="logbox:logger:{this}";
	
	// Local properties
	property name="widgetsPath" type="string";
	
	WidgetService function init(){
		return this;
	}
	
	/**
	* onDIComplete
	*/
	function onDIComplete(){
		setWidgetsPath( moduleSettings["contentbox"].path & "/widgets" );
	}

	/**
	* Get installed widgets as a list of names
	*/
	string function getWidgetsList(){
		var w = getWidgets();
		return valueList(w.name);
	}
	
	/**
	* Get widget code
	* @name {String}
	* @type {String}
	* return String
	*/
	string function getWidgetCode(required string name, required string type){
		var widgetPath = getWidgetFilePath( argumentCollection=arguments );
		return fileRead( widgetPath );
	}
	
	/**
	* Save widget code
	* @name {String}
	* @code {String}
	* @type {String}
	* return WidgetService
	*/
	WidgetService function saveWidgetCode(required string name, required string code, required string type){
		var widgetPath = getWidgetFilePath( argumentCollection=arguments );
		fileWrite( widgetPath, arguments.code );
		return this;
	}
	
	/**
	* Create new widget
	*/
	WidgetService function createNewWidget(required Widget widget){
		// read in template
		var templateCode = fileRead( getDirectoryFromPath( getMetadata(this).path ) & "templates/Widget.txt" );
		// parsing
		templateCode = replacenocase(templateCode,"@name@", widget.getName(),"all");
		templateCode = replacenocase(templateCode,"@description@", widget.getDescription(),"all");
		templateCode = replacenocase(templateCode,"@version@", widget.getVersion(),"all");
		templateCode = replacenocase(templateCode,"@author@", widget.getAuthor(),"all");
		templateCode = replacenocase(templateCode,"@authorURL@", widget.getAuthorURL(),"all");
		// write it out
		return saveWidgetCode( widget.getName(), templateCode );
	}
	
	/**
	* Get installed widgets
	*/
	query function getWidgets(){
		// get core widgets
		var widgets = directoryList(getWidgetsPath(),false,"query","*.cfc","name asc");
		// get module widgets
		var moduleWidgets = ModuleService.getModuleWidgetCache();
		// get layout widgets
		var layoutWidgets = LayoutService.getLayoutWidgetCache();
		// Add custom columns
		QueryAddColumn(widgets,"filename",[]);
		QueryAddColumn(widgets,"plugin",[]);
		QueryAddColumn(widgets,"widgettype",[]);
		QueryAddColumn(widgets,"module",[]);
		// cleanup and more stuff
		
		// add core widgets
		for(var x=1; x lte widgets.recordCount; x++){
			// filename
			widgets.fileName[x] = widgets.name[x];
			// name only
			widgets.name[x] = ripExtension( widgets.name[x] );
			// try to create the plugin
			widgets.plugin[x] = "";
			// set the type
			widgets.widgettype[x] = "Core";
			try{
				widgets.plugin[x] = getWidget( widgets.name[x], widgets.widgettype[x] );
			}
			catch(any e){
				log.error("Error creating widget plugin: #widgets.name[x]#",e);
			}
		}
		// add module widgets
		for( var widget in moduleWidgets ) {
			var widgetName = listGetAt( widget, 1, "@" );
			var moduleName = listGetAt( widget, 2, "@" );
			queryAddRow( widgets );
			querySetCell( widgets, "filename", widgetName );
			querySetCell( widgets, "name", widgetName );
			querySetCell( widgets, "widgettype", "Module" );
			querySetCell( widgets, "module", moduleName );
			
			try{
				querySetCell( widgets, "plugin", getWidget( name=widget, type="module" ) );
			}
			catch(any e){
				log.error("Error creating module widget plugin: #widgetsName#",e);
			}
		}
		
		// add layout widgets
		for( var widget in layoutWidgets ) {
			queryAddRow( widgets );
			querySetCell( widgets, "filename", widget );
			querySetCell( widgets, "name", widget );
			querySetCell( widgets, "widgettype", "Layout" );
			
			try{
				querySetCell( widgets, "plugin", getWidget( name=widget, type="layout" ) );
			}
			catch(any e){
				log.error("Error creating layout widget plugin: #widget#",e);
			}
		}
		
		return widgets;
	}
	
	/**
	* Get a widget by name
	*/
	any function getWidget( required name, required string type="core" ){
		var path = "";
		switch( type ) {
			case "layout":
				var path = LayoutService.getLayoutWidgetPath( arguments.name );
				break;
			case "module":
				var path = ModuleService.getModuleWidgetPath( arguments.name );
				break;
			case "core":
				var path = "contentbox.widgets." & arguments.name;
				break;
		}
		if( len( path ) ) {
			return coldbox.getPlugin(plugin=path, customPlugin=true);
		}
	}
	
	/**
	 * Gets widget file path by name and type
	 * @name {String}
	 * @type {String}
	 * return String
	 */
	string function getWidgetFilePath( required string name, required string type ) {
		var widgetPath = "";
		// switch on widget type (core, layout, module )
		switch( type ) {
			case "layout":
				var layout = LayoutService.getActiveLayout();
				widgetPath = "#layout.directory#/#layout.layoutname#/widgets/#arguments.name#.cfc";
				break;
			case "module":
				var widgetname = listGetAt( arguments.name, 1, '@' );
				var modulename = listGetAt( arguments.name, 2, '@' );
				widgetPath = moduleSettings[ "contentbox" ].path & "/modules/#modulename#/widgets/#widgetname#.cfc";
				break;
			case "core":
				widgetPath = getWidgetsPath() & "/#arguments.name#.cfc";
				break;
		}
		return widgetPath;
	}
	
	/**
	* Remove widget
	*/
	boolean function removeWidget(required widgetFile){
		var wPath = getWidgetsPath() & "/" & arguments.widgetFile & ".cfc";
		if( fileExists( wPath) ){ fileDelete( wPath ); return true; }
		return false;
	}
	
	/**
	* Upload Widget
	*/
	struct function uploadWidget(required fileField){
		var destination = getWidgetsPath();
		return fileUpload(destination,arguments.fileField,"","overwrite");
	}
	
	// rip extensions
	string function ripExtension(required filename){
		return reReplace(arguments.filename,"\.[^.]*$","");
	}
	
}