/**
* Manage content
*/
component extends="baseHandler"{

	// Dependencies
	property name="contentService"		inject="id:contentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";

	// content preview
	function preview(event,rc,prc){
		event.paramValue("content","");
		
		// get new content object
		prc.preview = contentService.new().renderContentSilent( rc.content );
		
		event.setView(view="content/preview",layout="ajax");
	}

}
