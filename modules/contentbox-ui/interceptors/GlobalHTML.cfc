/**
* Manages Global HTML INterception Points
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