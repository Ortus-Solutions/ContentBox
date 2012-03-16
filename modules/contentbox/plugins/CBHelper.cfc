/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
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

	// get contentbox version
	function getContentBoxVersion(){
		return getModuleSettings("contentbox").version;
	}
	// get contentbox codename
	function getContentBoxCodeName(){
		return getModuleSettings("contentbox").settings.codename;
	}
	// get contentbox codename URL
	function getContentBoxCodeNameURL(){
		return getModuleSettings("contentbox").settings.codenameLink;
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

	// Get the site base SES URL
	function siteBaseURL(){
		return replacenocase( getRequestContext().getSESBaseURL(), "index.cfm", "");
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
		if( structKeyExists(arguments,"content") ){
			return ( arguments.content.getAllowComments() AND setting("cb_comments_enabled") );
		}
		return ( setting("cb_comments_enabled") );
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

	// Determine if you have a category filter
	boolean function categoryFilterExists(){
		var rc = getRequestCollection();
		return (structKeyExists(rc,"category") AND len(rc.category));
	}
	// Get Category Filter
	function getCategoryFilter(){
		return getRequestContext().getValue("category","");
	}

	// Get Year Filter
	function getYearFilter(){
		return getRequestContext().getValue("year","0");
	}
	// Get Month Filter
	function getMonthFilter(){
		return getRequestContext().getValue("month","0");
	}
	// Get Day Filter
	function getDayFilter(){
		return getRequestContext().getValue("day","0");
	}

	// Determine if you are in the blog
	boolean function isBlogView(){
		if( isIndexView() OR isEntryView() OR isArchivesView() ){
			return true;
		}
		return false;
	}
	// Determine if you are in the archives view
	boolean function isArchivesView(){
		var event = getRequestContext();
		return (event.getCurrentEvent() eq "contentbox-ui:blog.archives" AND event.valueExists("entry",true) );
	}
	// Determine if you are in the index view
	boolean function isIndexView(){
		var event = getRequestContext();
		return (event.getCurrentEvent() eq "contentbox-ui:blog.index");
	}
	// Determine if you are in the entry view
	boolean function isEntryView(){
		var event = getRequestContext();
		return (event.getCurrentEvent() eq "contentbox-ui:blog.entry" AND event.valueExists("entry",true) );
	}
	/**
	* Determine if you are in the page view
	* @page.hint Optional page slug to determine if you are in that page or not.
	*/
	boolean function isPageView(page=""){
		var event = getRequestContext();
		if( findNoCase("contentbox-ui:page", event.getCurrentEvent() ) AND event.valueExists("page",true) ){
			// slug check
			if( len(arguments.page) AND getCurrentPage().getSlug() eq arguments.page ){
				return true;
			}
			else if( !len(arguments.page) ){
				return true;
			}
			return false;
		}
		return false;
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
	any function getMissingPage(){
		var event = getRequestContext();
		return event.getValue(name="missingPage",private="true",default="");
	}
	// Get Home Page slug set up by the administrator.  If the page slug equals 'blog', then it means the blog is your home page
	any function getHomePage(){
		return setting("cb_site_homepage");
	}
	// Get the current page's or blog entrie's custom fields as a struct
	struct function getCurrentCustomFields(){
		var fields = "";
		if( isPageView() ){
			fields = getCurrentPage().getCustomFields();
		}
		else{
			fields = getCurrentEntry().getCustomFields();
		}
		var results = {};
		for(var thisField in fields){
			results[ thisField.getKey() ] = thisField.getValue();
		}
		return results;
	}
	// Get a current page's or blog entrie's custom field by key, you can pass a default value if not found
	any function getCustomField(required key, defaultValue){
		var fields = getCurrentCustomFields();
		if( structKeyExists( fields, arguments.key ) ){
			return fields[arguments.key];
		}
		if( structKeyExists(arguments,"defaultValue") ){
			return arguments.defaultValue;
		}
		throw(message="No custom field with key: #arguments.key# found",detail="The keys are #structKeyList(fields)#",type="CBHelper.InvalidCustomField");
	}

	/************************************** search *********************************************/

	// Determine if you are in the search view
	boolean function isSearchView(){
		var event = getRequestContext();
		return (event.getCurrentEvent() eq "contentbox-ui:page.search");
	}

	/**
	* quickSearchForm will build a standard ContentBox Content Search Form according to the SearchForm widget
	*/
	function quickSearchForm(){
		return widget("SearchForm",{type="content"});
	}

	/**
	* Render out paging for search content
	*/
	function quickSearchPaging(){
		var prc = getRequestCollection(private=true);
		if( NOT structKeyExists(prc,"pagingPlugin") ){
			throw(message="Paging plugin is not in the collection",detail="This probably means you are trying to use the paging outside of the search results page and that is a No No",type="ContentBox.CBHelper.InvalidPagingContext");
		}
		return prc.pagingPlugin.renderit( getSearchResults().getTotal(), prc.pagingLink);
	}

	// get the curent search results object
	contentbox.model.search.SearchResults function getSearchResults(){
		var event = getRequestContext();
		return event.getValue(name="searchResults",private="true",default="");
	}

	// get the curent search results HTML content
	any function getSearchResultsContent(){
		var event = getRequestContext();
		return event.getValue(name="searchResultsContent",private="true",default="");
	}

	// Determine if you have a search term
	boolean function searchTermExists(){
		var rc = getRequestCollection();
		return (structKeyExists(rc,"q") AND len(rc.q));
	}

	// Get Search Term
	function getSearchTerm(){
		return getRequestContext().getValue("q","");
	}

	/************************************** events *********************************************/

	// event announcements, funky for whitespace reasons
	function event(required state,struct data=structNew()) output="true"{announceInterception(arguments.state,arguments.data);}

	/************************************** link methods *********************************************/

	/**
	* Build out ContentBox module links
	* @module.hint The module to link this URL to
	* @linkTo.hint The handler action combination to link to
	* @queryString.hint The query string to append in SES format
	* @ssl.hint Create the link in SSL or not
	*/
	function buildModuleLink(required string module, required string linkTo, queryString="", boolean ssl=false){
		return getRequestContext().buildLink(linkto=adminRoot() & ".module.#arguments.module#.#arguments.linkTo#",queryString=arguments.queryString,ssl=arguments.ssl);
	}

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
		return getRequestContext().buildLink(linkto="#siteRoot()##sep()#blog");
	}

	/**
	* Create a link to the current page/entry you are on
	*/
	function linkSelf(){
		return "#cgi.script_name##cgi.path_info#";
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
	* Link to the ContentBox Site RSS Feeds
	* @category.hint The category to filter on
	* @comments.hint Do comments RSS feeds
	* @slug.hint The content slug to filter on when using comments
	*/
	function linkSiteRSS(any category, boolean comments=false, string slug){
		var xehRSS = siteRoot() & sep() & "__rss";

		// do we have a category?
		if( structKeyExists(arguments,"category") ){

			if( isSimpleValue(arguments.category) ){
				xehRSS &= "/category/#arguments.category#";
			}
			else{
				xehRSS &= "/category/#arguments.category.getSlug()#";
			}

			return getRequestContext().buildLink(linkto=xehRSS);
		}

		// comments feed?
		if( arguments.comments ){
			xehRSS &= "/comments";
			// do we have content filter
			if( structKeyExists(arguments,"slug") ){
				xehRSS &= "/#arguments.slug#";
			}
			return getRequestContext().buildLink(linkto=xehRSS);
		}

		// build link to regular ContentBox RSS feed
		return getRequestContext().buildLink(linkto=xehRSS);
	}

	/**
	* Link to the ContentBox Page RSS Feeds
	* @category.hint The category to filter on
	* @comments.hint Page comments or not, defaults to false
	* @page.hint The page you want to filter on
	*/
	function linkPageRSS(any category, boolean comments=false, page){
		var xehRSS = siteRoot() & sep() & "__rss/pages";

		// do we have a category?
		if( structKeyExists(arguments,"category") ){

			if( isSimpleValue(arguments.category) ){
				xehRSS &= "/category/#arguments.category#";
			}
			else{
				xehRSS &= "/category/#arguments.category.getSlug()#";
			}

			return getRequestContext().buildLink(linkto=xehRSS);
		}

		// comments feed?
		if( arguments.comments ){
			xehRSS &= "/comments";
			// do we have content filter
			if( structKeyExists(arguments,"page") ){
				xehRSS &= "/#arguments.page.getSlug()#";
			}
			return getRequestContext().buildLink(linkto=xehRSS);
		}

		// build link to regular ContentBox RSS feed
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
	* Link to the search route for this blog
	*/
	function linkSearch(){
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.search";
		return getRequestContext().buildLink(linkto=xeh);
	}

	/**
	* Link to the content search route
	*/
	function linkContentSearch(){
		var xeh = siteRoot() & sep() & "__search";
		return getRequestContext().buildLink(linkto=xeh);
	}

	/**
	* Link to a specific blog entry's page
	* @entry The entry to link to
	*/
	function linkEntry(entry){
		if( isSimpleValue(arguments.entry) ){
			return linkEntryWithSlug( arguments.entry );
		}
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.#arguments.entry.getSlug()#";
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Link to a specific entry's page using a slug only
	* @slug The entry slug to link to
	*/
	function linkEntryWithSlug(slug){
		arguments.slug = reReplace( arguments.slug, "^/","" );
		var xeh = siteRoot() & sep() & "#blogEntryPoint#.#arguments.slug#";
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Link to a specific content object
	* @content The content object to link to
	*/
	function linkContent(content){
		if( arguments.content.getContentType() eq "entry" ){ return linkEntry(arguments.content); }
		if( arguments.content.getContentType() eq "page" ){ return linkPage(arguments.content); }
	}

	/**
	* Link to a specific page
	* @page The page to link to
	*/
	function linkPage(page){
		if( isSimpleValue(arguments.page) ){
			return linkPageWithSlug( arguments.page );
		}
		var xeh = siteRoot() & arguments.page.getSlug();
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Link to a specific page using a slug only
	* @slug The page slug to link to
	*/
	function linkPageWithSlug(slug){
		arguments.slug = reReplace( arguments.slug, "^/","" );
		var xeh = siteRoot() & sep() & "#arguments.slug#";
		return getRequestContext().buildLink(linkTo=xeh);
	}

	/**
	* Create a link to a specific comment in a page or in an entry
	* @comment The comment to link to
	*/
	function linkComment(comment){
		var xeh = "";
		if( arguments.comment.getRelatedContent().getContentType() eq 'page' ){
			xeh = linkPage( arguments.comment.getRelatedContent() );
		}
		else{
			xeh = linkEntry( arguments.comment.getRelatedContent() );
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
		if( arguments.content.getContentType() eq "page" ){
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

		if( arguments.content.getContentType() eq "page" ){
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
		var layoutWidgetPath = layoutRoot() & "/widgets/#arguments.name#.cfc";

		// layout widget overrides
		if( fileExists( expandPath( layoutWidgetPath ) ) ){
			var widgetCreationPath = replace( reReplace(layoutRoot(),"^/","")  ,"/",".","all") & ".widgets.#arguments.name#";
			return controller.getPlugin(plugin=widgetCreationPath,customPlugin=true);
		}

		// return core contentbox widget instead
		return getMyPlugin(plugin="widgets.#arguments.name#",module="contentbox-ui");
	}

	/************************************** quick HTML *********************************************/

	/*
	* Create entry category links to be display usually on an entry or entry list.
	* @entry.hint The entry to use to build its category links list.
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

	/**
	* Render out paging for blog entries
	*/
	function quickPaging(){
		var prc = getRequestCollection(private=true);
		if( NOT structKeyExists(prc,"pagingPlugin") ){
			throw(message="Paging plugin is not in the collection",detail="This probably means you are trying to use the paging outside of the main entries index page and that is a No No",type="ContentBox.CBHelper.InvalidPagingContext");
		}
		return prc.pagingPlugin.renderit(prc.entriesCount,prc.pagingLink);
	}

	/**
	* Render out entries in the home page by using our ColdBox collection rendering
	* @template.hint The name of the template to use, by default it looks in the 'templates/entry.cfm' convention, no '.cfm' please
	* @collectionAs.hint The name of the iterating object in the template, by default it is called 'entry'
	* @args.hint A structure of name-value pairs to pass to the template
	*/
	function quickEntries(template="entry",collectionAs="entry",args=structnew()){
		var entries = getCurrentEntries();
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=entries,collectionAs=arguments.collectionAs,args=arguments.args);
	}

	/**
	* Render out an entry using your pre-defined 'entry' template
	* @template.hint The name of the template to use, by default it looks in the 'templates/entry.cfm' convention, no '.cfm' please
	* @collectionAs.hint The name of the iterating object in the template, by default it is called 'entry'
	* @args.hint A structure of name-value pairs to pass to the template
	*/
	function quickEntry(template="entry",collectionAs="entry",args=structnew()){
		var entries = [getCurrentEntry()];
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=entries,collectionAs=arguments.collectionAs,args=arguments.args);
	}

	/**
	* Render out categories anywhere using ColdBox collection rendering
	* @template.hint The name of the template to use, by default it looks in the 'templates/category.cfm' convention, no '.cfm' please
	* @collectionAs.hint The name of the iterating object in the template, by default it is called 'category'
	* @args.hint A structure of name-value pairs to pass to the template
	*/
	function quickCategories(template="category",collectionAs="category",args=structnew()){
		var categories = getCurrentCategories();
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=categories,collectionAs=arguments.collectionAs,args=arguments.args);
	}

	/**
	* Render out custom fields for the current content
	*/
	function quickCustomFields(){
		var customFields = getCurrentCustomFields();
		var content = "";

		savecontent variable="content"{
			writeOutput("<ul class='customFields'>");
			for(var thisField in customFields){
				writeOutput("<li><span class='customField-key'>#thisField#:</span> #customFields[thisField]#</li>");
			}
			writeOutput("</ul>");
		}

		return content;
	}

	/**
	* Render out comments anywhere using ColdBox collection rendering
	* @template.hint The name of the template to use, by default it looks in the 'templates/comment.cfm' convention, no '.cfm' please
	* @collectionAs.hint The name of the iterating object in the template, by default it is called 'comment'
	* @args.hint A structure of name-value pairs to pass to the template
	*/
	function quickComments(template="comment",collectionAs="comment",args=structNew()){
		var comments = getCurrentComments();
		return renderView(view="#layoutName()#/templates/#arguments.template#",collection=comments,collectionAs=arguments.collectionAs,args=arguments.args);
	}

	/**
	* Renders out an author's avatar
	* @author.hint The author object to render an avatar from
	* @size.hint The size of the gravatar, by default we use 25 pixels
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
	* layout theme you are using. All the arguments are the same as renderView()'s methods
	*/
	function quickView(required view,cache=false,cacheTimeout,cacheLastAccessTimeout,cacheSuffix,module,args,collection,collectionAs,prepostExempt){
		arguments.view = "#layoutName()#/views/#arguments.view#";
		return renderView(argumentCollection=arguments);
	}

	/**
	* QuickLayout is a proxy to ColdBox's renderLayout method with the addition of prefixing the location of the layout according to the
	* layout theme you are using. All the arguments are the same as renderLayout()'s methods
	*/
	function quickLayout(required layout,view="",module="",args=structNew(),viewModule="",prePostExempt=false){
		arguments.layout = "#layoutName()#/layouts/#arguments.layout#";
		return renderLayout(argumentCollection=arguments);
	}

	/**
	* quickCommentForm will build a standard ContentBox Comment Form according to the CommentForm widget
	* @content.hint The content this comment form will be linked to, page or entry
	*/
	function quickCommentForm(required content){
		return widget("CommentForm",{content=arguments.content});
	}

	/**
	* Render the incoming event's main view, basically a proxy to ColdBox's renderView().
	*/
	function mainView(){
		return renderView(view="");
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
	* @page Optional page to create menu for, else look for current page, this can be a page object or a page slug
	* @excludes The list of pages to exclude from the menu
	* @type The type of menu, valid choices are: ul,ol,li,none
	* @separator Used if type eq none, to separate the list of href's
	* @showNone Shows a 'No Sub Pages' message or not
	*/
	function subPageMenu(any page,excludes="",type="ul",separator="",boolean showNone=true){
		// If page not passed, then use current
		if( !structKeyExists(arguments,"page") ){
			arguments.page = getCurrentPage();
		}

		// Is page passed as slug or object
		if( isSimpleValue(arguments.page) ){
			// retrieve page by slug
			arguments.page = pageService.findBySlug( arguments.page );
		}

		// get child pages
		arguments.pageRecords = pageService.findPublishedPages(parent=page.getContentID(),showInMenu=true);
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
		var currentcontentID = "";
		if( structKeyExists(prc,"page") and prc.page.isLoaded() ){
			currentcontentID = prc.page.getContentID();
		}

		// list start
		if( !listFindNoCase("li,none", arguments.type) ){	b.append('<#arguments.type# class="submenu">'); }
		for(var x=1; x lte pageResults.count; x++ ){
			if( !len(arguments.excludes) OR !listFindNoCase(arguments.excludes, pageResults.pages[x].getTitle() )){
				// class = active?
				if( currentcontentID eq pageResults.pages[x].getContentID() ){ classText = ' class="active"'; }else{ classText = ''; }
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