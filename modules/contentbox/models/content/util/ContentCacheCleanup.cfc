/**
* This interceptor monitors pages, posts and custom html content so it can purge caches on updates
*/
component extends="coldbox.system.Interceptor"{

	// DI Injections
	property name="cachebox" 			inject="cachebox";
	property name="settingService"		inject="id:settingService@cb";
	property name="commentService"		inject="id:commentService@cb";

	// Listen when comments are posted.
	function cbui_onCommentPost( event, interceptData ){
		doCacheCleanup( arguments.interceptData.content.buildContentCacheKey() , arguments.interceptData.content );
	}
	
	// Listen when comments are moderated
	function cbadmin_onCommentStatusUpdate( event, interceptData ){
		var oComment = commentService.get( arguments.interceptData.commentID );
		doCacheCleanup( oComment.getRelatedContent().buildContentCacheKey() , oComment.getRelatedContent() );
	}

	// Listen when comments are removed
	function cbadmin_preCommentRemove( event, interceptData ){
		var oComment = commentService.get( arguments.interceptData.commentID );
		doCacheCleanup( oComment.getRelatedContent().buildContentCacheKey() , oComment.getRelatedContent() );
	}
	
	// Listen when entries are saved
	function cbadmin_postEntrySave( event, interceptData ){
		var entry 	 = arguments.interceptData.entry;
		doCacheCleanup( entry.buildContentCacheKey() , entry);
	}

	// Listen when pages are saved
	function cbadmin_postPageSave( event, interceptData ){
		var page 	 = arguments.interceptData.page;
		doCacheCleanup( page.buildContentCacheKey(), page);
	}

	// Listen when pages are removed
	function cbadmin_prePageRemove( event, interceptData ){
		var page 	 = arguments.interceptData.page;
		doCacheCleanup( page.buildContentCacheKey(), page);
	}

	// Listen when custom HTML is saved
	function cbadmin_postContentStoreSave( event, interceptData ){
		var content		= arguments.interceptData.content;
		doCacheCleanup( content.buildContentCacheKey(), content );
	}

	// clear according to cache settings
	private function doCacheCleanup(required string cacheKey, any content){
		// Get settings
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		// clear internal caches
		cache.clearByKeySnippet(keySnippet=arguments.cacheKey, async=true);
		// clear ancestry caches
		var blogPrefix = ( arguments.content.getContentType() eq "Entry" ? "#settings.cb_site_blog_entrypoint#/" : "" );
		cache.clearByKeySnippet(keySnippet="cb-content-wrapper-#cgi.http_host#-#blogPrefix##replacenocase(arguments.content.getSlug(), "/" & listLast(arguments.content.getSlug(),"/" ),"" )#", async=true);
		// log
		if( log.canInfo() ){
			log.info( "Sent clear command using the following content key: #arguments.cacheKey# from provider: #settings.cb_content_cacheName#" );
		}
	}
}