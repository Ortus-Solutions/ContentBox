/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
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
		if( !reFindNoCase( "^contentbox\-ui\:", event.getCurrentEvent() ) ){
			return ;
		}

		// page or entry content determination
		if( structKeyExists(prc,"page" ) ){ content = prc.page; }
		else if( structKeyExists(prc,"entry" ) ){ content = prc.entry; }
		else{ return; }

		// Verify password protected
		if( !len(content.getpasswordProtection()) ){
			return;
		}

		// Verify Incoming Headers to see if we are authorizing already or we can view the page already
		if( !securityService.isContentViewable( content ) OR len( event.getHTTPHeader( "Authorization","" ) ) ){

			// Verify incoming authorization for content
			if( securityService.authorizeContent(content,event.getHTTPBasicCredentials().password) ){
				// we are secured woot woot!
				return;
			};

			// Not secure!
			event.setHTTPHeader(statusCode="401",value="Unauthorized" );
			event.setHTTPHeader(name="WWW-Authenticate",value="basic realm=""ContentBox content protection, enter the content password""" );

			// secured content data hijack
			event.renderData(data="<h1>Unathorized Access<p>Content Requires Authentication</p>",statusCode="401" );
		}

	}

}
