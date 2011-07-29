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
		
		// set skin view
		event.setView("#prc.bbLayout#/views/index");
	}
	
	// Entry site page
	function entry(event,rc,prc){
		
	}
	
	// Entry not found page
	function notFound(event,rc,prc){
		
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
		
		// Set view to render
		event.setView("#prc.bbLayout#/views/error");
	}

}