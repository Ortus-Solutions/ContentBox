﻿/**
* Manage comments
*/
component extend="baseHandler"{

	// Dependencies
	property name="commentService"		inject="id:commentService@cb";
	property name="settingsService"		inject="id:settingService@cb";

	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab
		prc.tabComments = true;
	}

	// index
	function index(event,rc,prc){
		// params
		event.paramValue("page",1);
		event.paramValue("searchComments","");
		event.paramValue("fStatus","any");
		event.paramValue("ftype","any");
		event.paramValue("isFiltering",false);

		// prepare paging plugin
		prc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 		 = prc.pagingPlugin.getBoundaries();
		prc.pagingLink 	 = event.buildLink('#prc.xehComments#.page.@page@?');
		// Append search to paging link?
		if( len(rc.searchComments) ){ prc.pagingLink&="&searchComments=#rc.searchComments#"; }
		// Append filters to paging link?
		if( rc.fStatus neq "any" ){ prc.pagingLink&="&fStatus=#rc.fStatus#"; }
		// is Filtering?
		if( rc.fStatus neq "any" ){ rc.isFiltering = true; }

		// search comments with filters and all
		var commentResults = commentService.search(search=rc.searchComments,
											       offset=prc.paging.startRow-1,
											       max=prc.cbSettings.cb_paging_maxrows,
											       isApproved=rc.fStatus);
		prc.comments 	 	= commentResults.comments;
		prc.commentsCount 	= commentResults.count;
		prc.countApproved 	= commentService.getApprovedCommentCount();
		prc.countUnApproved 	= commentService.getUnApprovedCommentCount();

		// exit Handlers
		prc.xehCommentEditor 	= "#prc.cbAdminEntryPoint#.comments.editor";
		prc.xehCommentRemove 	= "#prc.cbAdminEntryPoint#.comments.remove";
		prc.xehCommentstatus 	= "#prc.cbAdminEntryPoint#.comments.doStatusUpdate";
		prc.xehCommentQuickLook	= "#prc.cbAdminEntryPoint#.comments.quicklook";

		// tab
		prc.tabComments_inbox = true;
		
		// display
		event.setView("comments/index");
	}

	// change status
	function doStatusUpdate(event,rc,prc){
		// param values
		event.paramValue("commentID","");
		event.paramValue("page","1");
		var data = { "ERROR" = false, "MESSAGES" = "" };
		// check if comment id list has length
		if( len( rc.commentID ) ){
			commentService.bulkStatus(commentID=rc.commentID, status=rc.commentStatus);
			// announce event
			announceInterception( "cbadmin_onCommentStatusUpdate", {commentID=rc.commentID,status=rc.commentStatus} );
			// Message
			data.messages = "#listLen(rc.commentID)# Comment(s) #rc.commentStatus#d";
			getPlugin("MessageBox").info( data.messages );
		}
		else{
			data.messages = "No comments selected!";
			data.error = true;
			getPlugin("MessageBox").warn( data.messages );
		}
		
		// If ajax call, return as ajax
		if( event.isAjax() ){
			event.renderData(data=data, type="json");
		}
		else{
			// relocate back
			setNextEvent(event=prc.xehComments, queryString="page=#rc.page#");
		}
	}

	// editor
	function editor(event,rc,prc){
		// get new or persisted
		rc.comment  = commentService.get( event.getValue("commentID",0) );
		// exit handlers
		prc.xehCommentsave = "#prc.cbAdminEntryPoint#.comments.save";
		// view
		event.setView(view="comments/editor",layout="ajax");
	}

	// comment moderators
	function moderate(event,rc,prc){
		// get new or persisted
		rc.comment  = commentService.get( event.getValue("commentID",0) );
		if( isNull(rc.Comment) ){
			getPlugin("MessageBox").error("The commentID #rc.commentID# is invalid.");
			setNextEvent(prc.xehComments);
			return;
		}
		// exit handlers
		prc.xehCommentstatus = "#prc.cbAdminEntryPoint#.comments.doStatusUpdate";
		rc.xehCommentRemove = "#prc.cbAdminEntryPoint#.comments.remove";
		// view
		event.setView("comments/moderate");
	}

	// quick look
	function quickLook(event,rc,prc){
		// get new or persisted
		rc.comment  = commentService.get( event.getValue("commentID",0) );
		// view
		event.setView(view="comments/quickLook",layout="ajax");
	}

	// save
	function save(event,rc,prc){
		// populate and get comment
		var oComment = populateModel( commentService.get(id=rc.commentID) );
		// announce event
		announceInterception("cbadmin_preCommentSave",{comment=oComment,commentID=rc.commentID});
		// save comment
		commentService.save( oComment );
		// announce event
		announceInterception("cbadmin_postCommentSave",{comment=oComment});
		// messagebox
		getPlugin("MessageBox").setMessage("info","Comment saved!");
		// relocate
		setNextEvent(prc.xehComments);
	}

	// remove
	function remove(event,rc,prc){
		// param values
		event.paramValue("commentID","");
		event.paramValue("page","1");
		var data = { "ERROR" = false, "MESSAGES" = "" };
		// check for length
		if( len(rc.commentID) ){
			// announce event
			announceInterception("cbadmin_preCommentRemove",{commentID=rc.commentID});
			// remove using hibernate bulk
			var deleted = commentService.deleteByID( listToArray(rc.commentID) );
			// announce event
			announceInterception("cbadmin_postCommentRemove",{commentID=rc.commentID});
			// message
			data.messages = "#deleted# Comment(s) Removed!";
			getPlugin("MessageBox").info( data.messages );
		}
		else{
			data.messages = "No comments selected!";
			data.error = true;
			getPlugin("MessageBox").warn( data.messages );
		}
		// If ajax call, return as ajax
		if( event.isAjax() ){
			event.renderData(data=data, type="json");
		}
		else{
			// relocate back
			setNextEvent(event=prc.xehComments, queryString="page=#rc.page#");
		}
	}

	// pager viewlet
	// TODO: add link to pages
	function pager(event,rc,prc,contentID="all",max=0,pagination=true){

		// check if contentID exists in rc to do an override, maybe it's the paging call
		if( event.valueExists("commentPager_contentID") ){
			arguments.contentID = rc.commentPager_contentID;
		}
		// Check pagination incoming
		if( event.valueExists("commentPager_pagination") ){
			arguments.pagination = rc.commentPager_pagination;
		}
		// Check max rows
		if( event.valueExists("commentPager_max") ){
			arguments.max = rc.commentPager_max;
		}
		// Max rows incoming or take default for pagination.
		if( arguments.max eq 0 ){ arguments.max = prc.cbSettings.cb_paging_maxrows; }

		// paging default
		event.paramValue("page",1);

		// exit handlers
		prc.xehCommentPager 			= "#prc.cbAdminEntryPoint#.comments.pager";
		prc.xehCommentPagerQuickLook	= "#prc.cbAdminEntryPoint#.comments.quickLook";
		prc.xehCommentPagerStatus		= "#prc.cbAdminEntryPoint#.comments.doStatusUpdate";
		prc.xehCommentPagerRemove		= "#prc.cbAdminEntryPoint#.comments.remove";

		// prepare paging plugin
		prc.commentPager_pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.commentPager_paging 	  	= prc.commentPager_pagingPlugin.getBoundaries();
		prc.commentPager_pagingLink 	= "javascript:commentPagerLink(@page@)";
		prc.commentPager_pagination		= arguments.pagination;
		prc.commentPager_max			= arguments.max;

		// search entries with filters and all
		var commentResults = commentService.search(contentID=arguments.contentID,
											       offset=prc.commentPager_paging.startRow-1,
											       max=arguments.max);
		prc.commentPager_comments 	     = commentResults.comments;
		prc.commentPager_commentsCount   = commentResults.count;

		// incoming entry ID
		prc.commentPager_contentID	= arguments.contentID;

		// view pager
		return renderView(view="comments/pager",module="contentbox-admin");
	}

	// settings
	function settings(event,rc,prc){
		rc.xehSaveSettings = "#prc.cbAdminEntryPoint#.comments.saveSettings";
		prc.tabComments_settings = true;
		event.setView("comments/settings");
	}

	// save settings
	function saveSettings(event,rc,prc){

		// announce event
		announceInterception("cbadmin_preCommentSettingsSave",{oldSettings=prc.cbSettings,newSettings=rc});

		// bulk save the options
		settingsService.bulkSave(rc);

		// announce event
		announceInterception("cbadmin_postCommentSettingsSave");

		// relocate back to editor
		getPlugin("MessageBox").info("All comment settings updated!");
		setNextEvent(prc.xehCommentsettings);
	}
}
