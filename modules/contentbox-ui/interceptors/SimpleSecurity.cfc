/**
* Intercepts pages and entries that need password security
*/
component {

	property name="securityService" inject="id:securityService@cb";


	void function configure(){

	}

	void function postEvent(event,struct interceptData){
		var rc  	= event.getCollection();
		var prc 	= event.getCollection(private=true);
		var content = "";

		// security only for pages or blog entries
		if( !reFindNoCase("^contentbox\-ui\:", event.getCurrentEvent() ) ){
			return ;
		}

		// page or entry content determination
		if( structKeyExists(prc,"page") ){ content = prc.page; }
		else if( structKeyExists(prc,"entry") ){ content = prc.entry; }
		else{ return; }

		// Verify password protected
		if( !len(content.getpasswordProtection()) ){
			return;
		}

		// Verify Incoming Headers to see if we are authorizing already or we can view the page already
		if( !securityService.isContentViewable( content ) OR len( event.getHTTPHeader("Authorization","") ) ){

			// Verify incoming authorization for content
			if( securityService.authorizeContent(content,event.getHTTPBasicCredentials().password) ){
				// we are secured woot woot!
				return;
			};

			// Not secure!
			event.setHTTPHeader(statusCode="401",value="Unauthorized");
			event.setHTTPHeader(name="WWW-Authenticate",value="basic realm=""ContentBox content protection, enter the content password""");

			// secured content data hijack
			event.renderData(data="<h1>Unathorized Access<p>Content Requires Authentication</p>",statusCode="401");
		}

	}

}
