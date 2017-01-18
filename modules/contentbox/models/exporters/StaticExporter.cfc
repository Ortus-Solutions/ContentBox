/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Static content exporter service
*/
component accessors=true threadSafe singleton{

	// DI
	property name="settingService" 		inject="SettingService@cb";
	property name="pageService" 		inject="PageService@cb";
	property name="entryService" 		inject="entryService@cb";
	property name="themeService" 		inject="ThemeService@cb";
	property name="categoryService" 	inject="CategoryService@cb";
	property name="uiConfig" 			inject="coldbox:moduleconfig:contentbox-ui";
	property name="interceptorService" 	inject="coldbox:interceptorService";
	property name="zipUtil"             inject="zipUtil@cb";
	property name="Renderer"            inject="Provider:Renderer@coldbox";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Export static site with several exporting options.  The end result is the location of the generated site
	 * @exportDirectory The directory to export to, defaults to the temp site creation
	 * @includeBlog Flag to include the blog or not in the static site export
	 * @modifiedDate From when to export content, defaults to ALL
	 * @event Request Context
	 * @rc RC
	 * @prc PRC
	 *
	 * @return struct with keys: { exportLog:builder, exportDirectory, exportArchive }
	 */
	struct function export(
		exportDirectory = "#getTempDirectory()#/cbsite",
		boolean includeBlog = true,
		modifiedDate,
		required event,
		required rc,
		required prc
	){
		var lb = chr( 13 ) & chr( 10 );
		var results = {
			exportLog 		= createObject( "java", "java.lang.StringBuilder" ).init( 'Starting static site generation with the following options: #arguments.toString()#. #lb#' ),
			exportDirectory = arguments.exportDirectory,
			exportFile 		= getTempDirectory() & "/" & createUUID() & ".zip"
		};
		var allSettings = variables.settingService.getAllSettings( asStruct=true );

		// Create export directory
		if( directoryExists( arguments.exportDirectory ) ){
			directoryDelete( arguments.exportDirectory, true );
		}
		directoryCreate( arguments.exportDirectory );

		results.exportLog.append( "Created export directory: #arguments.exportDirectory# #lb#" );

		// ************ Prepare as if we are doing a UI request ******************
		// store UI module root
		arguments.prc.cbRoot = getContextRoot() & arguments.event.getModuleRoot( 'contentbox' );
		// store module entry point
		arguments.prc.cbEntryPoint 	= variables.uiConfig.entryPoint;
		// Place global cb options on scope
		arguments.prc.cbSettings 	= allSettings;
		// Place the default theme
		arguments.prc.cbTheme 		= arguments.prc.cbSettings.cb_site_theme;
		// Place theme root location
		arguments.prc.cbthemeRoot 	= arguments.prc.cbRoot & "/themes/" & arguments.prc.cbTheme;
		// Place widgets root location
		arguments.prc.cbWidgetRoot 	= arguments.prc.cbRoot & "/widgets";
		// Marker to tell layouts we are in static export mode
		arguments.prc.staticExport 	= true;
		/******************************************************************************/

		// Copy over content media
		directoryCopy( expandPath( allSettings.cb_media_directoryRoot ), arguments.exportDirectory & "/__media", true );
		// Copy over the theme
		directoryCopy( themeService.getThemesPath() & "/#prc.cbTheme#", arguments.exportDirectory & "/__theme", true );

		// Create Blog repository
		if( arguments.includeBlog ){
			var blogExportDir = arguments.exportDirectory & "/" & allSettings.cb_site_blog_entrypoint;
			directoryCreate( blogExportDir );
		}

		// Announce export
		interceptorService.processState( "cbadmin_preStaticSiteExport", { options = arguments } );
		
		// Get root pages, we need objects in order to render out the site
		var aPages = pageService.search( 
			parent		= "",
			sortOrder	= "order asc"
		);

		// Process Homepage
		var oHomePage = pageService.findBySlug( allSettings.cb_site_homepage );
		if( !isNull( oHomePage ) ){
			// put in scope for fake access
			prc.page = oHomePage;
			// process it
			processStaticPage( 
				content 	= oHomePage, 
				isHome 		= true, 
				event 		= event, 
				rc 			= rc, 
				prc 		= prc, 
				exportDir 	= arguments.exportDirectory,
				settings 	= allSettings
			);
		}

		// Process all Pages
		for( var thisPage in aPages.pages ){
			// put in scope for fake access
			prc.page = thisPage;
			// process it
			processStaticPage( 
				content 	= thisPage, 
				isHome 		= false, 
				event 		= event, 
				rc 			= rc, 
				prc 		= prc, 
				exportDir 	= arguments.exportDirectory,
				settings 	= allSettings
			);
		}

		// Process blog entries
		if( arguments.includeBlog ){
			var aEntries = entryService.search();
			// Put all categories in prc for processing
			prc.categories = categoryService.list ( sortOrder="category", asQuery=false );
			// Process all entries
			for( var thisEntry in aEntries.entries ){
				// put in scope for fake access
				prc.entry 		= thisEntry;
				prc.comments 	= prc.entry.getComments();
				// process it
				processStaticEntry( 
					content 	= thisEntry, 
					event 		= event, 
					rc 			= rc, 
					prc 		= prc, 
					exportDir 	= blogExportDir,
					settings 	= allSettings
				);
			}
		}

		// zip archive
		zipUtil.addFiles( zipFilePath=results.exportFile, directory=arguments.exportDirectory, recurse=true );

		// Announce export
		interceptorService.processState( "cbadmin_postStaticSiteExport", { options = arguments, results = results } );

		// Remove creation Folder now
		directoryDelete( arguments.exportDirectory, true );

		return results;
	}

	/*************************************** PRIVATE *************************************** */

	/**
	 * Process a static entry export
	 * @content The content object
	 * @event Request Context
	 * @rc RC
	 * @prc PRC
	 * @exportDir The location of export
	 * @settings All of the ContentBox Settings
	 */
	private function processStaticEntry( 
		required content, 
		required event, 
		required rc, 
		required prc,
		required exportDir,
		required settings
	){
		var allSettings 	= arguments.settings;
		var outputContent 	= "";
		var themeName 		= allSettings.cb_site_theme;

		// announce event
		interceptorService.processState( "cbui_preRequest" );
		
		// Render out entry
		arguments.event.setView( view = "#themeName#/views/entry", module = "contentbox" );
		outputContent = renderer.renderLayout(
			layout 		= "#themeName#/layouts/blog",
			module 		= "contentbox"
		);

		//****** Content Conversions ******
		// replace base tags
		outputContent = REReplaceNoCase( outputContent, "<base [^>]+?>", "", "all" );
		// replace local server addresses
		outputContent = replaceNoCase( outputContent, arguments.event.buildLink( '' ), "/", "all" );
		// replace theme root to new static locations
		outputContent = replaceNoCase( outputContent, arguments.prc.cbThemeRoot, "/__theme", "all" );
		//**********************************

		// Create child container, just in case
		if( !directoryExists( exportDir & "/" & arguments.content.getSlug() ) ){
			directoryCreate( exportDir & "/" & arguments.content.getSlug() );
		}
		// Write it out
		fileWrite( arguments.exportDir & "/" & arguments.content.getSlug() & "/index.html", outputContent );
	};

	/**
	 * Process a static page export
	 * @content The content object
	 * @isHome Is this the home page
	 * @event Request Context
	 * @rc RC
	 * @prc PRC
	 * @exportDir The location of export
	 * @settings All of the ContentBox Settings
	 */
	private function processStaticPage( 
		required content, 
		boolean isHome=false,
		required event, 
		required rc, 
		required prc,
		required exportDir,
		required settings
	){
		var allSettings 	= arguments.settings;
		var thisLayout 		= arguments.content.getLayoutWithInheritance();
		var outputContent 	= "";
		var themeName 		= allSettings.cb_site_theme;

		// announce event
		interceptorService.processState( "cbui_preRequest" );

		// Verify No Layout
		if( thisLayout eq '-no-layout-' ){
			outputContent = arguments.content.renderContent();
		} else {
			arguments.event.setView( view = "#themeName#/views/page", module = "contentbox" );
			outputContent = renderer.renderLayout(
				layout 		= "#themeName#/layouts/#thisLayout#",
				module 		= "contentbox"
			);
		}

		//****** Content Conversions ******
		// replace base tags
		outputContent = REReplaceNoCase( outputContent, "<base [^>]+?>", "", "all" );
		// replace local server addresses
		outputContent = replaceNoCase( outputContent, arguments.event.buildLink( '' ), "/", "all" );
		// replace theme root to new static locations
		outputContent = replaceNoCase( outputContent, arguments.prc.cbThemeRoot, "/__theme", "all" );
		//**********************************

		// Create child container, just in case
		if( !directoryExists( exportDir & "/" & arguments.content.getSlug() ) ){
			directoryCreate( exportDir & "/" & arguments.content.getSlug() );
		}

		// Write out either the home page or normal page
		if( arguments.isHome ){
			fileWrite( arguments.exportDir & "/index.html", outputContent );
		} else {
			fileWrite( arguments.exportDir & "/" & arguments.content.getSlug() & "/index.html", outputContent );
		}	

		// Do we have children
		if( arguments.content.hasChild() ){
			// iterate over children and process them
			for( var thisChild in arguments.content.getChildren() ){
				// process it
				processStaticPage( 
					content 	= thisChild, 
					isHome 		= false, 
					event 		= event, 
					rc 			= rc, 
					prc 		= prc, 
					exportDir 	= exportDir,
					settings 	= allSettings
				);
			}
		}
	};

}