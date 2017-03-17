/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage Generic content actions
*/
component extends="baseHandler"{

	// Dependencies
	property name="contentService"		inject="id:contentService@cb";
	property name="statsService"		inject="id:statsService@cb";
	property name="contentStoreService"	inject="id:contentStoreService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";

	/**
	* Quick Content Preview from editors
	* @return html
	*/
	function preview( event, rc, prc ){
		// param incoming data
		event.paramValue( "layout","pages" )
			.paramValue( "content","" )
			.paramValue( "contentType","" )
			.paramValue( "title","" )
			.paramValue( "slug","" )
			.paramValue( "markup","HTML" )
			.paramValue( "parentPage", "" );
		
		// Determine Type
		switch( rc.contentType ){
			case "Page" 	: { 
				prc.xehPreview = CBHelper.linkPage( "__page_preview" ); 
				break; 
			}
			case "Entry" : { 
				prc.xehPreview = CBHelper.linkPage( "__entry_preview" ); 
				rc.layout = "blog";
				break; 
			}
			case "ContentStore" : { 
				var oContent = contentStoreService.new();
				prc.preview  = oContent.renderContentSilent( rc.content );
				event.setView( view="content/simplePreview", layout="ajax" );
				return;
			}
		}
		// author security hash
		prc.h = hash( prc.oAuthor.getAuthorID() );
		// full preview view
		event.setView( view="content/preview", layout="ajax" );
	}
	
	/**
	* Global Content Search
	* @return html
	*/
	function search( event, rc, prc ){
		// Params
		event.paramValue( "search", "" );
		// Search for content
		prc.results = contentService.searchContent( 
			searchTerm			= rc.search, 
			max					= prc.cbSettings.cb_admin_quicksearch_max, 
			sortOrder			= "title", 
			isPublished			= "all",
			searchActiveContent	= false 
		);
		prc.minContentCount = ( prc.results.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.results.count : prc.cbSettings.cb_admin_quicksearch_max );
		
		// Search for Authors
		prc.authors = authorService.search(searchTerm=rc.search, max=prc.cbSettings.cb_admin_quicksearch_max);
		prc.minAuthorCount = ( prc.authors.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.authors.count : prc.cbSettings.cb_admin_quicksearch_max );
		// cb helper on scope
		prc.cb = variables.CBHelper;
		// announce event
		announceInterception( "onGlobalSearchRequest" );
		// renderdata
		event.renderdata( data = renderView( "content/search" ) );
	}

	/**
	* Check if a slug is unique
	* @return json
	*/
	function slugUnique( event, rc, prc ){
		// Params
		event.paramValue( "slug", "" )
			.paramValue( "contentID", "" );

		var data = {
			"UNIQUE" = false
		};
		
		if( len( rc.slug ) ){
			data[ "UNIQUE" ] = contentService.isSlugUnique( trim( rc.slug ), trim( rc.contentID ) );
		}
		
		event.renderData( data=data, type="json" );
	}

	/**
	* Render the content selector from editors
	* @return html
	*/
	function relatedContentSelector( event, rc, prc ){
		// paging default
		event.paramValue( "page", 1 )
			.paramValue( "search", "" )
			.paramValue( "clear", false )
			.paramValue( "excludeIDs", "" )
			.paramValue( "contentType", "" );

		// exit handlers
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";

		// prepare paging object
		prc.oPaging 	= getModel( "Paging@cb" );
		prc.paging 	  	= prc.oPaging.getBoundaries();
		prc.pagingLink 	= "javascript:pagerLink( @page@, '#rc.contentType#' )";

		// search entries with filters and all
		var contentResults = contentService.searchContent( 
			searchTerm			= rc.search,
			offset				= prc.paging.startRow-1,
			max					= prc.cbSettings.cb_paging_maxrows,
			sortOrder			= "slug asc",
			searchActiveContent	= false,
			contentTypes		= rc.contentType,
			excludeIDs			= rc.excludeIDs 
		);
		// setup data for display
		prc.content 		= contentResults.content;
		prc.contentCount  	= contentResults.count;
		prc.CBHelper 		= CBHelper;

		// if ajax and searching, just return tables
		return renderView( view="content/relatedContentResults", module="contentbox-admin" );
	}

	/**
	* Show the related content panel
	* @return html
	*/
	function showRelatedContentSelector( event, rc, prc ) {
		event.paramValue( "search", "" )
			.paramValue( "clear", false )
			.paramValue( "excludeIDs", "" )
			.paramValue( "contentType", "Page,Entry,ContentStore" );
		// exit handlers
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.CBHelper = CBHelper;
		event.setView( view="content/relatedContentSelector", layout="ajax" );
	}

	/**
	* Break related content links
	* @return json
	*/
	function breakContentLink( event, rc, prc ) {
		event.paramValue( "contentID", "" )
			.paramValue( "linkedID", "" );
		var data = {};
		if( len( rc.contentID ) && len( rc.linkedID ) ) {
			var currentContent = ContentService.get( rc.contentID );
			var linkedContent = ContentService.get( rc.linkedID );
			linkedContent.removeRelatedContent( currentContent );
			contentService.save( linkedContent );
			data[ "SUCCESS" ] = true;
		}
		event.renderData( data=data, type="json" );
	}

	/**
	* Reset Content Hits on one or more content items
	* @return json
	*/
	any function resetHits( event, rc, prc ){
		event.paramValue( "contentID", 0 );
		var response = { 
			"data" 			= { "data" = "", "error" = false, "messages" = [] },
			"statusCode" 	= "200", 
			"statusText" 	= "Ok" 
		};
		// build to array and iterate
		rc.contentID = listToArray( rc.contentID );
		for( var thisID in rc.contentID ){
			var oContent = contentService.get( thisID );
			// check if loaded
			if( !isNull( oContent ) and oContent.isLoaded() ){
				// Only update if it has stats
				if( oContent.hasStats() ){
					oContent.getStats().setHits( 0 );
					contentService.save( oContent );
				}
				arrayAppend( response.data.messages, "Hits reset for '#oContent.getTitle()#'" );
			} else {
				response.data.error = true;
				response.statusCode	= 400;
				arrayAppend( response.data.messages, "The contentID '#thisContentID#' requested does not exist" );

			}
		}
		// Render it out
		event.renderData( 
			data		= response.data, 
			type		= "json", 
			statusCode	= response.statusCode, 
			statusText	= ( arrayLen( response.data.messages ) ? 'Error processing request please look at data messages' : 'Ok' ) 
		);
	}

	/**
	* This viewlet shows latest content edits via arguments
	* @author 				The optional author to look for latest edits only
	* @author.generic 		contentbox.models.security.Author
	* @isPublished 			Boolean indicator if you need to search on all published states, only published, or only draft
	* @max 					The maximum number of records, capped at 25 by default
	* @showHits 			Show hit count on content item, defaults to true
	* @colorCodings 		Show content row color codings
	* @showPublishedStatus 	Show published status columns
	* @showAuthor 			Show the author in the table
	* 
	* @return html
	*/
	function latestContentEdits( 
		event, 
		rc, 
		prc,
		any author,
		boolean isPublished,
		numeric max=25,
		boolean showHits=true,
		boolean colorCodings=true,
		boolean showPublishedStatus=true,
		boolean showAuthor=true
	){
		// Setup args so we can use them in the viewlet
		var args = { max = arguments.max };
		if( structKeyExists( arguments, "author" ) ){ args.author = arguments.author; }
		if( structKeyExists( arguments, "isPublished" ) ){ args.isPublished = arguments.isPublished; }
		
		// Get latest content edits with criteria
		var aLatestEdits = contentService.getLatestEdits( argumentCollection = args );

		// view pager
		return renderView( 
			view 	= "content/contentViewlet", 
			module 	= "contentbox-admin",
			args 	= {
				viewletID 			= createUUID(),
				aContent 			= aLatestEdits,
				showHits 			= arguments.showHits,
				colorCodings 		= arguments.colorCodings,
				showPublishedStatus = arguments.showPublishedStatus,
				showAuthor 			= arguments.showAuthor
			}
		);
	}

	/**
	* This viewlet shows future or expired content using filters. By default it shows future published content
	* @author 				The optional author to look for latest edits only
	* @author.generic 		contentbox.models.security.Author
	* @showExpired 			Show expired content, defaults to false (future published content)
	* @offset 				The offset when doing pagination
	* @max 					The maximum number of records, capped at 25 by default
	* @showHits 			Show hit count on content item, defaults to true
	* @colorCodings 		Show content row color codings
	* @showPublishedStatus 	Show published status columns
	* @showAuthor 			Show the author in the table
	* 
	* @return html
	*/
	function contentByPublishedStatus( 
		event, 
		rc, 
		prc,
		boolean showExpired=false,
		any author,
		boolean offset=0,
		numeric max=25,
		boolean showHits=true,
		boolean colorCodings=true,
		boolean showPublishedStatus=true,
		boolean showAuthor=true
	){
		// Setup args so we can use them in the viewlet
		var args = { max = arguments.max, offset = arguments.offset };
		if( structKeyExists( arguments, "author" ) ){ args.author = arguments.author; }
		
		// Expired Content		
		var aContent = "";
		if( arguments.showExpired ){
			aContent = contentService.findExpiredContent( argumentCollection = args );
		} 
		// Future Published Content
		else {
			aContent = contentService.findFuturePublishedContent( argumentCollection = args );
		}

		// view pager
		return renderView( 
			view 	= "content/contentViewlet", 
			module 	= "contentbox-admin",
			args 	= { 
				viewletID 			= createUUID(),
				aContent 			= aContent,
				showHits 			= arguments.showHits,
				colorCodings		= arguments.colorCodings,
				showPublishedStatus = arguments.showPublishedStatus,
				showAuthor 			= arguments.showAuthor
			}
		);
	}

}
