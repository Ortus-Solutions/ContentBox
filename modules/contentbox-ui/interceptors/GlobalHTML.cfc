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
* Manages Global HTML Interception Points
*/
component extends="coldbox.system.Interceptor"{

	function configure(){}

	function cbui_beforeHeadEnd(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_beforeHeadEnd );
	}
	function cbui_afterBodyStart(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_afterBodyStart );
	}
	function cbui_beforeBodyEnd(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_beforeBodyEnd );
	}
	function cbui_beforeContent(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_beforeContent );
	}
	function cbui_afterContent(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_afterContent );
	}
	function cbui_beforeSideBar(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_beforeSideBar );
	}
	function cbui_afterSideBar(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_afterSideBar );
	}
	function cbui_footer(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_afterFooter );
	}
	function cbui_preEntryDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_preEntryDisplay );
	}
	function cbui_postEntryDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_postEntryDisplay );
	}
	function cbui_preIndexDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_preIndexDisplay );
	}
	function cbui_postIndexDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_postIndexDisplay );
	}
	function cbui_preArchivesDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_preArchivesDisplay );
	}
	function cbui_postArchivesDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_postArchivesDisplay );
	}
	function cbui_preCommentForm(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_preCommentForm );
	}
	function cbui_postCommentForm(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_postCommentForm );
	}
	function cbui_prePageDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_prePageDisplay );
	}
	function cbui_postPageDisplay(event,interceptData){
		appendToBuffer( getSettings( event ).cb_html_postPageDisplay );
	}

	private function getSettings(event){
		return event.getValue(name="cbSettings",private=true);
	}

}