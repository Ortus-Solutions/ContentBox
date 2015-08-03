/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage content
*/
component extends="baseHandler"{

	// Dependencies
	property name="contentService"		inject="id:contentService@cb";
	property name="statsService"		inject="id:statsService@cb";
	property name="contentStoreService"	inject="id:contentStoreService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";

	// content preview
	function preview(event,rc,prc){
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
	
	function search(event,rc,prc){
		// Params
		event.paramValue( "search", "" );
		// Search for content
		prc.results = contentService.searchContent( searchTerm=rc.search, 
													max=prc.cbSettings.cb_admin_quicksearch_max, 
													sortOrder="title", 
													isPublished="all",
													searchActiveContent=false );
		prc.minContentCount = ( prc.results.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.results.count : prc.cbSettings.cb_admin_quicksearch_max );
		
		// Search for Authors
		prc.authors = authorService.search(searchTerm=rc.search, max=prc.cbSettings.cb_admin_quicksearch_max);
		prc.minAuthorCount = ( prc.authors.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.authors.count : prc.cbSettings.cb_admin_quicksearch_max );
		
		// cb helper
		prc.cb = variables.CBHelper;
		// renderdata
		event.renderdata( data = renderView( "content/search" ) );
	}

	function slugUnique(event,rc,prc){
		// Params
		event.paramValue( "slug", "" );
		event.paramValue( "contentID", "" );

		var data = {
			"UNIQUE" = false
		};
		
		if( len( rc.slug ) ){
			data[ "UNIQUE" ] = contentService.isSlugUnique( trim( rc.slug ), trim( rc.contentID ) );
		}
		
		event.renderData(data=data, type="json" );
	}

	// related content selector
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
		var contentResults = contentService.searchContent( searchTerm=rc.search,
														   offset=prc.paging.startRow-1,
														   max=prc.cbSettings.cb_paging_maxrows,
														   sortOrder="slug asc",
														   searchActiveContent=false,
														   contentTypes=rc.contentType,
														   excludeIDs=rc.excludeIDs );
		// setup data for display
		prc.content = contentResults.content;
		prc.contentCount  = contentResults.count;
		prc.CBHelper 	= CBHelper;

		// if ajax and searching, just return tables
		return renderView( view="content/relatedContentResults", module="contentbox-admin" );
	}

	function showRelatedContentSelector( event, rc, prc ) {
		event.paramValue( "search", "" );
		event.paramValue( "clear", false );
		event.paramValue( "excludeIDs", "" );
		event.paramValue( "contentType", "Page,Entry,ContentStore" );
		// exit handlers
		prc.xehRelatedContentSelector	= "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.CBHelper = CBHelper;
		event.setView(view="content/relatedContentSelector",layout="ajax" );
	}

	function breakContentLink( event, rc, prc ) {
		event.paramValue( "contentID", "" );
		event.paramValue( "linkedID", "" );
		var data = {};
		if( len( rc.contentID ) && len( rc.linkedID ) ) {
			var currentContent = ContentService.get( rc.contentID );
			var linkedContent = ContentService.get( rc.linkedID );
			linkedContent.removeRelatedContent( currentContent );
			ContentService.save( linkedContent );
			data[ "SUCCESS" ] = true;
		}
		event.renderData( data=data, type="json" );
	}

	/**
	* Reset Content Hits
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

}
