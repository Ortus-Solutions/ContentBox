/**
* This interceptor monitors new comments and new entries to clear RSS cache entries
*/
component extends="coldbox.system.Interceptor"{

	// Listen when entries are saved
	function cbadmin_onEntrySave(event,interceptData){
		getModel("rssService@cb").clearCaches();
	}
	
	// Listen when entries are removed
	function cbadmin_postEntryRemove(event,interceptData){
		getModel("rssService@cb").clearCaches();
	}

	// Listen when comments are made
	function cbui_onCommentPost(event,interceptData){
		getModel("rssService@cb").clearCaches(comments=true);
	}
}