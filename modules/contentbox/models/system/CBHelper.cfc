/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is the ContentBox UI helper class that is injected by the CBRequest interceptor
 */
component accessors="true" singleton threadSafe {

	// DI
	property name="categoryService" inject="categoryService@contentbox";
	property name="settingService" inject="settingService@contentbox";
	property name="entryService" inject="entryService@contentbox";
	property name="pageService" inject="pageService@contentbox";
	property name="authorService" inject="authorService@contentbox";
	property name="commentService" inject="commentService@contentbox";
	property name="contentStoreService" inject="contentStoreService@contentbox";
	property name="widgetService" inject="widgetService@contentbox";
	property name="moduleService" inject="moduleService@contentbox";
	property name="themeService" inject="themeService@contentbox";
	property name="mobileDetector" inject="mobileDetector@contentbox";
	property name="menuService" inject="menuService@contentbox";
	property name="menuItemService" inject="menuItemService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="requestService" inject="coldbox:requestService";
	property name="wirebox" inject="wirebox";
	property name="controller" inject="coldbox";
	property name="cbResourceService" inject="resourceService@cbi18n";
	property name="securityService" inject="securityService@contentbox";
	property name="markdown" inject="Processor@cbmarkdown";
	property name="requestStorage" inject="requestStorage@cbstorages";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/************************************** coldbox bridge *********************************************/

	/**
	 * Get the current ColdBox request context
	 *
	 * @return coldbox.system.web.context.RequestContext
	 */
	function getRequestContext(){
		return variables.requestService.getContext();
	}

	/**
	 * Get the RC or PRC collection reference
	 *
	 * @private The boolean bit that says give me the RC by default or true for the private collection (PRC)
	 */
	struct function getRequestCollection( boolean private = false ){
		return getRequestContext().getCollection( private = arguments.private );
	}

	/**
	 * Get the private request collection
	 */
	struct function getPrivateRequestCollection(){
		return getRequestContext().getCollection( private = true );
	}

	/**
	 * Get a module's settings structure
	 *
	 * @module The module to retrieve the configuration settings from
	 */
	struct function getModuleSettings( required module ){
		return getModuleConfig( arguments.module ).settings;
	}

	/**
	 * Get a module's configuration structure
	 *
	 * @module The module to retrieve the configuration structure from
	 */
	struct function getModuleConfig( required module ){
		var mConfig = controller.getSetting( "modules" );
		if ( structKeyExists( mConfig, arguments.module ) ) {
			return mConfig[ arguments.module ];
		}
		throw(
			message: "The module you passed #arguments.module# is invalid.",
			detail : "The loaded modules are #structKeyList( mConfig )#",
			type   : "FrameworkSuperType.InvalidModuleException"
		);
	}

	/************************************** SETTINGS *********************************************/

	/**
	 * Get a global setting value by key or by default value
	 *
	 * @key          The setting key to get
	 * @defaultValue The default value to return if not found
	 * @throw        InvalidSettingException
	 */
	any function setting( required key, defaultValue ){
		var prc = getPrivateRequestCollection();

		// See if all the settings are loaded, else lazy load them
		if ( isNull( prc.cbSettings ) || structIsEmpty( prc.cbSettings ) ) {
			prc.cbSettings = variables.settingService.getAllSettings();
		}

		// return setting if it exists
		if ( structKeyExists( prc.cbSettings, arguments.key ) ) {
			return prc.cbSettings[ key ];
		}
		// default value
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}
		// else throw exception
		throw(
			message: "Setting requested: #arguments.key# not found",
			detail : "Settings keys are #structKeyList( prc.cbSettings )#",
			type   : "InvalidSettingException"
		);
	}

	/**
	 * Get a site setting value by key or by default value
	 *
	 * @key          The setting key to get
	 * @defaultValue The default value to return if not found
	 *
	 * @throws InvalidSettingException
	 */
	any function siteSetting( required key, defaultValue ){
		var prc = getPrivateRequestCollection();

		// See if all the settings are loaded, else lazy load them
		if ( isNull( prc.cbSiteSettings ) || structIsEmpty( prc.cbSiteSettings ) ) {
			prc.cbSiteSettings = variables.settingService.getAllSiteSettings( prc.oCurrentSite.getSlug() );
		}

		// return setting if it exists
		if ( structKeyExists( prc.cbSiteSettings, arguments.key ) ) {
			return prc.cbSiteSettings[ key ];
		}
		// default value
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}
		// else throw exception
		throw(
			message: "Site Setting requested: #arguments.key# not found",
			detail : "Site Settings keys are #structKeyList( prc.cbSiteSettings )#",
			type   : "InvalidSettingException"
		);
	}

	/**
	 * The ContentBox version
	 */
	function getContentBoxVersion(){
		return getModuleConfig( "contentbox" ).version;
	}

	/**
	 * The ContentBox Codename
	 */
	function getContentBoxCodeName(){
		return getModuleSettings( "contentbox" ).codename;
	}

	/**
	 * The ContentBox codename Uri
	 */
	function getContentBoxCodeNameURL(){
		return getModuleSettings( "contentbox" ).codenameLink;
	}

	/**
	 * Get the blog entry point as specified in the global settings
	 */
	function getBlogEntryPoint(){
		return setting( "cb_site_blog_entrypoint", "blog" );
	}

	/**
	 * Get the maintenance message from the ContentBox settings in rendering condition.
	 */
	function getMaintenanceMessage(){
		return variables.markdown.toHTML( setting( "cb_site_maintenance_message", "" ) );
	}

	/**
	 * Get a published content store and return its latest active content
	 *
	 * @slug         The content slug to retrieve
	 * @defaultValue The default value to use if the content element not found.
	 * @siteID       The site to get it from, defaults to current site
	 */
	function contentStore(
		required slug,
		defaultValue  = "",
		string siteID = site().getsiteID()
	){
		var content = variables.contentStoreService.findBySlug( slug: arguments.slug, siteID: arguments.siteID );

		// Render if the object is loaded
		return ( !content.isLoaded() ? arguments.defaultValue : content.renderContent() );
	}

	/**
	 * Get a content store object by slug
	 *
	 * @slug The content slug to retrieve
	 *
	 * @return The content object or a new empty content object
	 */
	function contentStoreObject( required slug, string siteID = site().getsiteID() ){
		return contentStoreService.findBySlug(
			slug           : arguments.slug,
			showUnpublished: true,
			siteID         : arguments.siteID
		);
	}

	/************************************** root and pathing methods *********************************************/

	/**
	 * Verifies if the admin module is loaded
	 */
	function isAdminLoaded(){
		return structKeyExists( controller.getSetting( "modules" ), "contentbox-admin" );
	}

	/**
	 * Get the admin site root location using the configured module's entry point
	 */
	function adminRoot(){
		return getPrivateRequestCollection().cbAdminEntryPoint;
	}

	/**
	 * Get the name of the current set and active theme
	 */
	function themeName(){
		return getPrivateRequestCollection().cbTheme;
	}

	/**
	 * Get the theme record of the current set and active theme
	 */
	function themeRecord(){
		return getPrivateRequestCollection().cbThemeRecord;
	}

	/**
	 * Get a theme setting
	 *
	 * @key          The name of the theme setting
	 * @defaultValue The default value if the layout setting does not exist
	 */
	function themeSetting( required key, defaultValue ){
		arguments.key = "cb_theme_#themeName()#_#arguments.key#";
		return siteSetting( argumentCollection = arguments );
	}

	/************************************** Site Methods *********************************************/

	/**
	 * Get the current site object that you are visiting the UI from via our discovery methods
	 *
	 * - Check argument override
	 * - Check prc set site
	 * - Do full detection
	 *
	 * @siteID The site id to get the root from, by default we use the current site you are on
	 */
	function site( string siteID = "" ){
		// Verify incoming override/lookup
		if ( len( arguments.siteID ) ) {
			// Do a request storage lookup cache for optmizations when requesting the same site
			// over and over again in the same request.
			return variables.requestStorage.getOrSet( "cbhelper-request-site-#arguments.siteID#", function(){
				return variables.siteService.getOrFail( siteID );
			} );
		}

		// Verify PRC
		var prc = getPrivateRequestCollection();
		if ( !isNull( prc.oCurrentSite ) ) {
			return prc.oCurrentSite;
		}

		// Do full detection
		return variables.siteService.discoverSite();
	}

	/**
	 * Get the location of your currently defined theme in the application, great for assets, cfincludes, etc
	 */
	function themeRoot(){
		return getPrivateRequestCollection().cbThemeRoot;
	}

	/**
	 * Get the site root location using your configured module's entry point and the discovered site
	 *
	 * @siteID The site id to get the root from, by default we use the current site you are on
	 */
	function siteRoot( string siteID = "" ){
		// Return the appropriate site Uri
		return this.site( arguments.siteID ).getSiteRoot() & getModuleConfig( "contentbox-ui" ).entryPoint;
	}

	/**
	 * Get the HTML base URL that is used for the HTML <base> tag. This also accounts for SSL or not.
	 *
	 * @siteID The site id to get the root from, by default we use the current site you are on
	 */
	function siteBaseURL( string siteID = "" ){
		return reReplaceNoCase(
			this.siteRoot( arguments.siteID ),
			"index.cfm\/?",
			""
		);
	}

	/**
	 * Retrieve the site name
	 */
	function siteName(){
		return site().getName();
	}

	/**
	 * Retrieve the site tagline
	 */
	function siteTagLine(){
		return site().getTagLine();
	}

	/**
	 * Retrieve the site description
	 */
	function siteDescription(){
		return site().getDescription();
	}

	/**
	 * Retrieve the site keywords
	 */
	function siteKeywords(){
		return site().getKeywords();
	}

	/**
	 * Retrieve the site administrator email
	 */
	function siteEmail(){
		return site().getNotificationEmails();
	}

	/**
	 * Retrieve the site outgoing email
	 */
	function siteOutgoingEmail(){
		return setting( "cb_site_outgoingEmail" );
	}

	/**
	 * Determines if site comments are enabled and if the entry accepts comments
	 *
	 * @content The entry or page content to validate comments also with
	 */
	boolean function isCommentsEnabled( content ){
		if ( !isNull( arguments.content ) ) {
			return ( arguments.content.getAllowComments() AND siteSetting( "cb_comments_enabled" ) );
		}
		return ( siteSetting( "cb_comments_enabled" ) );
	}

	/**
	 * Determines if a comment form error has ocurred
	 */
	boolean function isCommentFormError(){
		return getFlash().exists( "commentErrors" );
	}

	/**
	 * Determine if you are in printing or exporting format
	 */
	boolean function isPrintFormat(){
		var currentFormat = getRequestContext().getValue( "format", "contentbox" );
		return ( listFindNoCase( "contentbox,html", currentFormat ) ? false : true );
	}

	/**
	 * Get comment errors array, usually when the form elements did not validate
	 *
	 * @return The errors array or an empty array
	 */
	array function getCommentErrors(){
		return getFlash().get( "commentErrors", [] );
	}

	/************************************** Context Methods *********************************************/

	/**
	 * Prepare a ContentBox UI request. This sets ups settings, theme, etc. This method is usualy called
	 * automatically for you on the UI module. However, you can use it a-la-carte if you are building
	 * ajax or module extensions
	 *
	 * @layout      An optional layout to set for you in the request.
	 * @title       Optional request page metadata title
	 * @description Optional request page metadata description
	 * @keywords    Optional request page metadata keywords
	 */
	CBHelper function prepareUIRequest(
		string layout,
		string title,
		string description,
		string keywords
	){
		var event = getRequestContext();
		var prc   = getPrivateRequestCollection();
		var rc    = getRequestCollection();

		// Request Metadata
		if ( structKeyExists( arguments, "title" ) ) {
			setMetaTitle( arguments.title );
		}
		if ( structKeyExists( arguments, "description" ) ) {
			setMetaDescription( arguments.description );
		}
		if ( structKeyExists( arguments, "keywords" ) ) {
			setMetaKeywords( arguments.keywords );
		}

		// store UI module root
		prc.cbRoot       = getContextRoot() & event.getModuleRoot( "contentbox" );
		// store module entry point
		prc.cbEntryPoint = getModuleConfig( "contentbox-ui" ).entryPoint;
		// store site entry point
		if ( isAdminLoaded() ) {
			prc.cbAdminEntryPoint = getModuleConfig( "contentbox-admin" ).entryPoint;
		} else {
			prc.cbAdminEntryPoint = "";
		}
		// Place site on request
		prc.oCurrentSite   = variables.siteService.discoverSite();
		// Place global cb options on scope
		prc.cbSettings     = variables.settingService.getAllSettings();
		prc.cbSiteSettings = variables.settingService.getAllSiteSettings( prc.oCurrentSite.getSlug() );
		// Place the default layout on scope
		prc.cbTheme        = prc.oCurrentSite.getActiveTheme();
		prc.cbThemeRecord  = variables.themeService.getThemeRecord( prc.cbTheme );
		// Place layout root location
		prc.cbthemeRoot    = prc.cbThemeRecord.includePath;
		// Place widgets root location
		prc.cbWidgetRoot   = prc.cbRoot & "/widgets";
		// Place current logged in Author if any
		prc.oCurrentAuthor = variables.securityService.getAuthorSession();

		// announce event
		this.event( "cbui_preRequest" );

		// Do we set a layout for them already?
		if ( structKeyExists( arguments, "layout" ) ) {
			event.setLayout( name = "#prc.cbThemeRecord.includePath#/layouts/" & arguments.layout );
		}

		/************************************** FORCE SITE WIDE SSL *********************************************/

		if ( prc.oCurrentSite.getIsSSL() and !event.isSSL() ) {
			controller.relocate( event = event.getCurrentRoutedURL(), ssl = true );
		}

		/************************************** IDENTITY HEADER *********************************************/

		if ( prc.oCurrentSite.getPoweredByHeader() ) {
			event.setHTTPHeader( name = "X-Powered-By", value = "ContentBox Modular CMS" );
		}

		return this;
	}

	// Determine if you have a category filter
	boolean function categoryFilterExists(){
		var rc = getRequestCollection();
		return ( structKeyExists( rc, "category" ) AND len( rc.category ) );
	}
	// Get Category Filter
	function getCategoryFilter(){
		return getRequestContext().getValue( "category", "" );
	}

	// Get Year Filter
	function getYearFilter(){
		return getRequestContext().getValue( "year", "0" );
	}
	// Get Month Filter
	function getMonthFilter(){
		return getRequestContext().getValue( "month", "0" );
	}
	// Get Day Filter
	function getDayFilter(){
		return getRequestContext().getValue( "day", "0" );
	}

	// Determine if you are in the blog
	boolean function isBlogView(){
		if ( isIndexView() OR isEntryView() OR isArchivesView() ) {
			return true;
		}
		return false;
	}
	// Determine if you are in the archives view
	boolean function isArchivesView(){
		var event = getRequestContext();
		return ( event.getCurrentEvent() eq "contentbox-ui:blog.archives" );
	}
	// Determine if you are in the index view
	boolean function isIndexView(){
		var event = getRequestContext();
		return ( event.getCurrentEvent() eq "contentbox-ui:blog.index" );
	}
	// Determine if you are in the entry view
	boolean function isEntryView(){
		var event = getRequestContext();
		return (
			// If in static export, then mark as yes
			event.getPrivateValue( "staticExport", false )
			OR
			// In executing view
			event.getCurrentEvent() eq "contentbox-ui:blog.entry"
		);
	}

	/**
	 * Determine if you are in the page view
	 *
	 * @page Optional page slug to determine if you are in that page or not.
	 */
	boolean function isPageView( page = "" ){
		var event = getRequestContext();
		if (
			// If in static export, then mark as yes
			event.getPrivateValue( "staticExport", false ) OR
			(
				// Check if in page event
				findNoCase( "contentbox-ui:page", event.getCurrentEvent() ) AND
				// And page Exists
				event.valueExists( "page", true )
			)
		) {
			// slug check
			if ( len( arguments.page ) AND getCurrentPage().getSlug() eq arguments.page ) {
				return true;
			} else if ( !len( arguments.page ) ) {
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
		return reFindNoCase( "contentbox-ui:.*preview", getRequestContext().getCurrentEvent() ) ? true : false;
	}

	/**
	 * Get the index page entries, else throws exception
	 *
	 * @return array of entries
	 *
	 * @throws ContentBox.CBHelper.InvalidEntriesContext
	 */
	any function getCurrentEntries(){
		var prc = getRequestCollection( private = true );
		if ( structKeyExists( prc, "entries" ) ) {
			return prc.entries;
		}
		throw(
			message = "Entries not found in collection",
			detail  = "This probably means you are trying to use the entries in an non-index page",
			type    = "ContentBox.CBHelper.InvalidEntriesContext"
		);
	}

	/**
	 * Get the index page entries count, else throws exception
	 *
	 * @throws ContentBox.CBHelper.InvalidEntriesContext
	 */
	numeric function getCurrentEntriesCount(){
		var prc = getRequestCollection( private = true );
		if ( structKeyExists( prc, "entriesCount" ) ) {
			return prc.entriesCount;
		}
		throw(
			message = "Entries not found in collection",
			detail  = "This probably means you are trying to use the entries in an non-index page",
			type    = "ContentBox.CBHelper.InvalidEntriesContext"
		);
	}

	/**
	 * Get the current array of public category entities for the current site
	 *
	 * @isPublic By default return all public categories. If false, return private categories, If null, all categories
	 *
	 * @return array of category
	 */
	any function getCurrentCategories( isPublic = true ){
		return variables.categoryService.search(
			isPublic: ( isNull( arguments.isPublic ) ? javacast( "null", "" ) : arguments.isPublic ),
			siteId  : site().getSiteId()
		).categories;
	}

	/**
	 * Get the viewed entry if in entry view, else throws exception
	 *
	 * @return Entry
	 *
	 * @throws ContentBox.CBHelper.InvalidEntryContext
	 */
	any function getCurrentEntry(){
		var prc = getRequestCollection( private = true );
		if ( structKeyExists( prc, "entry" ) ) {
			return prc.entry;
		}
		throw(
			message = "Entry not found in collection",
			detail  = "This probably means you are trying to use the entry in an non-entry page",
			type    = "ContentBox.CBHelper.InvalidEntryContext"
		);
	}

	/**
	 * Get the viewed page if in page view, else throws exception
	 *
	 * @return Page
	 *
	 * @throws ContentBox.CBHelper.InvalidPageContext
	 */
	any function getCurrentPage(){
		var prc = getRequestCollection( private = true );
		if ( structKeyExists( prc, "page" ) ) {
			return prc.page;
		}
		throw(
			message = "Page not found in collection",
			detail  = "This probably means you are trying to use the page in an non-page page! Redundant huh?",
			type    = "ContentBox.CBHelper.InvalidPageContext"
		);
	}

	/**
	 * Get the viewed page's or entry's comments, else throw exception
	 *
	 * @return array of comments
	 *
	 * @throws ContentBox.CBHelper.InvalidCommentContext
	 */
	any function getCurrentComments(){
		var prc = getRequestCollection( private = true );
		if ( structKeyExists( prc, "comments" ) ) {
			return prc.comments;
		}
		// If we are in static export, set to empty array
		if ( !isNull( prc.staticExport ) ) {
			return [];
		}
		throw(
			message = "Comments not found in collection",
			detail  = "This probably means you are trying to use the entry or page comments in an non-entry or non-page page",
			type    = "ContentBox.CBHelper.InvalidCommentContext"
		);
	}

	/**
	 * Get the viewed entry's comments count, else throw exception
	 *
	 * @throws ContentBox.CBHelper.InvalidCommentContext
	 */
	numeric function getCurrentCommentsCount(){
		var prc = getRequestCollection( private = true );
		if ( structKeyExists( prc, "commentsCount" ) ) {
			return prc.commentsCount;
		}
		throw(
			message = "Comments not found in collection",
			detail  = "This probably means you are trying to use the entry or page comments in an non-entry or non-page page",
			type    = "ContentBox.CBHelper.InvalidCommentContext"
		);
	}

	/**
	 * Get the missing page, if any, usually used in a page not found context
	 */
	any function getMissingPage(){
		return getRequestContext().getValue(
			name         = "missingPage",
			private      = "true",
			defaultValue = ""
		);
	}

	/**
	 * Get the current working site's homepage
	 *
	 * @siteID The site id to get it from
	 */
	any function getHomePage( string siteID = "" ){
		return site( arguments.siteID ).getHomepage();
	}

	/**
	 * Checks if the currently viewed page is the homepage.
	 */
	boolean function isHomePage(){
		var prc = getPrivateRequestCollection();
		// Check if page exists
		if ( !structKeyExists( prc, "page" ) ) {
			return false;
		}
		return prc.page.isHomePage();
	}

	/**
	 * Get the current page or entries related content array
	 *
	 * @return array
	 */
	any function getCurrentRelatedContent(){
		var relatedContent = [];
		if ( isPageView() && getCurrentPage().hasRelatedContent() ) {
			relatedContent = getCurrentPage().getRelatedContent();
		} else if ( isEntryView() && getCurrentEntry().hasRelatedContent() ) {
			relatedContent = getCurrentEntry().getRelatedContent();
		}
		return relatedContent;
	}

	/**
	 * Get the current page's or blog entries custom fields as a struct
	 */
	struct function getCurrentCustomFields(){
		if ( isPageView() ) {
			return getCurrentPage().getCustomFieldsAsStruct();
		} else {
			return getCurrentEntry().getCustomFieldsAsStruct();
		}
	}

	/**
	 * Get a current page's or blog entrie's custom field by key, you can pass a default value if not found
	 *
	 * @key          The custom field key
	 * @defaultValue The default value to return if not found
	 */
	any function getCustomField( required key, defaultValue ){
		var fields = getCurrentCustomFields();
		if ( structKeyExists( fields, arguments.key ) ) {
			return fields[ arguments.key ];
		}
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}
		throw(
			message = "No custom field with key: #arguments.key# found",
			detail  = "The keys are #structKeyList( fields )#",
			type    = "CBHelper.InvalidCustomField"
		);
	}

	/************************************** SEO Metadata *********************************************/

	/**
	 * Check the Meta struct exists in the PRC
	 */
	function checkMetaStruct(){
		var prc = getPrivateRequestCollection();
		if ( !structKeyExists( prc, "meta" ) ) {
			prc.meta = {};
		}
	}

	/**
	 * Set the Meta Title for the request
	 *
	 * @title - The new title
	 */
	function setMetaTitle( required string title ){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		prc.meta.title = arguments.title;
	}

	/**
	 * Get the Meta Title for the request
	 */
	function getMetaTitle(){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		if ( structKeyExists( prc.meta, "title" ) ) {
			return prc.meta.title;
		} else {
			return "";
		}
	}

	/**
	 * Set the Meta Description for the request
	 *
	 * @description - The new Description
	 */
	function setMetaDescription( required string description ){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		prc.meta.description = arguments.description;
	}

	/**
	 * Get the Meta description for the request
	 */
	function getMetaDescription(){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		if ( structKeyExists( prc.meta, "description" ) ) {
			return stripWhitespace( prc.meta.description );
		} else {
			return "";
		}
	}

	/**
	 * Set the Meta Keywords for the request
	 *
	 * @keywords - The new Keywords
	 */
	function setMetaKeywords( required string keywords ){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		prc.meta.keywords = arguments.keywords;
	}

	/**
	 * Get the Meta keywords for the request
	 */
	function getMetaKeywords(){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		if ( structKeyExists( prc.meta, "keywords" ) ) {
			return stripWhitespace( prc.meta.keywords );
		} else {
			return "";
		}
	}

	/**
	 * Get the current content metadata title according to SEO Discovery Rules
	 */
	function getContentTitle(){
		var oCurrentContent = "";

		// If Meta Title is set Manually, return it
		if ( len( getMetaTitle() ) ) {
			return encodeForHTML( getMetaTitle() );
		}

		// Check if in page view or entry view
		if ( isPageView() ) {
			oCurrentContent = getCurrentPage();
		} else if ( isEntryView() ) {
			oCurrentContent = getCurrentEntry();
		}

		// in context view or global
		if ( isObject( oCurrentContent ) ) {
			// Do we have current page SEO title set?
			if ( len( oCurrentContent.getHTMLTitle() ) ) {
				return encodeForHTML( oCurrentContent.getHTMLTitle() );
			}
			// Get current page slug title
			return encodeForHTML( oCurrentContent.getTitle() );
		}

		// Return global site title + tagline
		return encodeForHTML( siteName() & " - " & siteTagLine() );
	}

	/**
	 * Get the current content metadata description according to SEO discovery rules
	 */
	function getContentDescription(){
		var oCurrentContent = "";

		// If Meta Description is set Manually, return it
		if ( len( getMetaDescription() ) ) {
			return encodeForHTMLAttribute( getMetaDescription() );
		}

		// Check if in page view or entry view
		if ( isPageView() ) {
			oCurrentContent = getCurrentPage();
		} else if ( isEntryView() ) {
			oCurrentContent = getCurrentEntry();
		}

		// in context view or global
		if ( isObject( oCurrentContent ) ) {
			// Do we have current page SEO description set?
			if ( len( oCurrentContent.getHTMLDescription() ) ) {
				return encodeForHTMLAttribute( oCurrentContent.getHTMLDescription() );
			}

			// Default description from content in non HTML mode
			return encodeForHTMLAttribute(
				reReplaceNoCase(
					left( stripWhitespace( oCurrentContent.renderContent() ), 160 ),
					"<[^>]*>",
					"",
					"ALL"
				)
			);
		}

		// Return global site description as metadata
		return encodeForHTMLAttribute( trim( siteDescription() ) );
	}

	/**
	 * Get the current content metadata keywords according to SEO discovery rules
	 */
	function getContentKeywords(){
		var oCurrentContent = "";

		// If Meta Keywords is set Manually, return it
		if ( len( getMetaKeywords() ) ) {
			return encodeForHTMLAttribute( stripWhitespace( getMetaKeywords() ) );
		}

		// Check if in page view or entry view
		if ( isPageView() ) {
			oCurrentContent = getCurrentPage();
		} else if ( isEntryView() ) {
			oCurrentContent = getCurrentEntry();
		}

		// in context view or global
		if ( isObject( oCurrentContent ) AND len( oCurrentContent.getHTMLKeywords() ) ) {
			return encodeForHTMLAttribute( stripWhitespace( oCurrentContent.getHTMLKeywords() ) );
		}

		// Return global site description
		return encodeForHTMLAttribute( siteKeywords() );
	}


	/**
	 * Set the Meta Canonical URL for the request
	 *
	 * @url - The new url
	 */
	function setMetaURL( required string url ){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		prc.meta.url = arguments.url;
	}

	/**
	 * Get the Meta Canonical URL for the request
	 */
	function getMetaURL(){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		if ( structKeyExists( prc.meta, "url" ) ) {
			return prc.meta.url;
		} else {
			return "";
		}
	}


	/**
	 * Get the Canonical URL based on content type
	 */
	function getContentURL(){
		var oCurrentContent    = "";
		var oCurrentEntryPoint = "";

		if ( len( getMetaURL() ) ) {
			return getMetaURL();
		}

		// Check if in page view or entry view
		if ( isPageView() ) {
			oCurrentContent    = getCurrentPage();
			oCurrentEntryPoint = "";
		} else if ( isEntryView() ) {
			oCurrentContent    = getCurrentEntry();
			oCurrentEntryPoint = setting( "cb_site_blog_entrypoint" ) & "/";
		}

		// in context view or global
		if ( isObject( oCurrentContent ) AND len( oCurrentContent.getslug() ) ) {
			return siteBaseURL() & oCurrentEntryPoint & oCurrentContent.getslug();
		}
	}

	/**
	 * Set the Meta ImageURL for the request
	 *
	 * @ImageURL - The new ImageURL
	 */
	function setMetaImageURL( required string ImageURL ){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		prc.meta.ImageURL = arguments.ImageURL;
	}

	/**
	 * Get the Meta ImageURL for the request
	 */
	function getMetaImageURL(){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		if ( structKeyExists( prc.meta, "ImageURL" ) ) {
			return prc.meta.ImageURL;
		} else {
			return "";
		}
	}

	/**
	 * Get the Content Image URL based on content type
	 */
	function getContentImageURL(){
		var oCurrentContent = "";

		if ( len( getMetaImageURL() ) ) {
			return getMetaImageURL();
		}

		// Check if in page view or entry view
		if ( isPageView() ) {
			oCurrentContent = getCurrentPage();
		} else if ( isEntryView() ) {
			oCurrentContent = getCurrentEntry();
		}

		// in context view or global
		if ( isObject( oCurrentContent ) AND len( oCurrentContent.getFeaturedImageURL() ) ) {
			return siteBaseURL() & oCurrentContent.getFeaturedImageURL();
		}
	}

	/**
	 * Set the Meta OGType for the request
	 *
	 * @OGType - The new OGType
	 */
	function setMetaOGType( required string OGType ){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		prc.meta.OGType = arguments.OGType;
	}

	/**
	 * Get the Meta OGType for the request
	 */
	function getMetaOGType(){
		var prc = getPrivateRequestCollection();
		checkMetaStruct();
		if ( structKeyExists( prc.meta, "OGType" ) ) {
			return prc.meta.OGType;
		} else {
			return "";
		}
	}

	/**
	 * Get the Content Open Graph Type based on content type
	 */
	function getContentOGType(){
		if ( len( getMetaOGType() ) ) {
			return getMetaOGType();
		}

		// Check if in page view or entry view
		if ( isPageView() ) {
			return "website";
		} else if ( isEntryView() ) {
			return "article";
		}

		return "website";
	}



	/**
	 * getOpenGraphMeta - return Open Graph Facebook friendly meta data
	 * More information: https://developers.facebook.com/docs/reference/opengraph
	 * Best Practices: https://developers.facebook.com/docs/sharing/best-practices
	 */
	function getOpenGraphMeta(){
		var content         = "";
		savecontent variable="content" {
			writeOutput( "<meta property=""og:title""              content=""#getContentTitle()#"" />#chr( 10 )#" );
			writeOutput( "<meta property=""og:type""               content=""#getContentOGType()#"" />#chr( 10 )#" );
			if ( len( getContentURL() ) ) {
				writeOutput( "<meta property=""og:url""                content=""#getContentURL()#"" />#chr( 10 )#" );
			}
			if ( len( getContentURL() ) ) {
				writeOutput(
					"<meta property=""og:description""        content=""#getContentDescription()#"" />#chr( 10 )#"
				);
			}
			if ( len( getContentImageURL() ) ) {
				writeOutput(
					"<meta property=""og:image""              content=""#getContentImageURL()#"" />#chr( 10 )#"
				);
			}
		}

		return content;
	}


	/************************************** search *********************************************/

	// Determine if you are in the search view
	boolean function isSearchView(){
		var event = getRequestContext();
		return ( event.getCurrentEvent() eq "contentbox-ui:page.search" );
	}

	/**
	 * quickSearchForm will build a standard ContentBox Content Search Form according to the SearchForm widget
	 */
	function quickSearchForm(){
		return widget( "SearchForm", { type : "content" } );
	}

	/**
	 * Render out paging for search content
	 */
	function quickSearchPaging(){
		var prc = getRequestCollection( private = true );
		if ( NOT structKeyExists( prc, "oPaging" ) ) {
			throw(
				message = "Paging object is not in the collection",
				detail  = "This probably means you are trying to use the paging outside of the search results page and that is a No No",
				type    = "ContentBox.CBHelper.InvalidPagingContext"
			);
		}
		return prc.oPaging.renderit(
			foundRows     = getSearchResults().getTotal(),
			link          = prc.pagingLink,
			pagingMaxRows = setting( "cb_search_maxResults" )
		);
	}

	/**
	 * Get the curent search results object
	 *
	 * @return contentbox.models.search.SearchResults
	 */
	function getSearchResults(){
		var event = getRequestContext();
		return event.getValue(
			name    = "searchResults",
			private = "true",
			default = ""
		);
	}

	/**
	 * get the curent search results HTML content
	 */
	any function getSearchResultsContent(){
		var event = getRequestContext();
		return event.getValue(
			name    = "searchResultsContent",
			private = "true",
			default = ""
		);
	}

	/**
	 * Determine if you have a search term
	 */
	boolean function searchTermExists(){
		var rc = getRequestCollection();
		return ( structKeyExists( rc, "q" ) AND len( rc.q ) );
	}

	/**
	 * Get Search Term used
	 */
	function getSearchTerm(){
		return getRequestContext().getValue( "q", "" );
	}

	/************************************** events *********************************************/

	// event announcements, funky for whitespace reasons
	function event( required state, struct data = structNew() ) output="true"{
		controller.getInterceptorService().announce( arguments.state, arguments.data );
	}

	/************************************** link methods *********************************************/

	/**
	 * Build out ContentBox module links
	 *
	 * @module      The module to link this URL to
	 * @to          The handler action combination to link to
	 * @queryString The query string to append in SES format
	 * @ssl         Create the link in SSL or not
	 */
	function buildModuleLink(
		required string module,
		required string to,
		queryString = "",
		boolean ssl = getRequestContext().isSSL()
	){
		// Remove by 6.x
		if ( !isNull( arguments.linkTo ) ) {
			arguments.to = arguments.linkTo;
		}
		return getRequestContext().buildLink(
			to         : adminRoot() & ".module.#arguments.module#.#arguments.to#",
			queryString: arguments.queryString,
			ssl        : arguments.ssl
		);
	}

	/**
	 * @deprecated Please use moduleRelocate()
	 */
	function setNextModuleEvent(
		required string module,
		required string event,
		string URL,
		string URI,
		string queryString = "",
		persist,
		struct persistStruct
		boolean addToken,
		boolean ssl,
		baseURL,
		boolean postProcessExempt,
		numeric statusCode
	){
		return moduleRelocate( argumentCollection = arguments );
	}

	/**
	 * Relocate to a ContentBox module event
	 *
	 * @module            The module to link this URL to
	 * @event             The name of the event to run, if not passed, then it will use the default event found in your configuration file
	 * @URL               The full URL you would like to relocate to instead of an event: ex: URL='http://www.google.com'
	 * @URI               The relative URI you would like to relocate to instead of an event: ex: URI='/mypath/awesome/here'
	 * @queryString       The query string to append, if needed. If in SES mode it will be translated to convention name value pairs
	 * @persist           What request collection keys to persist in flash ram
	 * @persistStruct     A structure key-value pairs to persist in flash ram
	 * @addToken          Wether to add the tokens or not. Default is false
	 * @ssl               Whether to relocate in SSL or not
	 * @baseURL           Use this baseURL instead of the index.cfm that is used by default. You can use this for ssl or any full base url you would like to use. Ex: https://mysite.com/index.cfm
	 * @postProcessExempt Do not fire the postProcess interceptors
	 * @statusCode        The status code to use in the relocation
	 */
	function moduleRelocate(
		required string module,
		required string event,
		string URL,
		string URI,
		string queryString = "",
		persist,
		struct persistStruct
		boolean addToken,
		boolean ssl,
		baseURL,
		boolean postProcessExempt,
		numeric statusCode
	){
		arguments.event = adminRoot() & ".module.#arguments.module#.#arguments.event#";
		return controller.relocate( argumentCollection = arguments );
	}

	/**
	 * Link to the admin
	 *
	 * @event An optional event to link to
	 * @ssl   Use SSL or not, defaults to event context.
	 */
	function linkAdmin( event = "", boolean ssl = getRequestContext().isSSL() ){
		return getRequestContext().buildLink( to = adminRoot() & ".#arguments.event#", ssl = arguments.ssl );
	}

	/**
	 * Link to the admin logout
	 *
	 * @ssl Use SSL or not, defaults to event context.
	 */
	function linkAdminLogout( boolean ssl = getRequestContext().isSSL() ){
		return getRequestContext().buildLink( to = adminRoot() & "/security/doLogout", ssl = arguments.ssl );
	}

	/**
	 * Link to the admin login
	 *
	 * @ssl Use SSL or not, defaults to event context.
	 */
	function linkAdminLogin( boolean ssl = getRequestContext().isSSL() ){
		return getRequestContext().buildLink( to = adminRoot() & "/security/login", ssl = arguments.ssl );
	}

	/**
	 * Create a link to your site homepage
	 *
	 * @siteID The site id to link to or use the default
	 */
	function linkHome( string siteID = "" ){
		return siteRoot( arguments.siteID );
	}

	/**
	 * Create a link to your site blog
	 *
	 * @siteID The site id to link to or use the default
	 */
	function linkBlog( string siteID = "" ){
		return "#siteRoot( arguments.siteID )#/#getBlogEntryPoint()#";
	}

	/**
	 * Create a link to the current page/entry you are on
	 */
	function linkSelf(){
		return "#siteRoot()##sep()##cgi.script_name##cgi.path_info#";
	}

	/**
	 * Get the site URL separator depending if you have an entry point or not
	 */
	private function sep(){
		return "/";
	}

	/**
	 * Link to RSS feeds that ContentBox generates, by default it is the recent updates feed
	 *
	 * @category You can optionally pass the category to filter on
	 * @comments A boolean flag that determines if you want the comments RSS feed
	 * @entry    You can optionally pass the entry to filter the comment's RSS feed
	 * @ssl      Use SSL or not, defaults to false.
	 */
	function linkRSS(
		category,
		comments = false,
		entry,
		boolean ssl = getRequestContext().isSSL()
	){
		var xehRSS = linkBlog() & "/rss";

		// do we have a category?
		if ( structKeyExists( arguments, "category" ) ) {
			xehRSS &= "/category/#arguments.category.getSlug()#";
			return xehRSS;
		}

		// comments feed?
		if ( arguments.comments ) {
			xehRSS &= "/comments";
			// do we have entry filter
			if ( structKeyExists( arguments, "entry" ) ) {
				xehRSS &= "/#arguments.entry.getSlug()#";
			}
		}

		// build link to regular RSS feed
		return xehRss;
	}

	/**
	 * Link to the ContentBox Site RSS Feeds
	 *
	 * @category The category to filter on
	 * @comments Do comments RSS feeds
	 * @slug     The content slug to filter on when using comments
	 * @ssl      Use SSL or not, defaults to false.
	 */
	function linkSiteRSS(
		any category,
		boolean comments = false,
		string slug,
		boolean ssl = getRequestContext().isSSL()
	){
		var xehRSS = siteRoot() & sep() & "__rss";

		// do we have a category?
		if ( structKeyExists( arguments, "category" ) ) {
			if ( isSimpleValue( arguments.category ) ) {
				xehRSS &= "/category/#arguments.category#";
			} else {
				xehRSS &= "/category/#arguments.category.getSlug()#";
			}
			return xehRSS;
		}

		// comments feed?
		if ( arguments.comments ) {
			xehRSS &= "/comments";
			// do we have content filter
			if ( structKeyExists( arguments, "slug" ) ) {
				xehRSS &= "/#arguments.slug#";
			}
		}

		return xehRSS;
	}

	/**
	 * Link to the ContentBox Page RSS Feeds
	 *
	 * @category The category to filter on
	 * @comments Page comments or not, defaults to false
	 * @page     The page you want to filter on
	 * @ssl      Use SSL or not, defaults to false.
	 */
	function linkPageRSS(
		any category,
		boolean comments = false,
		page,
		boolean ssl = getRequestContext().isSSL()
	){
		var xehRSS = siteRoot() & sep() & "__rss/pages";

		// do we have a category?
		if ( structKeyExists( arguments, "category" ) ) {
			if ( isSimpleValue( arguments.category ) ) {
				xehRSS &= "/category/#arguments.category#";
			} else {
				xehRSS &= "/category/#arguments.category.getSlug()#";
			}
			return xehRSS;
		}

		// comments feed?
		if ( arguments.comments ) {
			xehRSS &= "/comments";
			// do we have content filter
			if ( structKeyExists( arguments, "page" ) ) {
				xehRSS &= "/#arguments.page.getSlug()#";
			}
		}

		return xehRSS;
	}

	/**
	 * Link to a specific filtered category view of blog entries
	 *
	 * @category The category object or slug to link to
	 * @ssl      Use SSL or not, defaults to false.
	 */
	function linkCategory( required any category, boolean ssl = getRequestContext().isSSL() ){
		var categorySlug = "";
		if ( isSimpleValue( arguments.category ) ) {
			categorySlug = arguments.category;
		} else {
			categorySlug = arguments.category.getSlug();
		}

		return linkCategoryWithSlug( categorySlug, arguments.ssl );
	}

	/**
	 * Link to a specific filtered category view of blog entries
	 *
	 * @categorySlug The category slug as a string to link to
	 * @ssl          Use SSL or not, defaults to false.
	 */
	function linkCategoryWithSlug( required string categorySlug, boolean ssl = getRequestContext().isSSL() ){
		return linkBlog() & "/category/#arguments.categorySlug#";
	}

	/**
	 * Link to a specific filtered archive of entries
	 *
	 * @year  The year of the archive
	 * @month The month of the archive
	 * @day   The day of the archive
	 * @ssl   Use SSL or not, defaults to false.
	 */
	function linkArchive(
		year,
		month,
		day,
		boolean ssl = getRequestContext().isSSL()
	){
		var xeh = linkBlog() & "/archives";

		if ( structKeyExists( arguments, "year" ) ) {
			xeh &= "/#arguments.year#";
		}
		if ( structKeyExists( arguments, "month" ) ) {
			xeh &= "/#arguments.month#";
		}
		if ( structKeyExists( arguments, "day" ) ) {
			xeh &= "/#arguments.day#";
		}

		return xeh;
	}

	/**
	 * Link to the search route for this blog
	 *
	 * @ssl Use SSL or not, defaults to false.
	 */
	function linkSearch( boolean ssl = getRequestContext().isSSL() ){
		return linkBlog() & "/search";
	}

	/**
	 * Link to the content search route
	 *
	 * @ssl Use SSL or not, defaults to false.
	 */
	function linkContentSearch( boolean ssl = getRequestContext().isSSL() ){
		return siteRoot() & sep() & "__search";
	}

	/**
	 * Link to the content subscription route
	 *
	 * @ssl Use SSL or not, defaults to false.
	 */
	function linkContentSubscription( boolean ssl = getRequestContext().isSSL() ){
		return siteRoot() & sep() & "__subscribe";
	}

	/**
	 * Link to the ContentBox Content Subscription unsubscribe URL
	 *
	 * @token The token to use for unsubscribing
	 */
	function linkContentUnsubscribe( required string token, boolean ssl = getRequestContext().isSSL() ){
		return siteRoot() & sep() & "__unsubscribe/#arguments.token#";
	}

	/**
	 * Link to a specific blog entry's page
	 *
	 * @entry  The entry to link to
	 * @ssl    Use SSL or not, defaults to false.
	 * @format The format output of the content default is HTML bu you can pass pdf,print or doc.
	 */
	function linkEntry(
		required entry,
		boolean ssl = getRequestContext().isSSL(),
		format      = "html"
	){
		// format?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );

		if ( isSimpleValue( arguments.entry ) ) {
			return linkEntrywithslug(
				arguments.entry,
				arguments.ssl,
				arguments.format
			);
		}

		return linkBlog( arguments.entry.getsiteID() ) & "/" & arguments.entry.getSlug() & outputFormat;
	}

	/**
	 * Link to a specific entry's page using a slug only
	 *
	 * @slug   The entry slug to link to
	 * @ssl    Use SSL or not, defaults to false.
	 * @format The format output of the content default is HTML bu you can pass pdf,print or doc.
	 */
	function linkEntryWithSlug(
		required slug,
		boolean ssl = getRequestContext().isSSL(),
		format      = "html"
	){
		// format?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );
		// Cleanup
		arguments.slug   = reReplace( arguments.slug, "^/", "" );
		// link
		return linkBlog() & sep() & arguments.slug & outputFormat;
	}

	/**
	 * Link to a specific content object
	 *
	 * @content The content object to link to
	 * @ssl     Use SSL or not, defaults to false.
	 * @format  The format output of the content default is HTML but you can pass pdf,print or doc.
	 */
	function linkContent(
		required content,
		boolean ssl = getRequestContext().isSSL(),
		format      = "html"
	){
		if ( arguments.content.getContentType() eq "entry" ) {
			return linkEntry(
				arguments.content,
				arguments.ssl,
				arguments.format
			);
		}
		if ( arguments.content.getContentType() eq "page" ) {
			return linkPage(
				arguments.content,
				arguments.ssl,
				arguments.format
			);
		}
	}

	/**
	 * Link to a specific page
	 *
	 * @page   The page to link to. This can be a simple value or a page object
	 * @ssl    Use SSL or not, defaults to false.
	 * @format The format extension output of the content default is HTML but you can pass pdf, print or doc.
	 *
	 * @return The link to this page
	 */
	function linkPage(
		required page,
		boolean ssl = getRequestContext().isSSL(),
		format      = "html"
	){
		// format extension?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );

		// link directly or with slug
		if ( isSimpleValue( arguments.page ) ) {
			return linkPageWithSlug(
				arguments.page,
				arguments.ssl,
				arguments.format
			);
		}

		// Build out the link
		return siteRoot( arguments.page.getsiteID() ) & sep() & arguments.page.getSlug() & outputFormat;
	}

	/**
	 * Link to a specific page using a slug only
	 *
	 * @slug   The page slug to link to
	 * @ssl    Use SSL or not, defaults to false.
	 * @format The format output of the content default is HTML bu you can pass pdf,print or doc.
	 */
	function linkPageWithSlug(
		required slug,
		boolean ssl = getRequestContext().isSSL(),
		format      = "html"
	){
		// format?
		var outputFormat = ( arguments.format neq "html" ? ".#arguments.format#" : "" );
		// cleanup
		arguments.slug   = reReplace( arguments.slug, "^/", "" );
		// Return the formed link
		return siteRoot() & sep() & arguments.slug & outputFormat;
	}

	/**
	 * Create a link to a specific comment in a page or in an entry
	 *
	 * @comment The comment to link to
	 * @ssl     Use SSL or not, defaults to false.
	 */
	function linkComment( required comment, boolean ssl = getRequestContext().isSSL() ){
		var xeh = "";
		if ( arguments.comment.getRelatedContent().getContentType() eq "page" ) {
			xeh = linkPage( arguments.comment.getRelatedContent(), arguments.ssl );
		} else {
			xeh = linkEntry( arguments.comment.getRelatedContent(), arguments.ssl );
		}

		xeh &= "##comment_#arguments.comment.getCommentID()#";
		return xeh;
	}

	/**
	 * Create a link to an entry's or page's comments section
	 *
	 * @content The entry or page to link to its comments
	 * @ssl     Use SSL or not, defaults to false.
	 */
	function linkComments( required content, boolean ssl = getRequestContext().isSSL() ){
		var xeh = "";
		if ( arguments.content.getContentType() eq "page" ) {
			xeh = linkPage( arguments.content, arguments.ssl );
		} else {
			xeh = linkEntry( arguments.content, arguments.ssl );
		}
		xeh &= "##comments";
		return xeh;
	}

	/**
	 * Link to the commenting post action, this is where comments are submitted to
	 *
	 * @content The entry or page to link to its comments
	 * @ssl     Use SSL or not, defaults to false.
	 *
	 * @return The URL to submit to.
	 */
	function linkCommentPost( required content, boolean ssl = getRequestContext().isSSL() ){
		if ( arguments.content.getContentType() eq "page" ) {
			return siteRoot() & sep() & "__pageCommentPost";
		}

		return linkEntry( arguments.content, arguments.ssl ) & "/commentPost";
	}

	/**
	 * Link to the __changeLang route, this is where the fwLocale is changed
	 *
	 * @lang The iso language code
	 */
	function linkLanguageChange( string lang = "en_US" ){
		return getRequestContext().buildLink( "__changeLang/" & arguments.lang );
	}

	/************************************** widget functions *********************************************/

	/**
	 * Execute a widget's renderit method
	 *
	 * @name The name of the installed widget to execute
	 * @args The argument collection to pass to the widget's renderIt() method
	 */
	function widget( required name, struct args = structNew() ){
		return getWidget( arguments.name ).renderit( argumentCollection = arguments.args );
	}

	/**
	 * Return a widget object according to name convention:
	 * - ~name = Active Theme Widget
	 * - name@module = Module Widget
	 * - module = Custom or Core Widget
	 *
	 * @name The name of the installed widget to return
	 */
	function getWidget( required name ){
		return widgetService.getWidgetByDiscovery( arguments.name );
	}

	/************************************** quick HTML *********************************************/

	/*
	 * Create entry category links to be display usually on an entry or entry list.
	 * @entry The entry to use to build its category links list.
	 */
	function quickCategoryLinks( required entry ){
		var e = arguments.entry;

		// check if it has categories
		if ( NOT e.hasCategories() ) {
			return "";
		}

		var cats    = e.getCategories();
		var catList = [];

		// iterate and create links
		for ( var x = 1; x lte arrayLen( cats ); x++ ) {
			var link = "<a href=""#linkCategory( cats[ x ] )#"" title=""Filter entries by '#cats[ x ].getCategory()#'"">#cats[ x ].getCategory()#</a>";
			arrayAppend( catList, link );
		}

		// return list of links
		return replace( arrayToList( catList ), ",", ", ", "all" );
	}

	/**
	 * Render out paging for blog entries only
	 */
	function quickPaging(){
		var prc = getRequestCollection( private = true );
		if ( NOT structKeyExists( prc, "oPaging" ) ) {
			throw(
				message = "Paging object is not in the collection",
				detail  = "This probably means you are trying to use the paging outside of the main entries index page and that is a No No",
				type    = "ContentBox.CBHelper.InvalidPagingContext"
			);
		}
		return prc.oPaging.renderit(
			foundRows     = prc.entriesCount,
			link          = prc.pagingLink,
			aslist        = true,
			pagingMaxRows = setting( "cb_paging_maxentries" )
		);
	}

	/**
	 * Render out entries in the home page by using our ColdBox collection rendering
	 *
	 * @template     The name of the template to use, by default it looks in the 'templates/entry.cfm' convention, no '.cfm' please
	 * @collectionAs The name of the iterating object in the template, by default it is called 'entry'
	 * @args         A structure of name-value pairs to pass to the template
	 */
	function quickEntries(
		string template     = "entry",
		string collectionAs = "entry",
		struct args         = structNew()
	){
		var entries = getCurrentEntries();
		return controller
			.getRenderer()
			.renderView(
				view         = "#themeName()#/templates/#arguments.template#",
				collection   = entries,
				collectionAs = arguments.collectionAs,
				args         = arguments.args
			);
	}

	/**
	 * Render out an entry using your pre-defined 'entry' template
	 *
	 * @template     The name of the template to use, by default it looks in the 'templates/entry.cfm' convention, no '.cfm' please
	 * @collectionAs The name of the iterating object in the template, by default it is called 'entry'
	 * @args         A structure of name-value pairs to pass to the template
	 */
	function quickEntry(
		string template     = "entry",
		string collectionAs = "entry",
		struct args         = structNew()
	){
		var entries = [ getCurrentEntry() ];
		return controller
			.getRenderer()
			.renderView(
				view         = "#themeName()#/templates/#arguments.template#",
				collection   = entries,
				collectionAs = arguments.collectionAs,
				args         = arguments.args
			);
	}

	/**
	 * Render out categories anywhere using ColdBox collection rendering
	 *
	 * @template     The name of the template to use, by default it looks in the 'templates/category.cfm' convention, no '.cfm' please
	 * @collectionAs The name of the iterating object in the template, by default it is called 'category'
	 * @args         A structure of name-value pairs to pass to the template
	 * @isPublic     Return public categories by default. False, return private categories, null return all categories.
	 */
	function quickCategories(
		string template     = "category",
		string collectionAs = "category",
		struct args         = structNew(),
		isPublic            = true
	){
		var categories = getCurrentCategories( argumentCollection = arguments );
		return controller
			.getRenderer()
			.renderView(
				view         = "#themeName()#/templates/#arguments.template#",
				collection   = categories,
				collectionAs = arguments.collectionAs,
				args         = arguments.args
			);
	}

	/**
	 * Render out related content anywhere using ColdBox collection rendering
	 *
	 * @template     The name of the template to use, by default it looks in the 'templates/relatedContent.cfm' convention, no '.cfm' please
	 * @collectionAs The name of the iterating object in the template, by default it is called 'relatedContent'
	 * @args         A structure of name-value pairs to pass to the template
	 */
	function quickRelatedContent(
		string template     = "relatedContent",
		string collectionAs = "relatedContent",
		struct args         = structNew()
	){
		var relatedContent = getCurrentRelatedContent();
		return controller
			.getRenderer()
			.renderView(
				view         = "#themeName()#/templates/#arguments.template#",
				collection   = relatedContent,
				collectionAs = arguments.collectionAs,
				args         = arguments.args
			);
	}

	/**
	 * Render out custom fields for the current content
	 */
	function quickCustomFields(){
		var customFields = getCurrentCustomFields();
		var content      = "";

		savecontent variable="content" {
			writeOutput( "<ul class='customFields'>" );
			for ( var thisField in customFields ) {
				writeOutput( "<li><span class='customField-key'>#thisField#:</span> #customFields[ thisField ]#</li>" );
			}
			writeOutput( "</ul>" );
		}

		return content;
	}

	/**
	 * Render out comments anywhere using ColdBox collection rendering
	 *
	 * @template     The name of the template to use, by default it looks in the 'templates/comment.cfm' convention, no '.cfm' please
	 * @collectionAs The name of the iterating object in the template, by default it is called 'comment'
	 * @args         A structure of name-value pairs to pass to the template
	 */
	function quickComments(
		string template     = "comment",
		string collectionAs = "comment",
		struct args         = structNew()
	){
		var comments = getCurrentComments();
		return controller
			.getRenderer()
			.renderView(
				view         = "#themeName()#/templates/#arguments.template#",
				collection   = comments,
				collectionAs = arguments.collectionAs,
				args         = arguments.args
			);
	}

	/**
	 * Renders out an author's avatar
	 *
	 * @author The author object to render an avatar from
	 * @size   The size of the gravatar, by default we use 25 pixels
	 */
	string function quickAvatar(
		required author,
		numeric size = 25,
		string class = "gravatar"
	){
		var targetEmail = arguments.author;
		// check if simple or not
		if ( NOT isSimpleValue( arguments.author ) ) {
			targetEmail = arguments.author.getEmail();
		}

		return wirebox
			.getInstance( "Avatar@contentbox" )
			.renderAvatar(
				email = targetEmail,
				size  = arguments.size,
				class = arguments.class
			);
	}

	/**
	 * QuickView is a proxy to ColdBox's renderview method with the addition of prefixing the location of the view according to the
	 * theme you are using. All the arguments are the same as `renderView()'s` methods
	 *
	 * @view                   The view in the theme to render
	 * @cache                  Cache the output or not
	 * @cacheTimeout           The time in minutes to cache the view
	 * @cacheLastAccessTimeout The time in minutes the view will be removed from cache if idle or requested
	 * @cacheSuffix            The suffix to add into the cache entry for this view rendering
	 * @cacheProvider          The provider to cache this view in, defaults to 'template'
	 * @module                 The module to render the view from explicitly
	 * @args                   A struct of arguments to pass into the view for rendering, will be available as 'args' in the view.
	 * @collection             A collection to use by this Renderer to render the view as many times as the items in the collection (Array or Query)
	 * @collectionAs           The name of the collection variable in the partial rendering.  If not passed, we will use the name of the view by convention
	 * @collectionStartRow     The start row to limit the collection rendering with
	 * @collectionMaxRows      The max rows to iterate over the collection rendering with
	 * @collectionDelim        A string to delimit the collection renderings by
	 * @prePostExempt          If true, pre/post view interceptors will not be fired. By default they do fire
	 */
	function quickView(
		required view,
		cache = false,
		cacheTimeout,
		cacheLastAccessTimeout,
		cacheSuffix,
		cacheProvider = "template",
		module        = "contentbox",
		struct args,
		collection,
		collectionAs               = "",
		numeric collectionStartRow = "1",
		numeric collectionMaxRows  = 0,
		collectionDelim            = "",
		boolean prepostExempt      = false
	){
		arguments.view   = "#themeName()#/views/#arguments.view#";
		arguments.module = themeRecord().module;
		return controller.getRenderer().renderView( argumentCollection = arguments );
	}

	/**
	 * QuickLayout is a proxy to ColdBox's renderLayout method with the addition of prefixing the location of the layout according to the
	 * layout theme you are using. All the arguments are the same as renderLayout()'s methods
	 *
	 * @layout        The layout to render out
	 * @view          The view to render within this layout
	 * @module        The module to explicitly render this layout from
	 * @args          An optional set of arguments that will be available to this layouts/view rendering ONLY
	 * @viewModule    The module to explicitly render the view from
	 * @prePostExempt If true, pre/post layout interceptors will not be fired. By default they do fire
	 */
	function quickLayout(
		required layout,
		view                  = "",
		module                = themeRecord().module,
		args                  = structNew(),
		viewModule            = "",
		boolean prePostExempt = false
	){
		arguments.layout = "#themeName()#/layouts/#arguments.layout#";
		return controller.getRenderer().renderLayout( argumentCollection = arguments );
	}

	/**
	 * quickCommentForm will build a standard ContentBox Comment Form according to the CommentForm widget
	 *
	 * @content The content this comment form will be linked to, page or entry
	 */
	function quickCommentForm( required content ){
		return widget( "CommentForm", { content : arguments.content } );
	}

	/**
	 * Render the incoming event's main view, basically a proxy to ColdBox's controller.getRenderer().renderView().
	 *
	 * @args
	 */
	function mainView( struct args = structNew() ){
		return controller.getRenderer().renderView( view = "", args = arguments.args );
	}

	/************************************** MENUS *********************************************/

	/**
	 * Build out a menu from the defined menus in ContentBox.
	 *
	 * @slug      The menu slug to build
	 * @type      The type either 'html' or 'data', default is HTML
	 * @slugCache The cache of menu slugs already used in this request
	 *
	 * @return HTML of the menu or a struct representing the menu
	 */
	any function menu(
		required string slug,
		required type            = "html",
		required array slugCache = []
	){
		var menu = variables.menuService.findBySlug( arguments.slug, site().getsiteID() );

		if ( menu.isLoaded() ) {
			if ( arguments.type == "data" ) {
				return menu.getMemento( includes = "menuItems" );
			} else {
				return buildProviderMenu( menu = menu, slugCache = arguments.slugCache );
			}
		}

		return "";
	}

	/**
	 * Builds out a custom menu
	 *
	 * @menu             The root menu object that should be rendered
	 * @menu.doc_generic contentbox.models.menu.Menu
	 * @slugCache        The cache of menu slugs already used in this request
	 */
	public string function buildProviderMenu( required any menu, required array slugCache = [] ){
		var listType   = arguments.menu.getListType();
		// arguments.listType = !reFindNoCase( "^(ul|ol)$", arguments.listType ) ? "<ul>" : arguments.listType;
		// set start
		var menuString = "<#listType# class='#arguments.menu.getMenuClass()#'>";
		// now get root items
		var items      = arguments.menu.getRootMenuItems();
		// create cache of slugs to prevent infinite recursions
		arrayAppend( arguments.slugCache, menu.getSlug() );
		// build out this top level
		menuString &= buildProviderMenuLevel(
			items     = items,
			listType  = listType,
			slugCache = slugCache,
			listClass = arguments.menu.getListClass()
		);
		// set end
		menuString &= "</#listType#>";
		return menuString;
	}

	/**
	 * Builds out a level of a custom menu
	 *
	 * @items     An array of menu items for this level
	 * @listType  The type of list to create (derived from owning menu)
	 * @slugCache The cache of menu slugs already used in this request
	 */
	private string function buildProviderMenuLevel(
		required array items,
		required string listType = "ul",
		required array slugCache = [],
		string listClass         = ""
	){
		var menuString = "";
		// loop over items to build out level
		for ( var item in arguments.items ) {
			var extras = {
				slugCache : arguments.slugCache,
				listType  : arguments.listType
			};
			// check that item can be added
			if ( item.canDisplay( options = extras ) ) {
				// get template from provider
				menuString &= "<li class=""#item.getItemClass()#"">" & item
					.getProvider()
					.getDisplayTemplate( item, extras );
				// if this menu item has children...
				if ( item.hasChild() ) {
					// recurse, recurse, recurse!
					menuString &= "<#arguments.listType# class='#arguments.listClass#'>" &
					buildProviderMenuLevel(
						items     = item.getChildren(),
						listType  = arguments.listType,
						slugCache = arguments.slugCache
					) &
					"</#arguments.listType#>";
				}
				menuString &= "</li>";
			}
		}
		return menuString;
	}

	/**
	 * Render out a quick menu for root level pages
	 *
	 * @excludes     The list of pages to exclude from the menu
	 * @type         The type of menu, valid choices are: ul,ol,li,data,none
	 * @typeClass    The CSS class(es) to add to the type tag, defaults to 'submenu'
	 * @separator    Used if type eq none, to separate the list of href's
	 * @levels       The number of levels to nest hierarchical pages, by default it does only 1 level, * does all levels
	 * @elementClass The name of the CSS class to attach to the menu <li> element
	 * @parentClass  The name of the CSS class to attach to the menu <li> element when it has nested elements, by default it is 'parent'
	 * @activeClass  The name of the CSS class to attach to the menu <li> element when that element is the current page you are on, by default it is 'active'
	 */
	function rootMenu(
		excludes     = "",
		type         = "ul",
		typeClass    = "",
		separator    = "",
		levels       = "1",
		elementClass = "",
		parentClass  = "parent",
		activeClass  = "active"
	){
		arguments.showNone    = false;
		// get root pages
		arguments.pageRecords = pageService.findPublishedContent(
			parent    : "",
			showInMenu: true,
			siteID    : site().getsiteID(),
			properties: "contentID,slug,title,numberOfChildren",
			sortOrder : "order ASC, publishedDate ASC"
		);
		// build it out
		return buildMenu( argumentCollection = arguments );
	}

	/**
	 * Create a sub page menu for a given page or current page
	 *
	 * @page               Optional page to create menu for, else look for current page, this can be a page object or a page slug
	 * @excludes           The list of pages to exclude from the menu
	 * @type               The type of menu, valid choices are: ul,ol,li,none
	 * @typeClass          The CSS class(es) to add to the type tag, defaults to 'submenu'
	 * @separator          Used if type eq none, to separate the list of href's
	 * @showNone           Shows a 'No Sub Pages' message or not
	 * @levels             The number of levels to nest hierarchical pages, by default it does only 1 level, * does all levels
	 * @elementClass       The name of the CSS class to attach to the menu <li> element
	 * @parentClass        The name of the CSS class to attach to the menu <li> element when it has nested elements, by default it is 'parent'
	 * @activeClass        The name of the CSS class to attach to the menu <li> element when that element is the current page you are on, by default it is 'active'
	 * @activeShowChildren If true, then we will show the children of the active menu element, else we just show the active element
	 */
	function subPageMenu(
		any page,
		excludes           = "",
		type               = "ul",
		typeClass          = "",
		separator          = "",
		boolean showNone   = true,
		levels             = "1",
		elementClass       = "",
		parentClass        = "parent",
		activeClass        = "active",
		activeShowChildren = false
	){
		// If page not passed, or empty, then use the current page
		if ( isNull( arguments.page ) || ( isSimpleValue( arguments.page ) && !len( arguments.page ) ) ) {
			arguments.page = getCurrentPage();
		}

		// Is page passed as slug string or object
		if ( isSimpleValue( arguments.page ) ) {
			// retrieve page by slug
			arguments.page = pageService.findBySlug( arguments.page );
		}

		// get child pages
		arguments.pageRecords = pageService.findPublishedContent(
			parent    : page.getContentID(),
			showInMenu: true,
			siteID    : site().getsiteID(),
			properties: "contentID,slug,title,numberOfChildren",
			sortOrder : "order ASC, publishedDate ASC"
		);

		// build it out
		return buildMenu( argumentCollection = arguments );
	}

	/**
	 * Create an href to a page's parent
	 *
	 * @page Optional page to create link for, else look for current page
	 * @text The optional text to use for the link, else it uses the page's title
	 */
	function linkToParentPage( page, text = "" ){
		// verify incoming page
		if ( !structKeyExists( arguments, "page" ) ) {
			arguments.page = getCurrentPage();
		}
		// link if parent found.
		if ( arguments.page.hasParent() ) {
			if ( !len( arguments.text ) ) {
				arguments.text = arguments.page.getParent().getTitle();
			}
			// build link
			return "<a href=""#linkPage( arguments.page.getParent() )#"">#arguments.text#</a>";
		}
		return "";
	}

	/**
	 * Create breadcrumbs for a UI page
	 *
	 * @page      Optional page to create link for, else look for current page
	 * @separator Breadcrumb separator, defaults to '>'
	 */
	function breadCrumbs( any page, string separator = ">" ){
		// verify incoming page
		if ( !structKeyExists( arguments, "page" ) ) {
			arguments.page = getCurrentPage();
		}
		return wirebox.getInstance( "PageBreadcrumbVisitor@contentbox-ui" ).visit( arguments.page, arguments.separator );
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

	/**
	 * Retrieve i18n resources
	 *
	 * @resource     The resource (key) to retrieve from a loaded bundle or pass a @bundle
	 * @defaultValue A default value to send back if the resource (key) not found
	 * @locale       Pass in which locale to take the resource from. By default it uses the user's current set locale
	 * @values       An array, struct or simple string of value replacements to use on the resource string
	 * @bundle       The bundle alias to use to get the resource from when using multiple resource bundles. By default the bundle name used is 'default'
	 */
	any function r(
		required string resource,
		string defaultValue,
		string locale,
		any values,
		string bundle
	){
		// check for resource@bundle convention:
		if ( find( "@", arguments.resource ) ) {
			arguments.bundle   = listLast( arguments.resource, "@" );
			arguments.resource = listFirst( arguments.resource, "@" );
		}
		return variables.cbResourceService.getResource( argumentCollection = arguments );
	}

	/**
	 * utility to strip HTML
	 */
	function stripHTML( required stringTarget ){
		return encodeForHTML( reReplaceNoCase( arguments.stringTarget, "<[^>]*>", "", "ALL" ) );
	}

	/**
	 * removes CR LF TAB double spaces from string
	 */
	function stripWhitespace( required stringTarget ){
		arguments.stringTarget = reReplace( arguments.stringTarget, "\s", " ", "ALL" );
		return trim( reReplace( arguments.stringTarget, "\s{2,}", " ", "ALL" ) );
	}

	/************************************** PRIVATE *********************************************/

	private function buildMenu(
		pageRecords,
		excludes             = "",
		type                 = "ul",
		typeClass            = "submenu",
		separator            = "",
		boolean showNone     = true,
		levels               = "1",
		numeric currentLevel = "1",
		elementClass         = "",
		parentClass          = "parent",
		activeClass          = "active",
		activeShowChildren   = false
	){
		// Levels = *, then create big enough integer
		if ( arguments.levels eq "*" ) {
			arguments.levels = "999999";
		}
		// check type?
		if ( !reFindNoCase( "^(ul|ol|li|data|none)$", arguments.type ) ) {
			arguments.type = "ul";
		}
		var pageResults            = arguments.pageRecords;
		// buffer
		var b                      = createObject( "java", "java.lang.StringBuilder" ).init( "" );
		// current page?
		var prc                    = getRequestCollection( private = true );
		var pageAncestorContentIDs = "";
		var locPage                = "";
		// class text
		var classtext              = [];
		var currentPageID          = 0;

		// Get contentID
		if ( structKeyExists( prc, "page" ) and prc.page.isLoaded() ) {
			locPage                = getCurrentPage();
			currentPageID          = locPage.getContentID();
			pageAncestorContentIDs = locPage.getContentID();
			// If this is subnav, add ancestry trail
			while ( locPage.hasParent() ) {
				locPage                = locPage.getParent();
				pageAncestorContentIDs = listAppend( pageAncestorContentIDs, locPage.getContentID() );
			}
		}

		// list start
		if ( !listFindNoCase( "li,none,data", arguments.type ) ) {
			b.append( "<#arguments.type# class=""#arguments.typeClass#"">" );
		}
		// data setup
		if ( arguments.type eq "data" ) {
			var dataMenu = [];
		}

		// Iterate through pages and create sub menus
		for ( var x = 1; x lte pageResults.count; x++ ) {
			// Build up the element class into the current classText array list
			if ( isSimpleValue( arguments.elementClass ) ) {
				arguments.elementClass = listToArray( arguments.elementClass );
			}
			classText = duplicate( arguments.elementClass );

			if ( !len( arguments.excludes ) OR !listFindNoCase( arguments.excludes, pageResults.content[ x ][ "title" ] ) ) {
				// Do we need to nest?
				try {
					var doNesting = (
						arguments.currentLevel lt arguments.levels AND pageResults.content[ x ][ "numberOfChildren" ] > 0
					);
				} catch ( any e ) {
					writeDump( var = callStackGet() );
					writeDump( var = pageResults, top = 5 );
					writeDump( var = e );
					abort;
				}
				// Is element active (or one of its decendants)
				var isElementActive         = currentPageID eq pageResults.content[ x ][ "contentID" ];
				var isElementActiveAncestor = (
					listFindNoCase( pageAncestorContentIDs, pageResults.content[ x ][ "contentID" ] )
				);
				// class = active? Then add to class text
				if ( isElementActive ) {
					arrayAppend( classText, arguments.activeClass );
				}

				// list
				if ( arguments.type neq "none" and arguments.type neq "data" ) {
					// Nested Levels?
					if ( doNesting ) {
						// Setup Parent class, we are going down the wormhole
						arrayAppend( classText, arguments.parentClass );
						// Start Embedded List
						b.append(
							"<li class=""#arrayToList( classText, " " )#""><a href=""#linkPageWithSlug( pageResults.content[ x ][ "slug" ] )#"">#pageResults.content[ x ][ "title" ]#</a>"
						);
						// If type is "li" then guess to do a nested ul list
						b.append(
							buildMenu(
								pageRecords = pageService.findPublishedContent(
									parent    : pageResults.content[ x ][ "contentID" ],
									showInMenu: true,
									siteID    : site().getsiteID(),
									properties: "contentID,slug,title,numberOfChildren",
									sortOrder : "order ASC, publishedDate ASC"
								),
								excludes           = arguments.excludes,
								type               = ( arguments.type eq "li" ? "ul" : arguments.type ),
								typeClass          = arguments.typeClass,
								elementClass       = arguments.elementClass,
								showNone           = arguments.showNone,
								levels             = arguments.levels,
								currentLevel       = arguments.currentLevel + 1,
								activeShowChildren = arguments.activeShowChildren
							)
						);
					}
					// Do we nest active and activeShowChildren flag is activated?
					else if (
						activeShowChildren AND ( isElementActive OR isElementActiveAncestor ) AND pageResults.content[ x ].hasChild()
					) {
						// Setup Parent class, we are going down the wormhole
						arrayAppend( classText, arguments.parentClass );
						// Start Embedded List
						b.append(
							"<li class=""#arrayToList( classText, " " )#""><a href=""#linkPageWithSlug( pageResults.content[ x ][ "slug" ] )#"">#pageResults.content[ x ][ "title" ]#</a>"
						);
						// If type is "li" then guess to do a nested ul list
						b.append(
							buildMenu(
								pageRecords = pageService.findPublishedContent(
									parent    : pageResults.content[ x ][ "contentID" ],
									showInMenu: true,
									siteID    : site().getsiteID(),
									properties: "contentID,slug,title,numberOfChildren",
									sortOrder : "order ASC, publishedDate ASC"
								),
								excludes           = arguments.excludes,
								type               = ( arguments.type eq "li" ? "ul" : arguments.type ),
								typeClass          = arguments.typeClass,
								showNone           = arguments.showNone,
								levels             = 1,
								elementClass       = arguments.elementClass,
								currentLevel       = arguments.currentLevel + 1,
								activeShowChildren = activeShowChildren
							)
						);
					} else {
						// Start Embedded List
						b.append(
							"<li class=""#arrayToList( classText, " " )#""><a href=""#linkPageWithSlug( pageResults.content[ x ][ "slug" ] )#"">#pageResults.content[ x ][ "title" ]#</a>"
						);
					}

					// Close it
					b.append( "</li>" );
				} else if ( arguments.type eq "data" ) {
					var pageData = {
						title : pageResults.content[ x ][ "title" ],
						link  : linkPageWithSlug( pageResults.content[ x ][ "slug" ] )
					};
					if ( doNesting ) {
						pageData.subPageMenu = buildMenu(
							pageRecords = pageService.findPublishedContent(
								parent    : pageResults.content[ x ][ "contentID" ],
								showInMenu: true,
								siteID    : site().getsiteID(),
								properties: "contentID,slug,title,numberOfChildren",
								sortOrder : "order ASC, publishedDate ASC"
							),
							excludes           = arguments.excludes,
							type               = arguments.type,
							typeClass          = arguments.typeClass,
							showNone           = arguments.showNone,
							elementClass       = arguments.elementClass,
							levels             = arguments.levels,
							currentLevel       = arguments.currentLevel + 1,
							activeShowChildren = arguments.activeShowChildren
						);
					}
					// Do we nest active and activeShowChildren flag is activated?
					else if (
						activeShowChildren AND isElementActive AND pageResults.content[ x ][ "numberOfChildren" ] > 0
					) {
						pageData.subPageMenu = buildMenu(
							pageRecords = pageService.findPublishedContent(
								parent    : pageResults.content[ x ][ "contentID" ],
								showInMenu: true,
								siteID    : site().getsiteID(),
								properties: "contentID,slug,title,numberOfChildren",
								sortOrder : "order ASC, publishedDate ASC"
							),
							excludes           = arguments.excludes,
							type               = arguments.type,
							typeClass          = arguments.typeClass,
							showNone           = arguments.showNone,
							elementClass       = arguments.elementClass,
							levels             = 1,
							currentLevel       = arguments.currentLevel + 1,
							activeShowChildren = arguments.activeShowChildren
						);
					}
					arrayAppend( dataMenu, pageData );
				} else {
					b.append(
						"<a href=""#linkPageWithSlug( pageResults.content[ x ][ "slug" ] )#"" class=""#arrayToList( classText, " " )#"">#pageResults.content[ x ][ "title" ]#</a>#arguments.separator#"
					);
				}
			}
		}

		if ( arguments.type eq "data" ) {
			return dataMenu;
		}

		// None?
		if ( pageResults.count eq 0 and arguments.showNone ) {
			b.append( "<li>No Sub Pages</li>" );
		}

		// list end
		if ( !listFindNoCase( "li,none", arguments.type ) ) {
			b.append( "</#arguments.type#>" );
		}

		// return
		return b.toString();
	}

}
