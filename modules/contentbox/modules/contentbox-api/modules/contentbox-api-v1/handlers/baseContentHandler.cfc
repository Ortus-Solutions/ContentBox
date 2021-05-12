/**
 * Base handler for content based API handlers
 */
component extends="baseHandler" {

	// DI
	property name="contentService" inject="ContentService@cb";
	property name="categoryService" inject="categoryService@cb";
	property name="customFieldService" inject="customFieldService@cb";
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

	/**
	 * Create a content item
	 */
	function create(
		event,
		rc,
		prc,
		struct populate   = {},
		struct validate   = {},
		string saveMethod = variables.saveMethod
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
		param rc.categories     = "";
		param rc.changelog      = "Created from the RESTful API";
		param rc.content        = "";
		param rc.customFields   = [];
		param rc.expireDate     = "";
		param rc.isPublished    = true;
		param rc.parent         = "";
		param rc.publishedDate  = now();
		param rc.slug           = "";
		param rc.title          = "";

		// Verify Content exists
		if ( !len( rc.content ) ) {
			arguments.event
				.getResponse()
				.setErrorMessage( "Content is required", arguments.event.STATUS.BAD_REQUEST );
			return;
		}

		// slugify the incoming title or slug
		rc.slug = (
			NOT len( rc.slug ) ? variables.HTMLHelper.slugify( rc.title ) : variables.HTMLHelper.slugify(
				listLast( rc.slug, "/" )
			)
		);

		// Setup Relationships
		rc.site    = prc.oCurrentSite;
		rc.creator = prc.oCurrentAuthor;

		// Verify permission for publishing, else save as draft
		if ( !prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN" ) ) {
			rc.isPublished = "false";
		}

		// Population arguments
		arguments.populate.memento          = rc;
		arguments.populate.model            = variables.ormService.new();
		arguments.populate.nullEmptyInclude = "parent";
		arguments.populate.excludes         = "categories,comments,customFields,contentVersions,children,commentSubscriptions";

		// Start save transaction procedures
		transaction {
			// populate + validate + add new content version
			arguments.validate.target = populateModel( argumentCollection = arguments.populate );
			prc.oEntity               = validateOrFail( argumentCollection = arguments.validate ).addNewContentVersion(
				content  : rc.content,
				changelog: rc.changelog,
				author   : prc.oCurrentAuthor
			);

			// Inflate Categories
			if ( isSimpleValue( rc.categories ) ) {
				rc.categories = listToArray( rc.categories );
			}
			prc.oEntity.setCategories(
				rc.categories.map( function( thisCategory ){
					var oCategory = variables.categoryService.findWhere( { slug : arguments.thisCategory, site : rc.site } );
					if ( isNull( oCategory ) ) {
						oCategory = variables.categoryService.new( {
							category : arguments.thisCategory,
							slug     : arguments.thisCategory,
							site     : rc.site
						} );
						variables.categoryService.save( oCategory );
					}
					return oCategory;
				} )
			);

			// Inflate Custom Fields [ { key : "", value : "" } ] if a string, else this should be an array
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

			// announce it
			announceInterception(
				"#variables.settings.resources.eventPrefix#pre#variables.entity#Save",
				{ entity : prc.oEntity }
			);

			// Save it
			invoke(
				variables.ormService,
				arguments.saveMethod,
				[ prc.oEntity ]
			);

			// announce it
			announceInterception(
				"#variables.settings.resources.eventPrefix#post#variables.entity#Save",
				{ entity : prc.oEntity }
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

	/**
	 * Update an existing content item
	 */
	function update( event, rc, prc ){
		super.update( argumentCollection = arguments );
	}

}
