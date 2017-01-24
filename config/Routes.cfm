<!--- 
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
 --->
<cfscript>
	// Allow unique URL or combination of URLs, we recommend both enabled
	setUniqueURLS( false );
	// Auto reload configuration, true in dev makes sense to reload the routes on every request
	//setAutoReload(false);
	// Sets automatic route extension detection and places the extension in the rc.format variable
	// setExtensionDetection(true);
	// The valid extensions this interceptor will detect
	setValidExtensions('xml,json,jsont,rss,html,htm,cfm,print,pdf,doc,txt');
	// If enabled, the interceptor will throw a 406 exception that an invalid format was detected or just ignore it
	// setThrowOnInvalidExtension(true);

	// TO ENABLE FULL REWRITES REMOVE THE "INDEX.CFM" FROM THE LINES BELOW

	// Base URL
	if( len(getSetting('AppMapping') ) lte 1){
		setBaseURL("http://#cgi.HTTP_HOST##getContextRoot()#/index.cfm");
	}
	else{
		setBaseURL("http://#cgi.HTTP_HOST##getContextRoot()#/#getSetting('AppMapping')#/index.cfm");
	}
	
	// Your Application Routes
	addRoute(pattern=":handler/:action?");

</cfscript>