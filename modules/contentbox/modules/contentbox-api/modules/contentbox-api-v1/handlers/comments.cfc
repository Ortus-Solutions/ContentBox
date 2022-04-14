/**
 * RESTFul CRUD for Content Comments
 *
 * An incoming site identifier is required
 * An incoming contentID or slug is required
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="CommentService@contentbox";
	property name="contentService" inject="contentService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "createdDate DESC";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Comment";
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
		prc.oRelatedContent = variables.contentService.getByIdOrSlugOrFail( rc.contentIdOrSlug );
	}

	/**
	 * Display all comments for the requested content object
	 *
	 * @tags      Comments
	 * @responses contentbox/apidocs/comments/index/responses.json
	 */
	function index( event, rc, prc ){
		param rc.page       = 1;
		// Criterias and Filters
		param rc.sortOrder  = variables.sortOrder;
		// Approved Bit
		param rc.isApproved = "";

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
	 * Show a comment using an ID
	 *
	 * @tags      Comments
	 * @responses contentbox/apidocs/comments/show/responses.json
	 */
	function show( event, rc, prc ){
		param rc.includes = "relatedContentSnapshot:relatedContent";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a new comment
	 *
	 * @tags        Comments
	 * @requestBody contentbox/apidocs/comments/create/requestBody.json
	 * @responses   contentbox/apidocs/comments/create/responses.json
	 */
	function create( event, rc, prc ){
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing comment
	 *
	 * @tags                     Comments
	 * @responses                contentbox/apidocs/comments/update/responses.json
	 * @x-contentbox-permissions COMMENTS_ADMIN
	 */
	function update( event, rc, prc ) secured="COMMENTS_ADMIN"{
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete a comment
	 *
	 * @tags                     Comments
	 * @responses                contentbox/apidocs/comments/delete/responses.json
	 * @x-contentbox-permissions COMMENTS_ADMIN
	 */
	function delete( event, rc, prc ) secured="COMMENTS_ADMIN"{
		super.delete( argumentCollection = arguments );
	}

}
