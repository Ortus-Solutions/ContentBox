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
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="settingService" inject="settingService@contentbox";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Constructor
	 */
	function init(){
		super.init( entityname = "cbStats", queryCaching = true );
		return this;
	}


	/**
	 * Determine if we have a bot
	 */
	function isUserAgentABot(){
		var userAgent = lCase( CGI.http_user_agent );
		var aBotRegex = listToArray( settingService.getSetting( "cb_content_bot_regex" ), chr( 13 ) );
		// iterate and try to match
		for ( var thisBot in aBotRegex ) {
			if ( arrayLen( reMatch( thisBot, userAgent ) ) gt 0 ) {
				return true;
			}
		}

		return false;
	}

	/**
	 * Get the total content counts
	 *
	 * @contentId The site to filter on
	 */
	numeric function getTotalHitsByContent( string contentId = "" ){
		var oStat = newCriteria()
			.isEq( "relatedContent.contentID", arguments.contentId )
			.withProjections( property: "hits" )
			.get();
		return ( isNull( oStat ) ? 0 : oStat );
	}

	/**
	 * Update the hits for a content object
	 *
	 * @content. The content object to update the hits on
	 */
	StatsService function syncUpdateHits( required content ){
		// are we tracking hit counts?
		if ( variables.settingService.getSetting( "cb_content_hit_count" ) ) {
			try {
				// try to match a bot? or ignored bots?
				if ( variables.settingService.getSetting( "cb_content_hit_ignore_bots" ) OR !isUserAgentABot() ) {
					var q = new Query(
						sql = "UPDATE cb_stats
							SET hits = hits + 1,
							modifiedDate = #createODBCDateTime( now() )#
							WHERE FK_contentID = '#arguments.content.getContentId()#'"
					).execute();
					// if no record, means, new record, so insert
					if ( q.getPrefix().RECORDCOUNT eq 0 ) {
						save( this.new( { hits : 1, relatedContent : arguments.content } ) );
					}
				}
			} catch ( any e ) {
				log.error(
					"Error hit tracking contentID: #arguments.content.getContentId()#. #e.message# #e.detail#",
					e
				);
				writeDump( var = e );
				abort;
			}
		}

		return this;
	}

}
