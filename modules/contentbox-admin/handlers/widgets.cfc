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
		prc.tabSite = true;
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		rc.xehWidgetRemove 	= "#prc.cbAdminEntryPoint#.widgets.remove";
		rc.xehWidgetUpload  = "#prc.cbAdminEntryPoint#.widgets.upload";
		rc.xehWidgetDocs    = "#prc.cbAdminEntryPoint#.widgets.docs";
		
		// Get all widgets
		rc.widgets = widgetService.getWidgets();
		
		// ForgeBox Entry URL
		rc.forgeBoxEntryURL = getModuleSettings("contentbox-admin").settings.forgeBoxEntryURL;
		
		// Tab
		prc.tabSite_widgets = true;
		// view
		event.setView("widgets/index");
	}
	
	//docs
	function docs(event,rc,prc){
		rc.widgetName = widgetService.ripExtension( urlDecode(rc.widget) );
		// get widget plugin
		rc.oWidget  = getMyPlugin(plugin="widgets.#rc.widgetName#",module="contentbox-ui");
		// get its metadata
		rc.metadata = getmetadata(rc.oWidget.renderit);
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
}
