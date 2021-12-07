/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage widgets
 */
component extends="baseHandler" {

	// Dependencies
	property name="widgetService" inject="widgetService@contentbox";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabLookAndFeel         = true;
		prc.tabLookAndFeel_widgets = true;
	}

	// index
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehWidgetRemove = "#prc.cbAdminEntryPoint#.widgets.remove";
		prc.xehWidgetUpload = "#prc.cbAdminEntryPoint#.widgets.upload";
		prc.xehWidgetDocs   = "#prc.cbAdminEntryPoint#.widgets.docs";
		prc.xehWidgetEditor = "#prc.cbAdminEntryPoint#.widgets.edit";
		prc.xehWidgetCreate = "#prc.cbAdminEntryPoint#.widgets.create";
		prc.xehWidgetTest   = "#prc.cbAdminEntryPoint#.widgets.viewWidgetInstance";

		// Get all widgets
		prc.widgets       = widgetService.getWidgets();
		prc.categories    = widgetService.getWidgetCategories();
		prc.widgetService = widgetService;

		// view
		event.setView( "widgets/index" );
	}

	// docs
	function docs( event, rc, prc ){
		prc.widgetName = widgetService.ripExtension( urlDecode( rc.widget ) );
		prc.widgetType = urlDecode( rc.type );
		prc.icon       = widgetService.getWidgetIcon( rc.widget, rc.type );
		// get widget
		prc.oWidget    = widgetService.getWidget( prc.widgetName, prc.widgetType );
		// get its metadata
		prc.metadata   = prc.oWidget.getPublicMethods();
		// presetn view
		event.setView( view = "widgets/docs", layout = "ajax" );
	}

	// Remove
	function remove( event, rc, prc ){
		widgetService.removeWidget( rc.widgetFile );
		cbMessagebox.info( "Widget Removed Forever!" );
		relocate( prc.xehWidgets );
	}



	// Editor Selector
	function editorSelector( event, rc, prc ){
		// Get all widgets, categories and setup the service on context
		prc.widgets       = widgetService.getWidgets();
		prc.categories    = widgetService.getWidgetCategories();
		prc.widgetService = widgetService;
		// render it out
		event.setView( view = "widgets/editorSelector", layout = "ajax" );
	}

	// Preview Widget
	function preview( event, rc, prc ){
		// get widget
		var widget = WidgetService.getWidget( name = rc.widgetname, type = rc.widgettype );
		try {
			event.renderData( data = invoke( widget, rc.widgetudf, rc ), type = "html" );
		} catch ( any e ) {
			log.error( "Error rendering widget: #e.message# #e.detail#", e );
			event.renderData( data = "Error rendering widget: #e.message# #e.detail# #e.stacktrace#", type = "html" );
		}
	}

	function viewWidgetInstance( event, rc, prc ){
		// param data
		event
			.paramValue( "modal", false )
			.paramValue( "test", false )
			.paramValue( "widgetudf", "renderIt" );

		// get widget
		var widget = widgetService.getWidget( name = rc.widgetname, type = rc.widgettype );
		prc.md     = widgetService.getWidgetRenderArgs(
			udf    = rc.widgetudf,
			widget = rc.widgetname,
			type   = rc.widgettype
		);
		prc.widget = {
			name       : rc.widgetname,
			widgetType : rc.widgettype,
			widget     : widget,
			udf        : rc.widgetudf,
			module     : find( "@", rc.widgetname ) ? listGetAt( rc.widgetname, 2, "@" ) : "",
			category   : !isNull( widget.getCategory() ) ? widget.getCategory() : rc.widgetType == "Core" ? "Miscellaneous" : rc.widgetType,
			icon       : !isNull( widget.getIcon() ) ? widget.getIcon() : ""
		};
		// get its metadata
		prc.metadata            = widget.getPublicMethods();
		prc.vals                = rc;
		prc.vals[ "widgetUDF" ] = prc.widget.udf;
		if ( event.isAjax() ) {
			event.renderData( data = renderView( view = "widgets/instance", layout = "ajax" ) );
		} else {
			event.setView( view = "widgets/instance", layout = "ajax" );
		}
	}

}
