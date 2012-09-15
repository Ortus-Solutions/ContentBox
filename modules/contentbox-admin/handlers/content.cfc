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
		event.paramValue("contentType","page");
		event.paramValue("title","");
		event.paramValue("slug","");
		
		// Determine Type
		switch( rc.contentType ){
			case "page" : { prc.xehPreview = CBHelper.linkPage("__page_preview"); break; }
			case "entry" : { prc.xehPreview = CBHelper.linkPage("__entry_preview"); break; }
		}
		// author security hash
		prc.h = hash( prc.oAuthor.getAuthorID() );
		// view
		event.setView(view="content/preview",layout="ajax");
	}

}
