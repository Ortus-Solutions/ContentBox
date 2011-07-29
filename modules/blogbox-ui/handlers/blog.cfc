/**
* The main BlogBox engine handler
*/
component singleton{

	// DI
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="authorService"		inject="id:authorService@bb";
	property name="commentService"		inject="id:commentService@bb";
	property name="bbHelper"			inject="coldbox:myplugin:BBHelper@blogbox-ui";

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

	// Main site page
	function index(event,rc,prc){
		// incoming params
		event.paramValue("page",1);
		event.paramValue("category","");
		event.paramValue("q","");
		
		// prepare paging plugin
		prc.pagingPlugin 		= getMyPlugin(plugin="Paging",module="blogbox");
		prc.pagingBoundaries	= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 			= bbHelper.linkHome() & "/page/@page@?";
		
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
	
	// Entry site page
	function entry(event,rc,prc){
		// incoming params
		event.paramValue("entrySlug","");
		
		// Try to retrieve by slug
		prc.entry = entryService.findBySlug(rc.entrySlug);
		
		// Check if loaded, else not found
		if( prc.entry.isLoaded() ){
			// Record hit
			entryService.updateHits( prc.entry );
			// announce event
			announceInterception("bbui_onEntry",{entry=prc.entry,entrySlug=rc.entrySlug});
			// set skin view
			event.setView("#prc.bbLayout#/views/entry");	
		}
		else{
			// announce event
			announceInterception("bbui_onPageNotFound",{entry=prc.entry,entrySlug=rc.entrySlug});
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
		
		// announce event
		announceInterception("bbui_preCommentPost");
		
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
		rc.content 		= antiSamy.htmlSanitizer( trim(rc.content) );
		
		// Validate incoming data
		prc.commentErrors = [];
		if( !len(rc.author) ){ arrayAppend(prc.commentErrors,"Your name is missing!"); }
		if( !len(rc.authorEmail) OR NOT getPlugin("Validator").checkEmail(rc.authorEmail)){ arrayAppend(prc.commentErrors,"Your email is missing or is invalid!"); }
		if( len(rc.authorURL) AND getPlugin("Validator").checkURL(rc.authorURL) ){ arrayAppend(prc.commentErrors,"Your URL is invalid!"); }
		if( !len(rc.content) ){ arrayAppend(prc.commentErrors,"Your URL is invalid!"); }
		
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
		
		// relocate back to comments
		setNextEvent( bbHelper.linkEntry(thisEntry) & "##comments" );		
	}

}