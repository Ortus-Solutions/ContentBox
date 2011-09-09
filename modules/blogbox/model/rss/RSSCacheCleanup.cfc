/**
* This interceptor monitors new comments and new entries to clear RSS cache entries
*/
component extends="coldbox.system.Interceptor"{

	property name="cache" 		inject="cachebox:default";
	property name="rssService"	inject="rssService@bb";

	
	// Listen when entries are saved
	function bbadmin_onEntrySave(event,interceptData){
		rssService.clearCaches();
	}
	
	// Listen when entries are removed
	function bbadmin_postEntryRemove(event,interceptData){
		rssService.clearCaches();
	}

	// Listen when comments are made
	function bbui_onCommentPost(event,interceptData){
		rssService.clearCaches(comments=true);
	}
}