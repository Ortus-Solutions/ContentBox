/**
 * RESTFul CRUD for Content Versions
 *
 * An incoming site identifier is required
 * An incoming contentID or slug is required
 */
component
	extends="baseHandler"
	secured="PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR"
{

	// DI
	property name="ormService" inject="contentVersionService@contentbox";
	property name="contentService" inject="contentService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "version DESC";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "ContentVersion";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = true;

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Verify incoming params
		param rc.site            = "";
		param rc.contentIdOrSlug = "";

		prc.oCurrentSite    = rc.site = getSiteByIdOrSlugOrFail( rc.site );
		prc.contentType     = event.getCurrentRouteMeta().contentType;
		prc.oRelatedContent = variables.contentService.getByIdOrSlugOrFail( rc.contentIdOrSlug, prc );
	}

	/**
	 * Display all versions for the requested contentype
	 *
	 * @tags                     Versions
	 * @responses                contentbox/apidocs/versions/index/responses.json
	 * @x-contentbox-permissions PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR
	 */
	function index( event, rc, prc ){
		param rc.page       = 1;
		// Criterias and Filters
		param rc.sortOrder  = variables.sortOrder;
		// Approved Bit
		param rc.isApproved = "";
		// Memento Params
		param rc.includes   = "";
		param rc.excludes   = "content";

		// Boolean check is approved
		if ( len( rc.isApproved ) && !isBoolean( rc.isApproved ) ) {
			rc.isApproved = "";
		}
		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria()
			// Pin the related content
			.isEq( "relatedContent.contentID", prc.oRelatedContent.getContentID() )
			// isApproved filter
			.when( len( rc.isApproved ), function( c ){
				arguments.c.isEq( "isApproved", javacast( "Boolean", rc.isApproved ) );
			} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show a content version individually
	 *
	 * @tags                     Versions
	 * @responses                contentbox/apidocs/versions/show/responses.json
	 * @x-contentbox-permissions PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR
	 */
	function show( event, rc, prc ){
		param rc.includes = "relatedContentSnapshot:relatedContent";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Delete a version from a specific content item
	 *
	 * @tags                     Versions
	 * @responses                contentbox/apidocs/versions/delete/responses.json
	 * @x-contentbox-permissions VERSIONS_DELETE
	 */
	function delete( event, rc, prc ) secured="VERSIONS_DELETE"{
		super.delete( argumentCollection = arguments );
	}

}
