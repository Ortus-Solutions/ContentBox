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

}