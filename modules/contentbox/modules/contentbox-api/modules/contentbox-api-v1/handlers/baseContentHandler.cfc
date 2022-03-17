/**
 * Base handler for content based API handlers
 */
component extends="baseHandler" {

	// DI
	property name="authorService" inject="authorService@contentbox";
	property name="contentService" inject="ContentService@contentbox";
	property name="categoryService" inject="categoryService@contentbox";
	property name="customFieldService" inject="customFieldService@contentbox";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";

	// The name of the method to use for save persistence on the ORM service
	variables.saveMethod   = "save";
	// The name of the method to use for deleting entites on the ORM service
	variables.deleteMethod = "delete";

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Verify incoming site
		param rc.site    = "";
		prc.oCurrentSite = rc.site = getSiteByIdOrSlugOrFail( rc.site );
	}

	/**
	 * Show a content item using an incoming slug or id
	 */
	function show( event, rc, prc ){
		param rc.includes = arrayToList( [
			"activeContent",
			"childrenSnapshot:children",
			"customFieldsAsStruct:customFields",
			"linkedContentSnapshot:linkedContent",
			"relatedContentSnapshot:relatedContent",
			"renderedContent"
		] );

		super.show( argumentCollection = arguments );
	}

	/***************************************************************************/
	/** PRIVATE HELPERS **/
	/***************************************************************************/

	/**
	 * Shared method for create and update to be DRY
	 *
	 * @populate   Population arguments
	 * @validate   Validation arguments
	 * @saveMethod The method to use for saving entities
	 * @contenType The type used for permission checks
	 */
	private function save(
		event,
		rc,
		prc,
		struct populate    = {},
		struct validate    = {},
		string saveMethod  = variables.saveMethod,
		string contentType = ""
	){
		// params
		param arguments.populate.composeRelationships = true;
		param rc.includes                             = arrayToList( [
			"activeContent",
			"customFieldsAsStruct:customFields",
			"linkedContentSnapshot:linkedContent",
			"relatedContentSnapshot:relatedContent",
			"renderedContent"
		] );
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;
		// param content fields
		param rc.id             = "";
		param rc.content        = "";
		param rc.changelog      = len( rc.id ) ? "Update from the ContentBox API" : "Creation from the ContentBox API";

		// Verify content exists ONLY for new objects
		if ( !len( rc.id ) && !len( rc.content ) ) {
			arguments.event.getResponse().setErrorMessage( "Content is required", arguments.event.STATUS.BAD_REQUEST );
			return;
		}
		// Setup Parent if sent!
		if ( !isNull( rc.parent ) && len( rc.parent ) ) {
			rc.parent = getByIdOrSlugOrFail( rc.parent, prc );
		}
		// slugify the incoming title or slug
		if ( !isNull( rc.slug ) && len( rc.slug ) ) {
			rc.slug = variables.HTMLHelper.slugify( listLast( rc.slug, "/" ) );
		}
		// Verify permission for publishing, else save as draft
		if ( !prc.oCurrentAuthor.checkPermission( "#arguments.contentType#_ADMIN" ) ) {
			rc.isPublished = "false";
		}

		// Population arguments
		arguments.populate.memento          = rc;
		// Check if creation or editing
		arguments.populate.model            = ( !len( rc.id ) ? variables.ormService.new() : getByIdOrSlugOrFail( rc.id, prc ) );
		arguments.populate.nullEmptyInclude = "parent";
		arguments.populate.exclude          = "contentID,creator,categories,comments,customFields,contentVersions,children,commentSubscriptions";

		// Creator override: Only if you have the right perms
		arguments.populate.model.setCreator( prc.oCurrentAuthor );
		if (
			arguments.populate.model.isLoaded() && !isNull( rc.creator ) && len( rc.creator ) && prc
				.oCurrentAuthor()
				.checkPermission( "#arguments.contentType#_ADMIN" )
		) {
			arguments.populate.model.setCreator( variables.authorService.retrieveUserById( rc.creator ) );
		}

		// populate it
		var originalSlug          = arguments.populate.model.getSlug();
		arguments.validate.target = populateModel( argumentCollection = arguments.populate );

		// Start save transaction procedures
		transaction {
			// Validate or fail
			prc.oEntity = validateOrFail( argumentCollection = arguments.validate );

			// Do we have any incoming content to create a version for?
			if ( len( rc.content ) ) {
				prc.oEntity.addNewContentVersion(
					content  : rc.content,
					changelog: rc.changelog,
					author   : prc.oCurrentAuthor
				);
			}

			// Inflate Categories if they come as a list of slugs
			if ( !isNull( rc.categories ) ) {
				if ( isSimpleValue( rc.categories ) ) {
					rc.categories = listToArray( rc.categories );
				}
				prc.oEntity.setCategories(
					rc.categories.map( function( thisCategory ){
						return variables.categoryService.getOrCreateBySlug( arguments.thisCategory, rc.site );
					} )
				);
			}

			// Inflate Custom Fields [ { key : "", value : "" } ] if a string, else this should be an array
			if ( !isNull( rc.customFields ) ) {
				if ( isSimpleValue( rc.customFields ) && isJSON( rc.customFields ) ) {
					rc.customFields = deserializeJSON( rc.customFields );
				}
				prc.oEntity.setCustomFields(
					rc.customFields.map( function( thisField ){
						return variables.customFieldService.new( {
							key            : toString( arguments.thisField.key ),
							value          : toString( arguments.thisField.value ),
							relatedContent : prc.oEntity
						} );
					} )
				);
			}

			// announce it
			announceInterception(
				"#variables.settings.resources.eventPrefix#pre#variables.entity##len( rc.id ) ? "Update" : "Save"#",
				{ entity : prc.oEntity, originalSlug : originalSlug }
			);

			// Save it
			invoke(
				variables.ormService,
				arguments.saveMethod,
				[ prc.oEntity, originalSlug ]
			);

			// announce it
			announceInterception(
				"#variables.settings.resources.eventPrefix#post#variables.entity##len( rc.id ) ? "Update" : "Save"#",
				{ entity : prc.oEntity, originalSlug : originalSlug }
			);
		}
		// end transaction

		// Marshall it out
		prc.response.setData(
			prc.oEntity.getMemento(
				includes       = rc.includes,
				excludes       = rc.excludes,
				ignoreDefaults = rc.ignoreDefaults
			)
		);
	}

}
