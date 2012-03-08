/**
* Manage widgets
*/
component extends="baseHandler"{

	// Dependencies
	property name="widgetService"	inject="id:widgetService@cb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabLookAndFeel = true;
		prc.tabLookAndFeel_widgets = true;
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehWidgetRemove	= "#prc.cbAdminEntryPoint#.widgets.remove";
		prc.xehWidgetUpload = "#prc.cbAdminEntryPoint#.widgets.upload";
		prc.xehWidgetDocs   = "#prc.cbAdminEntryPoint#.widgets.docs";
		prc.xehWidgetEditor = "#prc.cbAdminEntryPoint#.widgets.edit";
		prc.xehWidgetCreate = "#prc.cbAdminEntryPoint#.widgets.create";
		prc.xehForgeBox		= "#prc.cbAdminEntryPoint#.forgebox.index";
		
		// Get all widgets
		prc.widgets = widgetService.getWidgets();
		
		// ForgeBox Entry URL
		prc.forgeBoxEntryURL = getModuleSettings("contentbox-admin").settings.forgeBoxEntryURL;
		// ForgeBox Stuff
		prc.forgeBoxSlug = "contentbox-widgets";
		prc.forgeBoxInstallDir = URLEncodedFormat( widgetService.getWidgetsPath() );
		prc.forgeboxReturnURL = URLEncodedFormat( event.buildLink(prc.xehWidgets) );
		
		// view
		event.setView("widgets/index");
	}
	
	//docs
	function docs(event,rc,prc){
		prc.widgetName = widgetService.ripExtension( urlDecode(rc.widget) );
		// get widget plugin
		prc.oWidget  = getMyPlugin(plugin="widgets.#prc.widgetName#",module="contentbox-ui");
		// get its metadata
		prc.metadata = getmetadata(prc.oWidget.renderit);
		// presetn view
		event.setView(view="widgets/docs",layout="ajax");
	}
	
	//Remove
	function remove(event,rc,prc){
		widgetService.removeWidget( rc.widgetFile );
		getPlugin("MessageBox").info("Widget Removed Forever!");
		setNextEvent(prc.xehWidgets);
	}

	//upload
	function upload(event,rc,prc){
		var fp = event.getTrimValue("filePlugin","");
		
		// Verify
		if( len( fp ) eq 0){
			getPlugin("MessageBox").setMessage(type="warning", message="Please choose a file to upload");
		}
		else{
			// Upload File
			try{
				widgetService.uploadWidget("filePlugin");
				// Info
				getPlugin("MessageBox").setMessage(type="info", message="Widget Installed Successfully");
			}
			catch(Any e){
				getPlugin("MessageBox").error("Error uploading file: #e.detail# #e.message#");
			}
		}
		
		setNextEvent(prc.xehWidgets);		
	}
	
	// Editor Selector
	function editorSelector(event,rc,prc){
		// Get all widgets
		prc.widgets = widgetService.getWidgets();
		
		event.setView(view="widgets/editorSelector",layout="ajax");
	}
	
	// Create New Widget wizard
	function create(event,rc,prc){
		prc.xehWidgetSave = "#prc.cbAdminEntryPoint#.widgets.doCreate";
		prc.widgetsPath = widgetService.getWidgetsPath();
		event.setView(view="widgets/create",layout="ajax");
	}
	// Create the new widget
	function doCreate(event,rc,prc){
		// slugify name
		rc.name = getPlugin("HTMLHelper").slugify( rc.name );
		// get and populate widget
		var oWidget = populateModel("Widget@cb");
		var errors = oWidget.validate();
		if( !arrayLen(errors) ){
			// save the new widget
			widgetService.createNewWidget( oWidget );
			getPlugin("MessageBox").info("Widget Created! Now Code It!");
			setNextEvent(event="#prc.cbAdminEntryPoint#.widgets.edit",queryString="widget=#oWidget.getName()#");
		}
		else{
			getPlugin("MessageBox").error(messageArray=errors);
			setNextEvent(prc.xehWidgets);
		}
	}
	
	// Editor
	function edit(event,rc,prc){
		// Exit handlers
		prc.xehWidgetSave = "#prc.cbAdminEntryPoint#.widgets.save";
		// Get Widget Code
		prc.widgetCode = widgetService.getWidgetCode( rc.widget );
		// view		
		event.setView("widgets/edit");
	}
	
	// Save Widget Code
	function save(event,rc,prc){
		// Save the widget code
		widgetService.saveWidgetCode( rc.widget, rc.widgetCode );
		// stay or relocate?
		if( event.isAjax() ){
			event.renderData(data=true,type="json");
		}
		else{
			getPlugin("MessageBox").info("Widget Code Saved!");
			setNextEvent(prc.xehWidgets);
		}
	}
}
