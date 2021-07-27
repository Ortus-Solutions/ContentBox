/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * The base content handler which is used by the entries, contentstore and pages handlers to provide uniformity
 */
component extends="baseHandler" {

	/**
	 * --------------------------------------------------------------------------
	 * Core Dependencies
	 * --------------------------------------------------------------------------
	 */

	property name="authorService" inject="authorService@contentbox";
	property name="themeService" inject="themeService@contentbox";
	property name="CBHelper" inject="CBHelper@contentbox";
	property name="CKHelper" inject="CKHelper@contentbox-ckeditor";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";
	property name="categoryService" inject="categoryService@contentbox";
	property name="customFieldService" inject="customFieldService@contentbox";
	property name="editorService" inject="editorService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="contentService" inject="contentService@contentbox";

	/**
	 * --------------------------------------------------------------------------
	 * ColdBox Properties
	 * --------------------------------------------------------------------------
	 */

	this.preHandler_except = "pager";

	/**
	 * --------------------------------------------------------------------------
	 * Base Content Properties
	 * --------------------------------------------------------------------------
	 * These properties must be set by the concrete content type handler
	 */

	// The name of the method to use for save persistence on the ORM service
	variables.saveMethod      = "save";
	// The name of the method to use for deleting entites on the ORM service
	variables.deleteMethod    = "delete";
	// The handler controlling the requests
	variables.handler         = "";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity          = "";
	// The plural of the entity used for collections, ordering, etc.
	variables.entityPlural    = "";
	// The default ordering on collection searches, etc.
	variables.defaultOrdering = "createdDate desc";

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		// Light up the content tab in the sidebar
		prc.tabContent = true;
	}

	/**
	 * Show Content
	 */
	function index( event, rc, prc ){
		// Params
		event.paramValue( "parent", "" );

		// get all authors
		prc.authors = variables.authorService.getAll( sortOrder = "lastName" );

		// get all categories
		prc.categories = variables.categoryService.list(
			criteria  = { "site" : prc.oCurrentSite },
			sortOrder = "category",
			asQuery   = false
		);

		// view
		event.setView( "#variables.handler#/index" );
	}

	/**
	 * Content table
	 *
	 * @return HTML
	 */
	function contentTable( event, rc, prc ){
		// params
		event
			.paramValue( "page", 1 )
			.paramValue( "searchContent", "" )
			.paramValue( "fAuthors", "all" )
			.paramValue( "fCategories", "all" )
			.paramValue( "fCreators", "all" )
			.paramValue( "fStatus", "any" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "parent", "" )
			.paramValue( "showAll", false );

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@contentbox" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = "javascript:contentPaginate(@page@)";

		// JS null checks
		if ( rc.parent eq "undefined" ) {
			rc.parent = "";
		}

		// Are we Filtering?
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
		var contentResults = variables.ormService.search(
			search     : rc.searchContent,
			isPublished: rc.fStatus,
			category   : rc.fCategories,
			author     : rc.fAuthors,
			creator    : rc.fCreators,
			parent     : ( !isNull( rc.parent ) ? rc.parent : javacast( "null", "" ) ),
			sortOrder  : variables.defaultOrdering,
			siteID     : prc.oCurrentSite.getsiteID()
		);
		prc.content      = contentResults[ variables.entityPlural ];
		prc.contentCount = contentResults.count;

		// Do we have a parent? Inflate it
		if ( structKeyExists( rc, "parent" ) ) {
			prc.oParent = variables.ormService.get( rc.parent );
		}

		// view
		event.setView( view = "#variables.handler#/indexTable", layout = "ajax" );
	}

	/**
	 * Content quick look
	 *
	 * @return HTML
	 */
	function quickLook( event, rc, prc ){
		prc.content          = variables.ormService.get( event.getValue( "contentID", 0 ) );
		prc.xehContentEditor = "#prc.cbAdminEntryPoint#.#variables.handler#.editor";
		event.setView( view = "content/quickLook", layout = "ajax" );
	}

	/**
	 * Change order of content items
	 *
	 * @return json
	 */
	function changeOrder( event, rc, prc ){
		// param values
		event.paramValue( "tableID", variables.entityPlural ).paramValue( "newRulesOrder", "" );

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
				return variables.ormService.get( arguments.thisId ).setOrder( arguments.index );
			} );


		// save them
		if ( arrayLen( aOrderedContent ) ) {
			variables.ormService.saveAll( aOrderedContent );
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

	/**
	 * Change the status of many content objects
	 *
	 * @relocateTo Where to relocate when done updating
	 */
	function bulkStatus( event, rc, prc, relocateTo ){
		event
			.paramValue( "parent", "" )
			.paramValue( "contentID", "" )
			.paramValue( "contentStatus", "draft" );

		// check if id list has length
		if ( len( rc.contentID ) ) {
			variables.ormService.bulkPublishStatus(
				contentID: rc.contentID,
				status   : rc.contentStatus
			);
			// announce event
			announce(
				"cbadmin_on#variables.entity#StatusUpdate",
				{ contentID : rc.contentID, status : rc.contentStatus }
			);
			// Message
			variables.cbMessageBox.info(
				"#listLen( rc.contentID )# content where set to '#rc.contentStatus#'"
			);
		} else {
			variables.cbMessageBox.warn( "No content selected!" );
		}

		// relocate back
		if ( len( rc.parent ) ) {
			relocate( event = arguments.relocateTo, queryString = "parent=#rc.parent#" );
		} else {
			relocate( event = arguments.relocateTo );
		}
	}

	/**
	 * Show the editor
	 */
	function editor( event, rc, prc ){
		// get all categories
		prc.categories = variables.categoryService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "category",
			asQuery  : false
		);

		// get new or persisted content object to edit
		prc.oContent = variables.ormService.get( event.getValue( "contentID", 0 ) );

		// Load Persisted Companion Viewlets
		if ( prc.oContent.isLoaded() ) {
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(
				event          = "contentbox-admin:comments.pager",
				eventArguments = { contentID : rc.contentID }
			);
			// Get Child Pages Viewlet
			prc.childPagesViewlet = pager(
				event  = arguments.event,
				rc     = arguments.rc,
				prc    = arguments.prc,
				parent = prc.oContent.getContentID()
			);
			// Get History Versions Viewlet
			prc.versionsViewlet = runEvent(
				event          = "contentbox-admin:versions.pager",
				eventArguments = { contentID : rc.contentID }
			);
		}
		// Get all content names for parent drop downs
		prc.allContent = variables.ormService.getAllFlatContent(
			sortOrder: "slug asc",
			siteID   : prc.oCurrentSite.getsiteID()
		);
		// CK Editor Helper
		prc.ckHelper      = variables.CKHelper;
		// Get All registered editors so we can display them
		prc.editors       = variables.editorService.getRegisteredEditorsMap();
		// Get User's default editor
		prc.defaultEditor = getUserDefaultEditor( prc.oCurrentAuthor );
		// Check if the markup matches the choosen editor
		if (
			listFindNoCase( "markdown,json", prc.oContent.getMarkup() ) && prc.defaultEditor != "simplemde"
		) {
			prc.defaultEditor = "simplemde";
		}
		// Get the editor driver object
		prc.oEditorDriver = variables.editorService.getEditor( prc.defaultEditor );
		// Get All registered markups so we can display them
		prc.markups       = variables.editorService.getRegisteredMarkups();
		// Get User's default markup
		prc.defaultMarkup = prc.oCurrentAuthor.getPreference(
			"markup",
			variables.editorService.getDefaultMarkup()
		);
		// get all authors
		prc.authors           = variables.authorService.getAll( sortOrder = "lastName" );
		// get related content
		prc.relatedContent    = prc.oContent.hasRelatedContent() ? prc.oContent.getRelatedContent() : [];
		prc.linkedContent     = prc.oContent.hasLinkedContent() ? prc.oContent.getLinkedContent() : [];
		prc.relatedContentIDs = prc.oContent.getRelatedContentIDs();

		// Get Default Parent
		prc.parentContentID = prc.oContent.getParentID();
		// Override the parent page if incoming via URL
		if ( structKeyExists( rc, "parentID" ) ) {
			prc.parentContentID = rc.parentID;
		}

		// exit handlers
		prc.xehAuthorEditorSave           = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehSlugCheck                  = "#prc.cbAdminEntryPoint#.content.slugUnique";
		prc.xehRelatedContentSelector     = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.xehShowRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector";
		prc.xehBreakContentLink           = "#prc.cbAdminEntryPoint#.content.breakContentLink";

		// view
		event.setView( "#variables.handler#/editor" );
	}

	/**
	 * Save Content
	 *
	 * @adminPermission The admin permission to apply for publishing, eg: ENTRIES_ADMIN, PAGES_ADMIN
	 * @relocateTo Where to relocate to when saving is done
	 */
	function save( event, rc, prc, adminPermission, relocateTo ){
		// form params
		event
			.paramValue( "allowComments", prc.cbSiteSettings.cb_comments_enabled )
			.paramValue( "changelog", "" )
			.paramValue( "creatorID", "" )
			.paramValue( "content", "" )
			.paramValue( "customFieldsCount", 0 )
			.paramValue( "isPublished", true )
			.paramValue( "expireHour", "" )
			.paramValue( "expireMinute", "" )
			.paramValue( "expireTime", "" )
			.paramValue( "newCategories", "" )
			.paramValue( "parentContent", "null" )
			.paramValue( "publishedDate", now() )
			.paramValue( "publishedHour", timeFormat( rc.publishedDate, "HH" ) )
			.paramValue( "publishedMinute", timeFormat( rc.publishedDate, "mm" ) )
			.paramValue(
				"publishedTime",
				event.getValue( "publishedHour" ) & ":" & event.getValue( "publishedMinute" )
			)
			.paramValue( "relatedContentIDs", [] )
			.paramValue( "site", prc.oCurrentSite.getsiteID() )
			.paramValue( "slug", "" )
		;

		// If no published date found, then default it to NOW!
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
		if ( !prc.oCurrentAuthor.checkPermission( arguments.adminPermission ) ) {
			rc.isPublished = "false";
		}

		// get new/persisted page and populate it with incoming data.
		var oContent     = variables.ormService.get( rc.contentID );
		var originalSlug = oContent.getSlug();
		populateModel( model: oContent, exclude = "contentID" )
			.addJoinedPublishedtime( rc.publishedTime )
			.addJoinedExpiredTime( rc.expireTime )
			.setSite( variables.siteService.get( rc.site ) );
		var isNew = ( NOT oContent.isLoaded() );

		// Validate Page And Incoming Data
		var vResults = validate( oContent );
		if ( vResults.hasErrors() ) {
			variables.cbMessageBox.warn( vResults.getAllErrors() );
			editor( argumentCollection = arguments );
			return;
		}

		// Attach creator if new page
		if ( isNew ) {
			oContent.setCreator( prc.oCurrentAuthor );
		}
		// Override creator if persisted?
		else if (
			!isNew and
			prc.oCurrentAuthor.checkPermission( arguments.adminPermission ) and
			len( rc.creatorID ) and
			oContent.getCreator().getAuthorID() NEQ rc.creatorID
		) {
			oContent.setCreator( variables.authorService.get( rc.creatorID ) );
		}

		// Prettify content if json
		if ( isJSON( rc.content ) ) {
			rc.content = getInstance( "JSONPrettyPrint@JSONPrettyPrint" ).formatJson(
				json           : rc.content,
				lineEnding     : chr( 10 ),
				spaceAfterColon: true
			);
		}

		// Register a new content in the page, versionized!
		oContent.addNewContentVersion(
			content  : rc.content,
			changelog: rc.changelog,
			author   : prc.oCurrentAuthor
		);

		// Inflate parent
		if ( rc.parentContent EQ "null" OR rc.parentContent EQ "" ) {
			oContent.setParent( javacast( "null", "" ) );
		} else {
			oContent.setParent( variables.ormService.get( rc.parentContent ) );
		}

		// Create new categories?
		var categories = [];
		if ( len( trim( rc.newCategories ) ) ) {
			categories = variables.categoryService.createCategories( trim( rc.newCategories ) );
		}
		// Inflate sent categories from collection
		categories.addAll( variables.categoryService.inflateCategories( rc ) );
		// Add categories to page
		oContent.removeAllCategories().setCategories( categories );
		// Inflate Custom Fields into the page
		oContent.inflateCustomFields( rc.customFieldsCount, rc );
		// Inflate Related Content into the page
		oContent.inflateRelatedContent( rc.relatedContentIDs );
		// announce event
		announce(
			"cbadmin_pre#variables.Entity#Save",
			{
				content      : oContent,
				isNew        : isNew,
				originalSlug : originalSlug
			}
		);

		// save content
		variables.ormService.save( oContent, originalSlug );

		// announce event
		announce(
			"cbadmin_post#variables.entity#Save",
			{
				content      : oContent,
				isNew        : isNew,
				originalSlug : originalSlug
			}
		);

		// Ajax?
		if ( event.isAjax() ) {
			var rData = { "CONTENTID" : oContent.getContentID() };
			event.renderData( type = "json", data = rData );
		} else {
			// relocate
			variables.cbMessageBox.info( "Page Saved!" );
			if ( oContent.hasParent() ) {
				relocate(
					event       = arguments.relocateTo,
					querystring = "parent=#oContent.getParent().getContentID()#"
				);
			} else {
				relocate( event = arguments.relocateTo );
			}
		}
	}

	/**
	 * Clone Content
	 *
	 * @relocateTo Where to relocate to when saving is done
	 */
	function clone( event, rc, prc, relocateTo ){
		// Defaults
		event.paramValue( "site", prc.oCurrentSite.getsiteID() );

		// validation
		if ( !event.valueExists( "title" ) OR !event.valueExists( "contentID" ) ) {
			cbMessageBox.warn( "Can't clone the unclonable, meaning no contentID or title passed." );
			relocate( arguments.relocateTo );
			return;
		}

		// get the content to clone
		var original = variables.ormService.get( rc.contentID );

		// Verify new Title, else do a new copy of it, but only if it's in the same site.
		if ( original.isSameSite( rc.site ) && rc.title eq original.getTitle() ) {
			rc.title = "Copy of #rc.title#";
		}

		// get a clone
		var clone = variables.ormService.new( {
			title   : rc.title,
			slug    : variables.HTMLHelper.slugify( rc.title ),
			creator : prc.oCurrentAuthor,
			site    : variables.siteService.get( rc.site )
		} );

		// attach to the original's parent.
		if ( original.hasParent() ) {
			clone
				.setParent( original.getParent() )
				.setSlug( original.getSlug() & "/" & clone.getSlug() );
		}

		// prepare descendants for cloning, might take a while if lots of children to copy.
		clone.prepareForClone(
			author          : prc.oCurrentAuthor,
			original        : original,
			originalService : variables.ormService,
			publish         : rc.pageStatus,
			originalSlugRoot: original.getSlug(),
			newSlugRoot     : clone.getSlug()
		);

		// clone this sucker now!
		variables.ormService.save( clone );

		// relocate
		cbMessageBox.info( "#variables.entity# Cloned!" );

		// Relocate
		if ( original.hasParent() ) {
			relocate(
				event       = arguments.relocateTo,
				querystring = "parent=#original.getParent().getContentID()#"
			);
		} else {
			relocate( event = arguments.relocateTo );
		}
	}

	/****************************************************************/
	/* PRIVATE FUNCTIONS */
	/****************************************************************/

	/**
	 * Get the user's default editor with some logic
	 *
	 * @author The author object to get the default editor from
	 *
	 * @return The default editor in string format
	 */
	private function getUserDefaultEditor( required author ){
		// get user default editor
		var userEditor = arguments.author.getPreference(
			"editor",
			editorService.getDefaultEditor()
		);

		// verify if editor exists
		if ( editorService.hasEditor( userEditor ) ) {
			return userEditor;
		}

		// not found, reset prefernce to system default, something is wrong.
		arguments.author.setPreference( "editor", editorService.getDefaultEditor() );
		authorService.save( arguments.author );

		// return default editor
		return editorService.getDefaultEditor();
	}

}
