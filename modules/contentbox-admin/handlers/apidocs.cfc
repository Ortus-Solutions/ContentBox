/**
* Render out cool API Docs
*/
component extends="baseHandler"{

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabTools = true;
	}
	
	// index
	function index(event,rc,prc){
		// setup tab
		prc.tabTools_apidocs = true;
		event.paramValue("_cfcviewer_package","");
		event.paramValue("apislug","model");
		
		// print existence check
		if( structKeyExists(rc,"print") and !len(trim(rc.print)) ){
			rc.print = true;
		}
		event.paramValue("print",false);
		
		
		var dirPath = "";
		
		switch(rc.apislug){
			case "plugins" : {
				dirPath = "/contentbox/plugins";
				break;
			}
			case "widgets" : {
				dirPath = "/contentbox-ui/plugins/widgets";
				break;
			}
			default: {
				dirPath = "/contentbox/model";
				break;
			}
		}
		
		// self link
		prc.selfLink = event.buildLink(prc.xehApiDocs)&"/index/apislug/#rc.apislug#?";
		if(rc.print){
			prc.selfLink &="print=true&";
		}
		// Document the entire API for contentbox
		prc.cfcViewer = getMyPlugin(plugin="CFCViewer",module="contentbox-admin")
			.setup(dirpath=dirPath,
				   dirLink=prc.selfLink,
				   linkBaseURL=prc.selfLink&"_cfcviewer_package=#rc._cfcviewer_package#");
		
		// view or print
		if( rc.print ){
			event.renderData(data=prc.cfcViewer.renderIt(),type="html");
		}
		else{
			event.setView(view="apidocs/index");
		}
	}	
	
}
