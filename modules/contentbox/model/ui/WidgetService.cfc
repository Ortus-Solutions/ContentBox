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
	function getWidgetsList(){
		var w = getWidgets();
		return valueList(w.name);
	}
	
	/**
	* Get installed widgets
	*/
	function getWidgets(){
		var widgets = directoryList(getWidgetsPath(),false,"query","*.cfc","name asc");
		
		// Add custom columns
		QueryAddColumn(widgets,"filename",[]);
		QueryAddColumn(widgets,"plugin",[]);
		
		// cleanup and more stuff
		for(x=1; x lte widgets.recordCount; x++){
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
		var wPath = getWidgetsPath() & "/" & arguments.widgetFile;
		if( fileExists( wPath) ){ fileDelete( wPath ); return true; }
		return false;
	}
	
	/**
	* Upload Widget
	*/
	function uploadWidget(required fileField){
		var destination = getWidgetsPath();
		return fileUpload(destination,arguments.fileField,"","overwrite");
	}
	
	// rip extensions
	function ripExtension(required filename){
		return reReplace(arguments.filename,"\.[^.]*$","");
	}
	
}