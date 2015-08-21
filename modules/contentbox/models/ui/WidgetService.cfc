/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages ContentBox Widgets
*/
component accessors="true" singleton threadSafe{

	// Dependecnies
	property name="settingService"		inject="id:settingService@cb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
	property name="moduleService"		inject="ModuleService@cb";
	property name="themeService"		inject="themeService@cb";
	property name="wirebox"				inject="wirebox";
	property name="log"					inject="logbox:logger:{this}";

	// Local properties
	property name="widgetsPath" 			type="string";
	property name="widgetsIconsPath" 		type="string";
	property name="widgetsIconsIncludePath" type="string";

	/**
	* Constructor
	*/
	WidgetService function init(){
		return this;
	}

	/**
	* onDIComplete
	*/
	function onDIComplete(){
		widgetsPath 			= moduleSettings[ "contentbox" ].path & "/widgets";
		widgetsIconsPath 		= moduleSettings[ "contentbox-admin" ].path & "/includes/images/widgets";
		widgetsIconsPath 		= moduleSettings[ "contentbox-admin" ].path & "/includes/images/widgets";
		widgetsIconsIncludePath = moduleSettings[ "contentbox-admin" ].mapping & "/includes/images/widgets";
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
	 * Get unique, sorted widget categories from main widget query
	 * returns Query
	 */
	public query function getWidgetCategories() {
		var widgets = getWidgets();
		var q = new Query();
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
		var layoutWidgets = themeService.getWidgetCache();

		// Add custom columns
		QueryAddColumn( widgets, "filename", [] );
		QueryAddColumn( widgets, "plugin", [] );
		QueryAddColumn( widgets, "widgettype", [] );
		QueryAddColumn( widgets, "module", [] );
		QueryAddColumn( widgets, "category", [] );
		QueryAddColumn( widgets, "icon", [] );
		QueryAddColumn( widgets, "debug", [] );
		// cleanup and more stuff

		// add core widgets
		for( var x=1; x lte widgets.recordCount; x++ ){
			// filename
			widgets.fileName[ x ] = widgets.name[ x ];
			// rip extension name only
			widgets.name[ x ] = ripExtension( widgets.name[ x ] );
			// try to create the plugin
			widgets.plugin[ x ] = "";
			// set the type
			widgets.widgettype[ x ] = "Core";
			try{
				//widgets.plugin[ x ] = getWidget( widgets.name[ x ], widgets.widgettype[ x ] );
				widgets.category[ x ] = getWidgetCategory( widgets.name[ x ], widgets.widgettype[ x ] );
				widgets.icon[ x ] = getWidgetIcon( widgets.name[ x ], widgets.widgettype[ x ] );
			}
			catch(any e){
				log.error( "Error creating widget plugin: #widgets.name[ x ]#",e);
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
				//var mplugin = getWidget( name=widget, type="module" );
				var category = getWidgetCategory( name=widget, type="module" );
				var icon = getWidgetIcon( name=widget, type="module" );
				//querySetCell( widgets, "plugin", mplugin );
				querySetCell( widgets, "category", category );
				querySetCell( widgets, "icon", icon );
			}
			catch(any e){
				log.error( "Error creating module widget plugin: #widgetName#",e);
				querySetCell( widgets, "debug", "Error creating module widget plugin #e.message# #e.detail#. Logged error and stacktrace too." );
			}
		}

		// add layout widgets
		for( var widget in layoutWidgets ) {
			queryAddRow( widgets );
			querySetCell( widgets, "filename", widget );
			querySetCell( widgets, "name", widget );
			querySetCell( widgets, "widgettype", "Layout" );

			try{
				//var lplugin = getWidget( name=widget, type="layout" );
				var category = getWidgetCategory( name=widget, type="layout" );
				var icon = getWidgetIcon( name=widget, type="layout" );
				//querySetCell( widgets, "plugin", lplugin );
				querySetCell( widgets, "category", category );
				querySetCell( widgets, "icon", icon );
			}
			catch(any e){
				log.error( "Error creating layout widget plugin: #widget#",e);
			}
		}
		return widgets;
	}

	/**
	* Get a widget by name
	* @name
	* @type This can be one of the following: core, layout, module
	*/
	any function getWidget( required name, required string type="core" ){
		var path = "";
		switch( type ) {
			case "layout":
				var path = themeService.getThemeWidgetPath( arguments.name );
				break;
			case "module":
				var path = moduleService.getModuleWidgetPath( arguments.name );
				break;
			case "core":
				var path = "contentbox.widgets." & arguments.name;
				break;
		}
		if( len( path ) ) {
			return wirebox.getInstance( path );
		}
	}

	/**
	* Get a widget icon representation
	* @name The name of the widget
	* @type This can be one of the following: core, layout, module
	*/
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

	/**
	* Get a widget category
	* @name The name of the widget
	* @type This can be one of the following: core, layout, module
	*/
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
				var layout = themeService.getActiveTheme();
				widgetPath = "#layout.directory#/#layout.name#/widgets/#replaceNoCase( arguments.name, '~', '', 'one' )#.cfc";
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
		var results = fileUpload(destination, arguments.fileField, "", "overwrite" );
		if( results.clientfileext neq "cfc" ){
			fileDelete( results.serverDirectory & "/" & results.serverfile );
			throw(message="Invalid widget type detected: #results.clientfileext#", type="InvalidWidgetType" );
		}
		return results;
	}

	// rip extensions
	string function ripExtension(required filename){
		return reReplace(arguments.filename,"\.[^.]*$","" );
	}

	any function getWidgetRenderArgs( udf, widget, type ){
		// get widget
		var p = getWidget( name=arguments.widget, type=arguments.type );
		var md = getMetadata( p[ udf ] );
		return md;
	}
}