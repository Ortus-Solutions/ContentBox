/**
* The main BlogBox engine handler
*/
component singleton{

	// DI
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="authorService"		inject="id:authorService@bb";
	property name="commentService"		inject="id:commentService@bb";

	// pre Handler
	function preHandler(event,action,eventArguments){
		// Determine used layout
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);		
	}

	// Main site page
	function index(event,rc,prc){
		event.setView("home/index");
	}
	
	// Entry site page
	function entry(event,rc,prc){
		
	}
	
	// Entry not found page
	function notFound(event,rc,prc){
		
	}
	
	// Error page
	function onError(event,faultAction,exception,eventArguments){
		
	}

}