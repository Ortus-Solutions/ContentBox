/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Admin Dashboard
 */
component extends="baseHandler" {

	// Dependencies
	property name="entryService" inject="entryService@contentbox";
	property name="pageService" inject="pageService@contentbox";
	property name="contentService" inject="contentService@contentbox";
	property name="commentService" inject="commentService@contentbox";
	property name="categoryService" inject="categoryService@contentbox";
	property name="feedReader" inject="FeedReader@cbfeeds";
	property name="loginTrackerService" inject="loginTrackerService@contentbox";
	property name="markdown" inject="Processor@cbmarkdown";

	/**
	 * Main dashboard event
	 *
	 * @return html
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehDeleteInstaller   = "#prc.cbAdminEntryPoint#.dashboard.deleteInstaller";
		// Ajax Loaded handlers
		prc.xehLatestSystemEdits = "#prc.cbAdminEntryPoint#.dashboard.latestSystemEdits";
		prc.xehLatestUserDrafts  = "#prc.cbAdminEntryPoint#.dashboard.latestUserDrafts";
		prc.xehPublishedContent  = "#prc.cbAdminEntryPoint#.dashboard.futurePublishedContent";
		prc.xehExpiredContent    = "#prc.cbAdminEntryPoint#.dashboard.expiredContent";
		prc.xehLatestComments    = "#prc.cbAdminEntryPoint#.dashboard.latestComments";
		prc.xehLatestNews        = "#prc.cbAdminEntryPoint#.dashboard.latestNews";
		prc.xehLatestSnapshot    = "#prc.cbAdminEntryPoint#.dashboard.latestSnapshot";
		prc.xehLatestLogins      = "#prc.cbAdminEntryPoint#.dashboard.latestLogins";

		// Installer Check
		prc.installerCheck = variables.settingService.isInstallationPresent();
		// Welcome Body
		prc.welcomeBody    = variables.markdown.toHTML( prc.cbSettings.cb_dashboard_welcome_body );
		// Light up
		prc.tabDashboard   = true;
		// announce event
		announce( "cbadmin_onDashboard" );
		// dashboard view
		event.setView( "dashboard/index" );
	}

	/**
	 * Produce the latest system snapshots
	 *
	 * @return html
	 */
	function latestSnapshot( event, rc, prc ){
		var siteID = prc.oCurrentSite.getsiteID();

		prc.entriesCount            = variables.entryService.getTotalContentCount( siteID );
		prc.pagesCount              = variables.pageService.getTotalContentCount( siteID );
		prc.commentsCount           = variables.commentService.getTotalCount( siteID );
		prc.commentsApprovedCount   = variables.commentService.getApprovedCount( siteID );
		prc.commentsUnApprovedCount = variables.commentService.getUnApprovedCount( siteID );
		prc.categoriesCount         = variables.categoryService.getTotalCategoryCount( siteID );

		// Few Reports
		prc.topContent   = variables.contentService.getTopVisitedContent( max: 5, siteID: siteID );
		prc.topCommented = variables.contentService.getTopCommentedContent( max: 5, siteID: siteID );

		// convert report to chart data
		prc.aTopContent          = [];
		prc.aTopContentTotalHits = 0;

		for ( var thisContent in prc.topContent ) {
			arrayAppend(
				prc.aTopContent,
				{
					"label" : thisContent.getTitle(),
					"value" : thisContent.getNumberOfHits()
				}
			);
			prc.aTopContentTotalHits += thisContent.getNumberOfHits();
		}
		prc.aTopContent = serializeJSON( prc.aTopContent );

		prc.aTopCommented          = [];
		prc.aTopCommentedTotalHits = 0;

		for ( var thisContent in prc.topCommented ) {
			arrayAppend(
				prc.aTopCommented,
				{
					"label" : thisContent.getTitle(),
					"value" : thisContent.getNumberOfComments()
				}
			);
			prc.aTopCommentedTotalHits += thisContent.getNumberOfComments();
		}
		prc.aTopCommented = serializeJSON( prc.aTopCommented );

		// render view out.
		event.setView( view = "dashboard/latestSnapshot", layout = "ajax" );
	}

	/**
	 * Produce the latest currently logged in user drafts
	 *
	 * @return html
	 */
	function latestUserDrafts( event, rc, prc ){
		// Latest Edits
		prc.latestDraftsViewlet = runEvent(
			event          = "contentbox-admin:content.latestContentEdits",
			eventArguments = {
				max                 : 10,
				author              : prc.oCurrentAuthor,
				isPublished         : false,
				showHits            : false,
				colorCodings        : false,
				showPublishedStatus : false,
				showAuthor          : false
			}
		);
		event.setView( view = "dashboard/latestUserDrafts", layout = "ajax" );
	}

	/**
	 * Produce the latest system content edits
	 *
	 * @return html
	 */
	function latestSystemEdits( event, rc, prc ){
		// Latest Edits
		prc.latestEditsViewlet = runEvent(
			event          = "contentbox-admin:content.latestContentEdits",
			eventArguments = { max : 10, showHits : true }
		);
		event.setView( view = "dashboard/latestSystemEdits", layout = "ajax" );
	}

	/**
	 * Produce the publish in the future content
	 *
	 * @return html
	 */
	function futurePublishedContent( event, rc, prc ){
		// Latest Edits
		prc.futurePublishedContent = runEvent(
			event          = "contentbox-admin:content.contentByPublishedStatus",
			eventArguments = { max : 10, showHits : false, colorCodings : false }
		);
		event.setView( view = "dashboard/futurePublishedContent", layout = "ajax" );
	}

	/**
	 * Produce the expired content report
	 *
	 * @return html
	 */
	function expiredContent( event, rc, prc ){
		// Latest Edits
		prc.expiredContent = runEvent(
			event          = "contentbox-admin:content.contentByPublishedStatus",
			eventArguments = {
				max          : 10,
				showHits     : true,
				showExpired  : true,
				colorCodings : false
			}
		);
		event.setView( view = "dashboard/expiredContent", layout = "ajax" );
	}

	/**
	 * Produce the latest system comments
	 *
	 * @return html
	 */
	function latestComments( event, rc, prc ){
		// Get Comments viewlet
		var eArgs = {
			max        : prc.cbSettings.cb_dashboard_recentComments,
			pagination : false
		};
		prc.commentsViewlet = runEvent( event = "contentbox-admin:comments.pager", eventArguments = eArgs );
		event.setView( view = "dashboard/latestComments", layout = "ajax" );
	}

	/**
	 * Produce the latest system news
	 *
	 * @return html
	 */
	function latestNews( event, rc, prc ){
		// Get latest ContentBox news
		try {
			if ( len( prc.cbsettings.cb_dashboard_newsfeed ) ) {
				prc.latestNews = feedReader.readFeed(
					feedURL   = prc.cbsettings.cb_dashboard_newsfeed,
					itemsType = "query",
					maxItems  = prc.cbsettings.cb_dashboard_newsfeed_count
				);
			} else {
				prc.latestNews = { items : queryNew( "" ) };
			}
		} catch ( Any e ) {
			prc.latestNews = { items : queryNew( "" ) };
			log.error( "Error retrieving news feed: #e.message# #e.detail#", e );
		}

		event.setView( view = "dashboard/latestNews", layout = "ajax" );
	}

	/**
	 * Produce the latest system logins
	 *
	 * @return html
	 */
	function latestLogins( event, rc, prc ){
		prc.lastLogins = loginTrackerService.getLastLogins( max = prc.cbsettings.cb_security_blocktime );
		event.setView( view = "dashboard/latestLogins", layout = "ajax" );
	}

	/*************************************** UTILITY ACTIONS *********************************/

	/**
	 * delete installer module
	 *
	 * @return JSON
	 */
	function deleteInstaller(){
		var results = { "ERROR" : false, "MESSAGE" : "" };

		try {
			variables.settingService.deleteInstaller();
			results[ "MESSAGE" ] = "The installer module has been successfully deleted.";
		} catch ( Any e ) {
			results[ "ERROR" ]   = true;
			results[ "MESSAGE" ] = "Error removing installer: #e.message#";
		}

		event.renderData( data = results, type = "json" );
	}

	/**
	 * Reload System Actions
	 *
	 * @return relocation if synchronous, json if ajax
	 */
	function reload( event, rc, prc ){
		try {
			switch ( rc.targetModule ) {
				// reload application
				case "app": {
					applicationStop();
					break;
				}
				case "orm": {
					ormReload();
					break;
				}
				case "rss-purge": {
					getInstance( "RSSService@contentbox" ).clearAllCaches( async = false );
					break;
				}
				case "content-purge": {
					getInstance( "ContentService@contentbox" ).clearAllCaches( async = false );
					break;
				}
				case "cache-purge": {
					getCache( "template" ).clearAll();
					break;
				}
				default: {
					relocate( prc.xehDashboard );
				}
			}

			// flash info for UI purposes
			flash.put( "moduleReloaded", rc.targetModule );

			// Ajax requests
			if ( event.isAjax() ) {
				event.renderData( type = "json", data = { error : false, executed : true } );
			} else {
				// relocate back to dashboard
				relocate( prc.xehDashboard );
			}
		} catch ( Any e ) {
			// Log Exception
			log.error( "Error running admin reload module action: #e.message# #e.detail#", e );
			// Ajax requests
			if ( event.isAjax() ) {
				var data = {
					error    : true,
					executed : false,
					messages : e.message & e.detail
				};
				event.renderData( type = "json", data = data );
			} else {
				// MessageBox
				cbMessagebox.error( "Error running admin reload module action: #e.message# #e.detail#" );
				// relocate back to dashboard
				relocate( prc.xehDashboard );
			}
		}
	}

}
