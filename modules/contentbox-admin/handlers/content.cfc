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
		event.paramValue("title","");
		event.paramValue("slug","");
		
		// get the rendered content
		//prc.previewContent = contentService.new().renderContentSilent( rc.content );
		prc.previewContent = rc.content;
		// iframe src
		prc.xehPreview = CBHelper.linkPage("__page_preview");
		// author security hash
		prc.h = hash( prc.oAuthor.getAuthorID() );
		// view
		event.setView(view="content/preview",layout="ajax");
	}

}
