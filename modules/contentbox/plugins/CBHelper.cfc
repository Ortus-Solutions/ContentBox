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
component extends="coldbox.system.Plugin" accessors="true" singleton threadSafe{

	// DI
	property name="categoryService"		inject="id:categoryService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="contentStoreService"	inject="id:contentStoreService@cb";
	property name="widgetService"		inject="id:widgetService@cb";
	property name="moduleService"		inject="id:moduleService@cb";
	property name="mobileDetector"		inject="id:mobileDetector@cb";
	property name="menuService"			inject="id:menuService@cb";
	property name="menuItemService"		inject="id:menuItemService@cb";
	property name="minifier"			inject="coldbox:myplugin:JSMin@contentbox";
	
	// Constructor
	function init( required controller ){
		super.init( arguments.controller );
	}

	/************************************** settings *********************************************/

	// get contentbox setting value by key or by default value
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
	// get blog entry point
	function getBlogEntryPoint(){
		return setting("cb_site_blog_entrypoint", "blog");
	}
	
	function getMaintenanceMessage(){
		return setting( "cb_site_maintenance_message" );
	}

	/**
	* Get a published custom HTML content pieces by slug: DEPRECATED, use contentStore() instead
	* @see contentStore
	* @deprecated
	* @slug.hint The content slug to retrieve
	* @defaultValue.hint The default value to use if custom html element not found.
	*/
	function customHTML(required slug, defaultValue=""){
		return contentStore(argumentCollection=arguments);
	}

	/**
	* Get a published content store and return its latest active content
	* @slug.hint The content slug to retrieve
	* @defaultValue.hint The default value to use if the content element not found.
	*/
	function contentStore(required slug, defaultValue=""){
		var content = contentStoreService.findBySlug( arguments.slug );
		return ( !content.isLoaded() ? arguments.defaultValue : content.renderContent() );
	}

	/**
	* Get a content store object by slug, if not found it returns null.
	* @slug.hint The content slug to retrieve
	*/
	function contentStoreObject(required slug){
		return contentStoreService.findBySlug( slug=arguments.slug, showUnpublished=true );
	}
	
	/************************************** Minify methods *********************************************/

	// Get the ContentBox JS/CSS Minifier
	function getMinifier(){
		return minifier;
	}
	
	/**
	* Prepare source(s) statements using our fabulous jsmin compressor
	* @assets.hint A list of js or css files to compress and add to the page. They will be concatenated in order
	*/
	any function minify(required assets){
		return minifier.minify(argumentCollection=arguments);
	}
	
	/**
	* Prepare source(s) statements using our fabulous jsmin compressor and send them to the head section
	* @assets.hint A list of js or css files to compress and add to the page. They will be concatenated in order
	*/
	CBHelper function minifyToHead(required assets){
		minifier.minifyToHead(argumentCollection=arguments);
		return this;
	}
	
	// Clean minify cache
	CBHelper function minifyClearCache(){
		minifier.cleanCache();
		return this;
	}

	/************************************** root methods *********************************************/

	// Get the location of your currently defined layout in the application, great for assets, cfincludes, etc
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
		return replacenocase( getRequestContext().buildLink(''), "index.cfm", "" );
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
	
	/**
	* Get a layout setting
	* @key.hint The name of the layout setting
	* @value.hint The default value if the layout setting does not exist
	*/
	function layoutSetting(required key, value){
		arguments.key = "cb_layout_#layoutName()#_#arguments.key#";
		return setting(argumentCollection=arguments);
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
	boolean function isCommentFormError(){
		return getFlash().exists( "commentErrors" );
	}

	// Determine if you are in printing or exporting format
	boolean function isPrintFormat(){
		return ( getRequestContext().getValue("format","contentbox") eq "contentbox" ? false : true );
	}

	// get comment errors array, usually when the form elements did not validate
	array function getCommentErrors(){
		return getFlash().get( "commentErrors", [] );
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
	/**
	 * Determine if you're in a "preview" mode or not
	 */
	boolean function isPreview(){
		var event = getRequestContext();
		return reFindNoCase( "contentbox-ui:.*preview", event.getCurrentEvent() ) ? true : false;
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
		return event.getValue(name="missingPage",private="true",defaultValue="");
	}
	// Get Home Page slug set up by the administrator.
	any function getHomePage(){
		return setting("cb_site_homepage");
	}
	// Get the the blog categories, else throws exception
	any function getCurrentRelatedContent(){
		var relatedContent = [];
		if( isPageView() && getCurrentPage().hasRelatedContent() ) {
			relatedContent = getCurrentPage().getRelatedContent();
		}
		else if( isEntryView() && getCurrentEntry().hasRelatedContent() ) {
			relatedContent = getCurrentEntry().getRelatedContent();
		}
		return relatedContent;
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
		return prc.pagingPlugin.renderit(foundRows=getSearchResults().getTotal(), link=prc.pagingLink, pagingMaxRows=setting("cb_search_maxResults"));
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
	* SetNextEvent For ContentBox Modules
	* @module.hint The module to link this URL to
	* @event.hint The handler action combination to link to
	* @queryString.hint The query string to append in SES format
	* @ssl.hint Create the link in SSL or not
	*/
	function setNextModuleEvent(required string module, string event,
							   queryString="", boolean addToken = false,
							   persist, struct persistStruct, boolean ssl=false,
							   boolean postProcessExempt=false, numeric statusCode){
		arguments.event = adminRoot() & ".module.#arguments.module#.#arguments.event#";
		return super.setNextEvent(argumentCollection=arguments);
	}

	/**
	* Link to the admin
	* @event.hint An optional event to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkAdmin( event="", boolean ssl=false ){
		return getRequestContext().buildLink( linkto=adminRoot() & ".#arguments.event#", ssl=arguments.ssl );
	}

	/**
	* Link to the admin logout
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkAdminLogout( boolean ssl=false ){
		return getRequestContext().buildLink( linkto=adminRoot() & "/security/doLogout", ssl=arguments.ssl );
	}

	/**
	* Link to the admin login
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkAdminLogin( boolean ssl=false ){
		return getRequestContext().buildLink( linkto=adminRoot() & "/security/login", ssl=arguments.ssl );
	}

	/**
	* Create a link to your site root or home page entry point for your blog.
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkHome( boolean ssl=false ){
		return getRequestContext().buildLink( linkto=siteRoot(), ssl=arguments.ssl );
	}

	/**
	* Create a link to your site blog
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkBlog( boolean ssl=false ){
		return getRequestContext().buildLink( linkto="#siteRoot()##sep()##getBlogEntryPoint()#", ssl=arguments.ssl );
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
		if( len( siteRoot() ) ){ return "."; }
		return "";
	}

	/**
	* Link to RSS feeds that ContentBox generates, by default it is the recent updates feed
	* @category You can optionally pass the category to filter on
	* @comments A boolean flag that determines if you want the comments RSS feed
	* @entry You can optionally pass the entry to filter the comment's RSS feed
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkRSS(category,comments=false,entry, boolean ssl=false){
		var xehRSS = siteRoot() & sep() & "#getBlogEntryPoint()#.rss";

		// do we have a category?
		if( structKeyExists(arguments,"category") ){
			xehRSS &= ".category.#arguments.category.getSlug()#";
			return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
		}

		// comments feed?
		if( arguments.comments ){
			xehRSS &= ".comments";
			// do we have entry filter
			if( structKeyExists(arguments,"entry") ){
				xehRSS &= ".#arguments.entry.getSlug()#";
			}
			return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
		}

		// build link to regular RSS feed
		return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
	}

	/**
	* Link to the ContentBox Site RSS Feeds
	* @category.hint The category to filter on
	* @comments.hint Do comments RSS feeds
	* @slug.hint The content slug to filter on when using comments
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkSiteRSS(any category, boolean comments=false, string slug, boolean ssl=false){
		var xehRSS = siteRoot() & sep() & "__rss";

		// do we have a category?
		if( structKeyExists(arguments,"category") ){

			if( isSimpleValue(arguments.category) ){
				xehRSS &= "/category/#arguments.category#";
			}
			else{
				xehRSS &= "/category/#arguments.category.getSlug()#";
			}

			return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
		}

		// comments feed?
		if( arguments.comments ){
			xehRSS &= "/comments";
			// do we have content filter
			if( structKeyExists(arguments,"slug") ){
				xehRSS &= "/#arguments.slug#";
			}
			return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
		}

		// build link to regular ContentBox RSS feed
		return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
	}

	/**
	* Link to the ContentBox Page RSS Feeds
	* @category.hint The category to filter on
	* @comments.hint Page comments or not, defaults to false
	* @page.hint The page you want to filter on
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkPageRSS(any category, boolean comments=false, page, boolean ssl=false){
		var xehRSS = siteRoot() & sep() & "__rss/pages";

		// do we have a category?
		if( structKeyExists(arguments,"category") ){

			if( isSimpleValue(arguments.category) ){
				xehRSS &= "/category/#arguments.category#";
			}
			else{
				xehRSS &= "/category/#arguments.category.getSlug()#";
			}

			return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
		}

		// comments feed?
		if( arguments.comments ){
			xehRSS &= "/comments";
			// do we have content filter
			if( structKeyExists(arguments,"page") ){
				xehRSS &= "/#arguments.page.getSlug()#";
			}
			return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
		}

		// build link to regular ContentBox RSS feed
		return getRequestContext().buildLink(linkto=xehRSS, ssl=arguments.ssl);
	}

	/**
	* Link to a specific filtered category view of blog entries
	* @category The category object or slug to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkCategory( required any category, boolean ssl=false ){
		var categorySlug = '';
		if( isSimpleValue( arguments.category ) ) {
			categorySlug = arguments.category;
		} else {
			categorySlug = arguments.category.getSlug();			
		}
		
		return linkCategoryWithSlug( categorySlug, arguments.ssl );
	}

	/**
	* Link to a specific filtered category view of blog entries
	* @categorySlug The category slug as a string to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkCategoryWithSlug( required string categorySlug, boolean ssl=false ){
		var xeh = siteRoot() & sep() & "#getBlogEntryPoint()#.category/#arguments.categorySlug#";
		return getRequestContext().buildLink(linkto=xeh, ssl=arguments.ssl);
	}

	/**
	* Link to a specific filtered archive of entries
	* @year The year of the archive
	* @month The month of the archive
	* @day The day of the archive
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkArchive(year, month, day, boolean ssl=false){
		var xeh = siteRoot() & sep() & "#getBlogEntryPoint()#.archives";
		if( structKeyExists(arguments,"year") ){ xeh &= "/#arguments.year#"; }
		if( structKeyExists(arguments,"month") ){ xeh &= "/#arguments.month#"; }
		if( structKeyExists(arguments,"day") ){ xeh &= "/#arguments.day#"; }
		return getRequestContext().buildLink(linkto=xeh, ssl=arguments.ssl);
	}

	/**
	* Link to the search route for this blog
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkSearch(boolean ssl=false){
		var xeh = siteRoot() & sep() & "#getBlogEntryPoint()#.search";
		return getRequestContext().buildLink(linkto=xeh, ssl=arguments.ssl);
	}

	/**
	* Link to the content search route
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkContentSearch(boolean ssl=false){
		var xeh = siteRoot() & sep() & "__search";
		return getRequestContext().buildLink(linkto=xeh, ssl=arguments.ssl);
	}

	/**
	* Link to a specific blog entry's page
	* @entry The entry to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	* @format.hint The format output of the content default is HTML bu you can pass pdf,print or doc.
	*/
	function linkEntry(required entry, boolean ssl=false, format="html"){
		// format?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );
		if( isSimpleValue(arguments.entry) ){
			return linkEntrywithslug( arguments.entry, arguments.ssl );
		}
		var xeh = siteRoot() & sep() & "#getBlogEntryPoint()#.#arguments.entry.getSlug()#";
		return getRequestContext().buildLink(linkTo=xeh, ssl=arguments.ssl) & outputFormat;
	}

	/**
	* Link to a specific entry's page using a slug only
	* @slug The entry slug to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	* @format.hint The format output of the content default is HTML bu you can pass pdf,print or doc.
	*/
	function linkEntryWithSlug(required slug, boolean ssl=false, format="html"){
		// format?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );
		arguments.slug = reReplace( arguments.slug, "^/","" );
		var xeh = siteRoot() & sep() & "#getBlogEntryPoint()#.#arguments.slug#";
		return getRequestContext().buildLink(linkTo=xeh, ssl=arguments.ssl) & outputFormat;
	}

	/**
	* Link to a specific content object
	* @content.hint The content object to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	* @format.hint The format output of the content default is HTML but you can pass pdf,print or doc.
	*/
	function linkContent(required content, boolean ssl=false, format="html"){
		if( arguments.content.getContentType() eq "entry" ){ return linkEntry( arguments.content, arguments.ssl, arguments.format ); }
		if( arguments.content.getContentType() eq "page" ){ return linkPage( arguments.content, arguments.ssl, arguments.format ); }
	}

	/**
	* Link to a specific page
	* @page.hint The page to link to. This can be a simple value or a page object
	* @ssl.hint	Use SSL or not, defaults to false.
	* @format.hint The format output of the content default is HTML but you can pass pdf,print or doc.
	*/
	function linkPage(required page, boolean ssl=false, format="html"){
		// format?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );
		// link directly or with slug
		if( isSimpleValue( arguments.page ) ){
			return linkPageWithSlug( arguments.page, arguments.ssl, arguments.format );
		}
		var xeh = siteRoot() & sep() & arguments.page.getSlug();
		return getRequestContext().buildLink(linkTo=xeh, ssl=arguments.ssl) & outputFormat;
	}

	/**
	* Link to a specific page using a slug only
	* @slug.hint The page slug to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	* @format.hint The format output of the content default is HTML bu you can pass pdf,print or doc.
	*/
	function linkPageWithSlug(required slug, boolean ssl=false, format="html"){
		// format?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );
		arguments.slug = reReplace( arguments.slug, "^/","" );
		var xeh = siteRoot() & sep() & "#arguments.slug#";
		return getRequestContext().buildLink(linkTo=xeh, ssl=arguments.ssl) & outputFormat;
	}

	/**
	* Create a link to a specific comment in a page or in an entry
	* @comment The comment to link to
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkComment(required comment, boolean ssl=false){
		var xeh = "";
		if( arguments.comment.getRelatedContent().getContentType() eq 'page' ){
			xeh = linkPage( arguments.comment.getRelatedContent(), arguments.ssl );
		}
		else{
			xeh = linkEntry( arguments.comment.getRelatedContent(), arguments.ssl );
		}
		xeh &= "##comment_#arguments.comment.getCommentID()#";
		return xeh;
	}

	/**
	* Create a link to an entry's or page's comments section
	* @content.hint The entry or page to link to its comments
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkComments(required content, boolean ssl=false){
		var xeh = "";
		if( arguments.content.getContentType() eq "page" ){
			xeh = linkPage( arguments.content, arguments.ssl );
		}
		else{
			xeh = linkEntry( arguments.content, arguments.ssl );
		}
		xeh &= "##comments";
		return xeh;
	}

	/**
	* Link to the commenting post action, this is where comments are submitted to
	* @content.hint The entry or page to link to its comments
	* @ssl.hint	Use SSL or not, defaults to false.
	*/
	function linkCommentPost(required content, boolean ssl=false){

		if( arguments.content.getContentType() eq "page" ){
			var xeh = siteRoot() & sep() & "__pageCommentPost";
			return getRequestContext().buildLink(linkTo=xeh, ssl=arguments.ssl);
		}

		return linkEntry( arguments.content, arguments.ssl ) & "/commentPost";
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

		// layout widgets overrides
		if( fileExists( expandPath( layoutWidgetPath ) ) ){
			var widgetCreationPath = replace( reReplace(layoutRoot(),"^/","")  ,"/",".","all") & ".widgets.#arguments.name#";
			return controller.getPlugin(plugin=widgetCreationPath,customPlugin=true);
		}

		// module widgets
		// if "@" is used in widget name, assume it's a module widget
		if( findNoCase( "@", arguments.name ) ) {
			// get module widgets
			var cache = moduleService.getModuleWidgetCache();
			// check if requested widget exists in widget cache
			if( structKeyExists( cache, arguments.name ) && len( cache[ arguments.name ] ) ) {
				// if exists, use it as the requested plugin
				return controller.getPlugin( plugin=cache[ arguments.name ], customPlugin=true );
			}
		}
		
		// return core contentbox widget instead
		return widgetService.getWidget( arguments.name );
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
	* Render out paging for blog entries only
	*/
	function quickPaging(){
		var prc = getRequestCollection(private=true);
		if( NOT structKeyExists(prc,"pagingPlugin") ){
			throw(message="Paging plugin is not in the collection",detail="This probably means you are trying to use the paging outside of the main entries index page and that is a No No",type="ContentBox.CBHelper.InvalidPagingContext");
		}
		return prc.pagingPlugin.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, pagingMaxRows=setting("cb_paging_maxentries"));
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
	* Render out related content anywhere using ColdBox collection rendering
	* @template.hint The name of the template to use, by default it looks in the 'templates/relatedContent.cfm' convention, no '.cfm' please
	* @collectionAs.hint The name of the iterating object in the template, by default it is called 'relatedContent'
	* @args.hint A structure of name-value pairs to pass to the template
	*/
	function quickRelatedContent( template="relatedContent", collectionAs="relatedContent", args=structnew() ){
		var relatedContent = getCurrentRelatedContent();
		return renderView( view="#layoutName()#/templates/#arguments.template#", collection=relatedContent,collectionAs=arguments.collectionAs, args=arguments.args );
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
	function quickView(required view,cache=false,cacheTimeout,cacheLastAccessTimeout,cacheSuffix,module="contentbox",args,collection,collectionAs,prepostExempt){
		arguments.view = "#layoutName()#/views/#arguments.view#";
		return renderView(argumentCollection=arguments);
	}

	/**
	* QuickLayout is a proxy to ColdBox's renderLayout method with the addition of prefixing the location of the layout according to the
	* layout theme you are using. All the arguments are the same as renderLayout()'s methods
	*/
	function quickLayout(required layout,view="",module="contentbox",args=structNew(),viewModule="",prePostExempt=false){
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
	public any function menu( required string slug, required type="html", required array slugCache=[] ) {
		var result = "";
		var menu = menuService.findBySlug( arguments.slug );
		if( !isNull( menu ) ) {
			if( arguments.type == "data" ) {
				return menu.getMemento();
			}
			else {
				return buildProviderMenu( menu=menu, slugCache=arguments.slugCache );
			}
		}
	}

	/**
	 * Builds out a custom menu
	 * @menu.hint The root menu that should be rendered
	 * @slugCache.hint The cache of menu slugs already used in this request
	 */
	public string function buildProviderMenu( required contentbox.model.menu.Menu menu, required array slugCache=[] ) {
		var listType = arguments.menu.getListType();
		//arguments.listType = !reFindNoCase( "^(ul|ol)$", arguments.listType ) ? "<ul>" : arguments.listType;
		// set start
		var menuString = "<#listType# class='nav nav-list'>";
		// now get root items
		var items = arguments.menu.getRootMenuItems();
		// create cache of slugs to prevent infinite recursions
		arrayAppend( arguments.slugCache, menu.getSlug() );
		// build out this top level
		menuString &= buildProviderMenuLevel( items=items, listType=listType, slugCache=slugCache );
		// set end
		menuString &= "</#listType#>";
		return menuString;
	}

	/**
	 * Builds out a level of a custom menu
	 * @items.hint An array of menu items for this level
	 * @listType.hint The type of list to create (derived from owning menu)
	 * @slugCache.hint The cache of menu slugs already used in this request
	 */
	private string function buildProviderMenuLevel( 
		required array items, 
		required string listType="ul", 
		required array slugCache=[] 
	) {
		var menuString = "";
		// loop over items to build out level
		for( var item in arguments.items ) {
			var extras = { slugCache=arguments.slugCache, listType=arguments.listType };
			// check that item can be added
			if( item.canDisplay( options=extras ) ) {
				// get template from provider
				menuString &= '<li #item.getAttributesAsString()#>' & item.getProvider().getDisplayTemplate( item, extras );
				// if this menu item has children...
				if( item.hasChild() ) {
					// recurse, recurse, recurse!
					menuString &= 	"<#arguments.listType#>" & 
									buildProviderMenuLevel( items=item.getChildren(), listType=arguments.listType, slugCache=arguments.slugCache ) & 
									"</#arguments.listType#>";
				}
				menuString &= "</li>";
			}
		}
		return menuString;
	}

	/**
	* Render out a quick menu for root level pages
	* @excludes.hint The list of pages to exclude from the menu
	* @type.hint The type of menu, valid choices are: ul,ol,li,data,none
	* @separator.hint Used if type eq none, to separate the list of href's
	* @levels.hint The number of levels to nest hierarchical pages, by default it does only 1 level, * does all levels
	* @parentClass.hint The name of the CSS class to attach to the menu <li> element when it has nested elements, by default it is 'parent'
	* @activeClass.hint The name of the CSS class to attach to the menu <li> element when that element is the current page you are on, by default it is 'active'
	*/
	function rootMenu(excludes="", type="ul", separator="", levels="1", parentClass="parent", activeClass="active"){
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
	* @levels.hint The number of levels to nest hierarchical pages, by default it does only 1 level, * does all levels
	* @parentClass.hint The name of the CSS class to attach to the menu <li> element when it has nested elements, by default it is 'parent'
	* @activeClass.hint The name of the CSS class to attach to the menu <li> element when that element is the current page you are on, by default it is 'active'
	* @activeShowChildren.hint If true, then we will show the children of the active menu element, else we just show the active element
	*/
	function subPageMenu(any page, excludes="", type="ul", separator="", boolean showNone=true, levels="1", parentClass="parent", activeClass="active", activeShowChildren=false){
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

	/************************************** UTILITIES *********************************************/

	/**
	* Detects if the incoming request is from a mobile device or NOT.
	*/
	boolean function isMobile(){
		return mobileDetector.isMobile();
	}

	/**
	* Return the current system flash scope
	*/
	any function getFlash(){
		return controller.getRequestService().getFlashScope();
	}

	/************************************** PRIVATE *********************************************/

	private function buildMenu(pageRecords, excludes="", type="ul", separator="", boolean showNone=true, levels="1", numeric currentLevel="1", parentClass="parent", activeClass="active", activeShowChildren=false){
		// Levels = *, then create big enough integer
		if( arguments.levels eq "*" ){ arguments.levels = "999999"; }
		// check type?
		if( !reFindNoCase("^(ul|ol|li|data|none)$", arguments.type) ){ arguments.type="ul"; }
		var pageResults = arguments.pageRecords;
		// buffer
		var b = createObject("java","java.lang.StringBuilder").init('');
		// current page?
		var prc = getRequestCollection(private=true);
		var pageAncestorContentIDs = "";
		var locPage = "";
		// class text
		var classtext = [];

		// Get contentID
		if( structKeyExists(prc,"page") and prc.page.isLoaded() ){
			locPage = getCurrentPage();
			pageAncestorContentIDs = locPage.getContentID();
			// If this is subnav, add ancestry trail
			while(locPage.hasParent()) {
				locPage = locPage.getParent();
				pageAncestorContentIDs = ListAppend(pageAncestorContentIDs,locPage.getContentID());
			}			
		}
		// list start
		if( !listFindNoCase("li,none,data", arguments.type) ){
			b.append('<#arguments.type# class="submenu">');
		}

		if( arguments.type eq "data" ){
			var dataMenu = [];
		}

		// Iterate through pages and create sub menus
		for(var x=1; x lte pageResults.count; x++ ){
			// need to reset this or all links after an active one appear as active
			classtext = [];
			if( !len(arguments.excludes) OR !listFindNoCase(arguments.excludes, pageResults.pages[x].getTitle() )){
				// Do we need to nest?
				var doNesting 		= ( arguments.currentLevel lt arguments.levels AND pageResults.pages[x].hasChild() );
				// Is element active (or one of its decendants)
				var isElementActive = ( listFindNoCase(pageAncestorContentIDs, pageResults.pages[x].getContentID()) );
				// class = active? Then add to class text
				if( isElementActive ){ arrayAppend( classText, arguments.activeClass); }
				// class = parent nesting?
				if( doNesting ){ arrayAppend(classText, arguments.parentClass); }

				// list
				if( arguments.type neq "none" and arguments.type neq "data" ){
					// Start Embedded List
					b.append('<li class="#arrayToList(classText, " ")#"><a href="#linkPage(pageResults.pages[x])#">#pageResults.pages[x].getTitle()#</a>');
					// Nested Levels?
					if( doNesting ){
						// If type is "li" then guess to do a nested ul list
						b.append( buildMenu(pageRecords=pageService.findPublishedPages(parent=pageResults.pages[x].getContentID(), showInMenu=true),
											excludes=arguments.excludes,
											type=( arguments.type eq "li" ? "ul" : arguments.type ),
											showNone=arguments.showNone,
											levels=arguments.levels,
											currentLevel=arguments.currentLevel+1) );
					}
					// Do we nest active and activeShowChildren flag is activated?
					else if( activeShowChildren AND isElementActive AND pageResults.pages[x].hasChild() ){
						// If type is "li" then guess to do a nested ul list
						b.append( buildMenu(pageRecords=pageService.findPublishedPages(parent=pageResults.pages[x].getContentID(), showInMenu=true),
											excludes=arguments.excludes,
											type=( arguments.type eq "li" ? "ul" : arguments.type ),
											showNone=arguments.showNone,
											levels=1,
											currentLevel=arguments.currentLevel+1) );
					}

					// Close it
					b.append('</li>');
				} else if ( arguments.type eq "data" )
				{
					var pageData = {
						title = pageResults.pages[x].getTitle(),
						link = linkPage(pageResults.pages[x])
					};
					if( doNesting ){
						pageData.subPageMenu = buildMenu(pageRecords=pageService.findPublishedPages(parent=pageResults.pages[x].getContentID(), showInMenu=true),
							excludes=arguments.excludes,
							type = arguments.type,
							showNone=arguments.showNone,
							levels=arguments.levels,
							currentLevel=arguments.currentLevel+1);
					}
					// Do we nest active and activeShowChildren flag is activated?
					else if( activeShowChildren AND isElementActive AND pageResults.pages[x].hasChild() ){
						pageData.subPageMenu = buildMenu(pageRecords=pageService.findPublishedPages(parent=pageResults.pages[x].getContentID(), showInMenu=true),
							excludes=arguments.excludes,
							type = arguments.type,
							showNone=arguments.showNone,
							levels=1,
							currentLevel=arguments.currentLevel+1);
					}
					arrayAppend(dataMenu,pageData);
				}
				else{
					b.append('<a href="#linkPage(pageResults.pages[x])#" class="#arrayToList(classText, " ")#">#pageResults.pages[x].getTitle()#</a>#arguments.separator#');
				}
			}
		}

		if( arguments.type eq "data" ){
			return dataMenu;
		}

		// None?
		if( pageResults.count eq 0 and arguments.showNone ){ b.append("<li>No Sub Pages</li>"); }

		// list end
		if( !listFindNoCase("li,none", arguments.type) ){	b.append('</#arguments.type#>'); }

		// return
		return b.toString();
	}
	
	/**
	* utility to strip HTML
	*/
	function stripHTML(required stringTarget){
		return HTMLEditFormat( REReplaceNoCase( arguments.stringTarget, "<[^>]*>", "", "ALL" ) );
	}

}