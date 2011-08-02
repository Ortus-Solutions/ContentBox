/**
* Manage widgets
*/
component extends="baseHandler"{

	// Dependencies
	property name="widgetService"	inject="id:widgetService@bb";
	
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
		rc.xehWidgetRemove 	= "#prc.bbEntryPoint#.widgets.remove";
		rc.xehWidgetUpload  = "#prc.bbEntryPoint#.widgets.upload";
		rc.xehWidgetDocs    = "#prc.bbEntryPoint#.widgets.docs";
		
		// Get all widgets
		rc.widgets = widgetService.getWidgets();
		
		// Tab
		prc.tabSite_widgets = true;
		// view
		event.setView("widgets/index");
	}
	
	//docs
	function docs(event,rc,prc){
		rc.widgetName = widgetService.ripExtension( urlDecode(rc.widget) );
		// get widget plugin
		rc.oWidget  = getMyPlugin(plugin="widgets.#rc.widgetName#",module="blogbox-ui");
		// get its metadata
		rc.metadata = getmetadata(rc.oWidget.renderit);
		// presetn view
		event.setView(view="widgets/docs",layout="ajax");
	}
	
	//Remove
	function remove(event,rc,prc){
		widgetService.removeWidget( rc.widgetFile );
		getPlugin("MessageBox").info("Widget Removed Forever!");
		setNextEvent(rc.xehWidgets);
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
				widgetService.uploadPlugin("filePlugin");
				// Info
				getPlugin("MessageBox").setMessage(type="info", message="Widget Installed Successfully");
			}
			catch(Any e){
				getPlugin("MessageBox").error("Error uploading file: #e.detail# #e.message#");
			}
		}
		
		setNextEvent(rc.xehWidgets);		
	}
}
