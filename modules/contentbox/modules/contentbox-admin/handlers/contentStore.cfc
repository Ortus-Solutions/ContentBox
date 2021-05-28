/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage content store
 */
component extends="baseContentHandler" {

	// Dependencies
	property name="contentStoreService" inject="contentStoreService@cb";
	property name="CKHelper" inject="CKHelper@contentbox-ckeditor";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";

	// Public properties
	this.preHandler_except = "pager";

	/**
	 * pre handler
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehContentEditor = "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehContentRemove = "#prc.cbAdminEntryPoint#.contentStore.remove";
	}

	/**
	 * index
	 */
	function index( event, rc, prc ){
		// params
		event.paramValue( "parent", "" );

		// get all authors
		prc.authors    = variables.authorService.getAll( sortOrder = "lastName" );
		// get all categories
		prc.categories = variables.categoryService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "category",
			asQuery  : false
		);

		// exit handlers
		prc.xehContentSearch     = "#prc.cbAdminEntryPoint#.contentStore";
		prc.xehContentTable      = "#prc.cbAdminEntryPoint#.contentStore.contentTable";
		prc.xehContentBulkStatus = "#prc.cbAdminEntryPoint#.contentStore.bulkstatus";
		prc.xehContentExportAll  = "#prc.cbAdminEntryPoint#.contentStore.exportAll";
		prc.xehContentImport     = "#prc.cbAdminEntryPoint#.contentStore.importAll";
		prc.xehContentClone      = "#prc.cbAdminEntryPoint#.contentStore.clone";
		prc.xehResetHits         = "#prc.cbAdminEntryPoint#.content.resetHits";

		// Light up
		prc.tabContent_contentStore = true;

		// view
		event.setView( "contentStore/index" );
	}

	/**
	 * index contentTable
	 */
	function contentTable( event, rc, prc ){
		// params
		event
			.paramValue( "page", 1 )
			.paramValue( "searchContent", "" )
			.paramValue( "fAuthors", "all" )
			.paramValue( "fCategories", "all" )
			.paramValue( "fStatus", "any" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "parent", "" )
			.paramValue( "showAll", false );

		// JS null checks
		if ( rc.parent eq "undefined" ) {
			rc.parent = "";
		}

		// is Filtering?
		if (
			rc.fAuthors neq "all" OR
			rc.fStatus neq "any" OR
			rc.fCategories neq "all" OR
			rc.fCreators neq "all" OR
			rc.showAll
		) {
			prc.isFiltering = true;
		}

		// Doing a search or filtering?
		if ( len( rc.searchContent ) OR prc.isFiltering ) {
			// remove parent for searches, we go hierarchy wide
			structDelete( rc, "parent" );
		}

		// search content with filters and all
		var contentResults = variables.contentStoreService.search(
			search     : rc.searchContent,
			isPublished: rc.fStatus,
			category   : rc.fCategories,
			author     : rc.fAuthors,
			creator    : rc.fCreators,
			parent     : ( !isNull( rc.parent ) ? rc.parent : javacast( "null", "" ) ),
			sortOrder  : "order asc, createdDate desc",
			siteID     : prc.oCurrentSite.getsiteID()
		);
		prc.content      = contentResults.content;
		prc.contentCount = contentResults.count;

		// Do we have a parent?
		if ( structKeyExists( rc, "parent" ) ) {
			prc.oParent = variables.contentStoreService.get( rc.parent );
		}

		// exit handlers
		prc.xehContentSearch  = "#prc.cbAdminEntryPoint#.contentStore";
		prc.xehContentHistory = "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehContentExport  = "#prc.cbAdminEntryPoint#.contentStore.export";
		prc.xehContentClone   = "#prc.cbAdminEntryPoint#.contentStore.clone";
		prc.xehContentOrder   = "#prc.cbAdminEntryPoint#.contentStore.changeOrder";

		// view
		event.setView( view = "contentStore/indexTable", layout = "ajax" );
	}

	/**
	 * Change order of content items
	 * @return json
	 */
	function changeOrder( event, rc, prc ){
		// param values
		event.paramValue( "tableID", "content" ).paramValue( "newRulesOrder", "" );

		// decode + cleanup incoming rules data
		// We replace _ to - due to the js plugin issue of not liking dashes
		var aOrderedContent = urlDecode( rc.newRulesOrder )
			.replace( "_", "-", "all" )
			.listToArray( "&" )
			.map( function( thisItem ){
				return reReplaceNoCase(
					arguments.thisItem,
					"#rc.tableID#\[\]\=",
					"",
					"all"
				);
			} )
			// Inflate
			.map( function( thisId, index ){
				return variables.contentStoreService
					.get( arguments.thisId )
					.setOrder( arguments.index );
			} );


		// save them
		if ( arrayLen( aOrderedContent ) ) {
			variables.contentStoreService.saveAll( aOrderedContent );
		}

		// Send response with the data in the right order
		event
			.getResponse()
			.setData(
				aOrderedContent.map( function( thisItem ){
					return arguments.thisItem.getContentID();
				} )
			)
			.addMessage( "Content ordered successfully!" );
	}

	// Bulk Status Change
	function bulkStatus( event, rc, prc ){
		event
			.paramValue( "parent", "" )
			.paramValue( "contentID", "" )
			.paramValue( "contentStatus", "draft" );

		// check if id list has length
		if ( len( rc.contentID ) ) {
			contentStoreService.bulkPublishStatus(
				contentID = rc.contentID,
				status    = rc.contentStatus
			);
			// announce event
			announce(
				"cbadmin_onContentStoreStatusUpdate",
				{ contentID : rc.contentID, status : rc.contentStatus }
			);
			// Message
			cbMessageBox.info(
				"#listLen( rc.contentID )# content where set to '#rc.contentStatus#'"
			);
		} else {
			cbMessageBox.warn( "No content selected!" );
		}
		// relocate back
		if ( len( rc.parent ) ) {
			relocate( event = prc.xehContentStore, queryString = "parent=#rc.parent#" );
		} else {
			relocate( event = prc.xehContentStore );
		}
	}

	// editor
	function editor( event, rc, prc ){
		// get all categories
		prc.categories = variables.categoryService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "category",
			asQuery  : false
		);
		// get new or persisted
		prc.content = variables.contentStoreService.get( event.getValue( "contentID", 0 ) );
		// load comments viewlet if persisted
		if ( prc.content.isLoaded() ) {
			var args         = { contentID : rc.contentID };
			// Get Child Pages Viewlet
			prc.childViewlet = pager(
				event  = arguments.event,
				rc     = arguments.rc,
				prc    = arguments.prc,
				parent = prc.content.getContentID()
			);
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(
				event          = "contentbox-admin:versions.pager",
				eventArguments = args
			);
		}
		// Get all page names for parent drop downs
		prc.allContent    = variables.contentStoreService.getAllFlatEntries( sortOrder = "slug asc" );
		// CK Editor Helper
		prc.ckHelper      = variables.CKHelper;
		// Get All registered editors so we can display them
		prc.editors       = editorService.getRegisteredEditorsMap();
		// Get User's default editor
		prc.defaultEditor = getUserDefaultEditor( prc.oCurrentAuthor );
		// Check if the markup matches the choosen editor
		if (
			listFindNoCase( "markdown,json", prc.content.getMarkup() ) && prc.defaultEditor != "simplemde"
		) {
			prc.defaultEditor = "simplemde";
		}
		// Get the editor driver object
		prc.oEditorDriver = editorService.getEditor( prc.defaultEditor );
		// Get All registered markups so we can display them
		prc.markups       = editorService.getRegisteredMarkups();
		// Get User's default markup
		prc.defaultMarkup = prc.oCurrentAuthor.getPreference(
			"markup",
			editorService.getDefaultMarkup()
		);
		// get all authors
		prc.authors           = authorService.getAll( sortOrder = "lastName" );
		// get related content
		prc.relatedContent    = prc.content.hasRelatedContent() ? prc.content.getRelatedContent() : [];
		prc.linkedContent     = prc.content.hasLinkedContent() ? prc.content.getLinkedContent() : [];
		prc.relatedContentIDs = prc.content.getRelatedContentIDs();

		// Get parent from active page
		prc.parentcontentID = prc.content.getParentID();
		// Override the parent page if incoming via URL
		if ( structKeyExists( rc, "parentID" ) ) {
			prc.parentcontentID = rc.parentID;
		}

		// exit handlers
		prc.xehContentSave                = "#prc.cbAdminEntryPoint#.contentStore.save";
		prc.xehSlugify                    = "#prc.cbAdminEntryPoint#.contentStore.slugify";
		prc.xehSlugCheck                  = "#prc.cbAdminEntryPoint#.content.slugUnique";
		prc.xehAuthorEditorSave           = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehRelatedContentSelector     = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.xehShowRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector";
		prc.xehBreakContentLink           = "#prc.cbAdminEntryPoint#.content.breakContentLink";

		// view
		event.setView( "contentStore/editor" );
	}

	/**
	 * Clone a content store item
	 */
	function clone( event, rc, prc ){
		// Defaults
		event.paramValue( "site", prc.oCurrentSite.getsiteID() );

		// validation
		if ( !event.valueExists( "title" ) OR !event.valueExists( "contentID" ) ) {
			cbMessageBox.warn( "Can't clone the unclonable, meaning no contentID or title passed." );
			relocate( event = prc.xehContentStore );
			return;
		}

		// get the content to clone
		var original = variables.contentStoreService.get( rc.contentID );

		// Verify new Title, else do a new copy of it, but only if it's in the same site.
		if ( original.isSameSite( rc.site ) && rc.title eq original.getTitle() ) {
			rc.title = "Copy of #rc.title#";
		}

		// get a clone
		var clone = variables.contentStoreService.new( {
			title       : rc.title,
			slug        : variables.HTMLHelper.slugify( rc.title ),
			description : original.getDescription(),
			order       : original.getOrder() + 1,
			creator     : prc.oCurrentAuthor,
			site        : variables.siteService.get( rc.site )
		} );

		// attach to the original's parent.
		if ( original.hasParent() ) {
			clone
				.setParent( original.getParent() )
				.setSlug( original.getSlug() & "/" & clone.getSlug() );
		}

		// prepare for cloning
		clone.prepareForClone(
			author           = prc.oCurrentAuthor,
			original         = original,
			originalService  = contentStoreService,
			publish          = rc.contentStatus,
			originalSlugRoot = original.getSlug(),
			newSlugRoot      = clone.getSlug()
		);

		// clone this sucker now!
		contentStoreService.save( clone );

		// relocate
		cbMessageBox.info( "Content Cloned!" );
		if ( original.hasParent() ) {
			relocate(
				event       = prc.xehContentStore,
				querystring = "parent=#original.getParent().getContentID()#"
			);
		} else {
			relocate( event = prc.xehContentStore );
		}
	}

	/**
	 * Save a new content store item
	 */
	function save( event, rc, prc ){
		// params
		event
			.paramValue( "newCategories", "" )
			.paramValue( "isPublished", true )
			.paramValue( "slug", "" )
			.paramValue( "creatorID", "" )
			.paramValue( "changelog", "" )
			.paramValue( "publishedDate", now() )
			.paramValue( "publishedHour", timeFormat( rc.publishedDate, "HH" ) )
			.paramValue( "publishedMinute", timeFormat( rc.publishedDate, "mm" ) )
			.paramValue(
				"publishedTime",
				event.getValue( "publishedHour" ) & ":" & event.getValue( "publishedMinute" )
			)
			.paramValue( "expireHour", "" )
			.paramValue( "expireMinute", "" )
			.paramValue( "expireTime", "" )
			.paramValue( "content", "" )
			.paramValue( "customFieldsCount", 0 )
			.paramValue( "relatedContentIDs", [] )
			.paramValue( "site", prc.oCurrentSite.getsiteID() );

		if ( NOT len( rc.publishedDate ) ) {
			rc.publishedDate = dateFormat( now() );
		}

		// slugify the incoming title or slug
		rc.slug = (
			NOT len( rc.slug ) ? variables.HTMLHelper.slugify( rc.title ) : variables.HTMLHelper.slugify(
				listLast( rc.slug, "/" )
			)
		);

		// Verify permission for publishing, else save as draft
		if ( !prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN" ) ) {
			rc.isPublished = "false";
		}

		// get new/persisted content and populate it
		var content      = variables.contentStoreService.get( rc.contentID )
		var originalSlug = content.getSlug();
		var content      = populateModel( content )
			.addJoinedPublishedtime( rc.publishedTime )
			.addJoinedExpiredTime( rc.expireTime )
			.setSite( variables.siteService.get( rc.site ) );
		var isNew = ( NOT content.isLoaded() );

		// Validate it
		var vResults = validate( content );
		if ( vResults.hasErrors() ) {
			variables.cbMessageBox.warn( vResults.getAllErrors() );
			editor( argumentCollection = arguments );
			return;
		}

		// Attach creator if new page
		if ( isNew ) {
			content.setCreator( prc.oCurrentAuthor );
		}

		// Override creator?
		if (
			!isNew and prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN" ) and len(
				rc.creatorID
			) and content.getCreator().getAuthorID() NEQ rc.creatorID
		) {
			content.setCreator( variables.authorService.get( rc.creatorID ) );
		}

		// Register a new content in the page, versionized!
		content.addNewContentVersion(
			content   = rc.content,
			changelog = rc.changelog,
			author    = prc.oCurrentAuthor
		);

		// Inflate parent
		if ( rc.parentContent EQ "null" OR rc.parentContent EQ "" ) {
			content.setParent( javacast( "null", "" ) );
		} else {
			content.setParent( variables.contentStoreService.get( rc.parentContent ) );
		}

		// Create new categories?
		var categories = [];
		if ( len( trim( rc.newCategories ) ) ) {
			categories = categoryService.createCategories( trim( rc.newCategories ) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		// Add categories to page
		content.removeAllCategories().setCategories( categories );
		// Inflate Custom Fields into the page
		content.inflateCustomFields( rc.customFieldsCount, rc );
		// Inflate Related Content into the content
		content.inflateRelatedContent( rc.relatedContentIDs );
		// announce event
		announce(
			"cbadmin_preContentStoreSave",
			{
				content      : content,
				isNew        : isNew,
				originalSlug : originalSlug
			}
		);
		// save content
		contentStoreService.save( content, originalSlug );
		// announce event
		announce(
			"cbadmin_postContentStoreSave",
			{
				content      : content,
				isNew        : isNew,
				originalSlug : originalSlug
			}
		);

		// Ajax?
		if ( event.isAjax() ) {
			var rData = { "CONTENTID" : content.getContentID() };
			event.renderData( type = "json", data = rData );
		} else {
			// relocate
			cbMessageBox.info( "content Saved!" );
			if ( content.hasParent() ) {
				relocate(
					event       = prc.xehContentStore,
					querystring = "parent=#content.getParent().getContentID()#"
				);
			} else {
				relocate( event = prc.xehContentStore );
			}
		}
	}

	// remove
	function remove( event, rc, prc ){
		// params
		event.paramValue( "contentID", "" ).paramValue( "parent", "" );

		// verify if contentID sent
		if ( !len( rc.contentID ) ) {
			cbMessageBox.warn( "No content sent to delete!" );
			relocate( event = prc.xehContentStore, queryString = "parent=#rc.parent#" );
		}

		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];

		// Iterate and remove
		for ( var thisContentID in rc.contentID ) {
			var content = variables.contentStoreService.get( thisContentID );
			if ( isNull( content ) ) {
				arrayAppend(
					messages,
					"Invalid content contentID sent: #thisContentID#, so skipped removal"
				);
			} else {
				// GET id to be sent for announcing later
				var contentID = content.getContentID();
				var title     = content.getTitle();
				// announce event
				announce( "cbadmin_preContentStoreRemove", { content : content } );
				// Delete it
				contentStoreService.delete( content );
				arrayAppend( messages, "content '#title#' removed" );
				// announce event
				announce( "cbadmin_postContentStoreRemove", { contentID : contentID } );
			}
		}
		// messagebox
		cbMessageBox.info( messages );
		// relocate
		relocate( event = prc.xehContentStore, queryString = "parent=#rc.parent#" );
	}

	// pager viewlet
	function pager(
		event,
		rc,
		prc,
		authorID = "all",
		parent,
		max        = 0,
		pagination = true,
		latest     = false
	){
		// check if authorID exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pager_authorID" ) ) {
			arguments.authorID = rc.pager_authorID;
		}
		// check if parent exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pager_parentID" ) ) {
			arguments.parent = rc.pager_parentID;
		}
		// Max rows incoming or take default for pagination.
		if ( arguments.max eq 0 ) {
			arguments.max = prc.cbSettings.cb_paging_maxrows;
		}

		// paging default
		event.paramValue( "page", 1 );

		// exit handlers
		prc.xehPager          = "#prc.cbAdminEntryPoint#.contentStore.pager";
		prc.xehContentEditor  = "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehContentHistory = "#prc.cbAdminEntryPoint#.versions.index";

		// prepare paging object
		prc.pager_oPaging    = getInstance( "Paging@cb" );
		prc.pager_paging     = prc.pager_oPaging.getBoundaries();
		prc.pager_pagingLink = "javascript:pagerLink(@page@)";
		prc.pager_pagination = arguments.pagination;

		// Sorting
		var sortOrder = "publishedDate DESC";
		if ( arguments.latest ) {
			sortOrder = "modifiedDate desc";
		}

		// search content with filters and all
		var contentResults = variables.contentStoreService.search(
			author = arguments.authorID,
			parent = (
				structKeyExists( arguments, "parent" ) ? arguments.parent : javacast( "null", "" )
			),
			offset    = prc.pager_paging.startRow - 1,
			max       = arguments.max,
			sortOrder = sortOrder
		);
		prc.pager_content      = contentResults.content;
		prc.pager_contentCount = contentResults.count;
		// author in RC
		prc.pager_authorID     = arguments.authorID;
		// parent
		event.paramValue( "pagePager_parentID", "", true );
		if ( structKeyExists( arguments, "parent" ) ) {
			prc.pagePager_parentID = arguments.parent;
		}
		// view pager
		return renderView( view = "contentStore/pager", module = "contentbox-admin" );
	}

	// slugify remotely
	function slugify( event, rc, prc ){
		event.renderData( data = trim( variables.HTMLHelper.slugify( rc.slug ) ), type = "plain" );
	}

	// editor selector
	function editorSelector( event, rc, prc ){
		// paging default
		event.paramValue( "page", 1 );
		event.paramValue( "search", "" );
		event.paramValue( "clear", false );

		// exit handlers
		prc.xehEditorSelector = "#prc.cbAdminEntryPoint#.contentStore.editorSelector";

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@cb" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = "javascript:pagerLink(@page@)";

		// search content with filters and all
		var contentResults = variables.contentStoreService.search(
			search             : rc.search,
			offset             : prc.paging.startRow - 1,
			max                : prc.cbSettings.cb_paging_maxrows,
			sortOrder          : "createdDate asc",
			searchActiveContent: false,
			siteID             : prc.oCurrentSite.getsiteID()
		);

		prc.content      = contentResults.content;
		prc.contentCount = contentResults.count;
		prc.CBHelper     = CBHelper;

		// if ajax and searching, just return tables
		if ( event.isAjax() and len( rc.search ) OR rc.clear ) {
			return renderView( view = "contentStore/editorSelectorEntries", prePostExempt = true );
		} else {
			event.setView( view = "contentStore/editorSelector", layout = "ajax" );
		}
	}

	// Export content
	function export( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get content
		prc.content = variables.contentStoreService.get( event.getValue( "contentID", 0 ) );

		// relocate if not existent
		if ( !prc.content.isLoaded() ) {
			cbMessageBox.warn( "ContentID sent is not valid" );
			relocate( prc.xehContentStore );
		}

		switch ( rc.format ) {
			case "xml":
			case "json": {
				var filename = "#prc.content.getSlug()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event
					.renderData(
						data        = prc.content.getMemento(),
						type        = rc.format,
						xmlRootName = "content"
					)
					.setHTTPHeader(
						name  = "Content-Disposition",
						value = " attachment; filename=#fileName#"
					);
				break;
			}
			default: {
				event.renderData( data = "Invalid export type: #rc.format#" );
			}
		}
	}

	// Export All content
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data = variables.contentStoreService.getAllForExport();

		switch ( rc.format ) {
			case "xml":
			case "json": {
				var filename = "ContentStore." & ( rc.format eq "xml" ? "xml" : "json" );
				event
					.renderData(
						data        = data,
						type        = rc.format,
						xmlRootName = "ContentStore"
					)
					.setHTTPHeader(
						name  = "Content-Disposition",
						value = " attachment; filename=#fileName#"
					);
				break;
			}
			default: {
				event.renderData( data = "Invalid export type: #rc.format#" );
			}
		}
	}

	// import contentstore
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = variables.contentStoreService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideContent
				);
				cbMessageBox.info( "Content imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessageBox.error(
					"The import file is invalid: #rc.importFile# cannot continue with import"
				);
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessageBox.error( errorMessage );
		}
		relocate( prc.xehContentStore );
	}

}
