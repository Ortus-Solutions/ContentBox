/**
* This interceptor monitors pages, posts and custom html content so it can purge caches on updates
*/
component extends="coldbox.system.Interceptor"{

	// DI Injections
	property name="cachebox" 			inject="cachebox" 					persistent="false";
	property name="settingService"		inject="id:settingService@cb" 		persistent="false";

	// Listen when entries are saved
	function cbadmin_postEntrySave(event,interceptData){
		var entry 	 = arguments.interceptData.entry;
		doCacheCleanup( entry.buildContentCacheKey() , entry);
	}

	// Listen when pages are saved
	function cbadmin_postPageSave(event,interceptData){
		var page 	 = arguments.interceptData.page;
		doCacheCleanup( page.buildContentCacheKey(), page);
	}

	// Listen when pages are removed
	function cbadmin_prePageRemove(event,interceptData){
		var page 	 = arguments.interceptData.page;
		doCacheCleanup( page.buildContentCacheKey(), page);
	}

	// Listen when custom HTML is saved
	function cbadmin_postCustomHTMLSave(event,interceptData){
		var content		= arguments.interceptData.content;
		doCacheCleanup( content.buildContentCacheKey() );
	}

	// clear according to cache settings
	private function doCacheCleanup(required string cacheKey, any content){
		// Get settings
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		// clear by keysnippets
		cache.clearByKeySnippet(keySnippet=arguments.cacheKey,async=false);
		// Page specific caching cleanup
		if( structKeyExists(arguments,"content") and arguments.content.getContentType() eq "Page"){
			// Remove ancestry caching
			cache.clearByKeySnippet(keySnippet="cb-content-pagewrapper-#replacenocase(arguments.content.getSlug(), "/" & listLast(arguments.content.getSlug(),"/"),"")#",async=false);
		}

		// log
		if( log.canInfo() ){
			log.info("Sent clear command using the following content key: #arguments.cacheKey# from provider: #settings.cb_content_cacheName#");
		}
	}
}