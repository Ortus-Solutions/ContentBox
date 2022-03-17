/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Static content exporter service
 */
component accessors=true threadSafe singleton {

	// DI
	property name="settingService" inject="SettingService@contentbox";
	property name="pageService" inject="PageService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="entryService" inject="entryService@contentbox";
	property name="themeService" inject="ThemeService@contentbox";
	property name="categoryService" inject="CategoryService@contentbox";
	property name="uiConfig" inject="coldbox:moduleconfig:contentbox-ui";
	property name="interceptorService" inject="coldbox:interceptorService";
	property name="zipUtil" inject="zipUtil@contentbox";
	property name="Renderer" inject="Provider:Renderer@coldbox";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Export static site with several exporting options.  The end result is the location of the generated site
	 *
	 * @exportDirectory The directory to export to, defaults to the temp site creation
	 * @includeBlog     Flag to include the blog or not in the static site export
	 * @modifiedDate    From when to export content, defaults to ALL
	 * @event           Request Context
	 * @rc              RC
	 * @prc             PRC
	 * @site            The site to export
	 *
	 * @return struct with keys: { exportLog:builder, exportDirectory, exportArchive }
	 */
	struct function export(
		exportDirectory     = "#getTempDirectory()#/cbsite",
		boolean includeBlog = true,
		modifiedDate,
		required event,
		required rc,
		required prc,
		required site
	){
		var lb      = chr( 13 ) & chr( 10 );
		var results = {
			"exportLog" : createObject( "java", "java.lang.StringBuilder" ).init(
				"Starting static site generation with the following options: #arguments.toString()#. #lb#"
			),
			"exportDirectory" : arguments.exportDirectory,
			"exportFile"      : getTempDirectory() & "/" & createUUID() & ".zip"
		};
		var allSettings = variables.settingService.getAllSettings();

		// Create export directory
		if ( directoryExists( arguments.exportDirectory ) ) {
			directoryDelete( arguments.exportDirectory, true );
		}
		directoryCreate( arguments.exportDirectory );

		results.exportLog.append( "Created export directory: #arguments.exportDirectory# #lb#" );

		// ************ Prepare as if we are doing a UI request ******************
		// store UI module root
		arguments.prc.cbRoot         = getContextRoot() & arguments.event.getModuleRoot( "contentbox" );
		// store module entry point
		arguments.prc.cbEntryPoint   = variables.uiConfig.entryPoint;
		// Place global cb options on scope
		arguments.prc.cbSettings     = allSettings;
		// Place the site to export
		arguments.prc.oCurrentSite   = arguments.site;
		// Place the default theme
		arguments.prc.cbTheme        = arguments.prc.oCurrentSite.getActiveTheme();
		// Place the default theme record
		arguments.prc.cbThemeRecord  = variables.themeService.getThemeRecord( arguments.prc.cbTheme );
		// Place theme root location
		arguments.prc.cbthemeRoot    = arguments.prc.cbRoot & "/themes/" & arguments.prc.cbTheme;
		// Place widgets root location
		arguments.prc.cbWidgetRoot   = arguments.prc.cbRoot & "/widgets";
		// Marker to tell layouts we are in static export mode
		arguments.prc.staticExport   = true;
		// Current Site
		arguments.prc.cbSiteSettings = variables.settingService.getAllSiteSettings(
			arguments.prc.oCurrentSite.getSlug()
		);

		/******************************************************************************/

		// Copy over content media
		directoryCopy(
			expandPath( allSettings.cb_media_directoryRoot ),
			arguments.exportDirectory & "/__media",
			true
		);
		// Copy over the theme
		directoryCopy(
			arguments.prc.cbThemeRecord.path,
			arguments.exportDirectory & "/__theme",
			true
		);

		// Create Blog repository
		if ( arguments.includeBlog ) {
			var blogExportDir = arguments.exportDirectory & "/" & allSettings.cb_site_blog_entrypoint;
			directoryCreate( blogExportDir );
		}

		// Announce export
		interceptorService.announce( "cbadmin_preStaticSiteExport", { options : arguments } );

		// Get root pages, we need objects in order to render out the site
		var aPages = variables.pageService.search(
			parent   = "",
			siteID   : arguments.site.getSiteID(),
			sortOrder= "order asc"
		);

		// Process Homepage
		var oHomePage = variables.pageService.findBySlug(
			slug  : arguments.prc.oCurrentSite.getHomepage(),
			siteID: arguments.site.getSiteID()
		);
		if ( !isNull( oHomePage ) && oHomepage.isLoaded() ) {
			// put in scope for fake access
			prc.page = oHomePage;
			// process it
			processStaticPage(
				content   = oHomePage,
				isHome    = true,
				event     = event,
				rc        = rc,
				prc       = prc,
				exportDir = arguments.exportDirectory,
				settings  = allSettings
			);
		}

		// Process all Pages
		for ( var thisPage in aPages.pages ) {
			// put in scope for fake access
			prc.page = thisPage;
			// process it
			processStaticPage(
				content   = thisPage,
				isHome    = false,
				event     = event,
				rc        = rc,
				prc       = prc,
				exportDir = arguments.exportDirectory,
				settings  = allSettings
			);
		}

		// Process blog entries
		if ( arguments.includeBlog ) {
			var aEntries   = variables.entryService.search( siteID: arguments.site.getSiteID() );
			// Put all categories in prc for processing
			prc.categories = variables.categoryService.search( isPublic: true, siteId: arguments.site.getSiteId() ).categories;
			// Process all entries
			for ( var thisEntry in aEntries.entries ) {
				// put in scope for fake access
				prc.entry    = thisEntry;
				prc.comments = prc.entry.getComments();
				// process it
				processStaticEntry(
					content   = thisEntry,
					event     = event,
					rc        = rc,
					prc       = prc,
					exportDir = blogExportDir,
					settings  = allSettings
				);
			}
		}

		// zip archive
		zipUtil.addFiles(
			zipFilePath = results.exportFile,
			directory   = arguments.exportDirectory,
			recurse     = true
		);

		// Announce export
		interceptorService.announce( "cbadmin_postStaticSiteExport", { options : arguments, results : results } );

		// Remove creation Folder now
		directoryDelete( arguments.exportDirectory, true );

		return results;
	}

	/*************************************** PRIVATE *************************************** */

	/**
	 * Process a static entry export
	 *
	 * @content   The content object
	 * @event     Request Context
	 * @rc        RC
	 * @prc       PRC
	 * @exportDir The location of export
	 * @settings  All of the ContentBox Settings
	 */
	private function processStaticEntry(
		required content,
		required event,
		required rc,
		required prc,
		required exportDir,
		required settings
	){
		var allSettings   = arguments.settings;
		var outputContent = "";

		// announce event
		interceptorService.announce( "cbui_preRequest" );

		// Render out entry
		arguments.event.setView(
			view   = "#arguments.prc.cbTheme#/views/entry",
			module = arguments.prc.cbThemeRecord.module
		);
		outputContent = renderer.renderLayout(
			layout = "#arguments.prc.cbTheme#/layouts/blog",
			module = arguments.prc.cbThemeRecord.module
		);

		// ****** Content Conversions ******
		// replace base tags
		outputContent = reReplaceNoCase( outputContent, "<base [^>]+?>", "", "all" );
		// replace local server addresses
		outputContent = replaceNoCase(
			outputContent,
			arguments.content.getSite().getSiteRoot(),
			"/",
			"all"
		);
		// replace theme root to new static locations
		outputContent = replaceNoCase(
			outputContent,
			arguments.prc.cbThemeRoot,
			"__theme/#arguments.prc.cbTheme#",
			"all"
		);
		// **********************************

		// Create child container, just in case
		if ( !directoryExists( exportDir & "/" & arguments.content.getSlug() ) ) {
			directoryCreate( exportDir & "/" & arguments.content.getSlug() );
		}
		// Write it out
		fileWrite( arguments.exportDir & "/" & arguments.content.getSlug() & "/index.html", outputContent );
	};

	/**
	 * Process a static page export
	 *
	 * @content   The content object
	 * @isHome    Is this the home page
	 * @event     Request Context
	 * @rc        RC
	 * @prc       PRC
	 * @exportDir The location of export
	 * @settings  All of the ContentBox Settings
	 */
	private function processStaticPage(
		required content,
		boolean isHome = false,
		required event,
		required rc,
		required prc,
		required exportDir,
		required settings
	){
		var allSettings   = arguments.settings;
		var thisLayout    = arguments.content.getLayoutWithInheritance();
		var outputContent = "";

		// announce event
		interceptorService.announce( "cbui_preRequest" );

		// Verify No Layout
		if ( thisLayout eq "-no-layout-" ) {
			outputContent = arguments.content.renderContent();
		} else {
			arguments.event.setView(
				view   = "#arguments.prc.cbTheme#/views/page",
				module = arguments.prc.cbThemeRecord.module
			);
			outputContent = renderer.renderLayout(
				layout = "#arguments.prc.cbTheme#/layouts/#thisLayout#",
				module = arguments.prc.cbThemeRecord.module
			);
		}

		// ****** Content Conversions ******
		// replace base tags
		outputContent = reReplaceNoCase( outputContent, "<base [^>]+?>", "", "all" );
		// replace local server addresses
		outputContent = replaceNoCase(
			outputContent,
			arguments.content.getSite().getSiteRoot(),
			"/",
			"all"
		);
		// replace theme root to new static locations
		outputContent = replaceNoCase(
			outputContent,
			arguments.prc.cbThemeRoot,
			"__theme/#arguments.prc.cbTheme#",
			"all"
		);
		// **********************************

		// Create child container, just in case
		if ( !directoryExists( exportDir & "/" & arguments.content.getSlug() ) ) {
			directoryCreate( exportDir & "/" & arguments.content.getSlug() );
		}

		// Write out either the home page or normal page
		if ( arguments.isHome ) {
			fileWrite( arguments.exportDir & "/index.html", outputContent );
		} else {
			fileWrite( arguments.exportDir & "/" & arguments.content.getSlug() & "/index.html", outputContent );
		}

		// Do we have children
		if ( arguments.content.hasChild() ) {
			// iterate over children and process them
			for ( var thisChild in arguments.content.getChildren() ) {
				// process it
				processStaticPage(
					content   = thisChild,
					isHome    = false,
					event     = event,
					rc        = rc,
					prc       = prc,
					exportDir = exportDir,
					settings  = allSettings
				);
			}
		}
	};

}
