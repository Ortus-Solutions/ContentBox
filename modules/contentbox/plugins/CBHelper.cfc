/**
* This is the ContentBox UI helper class that is injected by the CBRequest interceptor
*/
component extends="coldbox.system.Plugin" accessors="true" singleton{

	// DI
	property name="categoryService"		inject="id:categoryService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="customHTMLService"	inject="id:customHTMLService@cb";

	function init(controller){
		super.init( arguments.controller );

		blogEntryPoint = "blog";
	}

	/************************************** settings *********************************************/

	// get contentbox settings
	function setting(required key,value){
		var prc = getRequestCollection(private=true);

		// return setting if it exists
		if( structKeyExists(prc.cbSettings, arguments.key) ){
			return prc.cbSettings[ key ];
		}
		// default value
		if( structKeyExists(arguments,"value") ){
			return arguments.value;
		}
		// else throw exception
		throw(message="Setting requested: #arguments.key# not found",detail="Settings keys are #structKeyList(prc.cbSettings)#",type="ContentBox.CBHelper.InvalidSetting");
	}

	/**
	* Get custom HTML content pieces by slug
	* @slug The content slug to retrieve
	*/
	function customHTML(required slug){
		var content = customHTMLService.findWhere({slug=arguments.slug});
		if( isNull(content) ){
			throw(message="The content slug '#arguments.slug#' does not exist",type="ContentBox.CBHelper.InvalidCustomHTMLSlug");
		}
		return content.renderContent();
	}

	/************************************** root methods *********************************************/

	// Get the location of your layout in the application, great for assets, cfincludes, etc
	function layoutRoot(){
		var prc = getRequestCollection(private=true);
		return prc.cbLayoutRoot;
	}

	// Get the site root location using your configured module's entry point
	function siteRoot(){
		var prc = getRequestCollection(private=true);
		return prc.cbEntryPoint;
	}

	// Get the admin site root location using the configured module's entry point
	function adminRoot(){
		var prc = getRequestCollection(private=true);
		return prc.cbAdminEntryPoint;
	}

	// Get the name of the current set and active layout
	function layoutName(){
		var prc = getRequestCollection(private=true);
		return prc.cbLayout;
	}

	// Get the location of the widgets in the application, great for assets, cfincludes, etc
	function widgetRoot(){
		var prc = getRequestCollection(private=true);
		return prc.cbWidgetRoot;
	}

	/************************************** site properties *********************************************/

	// Retrieve the site name
	function siteName(){ return setting("cb_site_name"); }
	// Retrieve the site tagline
	function siteTagLine(){ return setting("cb_site_tagline"); }
	// Retrieve the site description
	function siteDescription(){ return setting("cb_site_description"); }
	// Retrieve the site keywords
	function siteKeywords(){ return setting("cb_site_keywords"); }
	// Retrieve the site administrator email
	function siteEmail(){ return setting("cb_site_email"); }
	// Retrieve the site outgoing email
	function siteOutgoingEmail(){ return setting("cb_site_outgoingEmail"); }
	
	/**
	* Determines if site comments are enabled and if the entry accepts comments
	* @content The entry or page content to validate comments also with
	*/
	function isCommentsEnabled(content){
		return ( arguments.content.getAllowComments() AND setting("cb_comments_enabled") );
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

	/************************************** Context Methods *********************************************/

	// Determin if you are in the index view
	boolean function isIndexView(){
		var event = getRequestContext();
		return (event.getCurrentEvent() eq "contentbox-ui:blog.index");
	}
	// Determin if you are in the entry view
	boolean function isEntryView(){
		var event = getRequestContext();
		return (event.getCurrentEvent() eq "contentbox-ui:blog.entry");
	}
	// Determin if you are in the page view
	boolean function isPageView(){
		var event = getRequestContext();
		return (event.getCurrentEvent() eq "contentbox-ui:blog.page");
	}
	// Get the index page entries, else throws exception
	any function getCurrentEntries(){
		var prc = getRequestCollection(private=true);
		if( structKeyExists(prc,"entries") ){ return prc.entries; }
		throw(message="Entries not found in collection",detail="This probably means you are trying to use the entries in an non-index page",type="ContentBox.CBHelper.InvalidEntriesContext");
	}
	// Get the index page entries count, else throws exception
	any function getCurrentEntriesCount(){
		var prc = getRequestCollection(private=true);
		if( structKeyExists(prc,"entriesCount") ){ return prc.entriesCount; }
		throw(message="Entries not found in collection",detail="This probably means you are trying to use the entries in an non-index page",type="ContentBox.CBHelper.InvalidEntriesContext");
	}
	// Get the the blog categories, else throws exception
	any function getCurrentCategories(){
		var prc = getRequestCollection(private=true);
		if( structKeyExists(prc,"categories") ){ return prc.categories; }
		throw(message="Categories not found in collection",detail="Hmm, weird as categories should be available to all blog events",type="ContentBox.CBHelper.InvalidBlogContext");
	}
	// Get the viewed entry if in entry view, else throws exception
	any function getCurrentEntry(){
		var prc = getRequestCollection(private=true);
		if( structKeyExists(prc,"entry") ){ return prc.entry; }
		throw(message="Entry not found in collection",detail="This probably means you are trying to use the entry in an non-entry page",type="ContentBox.CBHelper.InvalidEntryContext");
	}
	// Get the viewed page if in page view, else throws exception
	any function getCurrentPage(){
		var prc = getRequestCollection(private=true);
		if( structKeyExists(prc,"page") ){ return prc.page; }
		throw(message="Page not found in collection",detail="This probably means you are trying to use the page in an non-page page! Redundant huh?",type="ContentBox.CBHelper.InvalidPageContext");
	}
	// Get the viewed page's or entry's comments, else throw exception
	any function getCurrentComments(){
		var prc = getRequestCollection(private=true);
		if( structKeyExists(prc,"comments") ){ return prc.comments; }
		throw(message="Comments not found in collection",detail="This probably means you are trying to use the entry or page comments in an non-entry or non-page page",type="ContentBox.CBHelper.InvalidCommentContext");
	}
	// Get the viewed entry's comments count, else throw exception
	any function getCurrentCommentsCount(){
		var prc = getRequestCollection(private=true);
		if( structKeyExists(prc,"commentsCount") ){ return prc.commentsCount; }
		throw(message="Comments not found in collection",detail="This probably means you are trying to use the entry or page comments in an non-entry or non-page page",type="ContentBox.CBHelper.InvalidCommentContext");
	}
	// Get the missing page, if any
	function getMissingPage(){
		var event = getRequestContext();
		return event.getValue(name="missingPage",private="true",default="");
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
	* Link to the admin logout
	*/
	function linkAdminLogout(){
		return getRequestContext().buildLink(linkto=adminRoot() & "/security/doLogout");
	}

	/**
	* Link to the admin login
	*/
	function linkAdminLogin(){
		return getRequestContext().buildLink(linkto=adminRoot() & "/security/login");
	}

	/**
	* Create a link to your site root or home page entry point for your blog.
	*/
	function linkHome(){
		return getRequestContext().buildLink(linkto=siteRoot());
	}

	/**
	* Create a link to your site blog
	*/
	function linkBlog(){
		return getRequestContext().buildLink(linkto="#siteRoot()#/blog");
	}

	/**
	* Create a link to the current page/entry you are on
	*/
	function linkSelf(){
		//check if we are a page or entry view
		if ( isEntryView() ){
			return linkEntry( getCurrentEntry() );
		}

		return linkPage( getCurrentPage() );
	}

	/**
	* Get the site URL separator
	*/
	private function sep(){
		if( len(siteRoot()) ){ return "."; }
		return "";
	}

	/**
	* Link to RSS feeds that ContentBox generates, by default it is the recent updates feed
	* @category You can optionally pass the category to filter on
	* @comments A boolean flag that determines if you want the comments RSS feed
	* @entry You can optionally pass the entry to filter the comment's RSS feed
	*/
	function linkRSS(category,comments=false,entry){
		var xehRSS = siteRoot() & sep() & "#blogEntryPoint#.rss";

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
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.category/#arguments.category.getSlug()#";
		return getRequestContext().buildLink(linkto=xeh);
	}

	/**
	* Link to a specific filtered archive of entries
	* @year The year of the archive
	* @month The month of the archive
	* @day The day of the archive
	*/
	function linkArchive(year,month,day){
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.archives";
		if( structKeyExists(arguments,"year") ){ xeh &= "/#arguments.year#"; }
		if( structKeyExists(arguments,"month") ){ xeh &= "/#arguments.month#"; }
		if( structKeyExists(arguments,"day") ){ xeh &= "/#arguments.day#"; }
		return getRequestContext().buildLink(linkto=xeh);
	}

	/**
	* Link to the search page for this blog
	*/
	function linkSearch(){
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.search";
		return getRequestContext().buildLink(linkto=xeh);
	}

	/**
	* Link to a specific blog entry's page
	* @entry The entry to link to
	*/
	function linkEntry(entry){
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.#arguments.entry.getSlug()#";
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Link to a specific entry's page using a slug only
	* @slug The entry slug to link to
	*/
	function linkEntryWithSlug(slug){
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.#arguments.slug#";
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Link to a specific content object
	* @content The content object to link to
	*/
	function linkContent(content){
		if( arguments.content.getType() eq "entry" ){ return linkEntry(arguments.content); }
		if( arguments.content.getType() eq "page" ){ return linkPage(arguments.content); }
	}

	/**
	* Link to a specific page
	* @page The page to link to
	*/
	function linkPage(page){
		var xeh = siteRoot() & sep() & "#arguments.page.getSlug()#";
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Link to a specific page using a slug only
	* @slug The page slug to link to
	*/
	function linkPageWithSlug(slug){
		var xeh = siteRoot() & sep() & "#arguments.slug#";
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Create a link to a specific comment in a page or in an entry
	* @comment The comment to link to
	*/
	function linkComment(comment){
		var xeh = "";
		if( arguments.comment.hasPage() ){
			xeh = linkPage( arguments.comment.getPage() );
		}
		else{
			xeh = linkEntry( arguments.comment.getEntry() );
		}
		xeh &= "##comment_#arguments.comment.getCommentID()#";
		return xeh;
	}

	/**
	* Create a link to an entry's or page's comments section
	* @content The entry or page to link to its comments
	*/
	function linkComments(content){
		var xeh = "";
		if( arguments.content.getType() eq "page" ){
			xeh = linkPage( arguments.content );
		}
		else{
			xeh = linkEntry( arguments.content );
		}
		xeh &= "##comments";
		return xeh;
	}

	/**
	* Link to the commenting post action, this is where comments are submitted to
	* @content The entry or page to link to its comments
	*/
	function linkCommentPost(content){

		if( arguments.content.getType() eq "page" ){
			var xeh = siteRoot() & sep() & "__pageCommentPost";
			return getRequestContext().buildLink(linkTo=xeh);
		}

		return linkEntry( arguments.content ) & "/commentPost";
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
		return getMyPlugin(plugin="widgets.#arguments.name#",module="contentbox-ui");
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
		return replace(arrayToList( catList ), ",",", ","all");
	}

	// entry paging
	function quickPaging(){
		var prc = getRequestCollection(private=true);
		if( NOT structKeyExists(prc,"pagingPlugin") ){
			throw(message="Paging plugin is not in the collection",detail="This probably means you are trying to use the paging outside of the main entries index page and that is a No No",type="ContentBox.CBHelper.InvalidPagingContext");
		}
		return prc.pagingPlugin.renderit(prc.entriesCount,prc.pagingLink);
	}

	/*
	* Render out entries in the home page by using our ColdBox collection rendering
	* @template The name of the template to use, by default it looks in the 'templates/entry.cfm' convention, no '.cfm' please
	*/
	function quickEntries(template="entry"){
		var entries = getCurrentEntries();
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=entries,collectionAs="entry");
	}

	/*
	* Render out categories anywhere using ColdBox collection rendering
	* @template The name of the template to use, by default it looks in the 'templates/category.cfm' convention, no '.cfm' please
	*/
	function quickCategories(template="category"){
		var categories = getCurrentCategories();
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=categories,collectionAs="category");
	}

	/*
	* Render out comments anywhere using ColdBox collection rendering
	* @template The name of the template to use, by default it looks in the 'templates/comment.cfm' convention, no '.cfm' please
	*/
	function quickComments(template="comment"){
		var comments = getCurrentComments();
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=comments,collectionAs="comment");
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

		return getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=targetEmail,size=arguments.size);
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
	* quickCommentForm will build a standard ContentBox Comment Form according to the CommentForm widget
	* @content The content this comment form will be linked to, page or entry
	*/
	function quickCommentForm(content){
		return widget("CommentForm",{content=arguments.content});
	}

	/************************************** MENUS *********************************************/

	/**
	* Render out a quick menu for root level pages
	* @excludes The list of pages to exclude from the menu
	* @type The type of menu, valid choices are: ul,ol,li,none
	* @separator Used if type eq none, to separate the list of href's
	*/
	function rootMenu(excludes="",type="ul",separator=""){
		arguments.showNone = false;
		// get root pages
		arguments.pageRecords = pageService.findPublishedPages(parent="",showInMenu=true);
		// build it out
		return buildMenu(argumentCollection=arguments);
	}

	/**
	* Create a sub page menu for a given page or current page
	* @page Optional page to create menu for, else look for current page
	* @excludes The list of pages to exclude from the menu
	* @type The type of menu, valid choices are: ul,ol,li,none
	* @separator Used if type eq none, to separate the list of href's
	* @showNone Shows a 'No Sub Pages' message or not
	*/
	function subPageMenu(any page,excludes="",type="ul",separator="",boolean showNone=true){
		// verify incoming page
		if( !structKeyExists(arguments,"page") ){
			arguments.page = getCurrentPage();
		}
		// get child pages
		arguments.pageRecords = pageService.findPublishedPages(parent=page.getPageID(),showInMenu=true);
		// build it out
		return buildMenu(argumentCollection=arguments);
	}

	/**
	* Create an href to a page's parent
	* @page Optional page to create link for, else look for current page
	* @text The optional text to use for the link, else it uses the page's title
	*/
	function linkToParentPage(page,text=""){
		// verify incoming page
		if( !structKeyExists(arguments,"page") ){
			arguments.page = getCurrentPage();
		}
		// link if parent found.
		if( arguments.page.hasParent() ){
			if( !len(arguments.text) ){ arguments.text = arguments.page.getParent().getTitle(); }
			// build link
			return '<a href="#linkPage( arguments.page.getParent() )#">#arguments.text#</a>';
		}
		return '';
	}

	/**
	* Create breadcrumbs for a page
	* @page Optional page to create link for, else look for current page
	* @separator Breadcrumb separator
	*/
	function breadCrumbs(page,separator=">"){
		// verify incoming page
		if( !structKeyExists(arguments,"page") ){
			arguments.page = getCurrentPage();
		}
		return getMyPlugin(plugin="PageBreadcrumbVisitor",module="contentbox-ui").visit( arguments.page, arguments.separator );

	}

	/************************************** PRIVATE *********************************************/

	private function buildMenu(pageRecords,excludes="",type="ul",separator="",boolean showNone=true){
		// check type?
		if( !reFindNoCase("^(ul|ol|li|none)$", arguments.type) ){ arguments.type="ul"; }
		var pageResults = arguments.pageRecords;
		// buffer
		var b = createObject("java","java.lang.StringBuilder").init('');
		// current page?
		var prc = getRequestCollection(private=true);
		var currentPageID = "";
		if( structKeyExists(prc,"page") and prc.page.isLoaded() ){
			currentPageID = prc.page.getPageID();
		}

		// list start
		if( !listFindNoCase("li,none", arguments.type) ){	b.append('<#arguments.type# class="submenu">'); }
		for(var x=1; x lte pageResults.count; x++ ){
			if( !len(arguments.excludes) OR !listFindNoCase(arguments.excludes, pageResults.pages[x].getTitle() )){
				// class = active?
				if( currentPageID eq pageResults.pages[x].getPageID() ){ classText = ' class="active"'; }else{ classText = ''; }
				// list
				if( arguments.type neq "none"){
					b.append('<li#classText#><a href="#linkPage(pageResults.pages[x])#">#pageResults.pages[x].getTitle()#</a></li>');
				}
				else{
					b.append('<a href="#linkPage(pageResults.pages[x])#"#classText#>#pageResults.pages[x].getTitle()#</a>#arguments.separator#');
				}
			}
		}
		// None?
		if( pageResults.count eq 0 and arguments.showNone ){ b.append("<li>No Sub Pages</li>"); }

		// list end
		if( !listFindNoCase("li,none", arguments.type) ){	b.append('</#arguments.type#>'); }

		// return
		return b.toString();
	}

}