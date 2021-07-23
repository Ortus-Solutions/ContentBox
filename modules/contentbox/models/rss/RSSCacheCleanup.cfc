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
* This interceptor monitors new comments and new entries to clear RSS cache entries
*/
component extends="coldbox.system.Interceptor" {

	// Listen when entries are saved
	function cbadmin_postEntrySave( event, data ){
		getInstance( "rssService@contentbox" ).clearCaches();
	}

	// Listen when entries are removed
	function cbadmin_postEntryRemove( event, data ){
		getInstance( "rssService@contentbox" ).clearCaches();
	}

	// Listen when comments are made
	function cbui_onCommentPost( event, data ){
		getInstance( "rssService@contentbox" ).clearCaches(
			comments = true,
			slug     = arguments.data.comment.getRelatedContent().getSlug()
		);
	}

}
