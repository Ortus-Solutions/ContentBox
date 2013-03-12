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
	property name="widgetsPath" 			type="string";
	property name="widgetsIconsPath" 		type="string";
	property name="widgetsIconsIncludePath" type="string";
	
	WidgetService function init(){
		return this;
	}
	
	/**
	* onDIComplete
	*/
	function onDIComplete(){
		widgetsPath 			= moduleSettings["contentbox"].path & "/widgets";
		widgetsIconsPath 		= moduleSettings["contentbox-admin"].path & "/includes/images/widgets";
		widgetsIconsPath 		= moduleSettings["contentbox-admin"].path & "/includes/images/widgets";
		widgetsIconsIncludePath = moduleSettings["contentbox-admin"].mapping & "/includes/images/widgets";
	}
	
	/**
	* Get a list of widget icons available in the system
	*/
	array function getWidgetIcons(){
		return directoryList( widgetsIconsPath, false, "name", "*.png" );
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
	* Create new core widget
	*/
	WidgetService function createNewWidget(required Widget widget){
		// read in template
		var templateCode = fileRead( getDirectoryFromPath( getMetadata( this ).path ) & "templates/Widget.txt" );
		// parsing
		templateCode = replacenocase(templateCode,"@name@", widget.getName(),"all");
		templateCode = replacenocase(templateCode,"@description@", widget.getDescription(),"all");
		templateCode = replacenocase(templateCode,"@version@", widget.getVersion(),"all");
		templateCode = replacenocase(templateCode,"@author@", widget.getAuthor(),"all");
		templateCode = replacenocase(templateCode,"@authorURL@", widget.getAuthorURL(),"all");
		templateCode = replacenocase(templateCode,"@category@", widget.getCategory(),"all");
		templateCode = replacenocase(templateCode,"@icon@", widget.getIcon(),"all");
		// write it out
		return saveWidgetCode( widget.getName(), templateCode, "core" );
	}
	/**
	 * Get unique, sorted widget categories from main widget query
	 * returns Query
	 */
	public query function getWidgetCategories() {
		var widgets = getWidgets();
		var q = new query();
			q.setDbType( 'query' );
			q.setAttributes( QoQ=widgets );
			q.setSQL( 'select distinct category from QoQ order by category ASC' );
		return q.execute().getResult();
	}
	/**
	* Get installed widgets
	*/
	query function getWidgets(){
		// get core widgets
		var widgets = directoryList( widgetsPath, false, "query", "*.cfc", "name asc" );
		// get module widgets
		var moduleWidgets = moduleService.getModuleWidgetCache();
		// get layout widgets
		var layoutWidgets = layoutService.getLayoutWidgetCache();
		
		// Add custom columns
		QueryAddColumn(widgets,"filename",[]);
		QueryAddColumn(widgets,"plugin",[]);
		QueryAddColumn(widgets,"widgettype",[]);
		QueryAddColumn(widgets,"module",[]);
		QueryAddColumn(widgets,"category",[]);
		QueryAddColumn(widgets,"icon",[]);
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
				widgets.category[x] = getWidgetCategory( widgets.name[x], widgets.widgettype[x] );
				widgets.icon[x] = getWidgetIcon( widgets.name[x], widgets.widgettype[x] );
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
				var mplugin = getWidget( name=widget, type="module" );
				var category = getWidgetCategory( name=widget, type="module" );
				var icon = getWidgetIcon( name=widget, type="module" );
				querySetCell( widgets, "plugin", mplugin );
				querySetCell( widgets, "category", category );
				querySetCell( widgets, "icon", icon );
			}
			catch(any e){
				log.error("Error creating module widget plugin: #widgetName#",e);
			}
		}
		
		// add layout widgets
		for( var widget in layoutWidgets ) {
			queryAddRow( widgets );
			querySetCell( widgets, "filename", widget );
			querySetCell( widgets, "name", widget );
			querySetCell( widgets, "widgettype", "Layout" );
			
			try{
				var lplugin = getWidget( name=widget, type="layout" );
				var category = getWidgetCategory( name=widget, type="layout" );
				var icon = getWidgetIcon( name=widget, type="layout" );
				querySetCell( widgets, "plugin", lplugin );
				querySetCell( widgets, "category", category );
				querySetCell( widgets, "icon", icon );
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
				var path = layoutService.getLayoutWidgetPath( arguments.name );
				break;
			case "module":
				var path = moduleService.getModuleWidgetPath( arguments.name );
				break;
			case "core":
				var path = "contentbox.widgets." & arguments.name;
				break;
		}
		if( len( path ) ) {
			return coldbox.getPlugin(plugin=path, customPlugin=true);
		}
	}
	
	string function getWidgetIcon( required name, required string type="core" ) {
		var widget = getWidget( argumentCollection=arguments );
		var icon = widget.getIcon();
		if( isNull( icon ) || icon == "" ) {
			switch( type ) {
				case "layout":
					icon = "layout_squares_small.png";
					break;
				case "module":
					icon="box.png";
					break;
				default:
					icon = "puzzle.png";
					break;
			}
		}
		return icon;
	}
	
	string function getWidgetCategory( required name, required string type="core" ) {
		var widget = getWidget( argumentCollection=arguments );
		var category = widget.getCategory();
		if( isNull( category ) || category == "" ) {
			switch( type ) {
				case "layout":
					category = "Layout";
					break;
				case "module":
					category="Module";
					break;
				default:
					category = "Miscellaneous";
					break;
			}
		}
		return category;
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
				widgetPath = "#layout.directory#/#layout.name#/widgets/#arguments.name#.cfc";
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
	
	any function getWidgetRenderArgs( udf, widget, type ){
		// get widget
		var p = getWidget( name=arguments.widget, type=arguments.type );
		var md = getMetadata( p[ udf ] );
		return md;
	}
}