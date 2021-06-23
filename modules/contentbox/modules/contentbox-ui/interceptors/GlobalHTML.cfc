/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages Global HTML Interception Points
 */
component extends="coldbox.system.Interceptor" {

	function configure(){
	}

	function cbui_beforeHeadEnd( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_beforeHeadEnd );
	}

	function cbui_afterBodyStart( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_afterBodyStart );
	}

	function cbui_beforeBodyEnd( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_beforeBodyEnd );
	}

	function cbui_beforeContent( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_beforeContent );
	}

	function cbui_afterContent( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_afterContent );
	}

	function cbui_beforeSideBar( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_beforeSideBar );
	}

	function cbui_afterSideBar( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_afterSideBar );
	}

	function cbui_footer( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_afterFooter );
	}

	function cbui_preEntryDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_preEntryDisplay );
	}

	function cbui_postEntryDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_postEntryDisplay );
	}

	function cbui_preIndexDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_preIndexDisplay );
	}

	function cbui_postIndexDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_postIndexDisplay );
	}

	function cbui_preArchivesDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_preArchivesDisplay );
	}

	function cbui_postArchivesDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_postArchivesDisplay );
	}

	function cbui_preCommentForm( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_preCommentForm );
	}

	function cbui_postCommentForm( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_postCommentForm );
	}

	function cbui_prePageDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_prePageDisplay );
	}

	function cbui_postPageDisplay( event, data, buffer ){
		arguments.buffer.append( getSiteSettings( arguments.event ).cb_html_postPageDisplay );
	}

	private function getSiteSettings( event ){
		return arguments.event.getPrivateValue( "cbSiteSettings" );
	}

}
