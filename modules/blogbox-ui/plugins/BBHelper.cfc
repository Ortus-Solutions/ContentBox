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
	
	// Get the location of your layout in the application, great for assets, cfincludes, etc
	function layoutRoot(){
		var prc = getRequestCollection(private=true);		
		return prc.bbLayoutRoot;
	}
	
	// Get the site root location using your configured module's entry point  
	function siteRoot(){
		var prc = getRequestCollection(private=true);		
		return prc.bbEntryPoint;
	}
	
	// Get the admin site root location using the configured module's entry point
	function adminRoot(){
		var prc = getRequestCollection(private=true);
		return prc.bbAdminEntryPoint;
	}
	
	// Get the name of the current set and active layout
	function layoutName(){
		var prc = getRequestCollection(private=true);		
		return prc.bbLayout;		
	}
	
	/************************************** site properties *********************************************/

	// Retrieve the site name
	function siteName(){ return setting("bb_site_name"); }
	// Retrieve the site tagline
	function siteTagLine(){ return setting("bb_site_tagline"); }
	// Retrieve the site description
	function siteDescription(){ return setting("bb_site_description"); }
	// Retrieve the site keywords
	function siteKeywords(){ return setting("bb_site_keywords"); }
	
	/** 
	* Determines if site comments are enabled and if the entry accepts comments
	* @entry The entry to validate comments also with
	*/
	function isCommentsEnabled(entry){ 
		return ( arguments.entry.getAllowComments() AND setting("bb_comments_enabled") ); 
	}
	// determines if a comment form error has ocurred
	function isCommentFormError(){
		var prc = getRequestCollection(private=true);		
		if( structKeyExists(prc,"commentErrors") ){
			return true;
		}
		return false;
	}
	
	// get comment errors array, usually when the form elements did not validate
	array function getCommentErrors(){
		var prc = getRequestCollection(private=true);		
		if( structKeyExists(prc,"commentErrors") ){
			return prc.commentErrors;
		}
		return arrayNew(1);
	}
	
	/************************************** events *********************************************/
	
	// event announcements, funky for whitespace reasons
	function event(required state,struct data=structNew()) output="true"{announceInterception(arguments.state,arguments.data);}
	
	/************************************** link methods *********************************************/
	
	/**
	* Link to the admin
	* event An optional event to link to
	*/
	function linkAdmin(event=""){
		return getRequestContext().buildLink(linkto=adminRoot() & ".#arguments.event#");
	}
	
	/**
	* Create a link to your site root or home page entry point for your blog.
	*/
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
	
	/**
	* Link to a specific filtered category view of blog entries
	* @category The category object to link to
	*/
	function linkCategory(category){
		var xeh = siteRoot() & "/category/" & arguments.category.getSlug();
		return getRequestContext().buildLink(linkto=xeh);
	}
	
	/**
	* Link to the search page for this blog
	*/
	function linkSearch(){
		var xeh = siteRoot() & ".search";
		return getRequestContext().buildLink(linkto=xeh);
	}
	
	/**
	* Link to a specific entry's page
	* @entry The entry to link to
	*/
	function linkEntry(entry){
		var xeh = siteRoot() & "/#arguments.entry.getSlug()#";
		return getRequestContext().buildLink(linkTo=xeh);
	}
	
	/**
	* Create a link to a specific comment
	* @comment The comment to link to
	*/
	function linkComment(comment){
		var xeh = linkEntry( arguments.comment.getEntry() ) & "##comment_#arguments.comment.getCommentID()#";
		return xeh;
	}
	
	/**
	* Create a link to an entry's comments section
	* @entry The entry to link to its comments
	*/
	function linkComments(entry){
		var xeh = linkEntry( arguments.entry ) & "##comments";
		return xeh;
	}
	
	/**
	* Link to the commenting post action, this is where comments are submitted to
	*/
	function linkCommentPost(){
		var xeh = siteRoot() & "/commentPost";
		return getRequestContext().buildLink(linkTo=xeh);
	}
	
	/************************************** widget functions *********************************************/
	
	/**
	* Execute a widget's renderit method
	* @name The name of the installed widget to execute
	* @args The argument collection to pass to the widget's renderIt() method
	*/
	function widget(required name,struct args=structnew()){
		return getWidget(arguments.name).renderit(argumentCollection=arguments.args);
	}
	
	/**
	* Return a widget object
	* @name The name of the installed widget to return
	*/
	function getWidget(required name){
		return getMyPlugin(plugin="widgets.#arguments.name#",module="blogbox-ui");
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
		if( NOT structKeyExists(prc,"comments") ){
			throw(message="Comments not found in collection",detail="This probably means you are trying to use the entry comments display outside of an entry page",type="BlogBox.BBHelper.InvalidCommentContext");
		}
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=prc.comments,collectionAs="comment");
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
	
	/**
	* quickCommentForm will build a standard BlogBox Comment Form according to the CommentForm widget
	* @entry The entry this comment form will be linked to
	*/
	function quickCommentForm(entry){
		return widget("CommentForm",{entry=arguments.entry});
	}
	
	/************************************** PRIVATE *********************************************/

}