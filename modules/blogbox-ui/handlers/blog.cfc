/**
* The main BlogBox engine handler
*/
component singleton{

	// DI
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="pageService"			inject="id:pageService@bb";
	property name="authorService"		inject="id:authorService@bb";
	property name="commentService"		inject="id:commentService@bb";
	property name="bbHelper"			inject="id:bbhelper@bb";
	property name="rssService"			inject="rssService@bb";

	// pre Handler
	function preHandler(event,action,eventArguments){
		// Determine used layout
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// set layout
		event.setLayout("#prc.bbLayout#/layout");	
		// Get all categories
		prc.categories = categoryService.list(sortOrder="category desc",asQuery=false);
	}
	
	/**
	* The preview page
	*/
	function preview(event,rc,prc){
		event.paramValue("h","");
		event.paramValue("l","");
		
		var author = getModel("securityService@bb").getAuthorSession();
		// valid Author?
		if( author.isLoaded() AND author.isLoggedIn() AND compareNoCase( hash(author.getAuthorID()), rc.h) EQ 0){
			// Override layouts
			event.setLayout("#rc.l#/layout").overrideEvent("blogbox-ui:blog.index");
			// Place layout on scope
			prc.bbLayout = rc.l;
			// Place layout root location
			prc.bbLayoutRoot = prc.bbRoot & "/layouts/" & rc.l;
			// preview it
			index(argumentCollection=arguments);
		}
		else{
			setNextEvent(URL=bbHelper.linkHome());
		}
	}

	/**
	* The home page
	*/
	function index(event,rc,prc){
		// incoming params
		event.paramValue("page",1);
		event.paramValue("category","");
		event.paramValue("q","");
		
		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="blogbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 			= bbHelper.linkHome() & "?page=@page@";
		
		// Search Paging Link Override?
		if( len(rc.q) ){
			prc.pagingLink = bbHelper.linkHome() & "/search/#rc.q#/@page@?";
		}
		// Category Filter Link Override
		if( len(rc.category) ){
			prc.pagingLink = bbHelper.linkHome() & "/category/#rc.category#/@page@?";
		}
		
		// get published entries
		var entryResults = entryService.findPublishedEntries(offset=prc.pagingBoundaries.startRow-1,
											   				 max=prc.bbSettings.bb_paging_maxentries,
											   				 category=rc.category,
											   				 searchTerm=rc.q);
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;
		
		// announce event
		announceInterception("bbui_onIndex",{entries=prc.entries,entriesCount=prc.entriesCount});
		
		// set skin view
		event.setView("#prc.bbLayout#/views/index");
	}
	
	/**
	* An entry page
	*/
	function entry(event,rc,prc){
		// incoming params
		event.paramValue("entrySlug","");
		
		// Try to retrieve by slug
		prc.entry = entryService.findBySlug(rc.entrySlug);
		
		// Check if loaded, else not found
		if( prc.entry.isLoaded() ){
			// Record hit
			entryService.updateHits( prc.entry );
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(entryID=prc.entry.getEntryID());
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception("bbui_onEntry",{entry=prc.entry,entrySlug=rc.entrySlug});
			// set skin view
			event.setView("#prc.bbLayout#/views/entry");	
		}
		else{
			// announce event
			announceInterception("bbui_onPageNotFound",{entry=prc.entry,entrySlug=rc.entrySlug});
			// missing page
			prc.missingPage = rc.entrySlug;
			// set 404 headers
			event.setHTTPHeader("404","Page not found");
			// set skin not found
			event.setView("#prc.bbLayout#/views/notfound");
		}	
	}
	
	/**
	* An normal page
	*/
	function page(event,rc,prc){
		// incoming params
		event.paramValue("pageSlug","");
		
		// Try to retrieve by slug
		prc.page = pageService.findBySlug(rc.pageSlug);
		
		// Check if loaded, else not found
		if( prc.page.isLoaded() ){
			// Record hit
			pageService.updateHits( prc.page );
			// Retrieve Comments
			// TODO: paging
			var commentResults 	= commentService.findApprovedComments(pageID=prc.page.getPageID());
			prc.comments 		= commentResults.comments;
			prc.commentsCount 	= commentResults.count;
			// announce event
			announceInterception("bbui_onPage",{page=prc.page,pageSlug=rc.pageSlug});
			// set skin view
			event.setView("#prc.bbLayout#/views/page");	
		}
		else{
			// announce event
			announceInterception("bbui_onPageNotFound",{page=prc.page,pageSlug=rc.pageSlug});
			// missing page
			prc.missingPage = rc.pageSlug;
			// set 404 headers
			event.setHTTPHeader("404","Page not found");
			// set skin not found
			event.setView("#prc.bbLayout#/views/notfound");
		}	
	}
	
	/*
	* Error Pages
	*/
	function onError(event,faultAction,exception,eventArguments){
		// Determine used layout
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		
		// store exceptions
		prc.faultAction = arguments.faultAction;
		prc.exception   = arguments.exception;
		
		// announce event
		announceInterception("bbui_onError",{faultAction=arguments.faultAction,exception=arguments.exception,eventArguments=arguments.eventArguments});
			
		// Set view to render
		event.setView("#prc.bbLayout#/views/error");
	}

	/**
	* Comment Form Post
	*/
	function commentPost(event,rc,prc){
		// param values
		event.paramValue("entryID","");
		event.paramValue("author","");
		event.paramValue("authorURL","");
		event.paramValue("authorEmail","");
		event.paramValue("content","");
		event.paramValue("captchacode","");
		
		// check if entry id is empty
		if( !len(rc.entryID) ){
			setNextEvent(prc.bbEntryPoint);
		}
		
		// Retrieve entry
		var thisEntry = entryService.get(rc.entryID);
		// If null, kick them out
		if( isNull(thisEntry) ){ setNextEvent(prc.bbEntryPoint); }
		// Check if comments enabled? else kick them out, who knows how they got here
		if( NOT bbHelper.isCommentsEnabled( thisEntry ) ){
			getPlugin("MessageBox").warn("Comments are disabled!");
			setNextEvent(bbHelper.linkEntry( thisEntry ));
		}
		
		// Trim values & XSS Cleanup of fields
		var antiSamy 	= getPlugin("AntiSamy");
		rc.author 		= antiSamy.htmlSanitizer( trim(rc.author) );
		rc.authorEmail 	= antiSamy.htmlSanitizer( trim(rc.authorEmail) );
		rc.authorURL 	= antiSamy.htmlSanitizer( trim(rc.authorURL) );
		rc.captchacode 	= antiSamy.htmlSanitizer( trim(rc.captchacode) );
		rc.content 		= antiSamy.htmlSanitizer( xmlFormat(trim(rc.content)) );
		
		// Validate incoming data
		prc.commentErrors = [];
		if( !len(rc.author) ){ arrayAppend(prc.commentErrors,"Your name is missing!"); }
		if( !len(rc.authorEmail) OR NOT getPlugin("Validator").checkEmail(rc.authorEmail)){ arrayAppend(prc.commentErrors,"Your email is missing or is invalid!"); }
		if( len(rc.authorURL) AND getPlugin("Validator").checkURL(rc.authorURL) ){ arrayAppend(prc.commentErrors,"Your URL is invalid!"); }
		if( !len(rc.content) ){ arrayAppend(prc.commentErrors,"Your URL is invalid!"); }
		
		// Captcha Validation
		if( prc.bbSettings.bb_comments_captcha AND NOT getMyPlugin(plugin="Captcha",module="blogbox").validate( rc.captchacode ) ){
			ArrayAppend(prc.commentErrors, "Invalid security code. Please try again.");
		}
		
		// announce event
		announceInterception("bbui_preCommentPost",{commentErrors=prc.commentErrors,entry=thisEntry});
		
		// Validate if comment errors exist
		if( arrayLen(prc.commentErrors) ){
			// put slug in request
			rc.entrySlug = thisEntry.getSlug();
			// MessageBox
			getPlugin("MessageBox").warn(messageArray=prc.commentErrors);
			// Execute entry again, need to correct form
			entry(argumentCollection=arguments);
			return;			
		}
		
		// Get new comment to persist
		var comment = populateModel( commentService.new() );
		comment.setEntry( thisEntry );
		
		// Data is valid, let's send it to the comment service for persistence, translations, etc
		var results = commentService.saveComment( comment );
		
		// announce event
		announceInterception("bbui_onCommentPost",{comment=comment,entry=thisEntry,moderationResults=results});
		
		// Check if all good
		if( results.moderated ){
			// Message
			getPlugin("MessageBox").warn(messageArray=results.messages);
			flash.put(name="commentErrors",value=results.messages,inflateTOPRC=true);
			// relocate back to comment
			setNextEvent(URL=bbHelper.linkEntry(thisEntry) & "##comments" );	
		}
		else{
			// relocate back to comment
			setNextEvent(URL=bbHelper.linkEntry(thisEntry) & "##comment_#comment.getCommentID()#");		
		}		
	}

	/**
	* Display the RSS feeds
	*/
	function rss(event,rc,prc){
		// params
		event.paramValue("category","");
		event.paramValue("entrySlug","");
		event.paramValue("commentRSS",false);
		
		// Build out the RSS feeds
		var feed = RSSService.getRSS(comments=rc.commentRSS,category=rc.category,entrySlug=rc.entrySlug);
		
		// Render out the feed xml
		event.renderData(type="plain",data=feed,contentType="text/xml");
	}

}