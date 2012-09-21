/**
* Manage content
*/
component extends="baseHandler"{

	// Dependencies
	property name="contentService"		inject="id:contentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";

	// content preview
	function preview(event,rc,prc){
		// param incoming data
		event.paramValue("layout","pages");
		event.paramValue("content","");
		event.paramValue("contentType","");
		event.paramValue("title","");
		event.paramValue("slug","");
		
		// Determine Type
		switch( rc.contentType ){
			case "Page" 	: { 
				prc.xehPreview = CBHelper.linkPage("__page_preview"); 
				break; 
			}
			case "Entry" : { 
				prc.xehPreview = CBHelper.linkPage("__entry_preview"); 
				rc.layout = "blog";
				break; 
			}
			case "CustomHTML" : {
				prc.preview = contentService.new().renderContentSilent( rc.content );
				event.setView(view="content/simplePreview",layout="ajax");
				return;
			}
		}
		
		// author security hash
		prc.h = hash( prc.oAuthor.getAuthorID() );
		// full preview view
		event.setView(view="content/preview",layout="ajax");
	}

}
