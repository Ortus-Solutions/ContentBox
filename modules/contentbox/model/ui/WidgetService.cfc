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
component accessors="true" singleton{
	// Dependecnies
	property name="settingService"		inject="id:settingService@cb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
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
		setWidgetsPath( moduleSettings["contentbox-ui"].PluginsPhysicalPath & "/widgets" );
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
	*/
	string function getWidgetCode(required string name){
		var widgetPath = getWidgetsPath() & "/#arguments.name#.cfc";
		return fileRead( widgetPath );
	}
	
	/**
	* Save widget code
	*/
	WidgetService function saveWidgetCode(required string name, required string code){
		var widgetPath = getWidgetsPath() & "/#arguments.name#.cfc";
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
		var widgets = directoryList(getWidgetsPath(),false,"query","*.cfc","name asc");
		
		// Add custom columns
		QueryAddColumn(widgets,"filename",[]);
		QueryAddColumn(widgets,"plugin",[]);
		
		// cleanup and more stuff
		for(var x=1; x lte widgets.recordCount; x++){
			// filename
			widgets.fileName[x] = widgets.name[x];
			// name only
			widgets.name[x] = ripExtension( widgets.name[x] );
			// try to create the plugin
			widgets.plugin[x] = "";
			try{
				widgets.plugin[x] = getWidget( widgets.name[x] );
			}
			catch(any e){
				log.error("Error creating widget plugin: #widgets.name[x]#",e);
			}
		}
		
		return widgets;
	}
	
	/**
	* Get a widget by name
	*/
	any function getWidget(required name){
		return coldbox.getPlugin(plugin="widgets." & arguments.name,module="contentbox-ui",custom=true);
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