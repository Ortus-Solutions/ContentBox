/**
* Manage comments
*/
component extend="baseHandler"{

	// Dependencies
	property name="commentService"		inject="id:commentService@bb";
	property name="settingsService"		inject="id:settingService@bb";
	
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
		event.paramValue("isFiltering",false);
		
		// prepare paging plugin
		rc.pagingPlugin = getMyPlugin(plugin="Paging",module="blogbox");
		rc.paging 		= rc.pagingPlugin.getBoundaries();
		rc.pagingLink 	= event.buildLink('#rc.xehComments#.page.@page@?');
		// Append search to paging link?
		if( len(rc.searchComments) ){ rc.pagingLink&="&searchComments=#rc.searchComments#"; }
		// Append filters to paging link?
		if( rc.fStatus neq "any" ){ rc.pagingLink&="&fStatus=#rc.fStatus#"; }
		// is Filtering?
		if( rc.fStatus neq "any" ){ rc.isFiltering = true; }
		
		// search comments with filters and all
		var commentResults = commentService.search(search=rc.searchComments,
											       offset=rc.paging.startRow-1,
											       max=prc.bbSettings.bb_paging_maxrows,
											       isApproved=rc.fStatus);
		rc.comments 	 	= commentResults.comments;
		rc.commentsCount 	= commentResults.count;
		rc.countApproved 	= commentService.countWhere(isApproved=true);
		rc.countUnApproved 	= commentService.countWhere(isApproved=false);
		
		// exit Handlers
		rc.xehCommentEditor 	= "#prc.bbEntryPoint#.comments.editor";
		rc.xehCommentRemove 	= "#prc.bbEntryPoint#.comments.remove";
		rc.xehCommentStatus 	= "#prc.bbEntryPoint#.comments.doStatusUpdate";
		rc.xehCommentQuickLook	= "#prc.bbEntryPoint#.comments.quicklook";
		
		// tab 
		prc.tabComments_inbox = true;
		// display
		event.setView("comments/index");
	}
	
	// change status
	function doStatusUpdate(event,rc,prc){
		event.paramValue("commentID","");
		event.paramValue("page","1");
		// check if comment id list has length
		if( len(rc.commentID) ){
			commentService.bulkStatus(commentID=rc.commentID,status=rc.commentStatus);
			// announce event
			announceInterception("bbadmin_onCommentStatusUpdate",{commentID=rc.commentID,status=rc.commentStatus});
			// Message
			getPlugin("MessageBox").info("#listLen(rc.commentID)# Comment(s) #rc.commentStatus#d");
		}
		else{
			getPlugin("MessageBox").warn("No comments selected!");
		}
		// relocate back
		setNextEvent(event=rc.xehComments,queryString="page=#rc.page#");
	}

	// editor
	function editor(event,rc,prc){
		// get new or persisted
		rc.comment  = commentService.get( event.getValue("commentID",0) );
		// exit handlers
		rc.xehCommentSave = "#prc.bbEntryPoint#.comments.save";
		// view
		event.setView(view="comments/editor",layout="ajax");
	}
	
	// comment moderators
	function moderate(event,rc,prc){
		// get new or persisted
		rc.comment  = commentService.get( event.getValue("commentID",0) );
		if( isNull(rc.Comment) ){ 
			getPlugin("MessageBox").error("The commentID #rc.commentID# is invalid.");
			setNextEvent(rc.xehComments);
			return;
		}
		// exit handlers
		rc.xehCommentStatus = "#prc.bbEntryPoint#.comments.doStatusUpdate";
		rc.xehCommentRemove = "#prc.bbEntryPoint#.comments.remove";
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
		announceInterception("bbadmin_preCommentSave",{comment=oComment,commentID=rc.commentID});
		// save comment
		commentService.save( oComment );
		// announce event
		announceInterception("bbadmin_postCommentSave",{comment=oComment});
		// messagebox
		getPlugin("MessageBox").setMessage("info","Comment saved!");
		// relocate
		setNextEvent(rc.xehComments);
	}
	
	// remove
	function remove(event,rc,prc){
		event.paramValue("commentID","");
		event.paramValue("page","1");
		// check for length
		if( len(rc.commentID) ){
			// announce event
			announceInterception("bbadmin_preCommentRemove",{commentID=rc.commentID});
			// remove using hibernate bulk
			var deleted = commentService.deleteByID( listToArray(rc.commentID) );
			// announce event
			announceInterception("bbadmin_postCommentRemove",{commentID=rc.commentID});
			// message
			getPlugin("MessageBox").info("#deleted# Comment(s) Removed!");
		}
		else{
			getPlugin("MessageBox").warn("No comments selected!");
		}
		setNextEvent(event=rc.xehComments,queryString="page=#rc.page#");
	}
	
	// pager viewlet
	function pager(event,rc,prc,entryID="all",max=0,pagination=true){
		
		// check if authorID exists in rc to do an override, maybe it's the paging call
		if( event.valueExists("commentPager_entryID") ){
			arguments.entryID = rc.commentPager_entryID;
		}
		// Check pagination incoming
		if( event.valueExists("commentPager_pagination") ){
			arguments.pagination = rc.commentPager_pagination;
		}
		// Max rows incoming or take default for pagination.
		if( arguments.max eq 0 ){ arguments.max = prc.bbSettings.bb_paging_maxrows; }
		
		// paging default
		event.paramValue("page",1);
		
		// exit handlers
		prc.xehCommentPager 			= "#prc.bbEntryPoint#.comments.pager";
		prc.xehCommentPagerQuickLook	= "#prc.bbEntryPoint#.comments.quickLook";
		prc.xehCommentPagerStatus		= "#prc.bbEntryPoint#.comments.doStatusUpdate";
		prc.xehCommentPagerRemove		= "#prc.bbEntryPoint#.comments.remove";
		
		// prepare paging plugin
		prc.commentPager_pagingPlugin 	= getMyPlugin(plugin="Paging",module="blogbox");
		prc.commentPager_paging 	  	= prc.commentPager_pagingPlugin.getBoundaries();
		prc.commentPager_pagingLink 	= "javascript:commentPagerLink(@page@)";
		prc.commentPager_pagination		= arguments.pagination;
		
		// search entries with filters and all
		var commentResults = commentService.search(entryID=arguments.entryID,
											       offset=prc.commentPager_paging.startRow-1,
											       max=arguments.max);
		prc.commentPager_comments 	     = commentResults.comments;
		prc.commentPager_commentsCount   = commentResults.count;
		
		// incoming entry ID
		prc.commentPager_entryID		= arguments.entryID;
		
		// view pager
		return renderView(view="comments/pager",module="blogbox-admin");
	}
	
	// settings
	function settings(event,rc,prc){
		rc.xehSaveSettings = "#prc.bbEntryPoint#.comments.saveSettings";
		prc.tabComments_settings = true;
		event.setView("comments/settings");
	}
	
	// save settings
	function saveSettings(event,rc,prc){
		
		// announce event
		announceInterception("bbadmin_preCommentSettingsSave",{oldSettings=prc.bbSettings,newSettings=rc});
			
		// bulk save the options
		settingsService.bulkSave(rc);
		
		// announce event
		announceInterception("bbadmin_postCommentSettingsSave");
		
		// relocate back to editor
		getPlugin("MessageBox").info("All comment settings updated!");
		setNextEvent(rc.xehCommentSettings);
	}
}
