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
* A generic content service for content objects
*/
component extends="cborm.models.VirtualEntityService" singleton{

	// DI
	property name="settingService" 	inject="settingService@cb";
	property name="log"				inject="logbox:logger:{this}";

	/**
	* Constructor
	*/
	function init(){

		super.init( entityname="cbStats", queryCaching=true );
		return this;
	}


	/**
	* Determine if we have a bot
	*/
	function isUserAgentABot(){
		var userAgent 	= LCase( CGI.http_user_agent );
		var aBotRegex 	= ListToArray( settingService.getSetting( 'cb_content_bot_regex' ), chr(13) );
		// iterate and try to match
		for( var thisBot in aBotRegex ){
			if( arrayLen( reMatch( thisBot, userAgent ) ) gt 0 ){ 
				return true; 
			}
		}

		return false;
	}

	/**
	* Update the content hits
	* @contentID.hint The content id to update
	*/
	StatsService function syncUpdateHits( required contentID ){
		// are we tracking hit counts?
		if( settingService.getSetting( 'cb_content_hit_count' ) ){
			try {
				// try to match a bot? or ignored bots?
				if( settingService.getSetting( 'cb_content_hit_ignore_bots' ) OR !isUserAgentABot() ){
					var q = new Query( 
						sql="UPDATE cb_stats 
							SET hits = hits + 1,
							modifiedDate = #createODBCDateTime( now() )#
							WHERE FK_contentID = #arguments.contentID#" 
					).execute();
					// if no record, means, new record, so insert
					if( q.getPrefix().RECORDCOUNT eq 0 ){
						var q = new Query( 
							sql="INSERT INTO cb_stats ( hits, FK_contentID, createdDate, modifiedDate ) 
								VALUES ( 1, #arguments.contentID#, #createODBCDateTime( now() )#, #createODBCDateTime( now() )# )" 
						).execute();
					}
				}
			} catch (any e) {
				log.error( "Error hit tracking contentID: #arguments.contentID#. #e.message# #e.detail#", e );
			}
		}

		return this;
	}

}