/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage comments
 */
component extends="baseHandler" {

	// Dependencies
	property name="commentService" inject="commentService@contentbox";
	property name="settingsService" inject="settingService@contentbox";

	// Public properties
	this.preHandler_except = "pager";

	/**
	 * Pre handler
	 *
	 * @event         
	 * @action        
	 * @eventArguments
	 * @rc            
	 * @prc           
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab selection
		prc.tabComments = true;
	}

	/**
	 * Main display of comments
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function index( event, rc, prc ){
		// params
		event.paramValue( "page", 1 );
		event.paramValue( "searchComments", "" );
		event.paramValue( "fStatus", "any" );
		event.paramValue( "ftype", "any" );
		event.paramValue( "isFiltering", false );

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@contentbox" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = event.buildLink( "#prc.xehComments#.page.@page@?" );

		// Append search to paging link?
		if ( len( rc.searchComments ) ) {
			prc.pagingLink &= "&searchComments=#rc.searchComments#";
		}

		// Append filters to paging link?
		if ( rc.fStatus neq "any" ) {
			prc.pagingLink &= "&fStatus=#rc.fStatus#";
		}

		// is Filtering?
		if ( rc.fStatus neq "any" ) {
			rc.isFiltering = true;
		}

		// search comments with filters and all
		var commentResults = variables.commentService.search(
			search    : rc.searchComments,
			offset    : prc.paging.startRow - 1,
			max       : prc.cbSettings.cb_paging_maxrows,
			isApproved: rc.fStatus,
			siteID    : prc.oCurrentSite.getsiteID()
		);

		prc.comments        = commentResults.comments;
		prc.commentsCount   = commentResults.count;
		prc.countApproved   = variables.commentService.getApprovedCount();
		prc.countUnApproved = variables.commentService.getUnApprovedCount();

		// exit Handlers
		prc.xehCommentEditor             = "#prc.cbAdminEntryPoint#.comments.editor";
		prc.xehCommentRemove             = "#prc.cbAdminEntryPoint#.comments.remove";
		prc.xehCommentstatus             = "#prc.cbAdminEntryPoint#.comments.doStatusUpdate";
		prc.xehCommentQuickLook          = "#prc.cbAdminEntryPoint#.comments.quicklook";
		prc.xehCommentRemoveAllModerated = "#prc.cbAdminEntryPoint#.comments.removeAllModerated";

		// tab
		prc.tabComments_inbox = true;

		// display
		event.setView( "comments/index" );
	}

	/**
	 * Submit a status udpate on a comment
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function doStatusUpdate( event, rc, prc ){
		// param values
		event.paramValue( "commentID", "" );
		event.paramValue( "page", "1" );
		var data = { "ERROR" : false, "MESSAGES" : "" };

		// check if comment id list has length
		if ( len( rc.commentID ) ) {
			commentService.bulkStatus( commentID = rc.commentID, status = rc.commentStatus );
			// announce event
			announce( "cbadmin_onCommentStatusUpdate", { commentID : rc.commentID, status : rc.commentStatus } );
			// Message
			data.messages = "#listLen( rc.commentID )# Comment(s) #rc.commentStatus#d";
			cbMessagebox.info( data.messages );
		} else {
			data.messages = "No comments selected!";
			data.error    = true;
			cbMessagebox.warn( data.messages );
		}

		// If ajax call, return as ajax
		if ( event.isAjax() ) {
			event.renderData( data = data, type = "json" );
		} else {
			// relocate back
			relocate( event = prc.xehComments, queryString = "page=#rc.page#" );
		}
	}

	/**
	 * Show the comment editor
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function editor( event, rc, prc ){
		// get new or persisted
		rc.comment         = commentService.get( event.getValue( "commentID", 0 ) );
		// exit handlers
		prc.xehCommentsave = "#prc.cbAdminEntryPoint#.comments.save";
		// view
		event.setView( view = "comments/editor", layout = "ajax" );
	}

	/**
	 * Show the comment moderator
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function moderate( event, rc, prc ){
		// get new or persisted
		rc.comment = commentService.get( event.getValue( "commentID", 0 ) );
		if ( isNull( rc.Comment ) ) {
			cbMessagebox.error( "The commentID #rc.commentID# is invalid." );
			relocate( prc.xehComments );
			return;
		}
		// exit handlers
		prc.xehCommentstatus = "#prc.cbAdminEntryPoint#.comments.doStatusUpdate";
		rc.xehCommentRemove  = "#prc.cbAdminEntryPoint#.comments.remove";
		// view
		event.setView( "comments/moderate" );
	}

	/**
	 * Comment quick look
	 *
	 * @event
	 * @rc   
	 * @prc  
	 *
	 * @return HTML
	 */
	function quickLook( event, rc, prc ){
		// get new or persisted
		rc.comment = commentService.get( event.getValue( "commentID", 0 ) );
		// view
		event.setView( view = "comments/quickLook", layout = "ajax" );
	}

	/**
	 * Save a comment
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function save( event, rc, prc ){
		// populate and get comment
		var oComment = populateModel( model: commentService.get( id = rc.commentID ), exclude: "commentID" );
		// announce event
		announce( "cbadmin_preCommentSave", { comment : oComment, commentID : rc.commentID } );
		// save comment
		commentService.save( oComment );
		// announce event
		announce( "cbadmin_postCommentSave", { comment : oComment } );
		// notice
		cbMessagebox.info( "Comment Saved!" );
		// relocate
		relocate( prc.xehComments );
	}

	/**
	 * Remove all Moderated comments
	 *
	 * @event
	 * @rc   
	 * @prc  
	 *
	 * @return JSON or relocation
	 */
	function removeAllModerated( event, rc, prc ){
		var data = { "ERROR" : false, "MESSAGES" : "" };
		// announce event
		announce( "cbadmin_preCommentRemoveAllModerated" );
		// passing 0 will delete all unapproved...
		commentService.deleteUnApproved( 0 );
		// announce event
		announce( "cbadmin_postCommentRemoveAllModerated" );
		// message
		data.messages = "Moderated Comment(s) Removed!";
		cbMessagebox.info( data.messages );
		// If ajax call, return as ajax
		if ( event.isAjax() ) {
			event.renderData( data = data, type = "json" );
		} else {
			// relocate back
			relocate( event = prc.xehComments, queryString = "page=1" );
		}
	}

	/**
	 * Remove comments from the database
	 *
	 * @event
	 * @rc   
	 * @prc  
	 *
	 * @return JSON or relocation
	 */
	function remove( event, rc, prc ){
		// param values
		event.paramValue( "commentID", "" ).paramValue( "page", "1" );

		// prepare data return object
		var data = { "ERROR" : false, "MESSAGES" : [] };

		// Remove incoming comments
		rc.commentID
			.listToArray()
			.each( function( thisCommentID ){
				var oComment = commentService.get( thisCommentID );
				// null checks
				if ( isNull( oComment ) ) {
					arrayAppend( data.messages, "Invalid commentID sent: #thisCommentID#, so skipped removal" );
				} else {
					// announce event
					announce( "cbadmin_preCommentRemove", { comment : oComment, commentID : thisCommentID } );
					// remove
					commentService.delete( oComment );
					arrayAppend( data.messages, "Comment #thisCommentID# removed" );
					// announce event
					announce( "cbadmin_postCommentRemove", { commentID : thisCommentID } );
				}
			} );

		// No comments selected
		if ( !len( rc.commentID ) ) {
			arrayAppend( data.messages, "No comments selected!" );
			data.error = true;
			cbMessagebox.warn( data.messages );
		}

		// If ajax call, return as ajax json
		if ( event.isAjax() ) {
			return data;
		} else {
			// relocate back
			relocate( event = prc.xehComments, queryString = "page=#rc.page#" );
		}
	}

	/**
	 * Comment Pager
	 *
	 * @event     
	 * @rc        
	 * @prc       
	 * @contentID  The content ID to filter the comments on, defaults to all
	 * @max        Max number of comments to show, shows the global default
	 * @pagination Turn pagination on or off
	 */
	function pager(
		event,
		rc,
		prc,
		contentID  = "all",
		max        = 0,
		pagination = true
	){
		// check if contentID exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "commentPager_contentID" ) ) {
			arguments.contentID = rc.commentPager_contentID;
		}
		// Check pagination incoming
		if ( event.valueExists( "commentPager_pagination" ) ) {
			arguments.pagination = rc.commentPager_pagination;
		}
		// Check max rows
		if ( event.valueExists( "commentPager_max" ) ) {
			arguments.max = rc.commentPager_max;
		}
		// Max rows incoming or take default for pagination.
		if ( arguments.max eq 0 ) {
			arguments.max = prc.cbSettings.cb_paging_maxrows;
		}

		// paging default
		event.paramValue( "page", 1 );

		// exit handlers
		prc.xehCommentPager              = "#prc.cbAdminEntryPoint#.comments.pager";
		prc.xehCommentPagerQuickLook     = "#prc.cbAdminEntryPoint#.comments.quickLook";
		prc.xehCommentPagerStatus        = "#prc.cbAdminEntryPoint#.comments.doStatusUpdate";
		prc.xehCommentPagerRemove        = "#prc.cbAdminEntryPoint#.comments.remove";
		prc.xehCommentRemoveAllModerated = "#prc.cbAdminEntryPoint#.comments.removeAllModerated";

		// prepare paging object
		prc.commentPager_oPaging    = getInstance( "Paging@contentbox" );
		prc.commentPager_paging     = prc.commentPager_oPaging.getBoundaries();
		prc.commentPager_pagingLink = "javascript:commentPagerLink(@page@)";
		prc.commentPager_pagination = arguments.pagination;
		prc.commentPager_max        = arguments.max;

		// search entries with filters and all
		var commentResults = commentService.search(
			contentID: arguments.contentID,
			offset   : prc.commentPager_paging.startRow - 1,
			max      : arguments.max,
			siteID   : prc.oCurrentSite.getsiteID()
		);
		prc.commentPager_comments      = commentResults.comments;
		prc.commentPager_commentsCount = commentResults.count;

		// incoming entry ID
		prc.commentPager_contentID = arguments.contentID;

		// view pager
		return renderView( view = "comments/pager", module = "contentbox-admin" );
	}

	/**
	 * Show comment settings panel
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function settings( event, rc, prc ){
		rc.xehSaveSettings       = "#prc.cbAdminEntryPoint#.comments.saveSettings";
		prc.tabComments_settings = true;
		event.setView( "comments/settings" );
	}

	/**
	 * Save the comment settings
	 */
	function saveSettings( event, rc, prc ){
		// announce event
		announce( "cbadmin_preCommentSettingsSave", { oldSettings : prc.cbSettings, newSettings : rc } );
		// bulk save the options
		settingsService.bulkSave(
			rc.filter( function( key ){
				return key.findNoCase( "cb_comments" );
			} ),
			prc.oCurrentSite
		);
		// announce event
		announce( "cbadmin_postCommentSettingsSave" );
		// relocate back to editor
		cbMessagebox.info( "All comment settings updated!" );
		relocate( prc.xehCommentsettings );
	}

}
