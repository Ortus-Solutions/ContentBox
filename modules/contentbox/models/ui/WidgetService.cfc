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
	property name="coldbox"				inject="coldbox";
	property name="log"					inject="logbox:logger:{this}";

	/**
	* The core widgets location path
	*/
	property name="coreWidgetsPath" 		type="string";

	/**
	 * The custom widgets location path
	 */
	property name="customWidgetsPath" 		type="string";

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
		// Verify widgets path location
		variables.coreWidgetsPath 	= variables.moduleSettings[ "contentbox" ].path & "/widgets";
		variables.customWidgetsPath = variables.moduleSettings[ "contentbox-custom" ].path & "/_widgets";
	}

	/**
	* Get installed widgets as a list of names
	*/
	string function getWidgetsList(){
		var w = getWidgets();
		return valueList( w.name );
	}

	/**
	 * Get unique, sorted widget categories from main widget query
	 * returns Query
	 */
	query function getWidgetCategories() {
		var widgets = getWidgets();
		var q = new Query( 
			dbType 	= "query",
			sql 	= "select distinct category from QoQ order by category ASC"
		);
		return q.execute().getResult();
	}

	/**
	 * Get a query listing of widgets in a path
	 *
	 * @path The path to check
	 */
	private query function getWidgetsFromPath( required path ){
		return directoryList( arguments.path, false, "query", "*.cfc", "name asc" );
	}

	/**
	* Get all installed widgets in the core and custom location
	*/
	query function getWidgets(){
		// get core widgets
		var qAllWidgets 	= getWidgetsFromPath( variables.coreWidgetsPath );
		// get module widgets
		var moduleWidgets 	= moduleService.getModuleWidgetCache();
		// get theme widgets
		var themeWidgets 	= themeService.getWidgetCache();

		// Add custom columns
		QueryAddColumn( qAllWidgets, "filename",   [] );
		QueryAddColumn( qAllWidgets, "plugin",     [] );
		QueryAddColumn( qAllWidgets, "widgettype", [] );
		QueryAddColumn( qAllWidgets, "module",     [] );
		QueryAddColumn( qAllWidgets, "category",   [] );
		QueryAddColumn( qAllWidgets, "icon",       [] );
		QueryAddColumn( qAllWidgets, "debug",      [] );
		
		// add core widgets
		for( var x=1; x lte qAllWidgets.recordCount; x++ ){
			// filename
			qAllWidgets.fileName[ x ] = qAllWidgets.name[ x ];
			// rip extension name only
			qAllWidgets.name[ x ] = ripExtension( qAllWidgets.name[ x ] );
			// set the type
			qAllWidgets.widgettype[ x ] = "Core";
			try{
				qAllWidgets.category[ x ] = getWidgetCategory( qAllWidgets.name[ x ], qAllWidgets.widgettype[ x ] );
				qAllWidgets.icon[ x ] = getWidgetIcon( qAllWidgets.name[ x ], qAllWidgets.widgettype[ x ] );
			}
			catch(any e){
				log.error( "Error creating widget plugin: #qAllWidgets.name[ x ]#",e);
			}
		}

		writeDump( var=qAllWidgets );abort;

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

		// add theme widgets
		for( var widget in themeWidgets ) {
			queryAddRow( widgets );
			querySetCell( widgets, "filename", widget );
			querySetCell( widgets, "name", widget );
			querySetCell( widgets, "widgettype", "Theme" );

			try{
				//var lplugin = getWidget( name=widget, type="theme" );
				var category = getWidgetCategory( name=widget, type="theme" );
				var icon = getWidgetIcon( name=widget, type="theme" );
				//querySetCell( widgets, "plugin", lplugin );
				querySetCell( widgets, "category", category );
				querySetCell( widgets, "icon", icon );
			}
			catch(any e){
				log.error( "Error creating theme widget plugin: #widget#",e);
			}
		}
		return widgets;
	}

	/**
	 * Get a widget by name
	 * @name The name of the widget
	 * @type This can be one of the following: core, theme, module
	 */
	any function getWidget( required name, required string type="core" ){
		var path = "";
		switch( type ) {
			case "theme" :
				var path = themeService.getThemeWidgetPath( arguments.name );
				break;
			case "module" :
				var path = moduleService.getModuleWidgetPath( arguments.name );
				break;
			case "core" : case "custom" :
				var path = "contentbox.widgets." & arguments.name;
				
				break;
		}

		if( len( path ) ) {
			// Init Arguments added for backwards compat
			return wirebox.getInstance( 
				name 			= path, 
				initArguments	= { "controller" = variables.coldbox }
			);
		}
	}

	/**
	 * Get a widget icon representation
	 * @name The name of the widget
	 * @type This can be one of the following: core, theme, module
	 */
	string function getWidgetIcon( required name, required string type="core" ) {
		var widget = getWidget( argumentCollection=arguments );
		var icon = widget.getIcon();
		if( isNull( icon ) || icon == "" ) {
			switch( type ) {
				case "theme":
					icon = "th-large";
					break;
				case "module":
					icon="archive";
					break;
				default:
					icon = "puzzle-piece";
					break;
			}
		}
		return icon;
	}

	/**
	 * Get a widget category
	 * @name The name of the widget
	 * @type This can be one of the following: core, theme, module
	 */
	string function getWidgetCategory( required name, required string type="core" ) {
		var widget = getWidget( argumentCollection=arguments );
		var category = widget.getCategory();
		if( isNull( category ) || category == "" ) {
			switch( type ) {
				case "theme":
					category = "Theme";
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
	 * 
	 * @name The name of the widget
	 * @type The type of widget
	 */
	function getWidgetFilePath( required string name, required string type ) {
		var widgetPath = "";
		// switch on widget type (core, theme, module )
		switch( type ) {
			case "theme" :
				var theme 	= themeService.getActiveTheme();
				widgetPath 	= "#theme.directory#/#theme.name#/widgets/#replaceNoCase( arguments.name, '~', '', 'one' )#.cfc";
				break;
			case "module" :
				var widgetname = listGetAt( arguments.name, 1, '@' );
				var modulename = listGetAt( arguments.name, 2, '@' );
				widgetPath = moduleSettings[ "contentbox" ].path & "/modules/#modulename#/widgets/#widgetname#.cfc";
				break;
			case "core" : case "custom" :
				// Check custom path first
				if( fileExists( variables.customWidgetsPath & "/#arguments.name#.cfc " ) ){
					widgetPath = variables.customWidgetsPath & "/#arguments.name#.cfc";	
				} else {
					widgetPath = variables.coreWidgetsPath & "/#arguments.name#.cfc";
				}
				break;
		}
		return widgetPath;
	}

	/**
	 * Remove widget
	 * @widgetFile The location of the widget to remove
	 */
	boolean function removeWidget( required widgetFile ){
		var wPath 		= variables.coreWidgestPath & "/" & arguments.widgetFile & ".cfc";
		var wCustomPath = variables.customWidgetsPath & "/" & arguments.widgetFile & ".cfc";
		
		if( fileExists( wPath ) ){ 
			fileDelete( wPath ); 
			return true; 
		}

		if( fileExists( wCustomPath ) ){ 
			fileDelete( wCustomPath ); 
			return true; 
		}

		return false;
	}

	/**
	* Upload Widget
	* @fileField The form file field to use
	* 
	* @return The CFFile structure from the upload results
	*/
	struct function uploadWidget( required fileField ){
		var destination 	= variables.customWidgetsPath;
		var results 		= fileUpload( destination, arguments.fileField, "", "overwrite" );
		
		if( results.clientfileext neq "cfc" ){
			fileDelete( results.serverDirectory & "/" & results.serverfile );
			throw( message="Invalid widget type detected: #results.clientfileext#", type="InvalidWidgetType" );
		}
		return results;
	}

	/**
	 * Rip Extensions from file name
	 * @fileName The target to rip
	 */
	function ripExtension( required filename ){
		return reReplace( arguments.filename, "\.[^.]*$", "" );
	}

	/**
	 * Get widget rendering arguments
	 * @udf The target UDF to render out arguments for
	 * @widget The widget name
	 * @type The widget type
	 * 
	 * @return The argument metadata structure
	 */
	function getWidgetRenderArgs( udf, widget, type ){
		// get widget
		var p = getWidget( name=arguments.widget, type=arguments.type );
		return getMetadata( p[ udf ] );
	}
}