/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage system settings
 */
component extends="baseHandler" {

	// Dependencies
	property name="settingsService" inject="settingService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="pageService" inject="pageService@contentbox";
	property name="editorService" inject="editorService@contentbox";
	property name="mediaService" inject="mediaService@contentbox";
	property name="LoginTrackerService" inject="LoginTrackerService@contentbox";
	property name="mailService" inject="mailservice@cbMailservices";
	property name="markdownEditor" inject="markdownEditor@contentbox-markdowneditor";
	property name="twoFactorService" inject="twoFactorService@contentbox";

	/**
	 * Settings manager
	 *
	 * @return html
	 */
	function index( event, rc, prc ){
		// Exit Handler
		prc.xehSaveSettings    = "#prc.cbAdminEntryPoint#.settings.save";
		prc.xehEmailTest       = "#prc.cbAdminEntryPoint#.settings.emailTest";
		// Get All registered editors so we can display them
		prc.editors            = variables.editorService.getRegisteredEditorsMap();
		// Get All registered markups so we can display them
		prc.markups            = variables.editorService.getRegisteredMarkups();
		// Get all registered media providers so we can display them
		prc.mediaProviders     = variables.mediaService.getRegisteredProvidersMap();
		// Get All registered two factor providers so we can display them
		prc.twoFactorProviders = variables.twoFactorService.getRegisteredProvidersMap();
		// tab
		prc.tabSystem_Settings = true;
		// cb helper
		prc.cb                 = variables.CBHelper;
		// caches
		prc.cacheNames         = variables.cachebox.getCacheNames();
		// Markdown Editor Availability
		variables.markdownEditor.loadAssets();
		// view
		event.setView( "settings/index" );
	}

	/**
	 * Email Testing of settings
	 *
	 * @return json
	 */
	function emailTest( event, rc, prc ){
		var mail = mailservice.newMail(
			to       = rc.cb_site_outgoingEmail,
			from     = rc.cb_site_outgoingEmail,
			subject  = "ContentBox Test",
			server   = rc.cb_site_mail_server,
			username = rc.cb_site_mail_username,
			password = rc.cb_site_mail_password,
			port     = rc.cb_site_mail_smtp,
			useTLS   = rc.cb_site_mail_tls,
			useSSL   = rc.cb_site_mail_ssl,
			body     = "Test Email From ContentBox"
		);
		// send it out
		var results = mailService.send( mail );

		event.renderData( data = results, type = "json" );
	}

	/**
	 * Save settings
	 */
	function save( event, rc, prc ){
		// announce event
		announce( "cbadmin_preSettingsSave", { oldSettings : prc.cbSettings, newSettings : rc } );

		// bulk save the options
		variables.settingsService.bulkSave( rc );

		// Do blog entry point change?
		if (
			rc.keyExists( "cb_site_blog_entrypoint" ) && prc.cbSettings[ "cb_site_blog_entrypoint" ] != rc.cb_site_blog_entrypoint
		) {
			var routingService = variables.controller.getRoutingService();
			// Reroute using passed cb_site_blog_entryPoint just in case
			routingService.setRoutes(
				routingService
					.getRoutes()
					.map( function( item ){
						if ( arguments.item.namespaceRouting eq "blog" ) {
							arguments.item.pattern = item.regexpattern = replace(
								rc[ "cb_site_blog_entrypoint" ],
								"/",
								"-",
								"all"
							) & "/";
						}
						return arguments.item;
					} )
			);
		}
		// announce event
		announce( "cbadmin_postSettingsSave" );

		// relocate back to editor
		variables.cbMessagebox.info( "Settings saved!" );

		relocate( prc.xehSettings );
	}

	/**
	 * Raw settings manager
	 *
	 * @return html
	 */
	function raw( event, rc, prc ){
		// exit Handlers
		prc.xehSettingRemove    = "#prc.cbAdminEntryPoint#.settings.remove";
		prc.xehSettingsave      = "#prc.cbAdminEntryPoint#.settings.saveRaw";
		prc.xehFlushCache       = "#prc.cbAdminEntryPoint#.settings.flushCache";
		prc.xehFlushSingletons  = "#prc.cbAdminEntryPoint#.settings.flushSingletons";
		prc.xehViewCached       = "#prc.cbAdminEntryPoint#.settings.viewCached";
		prc.xehMappingDump      = "#prc.cbAdminEntryPoint#.settings.mappingDump";
		prc.xehRawSettingsTable = "#prc.cbAdminEntryPoint#.settings.rawtable";
		prc.xehExportAll        = "#prc.cbAdminEntryPoint#.settings.exportAll";
		prc.xehSettingsImport   = "#prc.cbAdminEntryPoint#.settings.importAll";

		// Get Interception Points
		prc.interceptionPoints = controller.getInterceptorService().getInterceptionPoints();
		arraySort( prc.interceptionPoints, "textnocase" );

		// Raw tab
		prc.tabSystem_geekSettings = true;

		// view
		event.setView( "settings/raw" );
	}

	/**
	 * Present the raw settings table
	 *
	 * @return html
	 */
	function rawtable( event, rc, prc ){
		// params
		event
			.paramValue( "page", 1 )
			.paramValue( "search", "" )
			.paramValue( "viewAll", false )
			.paramValue( "siteId", "" );

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@contentbox" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = event.buildLink( "#prc.xehRawSettings#.page.@page@?" );
		prc.pagingLink = "javascript:settingsPaginate(@page@)";
		prc.xehExport  = "#prc.cbAdminEntryPoint#.settings.export";

		// View all?
		var offset = prc.paging.startRow - 1;
		var max    = prc.cbSettings.cb_paging_maxrows;
		if ( rc.viewAll ) {
			offset = max = 0;
		}

		// Get settings
		var results = variables.settingsService.search(
			search   : rc.search,
			siteId   : rc.siteId,
			offset   : offset,
			max      : max,
			sortOrder: "name asc, site asc"
		);
		prc.settings      = results.settings;
		prc.settingsCount = results.count;

		event.setView( view = "settings/rawSettingsTable", layout = "ajax" );
	}

	/**
	 * Export a setting
	 */
	function export( event, rc, prc ){
		return variables.settingsService.get( event.getValue( "settingID", 0 ) ).getMemento();
	}

	/**
	 * Export multiple settings
	 */
	function exportAll( event, rc, prc ){
		param rc.settingID = "";
		// Export all or some
		if ( len( rc.settingID ) ) {
			return rc.settingID
				.listToArray()
				.map( function( id ){
					return variables.settingsService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.settingsService.getAllForExport();
		}
	}

	/**
	 * Import all settings from a file packet
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideSettings", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = settingsService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideSettings
				);
				variables.cbMessagebox.info( "Settings imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				variables.cbMessagebox.error(
					"The import file is invalid: #rc.importFile# cannot continue with import"
				);
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stacktrace#";
			log.error( errorMessage, e );
			variables.cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehRawSettings );
	}

	/**
	 * WireBox mapping dump
	 *
	 * @return html
	 */
	function mappingDump( event, rc, prc ){
		// params
		event.paramValue( "id", "" );
		prc.mapping = wirebox.getBinder().getMapping( rc.id );
		event.setView( view = "settings/mappingDump", layout = "ajax" );
	}

	/**
	 * Save all raw settings
	 */
	function saveRaw( event, rc, prc ){
		// params
		event.paramValue( "page", 1 ).paramValue( "isCore", false );

		// populate and get setting
		var setting = populateModel(
			model               : settingsService.get( rc.settingID ),
			composeRelationships: true,
			nullEmptyInclude    : "site",
			exclude             : "settingID"
		);

		// save new setting
		settingsService.save( setting );
		settingsService.flushSettingsCache();
		// messagebox
		variables.cbMessagebox.setMessage( "info", "Setting saved!" );
		// relocate
		relocate( event = prc.xehRawSettings, queryString = "page=#rc.page#" );
	}

	/**
	 * Remove a setting
	 */
	function remove( event, rc, prc ){
		// announce event
		announce( "cbadmin_preSettingRemove", { settingID : rc.settingID } );
		// delete by id
		if ( !settingsService.deleteByID( rc.settingID ) ) {
			variables.cbMessagebox.setMessage( "warning", "Invalid Setting detected!" );
		} else {
			// announce event
			announce( "cbadmin_postSettingRemove", { settingID : rc.settingID } );
			// flush cache
			settingsService.flushSettingsCache();
			variables.cbMessagebox.setMessage( "info", "Setting Removed!" );
		}
		relocate( prc.xehRawSettings );
	}

	/**
	 * Flush settings cache
	 */
	function flushCache( event, rc, prc ){
		var data = { error : false, messages : "" };
		try {
			settingsService.flushSettingsCache();
			data.messages = "Settings cache flushed!";
		} catch ( Any e ) {
			data[ "ERROR" ]    = true;
			data[ "MESSAGES" ] = "Error executing flush, please check logs: #e.message#";
			log.error( e.message & e.detail, e );
		}
		event.renderData( data = data, type = "json" );
	}

	/**
	 * Flush WireBox singletons
	 */
	function flushSingletons( event, rc, prc ){
		wirebox.clearSingletons();
		variables.cbMessagebox.setMessage( "info", "All singletons flushed and awaiting re-creation." );
		relocate( event = prc.xehRawSettings, queryString = "##wirebox" );
	}

	/**
	 * View settings cached data
	 *
	 * @return html
	 */
	function viewCached( event, rc, prc ){
		var cache    = settingsService.getSettingsCacheProvider();
		var cacheKey = settingsService.getSettingsCacheKey();
		// get Cached Settings
		prc.settings = cache.get( cacheKey );
		prc.metadata = cache.getCachedObjectMetadata( cacheKey );

		event.setView( view = "settings/viewCached", layout = "ajax" );
	}

	/**
	 * Display the auth logs manager
	 *
	 * @return html
	 */
	function authLogs( event, rc, prc ){
		prc.featureEnabled = prc.cbsettings.cb_security_login_blocker;
		prc.xehTruncate    = "#prc.cbAdminEntryPoint#.settings.truncateAuthLogs";

		// Check if the feature is enabled
		if ( prc.featureEnabled ) {
			prc.logs = variables.loginTrackerService.getAll( sortOrder = "attempts", asQuery = false );
		} else {
			prc.featureEnabled = false;
		}

		// Raw tab
		prc.tabSystem_authLogs = true;
		// View
		event.setView( "settings/authLogs" );
	}

	/**
	 * truncate all auth logs
	 */
	any function truncateAuthLogs( event, rc, prc ){
		variables.loginTrackerService.truncate();
		relocate( "#prc.cbAdminEntryPoint#.settings.authLogs" );
	}

}
