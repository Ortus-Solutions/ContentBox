/**
 * This interceptor monitors pages, posts and custom html content so it can purge caches on updates
 */
component extends="coldbox.system.Interceptor" {

	// DI Injections
	property name="cachebox" inject="cachebox";
	property name="settingService" inject="settingService@contentbox";
	property name="commentService" inject="commentService@contentbox";
	property name="contentService" inject="contentService@contentbox";

	/**
	 * Listen when comments are posted.
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbui_onCommentPost( event, data ){
		doCacheCleanup( arguments.data.content.buildContentCacheCleanupKey(), arguments.data.content );
	}

	/**
	 * Listen when comments are moderated
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_onCommentStatusUpdate( event, data ){
		variables.commentService
			.getAll( arguments.data.commentID )
			.each( function( thisComment ){
				doCacheCleanup(
					arguments.thisComment.getRelatedContent().buildContentCacheCleanupKey(),
					arguments.thisComment.getRelatedContent()
				);
			} );
	}

	/**
	 * Listen when comments are removed
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_preCommentRemove( event, data ){
		var oComment = variables.commentService.get( arguments.data.commentID );
		doCacheCleanup( oComment.getRelatedContent().buildContentCacheCleanupKey(), oComment.getRelatedContent() );
	}

	/**
	 * Listen when entries are saved
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_postEntrySave( event, data ){
		doCacheCleanup( arguments.data.content.buildContentCacheCleanupKey(), arguments.data.content );
	}

	/**
	 * Listen when entries are removed
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_preEntryRemove( event, data ){
		doCacheCleanup( arguments.data.content.buildContentCacheCleanupKey(), arguments.data.content );
	}

	/**
	 * Listen when pages are saved
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_postPageSave( event, data ){
		doCacheCleanup( arguments.data.content.buildContentCacheCleanupKey(), arguments.data.content );
	}

	/**
	 * Listen when pages are removed
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_prePageRemove( event, data ){
		doCacheCleanup( arguments.data.content.buildContentCacheCleanupKey(), arguments.data.content );
	}

	/**
	 * Listen when a content store item is saved
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_postContentStoreSave( event, data ){
		doCacheCleanup( arguments.data.content.buildContentCacheCleanupKey(), arguments.data.content );
	}

	/**
	 * Listen when a content store item is removed
	 *
	 * @event The request context
	 * @data  Intercept data
	 */
	function cbadmin_preContentStoreRemove( event, data ){
		doCacheCleanup( arguments.data.content.buildContentCacheCleanupKey(), arguments.data.content );
	}

	/*********************************************************************************************************/
	/* 										PRIVATE 														 */
	/*********************************************************************************************************/

	/**
	 * Clear the content caches according to incoming key and content object
	 *
	 * @cacheKey The cache key to use
	 * @content  The content object
	 */
	private function doCacheCleanup( required string cacheKey, any content ){
		// Log it
		variables.log.info(
			"=> Starting content cache cleanup for : #arguments.content.getContentType()#:#arguments.cacheKey#..."
		);

		// Get settings
		var settings = variables.settingService.getAllSettings();
		// Get appropriate cache provider
		var cache    = variables.cacheBox.getCache( settings.cb_content_cacheName );

		// clear content translation caches
		cache.clearByKeySnippet( keySnippet = arguments.cacheKey, async = true );
		// log it
		variables.log.info( "+ Cleared content translation caches for: #arguments.cacheKey#" );

		// clear content wrapper caches
		var blogPrefix = ( arguments.content.getContentType() eq "Entry" ? "#settings.cb_site_blog_entrypoint#/" : "" );
		var wrapperKey = "#blogPrefix##arguments.content.getSlug()#";
		variables.contentService.clearPageWrapperCaches( slug = wrapperKey, async = true );
		// log it
		variables.log.info( "+ Cleared content wrapper caches using wrapper key of: #wrapperKey#" );

		// Clear category count caches
		variables.contentService.clearAllCategoryCountCaches();
		// log it
		variables.log.info( "+ Cleared all category count caches." );

		// Rebuild Sitemap caches
		variables.contentService.clearAllSitemapCaches( async = true );
		// log it
		variables.log.info( "+ Cleared all sitemap caches" );

		variables.log.info(
			"=> Finalized cache content cleanup for #arguments.content.getContentType()#:#arguments.cacheKey#"
		);
	}

}
