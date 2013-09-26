/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
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
* Handles RSS Feeds
*/
component singleton{

	// DI
	property name="mediaService" 	inject="mediaService@cb";
	property name="settingService"  inject="id:settingService@cb";

	/**
	* Deliver Media
	*/
	function index(event,rc,prc){
		// Param cache purge
		event.paramValue( "cbcache", "false");
		if( !isBoolean( rc.cbcache ) ){ rc.cbcache = false; }
		
		// Get the requested media path
		var replacePath = ( len( prc.cbEntryPoint ) ? "#prc.cbEntryPoint#/" : "" ) & event.getCurrentRoute();
		prc.mediaPath = trim( replacenocase( event.getCurrentRoutedURL(), replacePath, "" ) );
		prc.mediaPath = reReplace( prc.mediaPath, "\/$", "" );
		
		// Determine if ColdBox is doing a format extension detection?
		if( structKeyExists( rc, "format" ) && len( rc.format ) ){ prc.mediaPath &= ".#rc.format#"; }

		// Get the media provider
		var mediaProvider = mediaService.getDefaultProvider();
		// Check if media path detected
		if( !len( prc.mediaPath ) OR !mediaProvider.mediaExists( prc.mediaPath ) ){
			// return invalid media
			return invalidMedia(event,rc,prc);
		}
		
		// Announce media delivery
		var iData = { mediaPath = prc.mediaPath, mediaProvider = mediaProvider };
		announceInterception( "cbui_onMediaRequest", iData );
		
		// Media Caching Headers
		if( !rc.cbcache and settingService.getSetting( "cb_media_provider_caching" ) ){
			// Set expiration for one year in advanced
			event.setHTTPHeader( name="expires", value="#GetHttpTimeString( dateAdd( "yyyy", 1, now() ) )#" )
				.setHTTPHeader( name="pragma", value="cache")
				.setHTTPHeader( name="cache-control", value="public, max-age=2592000" );
		}
		else{
			event.setHTTPHeader( name="expires", value="#GetHttpTimeString( now() )#" )
				.setHTTPHeader( name="pragma", value="no-cache")
				.setHTTPHeader( name="cache-control", value="no-cache, no-store, must-revalidate" );
		}
				
		// Deliver it baby!
		mediaProvider.deliverMedia( prc.mediaPath );
	}
	
	/**
	* Deliver Captcha
	*/
	function captcha(event,rc,prc){
		var data = getMyPlugin(plugin="Captcha",module="contentbox").display();
		var imgURL = arrayToList( reMatchNoCase( 'src="([^"]*)"', data ) );
		imgURL = replace( replace( imgURL, "src=", "" ) , '"', "", "all");
		// deliver image
		getPageContext().forward( imgURL );
	}
	
	/************************************** PRIVATE *********************************************/

	// Invalid Media
	private function invalidMedia(event,rc,prc){
		// Announce invalid media
		var iData = { mediaPath = prc.mediaPath };
		announceInterception( "cbui_onInvalidMediaRequest", iData );
		// Render invalid media
		event.renderData(data="<h1>404: Requested path not found</h1>", statusCode="404", statusText="Requested Path Not Found");
	}

}