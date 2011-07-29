/**
* This is the BlogBox UI helper class that is injected by the BBRequest interceptor
*/
component extends="coldbox.system.Plugin" accessors="true" singleton{
	
	// DI
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="authorService"		inject="id:authorService@bb";
	property name="commentService"		inject="id:commentService@bb";

	/************************************** settings *********************************************/
	
	// get blogbox settings
	function setting(required key,value){
		var prc = getRequestCollection(private=true);		
		
		// return setting if it exists
		if( structKeyExists(prc.bbSettings, arguments.key) ){
			return prc.bbSettings[ key ];
		}
		// default value
		if( structKeyExists(arguments,"value") ){
			return arguments.value;
		}
		// else throw exception
		throw(message="Setting requested: #arguments.key# not found",detail="Settings keys are #structKeyList(prc.bbSettings)#",type="BlogBox.BBHelper.InvalidSetting");
	}
	
	// custom html
	function customHTML(required slug){
		return setting("bb_html_" & arguments.slug);
	}
	
	/************************************** root methods *********************************************/
	
	// get layout root, where your layout is in the blogbox ui
	function layoutRoot(){
		var prc = getRequestCollection(private=true);		
		return prc.bbLayoutRoot;
	}
	
	// get site root, the defined entry point for your blog via the module configuration  
	function siteRoot(){
		var prc = getRequestCollection(private=true);		
		return prc.bbEntryPoint;
	}
	
	// get the name of the current set and active layout
	function layoutName(){
		var prc = getRequestCollection(private=true);		
		return prc.bbLayout;		
	}
	
	/************************************** site properties *********************************************/

	// site name
	function siteName(){ return setting("bb_site_name"); }
	// site tagline
	function siteTagLine(){ return setting("bb_site_tagline"); }
	// site description
	function siteDescription(){ return setting("bb_site_description"); }
	// site keywords
	function siteKeywords(){ return setting("bb_site_keywords"); }
	// site comments
	function isCommentsEnabled(entry){ 
		return ( arguments.entry.getAllowComments() AND setting("bb_comments_enabled") ); 
	}
	
	/************************************** events *********************************************/
	
	// event announcements, funky for whitespace reasons
	function event(required state,struct data=structNew()) output="true"{announceInterception(arguments.state,arguments.data);}
	
	/************************************** link methods *********************************************/
	
	// get Home Link
	function linkHome(){
		return getRequestContext().buildLink(linkto=siteRoot());
	}
	
	/**
	* Link to RSS feeds that BlogBox generates, by default it is the recent updates feed
	* @category You can optionally pass the category to filter on
	* @comments A boolean flag that determines if you want the comments RSS feed
	* @entry You can optionally pass the entry to filter the comment's RSS feed
	*/
	function linkRSS(category,comments=false,entry){
		var xehRSS = siteRoot() & ".rss";
		
		// do we have a category?
		if( structKeyExists(arguments,"category") ){
			xehRSS &= ".category.#arguments.category.getSlug()#";
			return getRequestContext().buildLink(linkto=xehRSS);
		}	
		
		// comments feed?
		if( arguments.comments ){
			xehRSS &= ".comments";
			// do we have entry filter
			if( structKeyExists(arguments,"entry") ){
				xehRSS &= ".#arguments.entry.getSlug()#";
			}
			return getRequestContext().buildLink(linkto=xehRSS);
		}	
		
		// build link to regular RSS feed
		return getRequestContext().buildLink(linkto=xehRSS);
	}

	
	// get Category Link using the category object
	function linkCategory(category){
		var xehCategory = siteRoot() & "/category/" & arguments.category.getSlug();
		return getRequestContext().buildLink(linkto=xehCategory);
	}
	
	// get Search link
	function linkSearch(){
		var xehSearch = siteRoot() & ".search";
		return getRequestContext().buildLink(linkto=xehSearch);
	}
	
	// get entry link
	function linkEntry(entry){
		var xehEntry = siteRoot() & "/#arguments.entry.getSlug()#";
		return getRequestContext().buildLink(linkTo=xehEntry);
	}
	
	/************************************** quick HTML *********************************************/
	
	/*
	* Create entry category links to be display usually on an entry or entry list.
	* @entry The entry to use to build its category links list.
	*/
	function quickCategoryLinks(required entry){
		var e = arguments.entry;
		
		// check if it has categories
		if( NOT e.hasCategories() ){ return ""; }
		
		var cats 	= e.getCategories();
		var catList = [];
		
		// iterate and create links
		for(var x=1; x lte arrayLen(cats); x++){
			var link = '<a href="#linkCategory(cats[x])#" title="Filter entries by ''#cats[x].getCategory()#''">#cats[x].getCategory()#</a>';
			arrayAppend( catList, link );
		}
		
		// return list of links
		return arrayToList( catList );
	}
	
	// entry paging
	function quickPaging(){
		var prc = getRequestCollection(private=true);		
		if( NOT structKeyExists(prc,"pagingPlugin") ){
			throw(message="Paging plugin is not in the collection",detail="This probably means you are trying to use the paging outside of the main entries index page and that is a No No",type="BlogBox.BBHelper.InvalidPagingContext");
		}
		return prc.pagingPlugin.renderit(prc.entriesCount,prc.pagingLink);
	}
	
	/* 
	* Render out entries in the home page by using our ColdBox collection rendering
	* @template The name of the template to use, by default it looks in the 'templates/entry.cfm' convention, no '.cfm' please
	*/
	function quickEntries(template="entry"){
		var prc = getRequestCollection(private=true);	
		if( NOT structKeyExists(prc,"entries") ){
			throw(message="Entries not found in collection",detail="This probably means you are trying to use the entries display outside of the main entries index page and that is a No No",type="BlogBox.BBHelper.InvalidEntriesContext");
		}	
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=prc.entries,collectionAs="entry");
	}
	
	/* 
	* Render out categories anywhere using ColdBox collection rendering
	* @template The name of the template to use, by default it looks in the 'templates/category.cfm' convention, no '.cfm' please
	*/
	function quickCategories(template="category"){
		var prc = getRequestCollection(private=true);	
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=prc.categories,collectionAs="category");
	}
	
	/* 
	* Render out comments anywhere using ColdBox collection rendering
	* @template The name of the template to use, by default it looks in the 'templates/comment.cfm' convention, no '.cfm' please
	*/
	function quickComments(template="comment"){
		var prc = getRequestCollection(private=true);	
		if( NOT structKeyExists(prc,"entry") ){
			throw(message="Entry not found in collection",detail="This probably means you are trying to use the entry comments display outside of an entry page",type="BlogBox.BBHelper.InvalidEntryContext");
		}
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=prc.entry.getComments(),collectionAs="comment");
	}
	
	/**
	* Renders out an author's avatar
	* @author The author object to render an avatar from
	* @size The size of the gravatar, by default we use 25 pixels
	*/
	function quickAvatar(required author,numeric size=25){
		var targetEmail = arguments.author;
		// check if simple or not
		if( NOT isSimpleValue(arguments.author) ){
			targetEmail = arguments.author.getEmail();
		}
		 
		return getMyPlugin(plugin="Avatar",module="blogbox").renderAvatar(email=targetEmail,size=arguments.size);
	}
	
	/**
	* QuickView is a proxy to ColdBox's renderview method with the addition of prefixing the location of the view according to the 
	* layout you are using. All the arguments are the same as renderView()'s methods
	*/
	function quickView(required view,cache=false,cacheTimeout,cacheLastAccessTimeout,cacheSuffix,module,args,collection,collectionAs,prepostExempt){
		arguments.view = "#layoutName()#/views/#arguments.view#";
		return renderView(argumentCollection=arguments);
	}
	
	/************************************** PRIVATE *********************************************/

}