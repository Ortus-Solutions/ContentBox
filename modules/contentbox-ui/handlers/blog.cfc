/**
* The main ContentBox engine handler
*/
component singleton{

	// DI
	property name="categoryService"		inject="id:categoryService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="rssService"			inject="rssService@cb";

	// pre Handler
	function preHandler(event,action,eventArguments){
		// Determine used layout
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		
		// set blog layout
		event.setLayout("#prc.cbLayout#/layouts/blog");
		// Get all categories
		prc.categories = categoryService.list(sortOrder="category desc",asQuery=false);
		
		// Home page determination
		if( event.getCurrentRoute() eq "/" AND prc.cbSettings.cb_site_homepage neq "cbBlog"){
			event.overrideEvent("contentbox-ui:blog.page");
			rc.pageSlug = prc.cbSettings.cb_site_homepage;
		}
	}
	
	/**
	* The preview page
	*/
	function preview(event,rc,prc){
		event.paramValue("h","");
		event.paramValue("l","");
		
		var author = getModel("securityService@cb").getAuthorSession();
		// valid Author?
		if( author.isLoaded() AND author.isLoggedIn() AND compareNoCase( hash(author.getAuthorID()), rc.h) EQ 0){
			// Override layouts
			event.setLayout("#rc.l#/layouts/blog").overrideEvent("contentbox-ui:blog.index");
			// Place layout on scope
			prc.cbLayout = rc.l;
			// Place layout root location
			prc.cbLayoutRoot = prc.cbRoot & "/layouts/" & rc.l;
			// preview it
			index(argumentCollection=arguments);
		}
		else{
			setNextEvent(URL=CBHelper.linkHome());
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
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 			= CBHelper.linkHome() & "?page=@page@";
		
		// Search Paging Link Override?
		if( len(rc.q) ){
			prc.pagingLink = CBHelper.linkHome() & "/search/#rc.q#/@page@?";
		}
		// Category Filter Link Override
		if( len(rc.category) ){
			prc.pagingLink = CBHelper.linkHome() & "/category/#rc.category#/@page@?";
		}
		
		// get published entries
		var entryResults = entryService.findPublishedEntries(offset=prc.pagingBoundaries.startRow-1,
											   				 max=prc.cbSettings.cb_paging_maxentries,
											   				 category=rc.category,
											   				 searchTerm=rc.q);
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;
		
		// announce event
		announceInterception("cbui_onIndex",{entries=prc.entries,entriesCount=prc.entriesCount});
		
		// set skin view
		event.setView("#prc.cbLayout#/views/index");
	}
	
	/**
	* The archives
	*/
	function archives(event,rc,prc){
		// incoming params
		event.paramValue("page",1);
		// archived params
		event.paramValue("year","0");
		event.paramValue("month","0");
		event.paramValue("day","0");
		
		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 			= CBHelper.linkHome() & event.getCurrentRoutedURL() & "?page=@page@";
		
		// get published entries
		var entryResults = entryService.findPublishedEntriesByDate(year=rc.year,
											   				  	   month=rc.month,
											   				 	   day=rc.day,
											   				 	   offset=prc.pagingBoundaries.startRow-1,
											   					   max=prc.cbSettings.cb_paging_maxentries);
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;
		
		// announce event
		announceInterception("cbui_onArchives",{entries=prc.entries,entriesCount=prc.entriesCount});
		
		// set skin view
		event.setView("#prc.cbLayout#/views/archives");
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
			announceInterception("cbui_onEntry",{entry=prc.entry,entrySlug=rc.entrySlug});
			// set skin view
			event.setView("#prc.cbLayout#/views/entry");	
		}
		else{
			// announce event
			announceInterception("cbui_onEntryNotFound",{entry=prc.entry,entrySlug=rc.entrySlug});
			// missing page
			prc.missingPage = rc.entrySlug;
			// set 404 headers
			event.setHTTPHeader("404","Entry not found");
			// set skin not found
			event.setView("#prc.cbLayout#/views/notfound");
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
			announceInterception("cbui_onPage",{page=prc.page,pageSlug=rc.pageSlug});
			// set skin view
			event.setView(view="#prc.cbLayout#/views/page",layout="#prc.cbLayout#/layouts/#prc.page.getLayout()#");
		}
		else{
			// announce event
			announceInterception("cbui_onPageNotFound",{page=prc.page,pageSlug=rc.pageSlug});
			// missing page
			prc.missingPage = rc.pageSlug;
			// set 404 headers
			event.setHTTPHeader("404","Page not found");
			// set skin not found
			event.setView(view="#prc.cbLayout#/views/notfound",layout="#prc.cbLayout#/layouts/pages");
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
		announceInterception("cbui_onError",{faultAction=arguments.faultAction,exception=arguments.exception,eventArguments=arguments.eventArguments});
			
		// Set view to render
		event.setView("#prc.cbLayout#/views/error");
	}

	/**
	* Comment Form Post
	*/
	function commentPost(event,rc,prc){
		// param values
		event.paramValue("contentID","");
		event.paramValue("contentType","blog");
		event.paramValue("author","");
		event.paramValue("authorURL","");
		event.paramValue("authorEmail","");
		event.paramValue("content","");
		event.paramValue("captchacode","");
		
		// check if entry id is empty
		if( !len(rc.contentID) ){
			setNextEvent(prc.cbEntryPoint);
		}
		
		var thisContent = "";
		// entry or page
		switch(rc.contenttype){
			case "page" : {
				thisContent = pageService.get( rc.contentID ); break;
			}
			default: {
				thisContent = entryService.get( rc.contentID ); break;
			}
		}
		// If null, kick them out
		if( isNull(thisContent) ){ setNextEvent(prc.cbEntryPoint); }
		// Check if comments enabled? else kick them out, who knows how they got here
		if( NOT CBHelper.isCommentsEnabled( thisContent ) ){
			getPlugin("MessageBox").warn("Comments are disabled!");
			setNextEvent(CBHelper.linkContent( thisContent ));
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
		if( prc.cbSettings.cb_comments_captcha AND NOT getMyPlugin(plugin="Captcha",module="contentbox").validate( rc.captchacode ) ){
			ArrayAppend(prc.commentErrors, "Invalid security code. Please try again.");
		}
		
		// announce event
		announceInterception("cbui_preCommentPost",{commentErrors=prc.commentErrors,content=thisContent,contentType=rc.contentType});
		
		// Validate if comment errors exist
		if( arrayLen(prc.commentErrors) ){
			// MessageBox
			getPlugin("MessageBox").warn(messageArray=prc.commentErrors);
			// Execute event again
			if( thisContent.getType() eq "entry" ){
				// put slug in request
				rc.entrySlug = thisContent.getSlug();
				// Execute entry again, need to correct form
				entry(argumentCollection=arguments);
			}
			else{
				// put slug in request
				rc.pageSlug = thisContent.getSlug();
				// Execute entry again, need to correct form
				page(argumentCollection=arguments);
			}
			return;			
		}
		
		// Get new comment to persist
		var comment = populateModel( commentService.new() ).setRelatedContent( thisContent );
		// Data is valid, let's send it to the comment service for persistence, translations, etc
		var results = commentService.saveComment( comment );
		
		// announce event
		announceInterception("cbui_onCommentPost",{comment=comment,content=thisContent,moderationResults=results,contentType=rc.contentType});
		
		// Check if all good
		if( results.moderated ){
			// Message
			getPlugin("MessageBox").warn(messageArray=results.messages);
			flash.put(name="commentErrors",value=results.messages,inflateTOPRC=true);
			// relocate back to comments
			setNextEvent(URL=CBHelper.linkComments(thisContent));	
		}
		else{
			// relocate back to comment
			setNextEvent(URL=CBHelper.linkComment(comment));		
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