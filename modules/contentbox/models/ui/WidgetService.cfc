/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages ContentBox Widgets
 */
component accessors="true" singleton threadSafe {

	// Dependecnies
	property name="settingService" inject="id:settingService@contentbox";
	property name="moduleSettings" inject="coldbox:setting:modules";
	property name="moduleService" inject="ModuleService@contentbox";
	property name="themeService" inject="themeService@contentbox";
	property name="wirebox" inject="wirebox";
	property name="coldbox" inject="coldbox";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * The core widgets location path
	 */
	property name="coreWidgetsPath" type="string";

	/**
	 * The custom widgets location path
	 */
	property name="customWidgetsPath" type="string";

	/**
	 * The core widgets map
	 */
	property name="coreWidgetsMap" type="struct";

	/**
	 * The custom widgets map
	 */
	property name="customWidgetsMap" type="struct";

	/**
	 * The loaded widgets in the entire system: core, custom, theme, modules
	 */
	property name="loadedWidgets";

	/**
	 * Constructor
	 */
	WidgetService function init(){
		variables.coreWidgetsMap   = {};
		variables.customWidgetsMap = {};

		variables.loadedWidgets = "";
		return this;
	}

	/**
	 * onDIComplete
	 */
	function onDIComplete(){
		// Verify widgets path location
		variables.coreWidgetsPath   = variables.moduleSettings[ "contentbox" ].path & "/widgets";
		variables.customWidgetsPath = variables.moduleSettings[ "contentbox-custom" ].path & "/_widgets";
	}

	/**
	 * Get installed widgets as an array of names
	 */
	array function getWidgetsList(){
		var w = getWidgets();
		return listToArray( valueList( w.name ) );
	}

	/**
	 * Get unique, sorted widget categories from main widget query
	 * returns Query
	 */
	query function getWidgetCategories(){
		var widgets = getWidgets();
		var q       = new Query(
			dbType = "query",
			QoQ    = widgets,
			sql    = "select distinct category from QoQ order by category ASC"
		);
		return q.execute().getResult();
	}

	/**
	 * Get all installed widgets in ContentBox by looking at the following locations:
	 * - core
	 * - custom
	 * - active theme
	 * - registered modules
	 *
	 * @reload Widgets are lazy loaded, or you can force a reload
	 */
	query function getWidgets( boolean reload = false ){
		// If query is loaded and not a reload then return it.
		if ( isQuery( variables.loadedWidgets ) and !arguments.reload ) {
			return variables.loadedWidgets;
		}

		var qAllWidgets = queryNew( "" );

		// Add custom columns
		queryAddColumn( qAllWidgets, "name", [] );
		queryAddColumn( qAllWidgets, "directory", [] );
		queryAddColumn( qAllWidgets, "filename", [] );
		queryAddColumn( qAllWidgets, "widgettype", [] );
		queryAddColumn( qAllWidgets, "module", [] );
		queryAddColumn( qAllWidgets, "category", [] );
		queryAddColumn( qAllWidgets, "icon", [] );
		queryAddColumn( qAllWidgets, "debug", [] );
		queryAddColumn( qAllWidgets, "invocationPath", [] );

		processWidgets( qAllWidgets, "Core" )
			.processWidgets( qAllWidgets, "Custom" )
			.processModuleWidgets( qAllWidgets )
			.processThemeWidgets( qAllWidgets );

		// Cache it
		variables.loadedWidgets = qAllWidgets;

		return qAllWidgets;
	}

	/**
	 * Discover the custom location widgets
	 *
	 * @qRecords The records query to attach yourself to
	 * @type     The type to process
	 */
	WidgetService function processWidgets( query qRecords = getLoadedWidgets(), type ){
		// get core widgets to start with.
		var qWidgets = getWidgetsFromPath(
			( arguments.type == "Core" ? variables.coreWidgetsPath : variables.customWidgetsPath )
		);

		// Iterate and incorporate exta metadata to record
		for ( var x = 1; x lte qWidgets.recordCount; x++ ) {
			var widgetName = ripExtension( qWidgets.name[ x ] );
			// Add new row with data
			queryAddRow( arguments.qRecords );
			querySetCell( arguments.qRecords, "name", widgetName );
			querySetCell(
				arguments.qRecords,
				"directory",
				qWidgets.directory[ x ]
			);
			querySetCell(
				arguments.qRecords,
				"filename",
				qWidgets.name[ x ]
			);
			querySetCell(
				arguments.qRecords,
				"widgettype",
				arguments.type
			);

			if ( arguments.type == "Core" ) {
				var invocationPath = "contentbox.wigets.#widgetName#";
				querySetCell(
					arguments.qRecords,
					"invocationPath",
					invocationPath
				);
			} else {
				var invocationPath = "contentbox-custom._wigets.#widgetName#";
				querySetCell(
					arguments.qRecords,
					"invocationPath",
					invocationPath
				);
			}

			// Store Map
			variables[ arguments.type & "widgetsMap" ][ widgetName ] = invocationPath;

			try {
				var oWidget = getWidget( widgetName, arguments.type );
				querySetCell(
					arguments.qRecords,
					"category",
					getWidgetCategory( oWidget, arguments.type )
				);
				querySetCell(
					arguments.qRecords,
					"icon",
					getWidgetIcon( oWidget, arguments.type )
				);
			} catch ( any e ) {
				log.error( "Error creating #arguments.type# widget: #widgetName#", e );
				querySetCell(
					arguments.qRecords,
					"debug",
					"Error creating #arguments.type# widget #e.message# #e.detail#. Logged error and stacktrace too."
				);
			}
		}

		return this;
	}

	/**
	 * Discover modules widgets and attach records to incoming widget records
	 *
	 * @qRecords The records query to attach yourself to
	 */
	WidgetService function processModuleWidgets( query qRecords = getLoadedWidgets() ){
		// get module widgets
		var moduleWidgets = moduleService.getModuleWidgetCache();
		// add module widgets
		for ( var widget in moduleWidgets ) {
			var thisRecord = moduleWidgets[ widget ];
			var widgetName = listGetAt( widget, 1, "@" );
			var moduleName = listGetAt( widget, 2, "@" );

			// Add new row with data
			queryAddRow( arguments.qRecords );
			querySetCell( arguments.qRecords, "name", widgetName );
			querySetCell( arguments.qRecords, "filename", widgetName );
			querySetCell( arguments.qRecords, "widgettype", "Module" );
			querySetCell( arguments.qRecords, "module", moduleName );
			querySetCell(
				arguments.qRecords,
				"directory",
				getDirectoryFromPath( thisRecord.path )
			);
			querySetCell(
				arguments.qRecords,
				"invocationPath",
				thisRecord.invocationPath
			);

			try {
				var oWidget = getWidget( widgetName, arguments.type );
				querySetCell(
					arguments.qRecords,
					"category",
					getWidgetCategory( name = oWidget, type = "module" )
				);
				querySetCell(
					arguments.qRecords,
					"icon",
					getWidgetIcon( name = oWidget, type = "module" )
				);
			} catch ( any e ) {
				log.error( "Error creating module (#moduleName#) widget: #widgetName#", e );
				querySetCell(
					arguments.qRecords,
					"debug",
					"Error creating module widget #e.message# #e.detail#. Logged error and stacktrace too."
				);
			}
		}

		return this;
	}

	/**
	 * Discover active theme widgets and attach records to incoming widget records
	 *
	 * @qRecords The records query to attach yourself to
	 */
	WidgetService function processThemeWidgets( query qRecords = getLoadedWidgets() ){
		// get theme widgets
		var themeWidgets = themeService.getWidgetCache();

		// add theme widgets
		for ( var widget in themeWidgets ) {
			var thisRecord = themeWidgets[ widget ];

			queryAddRow( qRecords );
			querySetCell( qRecords, "name", widget );
			querySetCell( qRecords, "filename", widget );
			querySetCell( qRecords, "widgettype", "Theme" );
			querySetCell(
				qRecords,
				"invocationPath",
				thisRecord.invocationPath
			);
			querySetCell(
				qRecords,
				"directory",
				getDirectoryFromPath( thisRecord.path )
			);

			try {
				var oWidget = getWidget( widget, "theme" );
				querySetCell(
					qRecords,
					"category",
					getWidgetCategory( name = oWidget, type = "theme" )
				);
				querySetCell(
					qRecords,
					"icon",
					getWidgetIcon( name = oWidget, type = "theme" )
				);
			} catch ( any e ) {
				log.error( "Error creating theme (#thisRecord.theme#) widget: #widget#", e );
				querySetCell(
					qRecords,
					"debug",
					"Error creating theme widget #e.message# #e.detail#. Logged error and stacktrace too."
				);
			}
		}

		return this;
	}

	/**
	 * Discover the type of widget, either custom or core.
	 * The lookup order is: custom, theme, core
	 *
	 * @name The name of the widget
	 */
	string function discoverWidgetType( required name ){
		var isCustom = false;
		var isTheme  = false;
		var qWidgets = getWidgets();

		for ( var thisRow in qWidgets ) {
			if ( thisrow.name == arguments.name && thisRow.widgetType == "Custom" ) {
				isCustom = true;
			}
			if ( thisrow.name == arguments.name && thisRow.widgetType == "Theme" ) {
				isTheme = true;
			}
		}

		if ( isCustom ) {
			return "Custom";
		}

		if ( isTheme ) {
			return "Theme";
		}

		return "core";
	}

	/**
	 * Get a widget instance by name convention discovery
	 * - ~name = Layout
	 * - name@module = Module
	 * - name = Custom or Core
	 *
	 * @name The convention name
	 */
	any function getWidgetByDiscovery( required name ){
		var isModuleWidget = findNoCase( "@", arguments.name ) ? true : false;
		var isThemeWidget  = findNoCase( "~", arguments.name ) ? true : false;

		if ( isModuleWidget ) {
			return getWidget( arguments.name, "module" );
		}

		if ( isThemeWidget ) {
			return getWidget( arguments.name, "theme" );
		}

		// Return custom or core Widget instance
		return getWidget( arguments.name, discoverWidgetType( arguments.name ) );
	}

	/**
	 * Get a widget by name and type (defaults to `core|custom`)
	 *
	 * @name The name of the widget
	 * @type This can be one of the following: core, custom, theme, module
	 *
	 * @throws WidgetNotFoundException
	 */
	any function getWidget( required name, required string type = "core" ){
		var widgetPath = "";

		switch ( arguments.type ) {
			case "theme":
				widgetPath = themeService.getThemeWidgetInvocationPath( arguments.name );
				break;
			case "module":
				widgetPath = moduleService.getModuleWidgetInvocationPath( arguments.name );
				break;
			case "core":
				widgetPath = "contentbox.widgets." & arguments.name;
				break;
			case "custom":
				widgetPath = "contentbox-custom._widgets." & arguments.name;
				break;
		}

		if ( len( widgetPath ) ) {
			// Init Arguments added for backwards compat
			return wirebox.getInstance( name = widgetPath, initArguments = { "controller" : variables.coldbox } );
		} else {
			throw(
				message = "The widget (#arguments.name#) could not be located anywhere.",
				type    = "WidgetNotFoundException"
			);
		}
	}

	/**
	 * Get a widget icon representation
	 *
	 * @name The name of the widget or the widget instance
	 * @type This can be one of the following: core, theme, module
	 */
	string function getWidgetIcon( required name, required string type = "core" ){
		if ( isSimpleValue( arguments.name ) ) {
			var widget = getWidget( argumentCollection = arguments );
		} else {
			var widget = arguments.name;
		}
		var icon = widget.getIcon();
		if ( isNull( icon ) || icon == "" ) {
			switch ( type ) {
				case "theme":
					icon = "th-large";
					break;
				case "module":
					icon = "archive";
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
	 *
	 * @name The name of the widget or the actual widget object
	 * @type This can be one of the following: core, theme, module
	 */
	string function getWidgetCategory( required name, required string type = "core" ){
		if ( isSimpleValue( arguments.name ) ) {
			var widget = getWidget( argumentCollection = arguments );
		} else {
			widget = arguments.name;
		}
		var category = widget.getCategory();
		if ( isNull( category ) || category == "" ) {
			switch ( type ) {
				case "theme":
					category = "Theme";
					break;
				case "module":
					category = "Module";
					break;
				default:
					category = "Miscellaneous";
					break;
			}
		}
		return category;
	}

	/**
	 * Remove a widget from the custom locations
	 *
	 * @widgetFile The location of the widget to remove
	 */
	boolean function removeWidget( required widgetFile ){
		var wCustomPath = variables.customWidgetsPath & "/" & arguments.widgetFile & ".cfc";

		if ( fileExists( wCustomPath ) ) {
			fileDelete( wCustomPath );
			return true;
		}

		// Process widgets
		getWidgets( reload = true );

		return false;
	}

	/**
	 * Rip Extensions from file name
	 *
	 * @fileName The target to rip
	 */
	function ripExtension( required filename ){
		return reReplace( arguments.filename, "\.[^.]*$", "" );
	}

	/**
	 * Get widget rendering arguments
	 *
	 * @udf    The target UDF to render out arguments for
	 * @widget The widget name
	 * @type   The widget type
	 *
	 * @return The argument metadata structure
	 */
	function getWidgetRenderArgs( required udf, required widget, required type ){
		// get widget
		var p = getWidget( name = arguments.widget, type = arguments.type );
		return getMetadata( p[ udf ] );
	}

	/**
	 * Get a query listing of widgets in a path
	 *
	 * @path The path to check
	 */
	private query function getWidgetsFromPath( required path ){
		return directoryList(
			arguments.path,
			false,
			"query",
			"*.cfc",
			"name asc"
		);
	}

}
