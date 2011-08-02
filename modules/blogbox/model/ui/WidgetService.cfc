component accessors="true" singleton{
	// Dependecnies
	property name="settingService"		inject="id:settingService@bb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
	
	// Local properties
	property name="widgetsPath" type="string";
	
	WidgetService function init(){
		return this;
	}
	
	/**
	* onDIComplete
	*/
	function onDIComplete(){
		setWidgetsPath( moduleSettings["blogbox-ui"].PluginsPhysicalPath & "/widgets" );
	}

	/**
	* Get installed widgets
	*/
	function getWidgets(){
		var widgets = directoryList(getWidgetsPath(),false,"query","*.cfc","name asc");
		return widgets;
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
	function uploadPlugin(required fileField){
		var destination = getWidgetsPath();
		return fileUpload(destination,arguments.fileField,"","overwrite");
	}
	
	// rip extensions
	function ripExtension(required filename){
		return reReplace(arguments.filename,"\.[^.]*$","");
	}
	
}