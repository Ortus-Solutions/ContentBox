/**
* Manage content
*/
component extends="baseHandler"{

	// Dependencies
	property name="contentService"		inject="id:contentService@cb";
	property name="customHTMLService"	inject="id:customHTMLService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";

	// content preview
	function preview(event,rc,prc){
		// param incoming data
		event.paramValue("layout","pages");
		event.paramValue("content","");
		event.paramValue("contentType","");
		event.paramValue("title","");
		event.paramValue("slug","");
		event.paramValue("markup","HTML");
		
		// Determine Type
		switch( rc.contentType ){
			case "Page" 	: { 
				prc.xehPreview = CBHelper.linkPage("__page_preview"); 
				break; 
			}
			case "Entry" : { 
				prc.xehPreview = CBHelper.linkPage("__entry_preview"); 
				rc.layout = "blog";
				break; 
			}
			case "CustomHTML" : {
				var oContent = customHTMLService.new();
				oContent.setMarkup( rc.markup );
				prc.preview = oContent.renderContentSilent( rc.content );
				event.setView(view="content/simplePreview", layout="ajax");
				return;
			}
		}
		// author security hash
		prc.h = hash( prc.oAuthor.getAuthorID() );
		// full preview view
		event.setView(view="content/preview",layout="ajax");
	}
	
	function search(event,rc,prc){
		// Params
		event.paramValue( "search", "" );
		// Search for content
		prc.results = contentService.searchContent( searchTerm=rc.search, 
													max=prc.cbSettings.cb_admin_quicksearch_max, 
													sortOrder="title", 
													isPublished="all",
													searchActiveContent=false);
		prc.minContentCount = ( prc.results.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.results.count : prc.cbSettings.cb_admin_quicksearch_max );
		
		// Search for Custom HTML
		prc.customHTML = customHTMLService.search( search=rc.search, max=prc.cbSettings.cb_admin_quicksearch_max);
		prc.minCustomHTMLCount = ( prc.customHTML.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.customHTML.count : prc.cbSettings.cb_admin_quicksearch_max );
		
		// Search for Authors
		prc.authors = authorService.search(searchTerm=rc.search, max=prc.cbSettings.cb_admin_quicksearch_max);
		prc.minAuthorCount = ( prc.authors.count lt prc.cbSettings.cb_admin_quicksearch_max ? prc.authors.count : prc.cbSettings.cb_admin_quicksearch_max );
		
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
		
		event.renderData(data=data, type="json");
	}

}
