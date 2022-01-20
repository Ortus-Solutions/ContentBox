/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A generic content service for content objects
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="settingService" inject="id:settingService@contentbox";
	property name="cacheBox" inject="cachebox";
	property name="log" inject="logbox:logger:{this}";
	property name="customFieldService" inject="customFieldService@contentbox";
	property name="categoryService" inject="categoryService@contentbox";
	property name="commentService" inject="commentService@contentbox";
	property name="contentVersionService" inject="contentVersionService@contentbox";
	property name="authorService" inject="authorService@contentbox";
	property name="contentStoreService" inject="contentStoreService@contentbox";
	property name="pageService" inject="pageService@contentbox";
	property name="entryService" inject="entryService@contentbox";
	property name="systemUtil" inject="SystemUtil@contentbox";
	property name="statsService" inject="statsService@contentbox";
	property name="dateUtil" inject="DateUtil@contentbox";
	property name="commentSubscriptionService" inject="CommentSubscriptionService@contentbox";
	property name="subscriberService" inject="subscriberService@contentbox";
	property name="asyncManager" inject="coldbox:asyncManager";

	/**
	 * Constructor
	 *
	 * @entityName The content entity name to bind this service to.
	 */
	ContentService function init( entityName = "cbContent" ){
		// init it
		super.init( entityName = arguments.entityName, useQueryCaching = true );

		return this;
	}

	/**
	 * Get the total content counts according to the passed filters
	 *
	 * @siteID     The site to filter on
	 * @categoryId The category Id to filter on
	 */
	numeric function getTotalContentCount( siteID = "", categoryId = "" ){
		var c = newCriteria()
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.when( len( arguments.categoryId ), function( c ){
				c.joinTo( "categories", "cats" ).isEq( "cats.categoryID", categoryId );
			} );
		return c.count();
	}

	/**
	 * Clear all content caches
	 *
	 * @async Run it asynchronously or not, defaults to false
	 */
	ContentService function clearAllCaches( boolean async = false ){
		variables.cacheBox
			.getCache( variables.settingService.getSetting( "cb_content_cacheName" ) )
			.clearByKeySnippet( keySnippet = "cb-content", async = arguments.async );
		return this;
	}

	/**
	 * Clear all category content counts caches
	 *
	 * @async Run it asynchronously or not, defaults to false
	 */
	ContentService function clearAllCategoryCountCaches( boolean async = false ){
		variables.cacheBox
			.getCache( variables.settingService.getSetting( "cb_content_cacheName" ) )
			.clearByKeySnippet( keySnippet = "cb-content-category-counts", async = arguments.async );
		return this;
	}

	/**
	 * Clear all sitemap caches
	 *
	 * @async Run it asynchronously or not, defaults to false
	 */
	ContentService function clearAllSitemapCaches( boolean async = false ){
		variables.cacheBox
			.getCache( variables.settingService.getSetting( "cb_content_cacheName" ) )
			.clearByKeySnippet( keySnippet = "cb-content-sitemap", async = arguments.async );
		return this;
	}

	/**
	 * Clear all page wrapper caches
	 *
	 * @async Run it asynchronously or not, defaults to false
	 */
	ContentService function clearAllPageWrapperCaches( boolean async = false ){
		variables.cacheBox
			.getCache( variables.settingService.getSetting( "cb_content_cacheName" ) )
			.clearByKeySnippet( keySnippet = "cb-content-wrapper", async = arguments.async );
		return this;
	}

	/**
	 * Clear a specific page wrapper caches according to slug prefix
	 *
	 * @slug  The slug partial to clean on
	 * @async Run it asynchronously or not, defaults to false
	 */
	ContentService function clearPageWrapperCaches( required any slug, boolean async = false ){
		variables.cacheBox
			.getCache( variables.settingService.getSetting( "cb_content_cacheName" ) )
			.clearByKeySnippet(
				keySnippet = "cb-content-wrapper-[^-]*-#arguments.slug#",
				regex      = true,
				async      = arguments.async
			);
		return this;
	}

	/**
	 * Clear a page wrapper cache for a specific content object
	 *
	 * @slug  The slug to clear
	 * @async Run it asynchronously or not, defaults to false
	 */
	ContentService function clearPageWrapper( required any slug, boolean async = false ){
		variables.cacheBox
			.getCache( variables.settingService.getSetting( "cb_content_cacheName" ) )
			.clear( "cb-content-wrapper-#cgi.HTTP_HOST#-#arguments.slug#/" );
		return this;
	}

	/**
	 * Searches published content with cool paramters, remember published content only
	 *
	 * @searchTerm          The search term to search
	 * @max                 The maximum number of records to paginate
	 * @offset              The offset in the pagination
	 * @asQuery             Return as query or array of objects, defaults to array of objects
	 * @sortOrder           The sorting of the search results, defaults to publishedDate DESC
	 * @isPublished         Search for published, non-published or both content objects [true, false, 'all']
	 * @searchActiveContent Search only content titles or both title and active content. Defaults to both.
	 * @contentTypes        Limit search to list of content types (comma-delimited). Leave blank to search all content types
	 * @excludeIDs          List of IDs to exclude from search
	 * @showInSearch        If true, it makes sure content has been stored as searchable, defaults to null, which means it searches no matter what this bit says
	 * @siteID              The site ID to filter on
	 * @propertyList        A list of properties to retrieve as a projection instead of array of objects
	 *
	 * @return struct = { content, count }
	 */
	function searchContent(
		any searchTerm              = "",
		numeric max                 = 0,
		numeric offset              = 0,
		boolean asQuery             = false,
		any sortOrder               = "publishedDate DESC",
		any isPublished             = true,
		boolean searchActiveContent = true,
		string contentTypes         = "",
		any excludeIDs              = "",
		boolean showInSearch,
		string siteID = "",
		string propertyList
	){
		var results = { "count" : 0, "content" : [] };
		var c       = newCriteria();

		// only published contentwithClause

		if ( isBoolean( arguments.isPublished ) ) {
			// Published bit
			c.isEq( "isPublished", javacast( "Boolean", arguments.isPublished ) );
			// Published eq true evaluate other params
			if ( arguments.isPublished ) {
				c.isLt( "publishedDate", now() )
					.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
					.isEq( "passwordProtection", "" );
			}
		}

		// only search shownInSearch bits
		if ( structKeyExists( arguments, "showInSearch" ) ) {
			c.isEq( "showInSearch", javacast( "Boolean", arguments.showInSearch ) );
		}

		// Search Criteria
		if ( len( arguments.searchTerm ) ) {
			// Do we search title and active content or just title?
			if ( arguments.searchActiveContent ) {
				c.createAlias(
						associationName: "contentVersions",
						alias          : "ac",
						withClause     : getRestrictions().isTrue( "ac.isActive" )
					)
					.$or(
						c.restrictions.like( "title", "%#arguments.searchTerm#%" ),
						c.restrictions.like( "ac.content", "%#arguments.searchTerm#%" )
					);
			} else {
				c.like( "title", "%#arguments.searchTerm#%" );
			}
		}

		// Site Filter
		if ( len( arguments.siteID ) ) {
			c.isEq( "site.siteID", arguments.siteID );
		}

		// Content Types
		if ( len( arguments.contentTypes ) ) {
			c.isIn( "contentType", arguments.contentTypes );
		}

		// excludeIDs
		if ( len( arguments.excludeIDs ) ) {
			// if not an array, inflate list
			if ( !isArray( arguments.excludeIDs ) ) {
				arguments.excludeIDs = listToArray( arguments.excludeIDs );
			}
			c.isNot( c.restrictions.in( "contentID", arguments.excludeIDs ) );
		}

		// run criteria query and projections count
		results.count = c.count( "contentID" );

		if ( !isNull( arguments.propertyList ) ) {
			c.withProjections( property = arguments.propertyList ).asStruct();
		} else {
			c.resultTransformer( c.DISTINCT_ROOT_ENTITY );
		}
		results.content = c.list(
			offset    = arguments.offset,
			max       = arguments.max,
			sortOrder = arguments.sortOrder,
			asQuery   = arguments.asQuery
		);

		return results;
	}

	/**
	 * Get an id from a slug of a content object
	 *
	 * @slug   The slug to search an ID for.
	 * @siteID The site this slug belongs to
	 *
	 * @return The id of the content object or empty string if not found
	 */
	function getIdBySlug( required any slug, string siteID = "" ){
		var results = newCriteria()
			.isEq( "slug", arguments.slug )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.withProjections( property: "contentID" )
			.get();

		// verify results
		return ( isNull( results ) ? "" : results );
	}

	/**
	 * This utility tries to get the content type by id/slug or fails
	 *
	 * @return The found entity
	 *
	 * @throws EntityNotFound
	 */
	function getByIdOrSlugOrFail( required id ){
		var c       = newCriteria();
		var oEntity = c
			.$or(
				// note: id is a shortcut in Hibernate for the Primary Key
				c.restrictions.isEq( "id", arguments.id ),
				c.restrictions.isEq( "slug", arguments.id )
			)
			.get();

		if ( isNull( oEntity ) ) {
			throw( message = "No entity found for ID/Slug #arguments.id.toString()#", type = "EntityNotFound" );
		}

		return oEntity;
	}

	/**
	 * Find a published content object by slug and published unpublished flags, if not found it returns
	 * a new content object
	 *
	 * @slug            The slug to search
	 * @showUnpublished To also show unpublished content, defaults to false.
	 * @siteID          The site this slug belongs to
	 *
	 * @return The content object or a new unpersisted content object
	 */
	function findBySlug(
		required any slug,
		required boolean showUnpublished = false,
		string siteID                    = ""
	){
		var oContent = newCriteria()
			.isEq( "slug", arguments.slug )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.when( !showUnpublished, function( c ){
				c.isTrue( "isPublished" )
					.isLT( "publishedDate", now() )
					.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) );
			} )
			.get();

		// return accordingly
		return isNull( oContent ) ? new () : oContent;
	}

	/**
	 * Verify an incoming slug is unique or not
	 *
	 * @slug        The slug to search for uniqueness
	 * @contentID   Limit the search to the passed contentID usually for updates
	 * @siteID      The site to filter on
	 * @contentType The content type uniqueness
	 *
	 * @return True if the slug is unique or false if it's already used
	 */
	boolean function isSlugUnique(
		required any slug,
		any contentID      = "",
		string siteID      = "",
		string contentType = ""
	){
		return newCriteria()
			.isEq( "slug", arguments.slug )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.when( len( arguments.contentId ), function( c ){
				c.ne( "contentID", contentId );
			} )
			.when( len( arguments.contentType ), function( c ){
				c.isEq( "contentType", contentType );
			} )
			.count() > 0 ? false : true;
	}

	/**
	 * Delete a content object safely via hierarchies
	 *
	 * @content the Content object to delete
	 */
	ContentService function delete( required any content ){
		transaction {
			// Check for dis-associations
			if ( arguments.content.hasParent() ) {
				arguments.content.getParent().removeChild( arguments.content );
			}
			if ( arguments.content.hasCategories() ) {
				arguments.content.removeAllCategories();
			}
			if ( arguments.content.hasRelatedContent() ) {
				arguments.content.getRelatedContent().clear();
			}
			if ( arguments.content.hasLinkedContent() ) {
				arguments.content.removeAllLinkedContent();
			}
			if ( arguments.content.hasChild() ) {
				var aItemsToDelete = [];
				for ( var thisChild in arguments.content.getChildren() ) {
					arrayAppend( aItemsToDelete, thisChild );
				}
				for ( var thisChild in aItemsToDelete ) {
					this.delete( thisChild );
				}
			}

			// now delete it
			super.delete( arguments.content );
		}

		// return service
		return this;
	}

	/**
	 * Find published content objects by different filters and output formats
	 *
	 * @max        The maximum number of records to paginate
	 * @offset     The offset in the pagination
	 * @searchTerm The search term to search
	 * @category   The category to filter the content on
	 * @asQuery    Return as query or array of objects, defaults to array of objects
	 * @sortOrder  how we need to sort the results
	 * @parent     The parentID or parent entity to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @slugPrefix If passed, this will do a hierarchical search according to this slug prefix. Remember that all hierarchical content's slug field contains its hierarchy: /products/awesome/product1. This prefix will be appended with a `/`
	 * @siteID     If passed, filter by site id
	 * @properties The list of properties to project on instead of giving you full object graphs
	 * @authorID   The authorID to filter on
	 * @criteria   The criteria object to use if passed, else we create a new one.
	 * @slugSearch If passed, we will search for content items with this field as a full text search on slugs
	 *
	 * @return struct as { count, content }
	 */
	function findPublishedContent(
		numeric max      = 0,
		numeric offset   = 0,
		any searchTerm   = "",
		any category     = "",
		boolean asQuery  = false,
		string sortOrder = "publishedDate DESC",
		any parent,
		string slugPrefix = "",
		string siteID     = "",
		string properties,
		string authorID = "",
		any criteria,
		string slugSearch = ""
	){
		var results = { "count" : 0, "content" : [] };
		var c       = ( isNull( arguments.criteria ) ? newCriteria() : arguments.criteria );

		// Do we evaluate parent roots or not?
		var nullParentFields = [
			arguments.searchTerm,
			arguments.category,
			arguments.authorID,
			arguments.slugPrefix,
			arguments.slugSearch
		];
		var hasSearchContext = nullParentFields.reduce( function( results, thisItem ){
			if ( len( arguments.thisItem ) ) {
				return true;
			}
			return results;
		}, false );

		// only published pages
		c.isTrue( "isPublished" )
			.isLT( "publishedDate", now() )
			.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
			// only non-password pages
			.isEq( "passwordProtection", "" )
			// Category Filter
			.when( len( arguments.category ), function( c ){
				// create association with categories by slug.
				arguments.c.joinTo( "categories", "cats" ).isIn( "cats.slug", listToArray( category ) );
			} )
			// Search Criteria
			.when( len( arguments.searchTerm ), function( c ){
				// like disjunctions
				arguments.c
					.joinTo(
						associationName: "contentVersions",
						alias          : "ac",
						withClause     : getRestrictions().isTrue( "ac.isActive" )
					)
					.$or(
						arguments.c.restrictions.like( "title", "%#searchTerm#%" ),
						arguments.c.restrictions.like( "slug", "%#searchTerm#%" ),
						arguments.c.restrictions.like( "ac.content", "%#searchTerm#%" )
					);
			} )
			// Slug Search Criteria
			.when( len( arguments.slugSearch ), function( c ){
				arguments.c.ilike( "slug", "%#slugSearch#%" );
			} )
			// Site Filter
			.when( len( arguments.siteID ), function( c ){
				arguments.c.isEq( "site.siteID", siteID );
			} )
			// Creator Filter
			.when( len( arguments.authorID ), function( c ){
				arguments.c.isEq( "creator.authorID", authorID );
			} )
			// Slug Prefix hierarchy search
			.when( len( arguments.slugPrefix ), function( c ){
				arguments.c.ilike( "slug", "#slugPrefix#/%" );
			} )
			// Parent Included Filter
			.when( !isNull( arguments.parent ) && len( arguments.parent ), function( c ){
				arguments.c.isEq( "parent.contentID", parent );
			} )
			// Parent Root when parent = ''
			.when( !isNull( arguments.parent ) && !len( arguments.parent ) && !hasSearchContext, function( c ){
				// change sort by parent
				arguments.c.isNull( "parent" );
				sortOrder = "order asc";
			} )
		;

		// run criteria query and projections count
		results.count   = c.count( "contentID" );
		results.content = c
			// Do we want array of simple projections?
			.when( !isNull( arguments.properties ), function( c ){
				arguments.c.withProjections( property: properties ).asStruct();
			} )
			.list(
				offset   : arguments.offset,
				max      : arguments.max,
				sortOrder: arguments.sortOrder,
				asQuery  : arguments.asQuery
			);

		return results;
	}

	/**
	 * Bulk Publish Status Updates
	 *
	 * @contentID The list or array of ID's to bulk update
	 * @status    The status either 'publish' or 'draft'
	 */
	any function bulkPublishStatus( required any contentID, required any status ){
		var publish = false;

		// publish flag
		if ( arguments.status eq "publish" ) {
			publish = true;
		}

		// Get all by id
		var contentObjects = getAll( id = arguments.contentID );
		for ( var x = 1; x lte arrayLen( contentObjects ); x++ ) {
			contentObjects[ x ].setpublishedDate( now() );
			contentObjects[ x ].setisPublished( publish );
		}

		// transaction the save of all the content objects
		saveAll( contentObjects );

		return this;
	}

	/**
	 * Get all the expired content in the system by filters
	 *
	 * @author The author filtering if passed.
	 * @max    The maximum number of records to return
	 * @offset The pagination offset
	 * @siteID The site to filter on
	 */
	array function findExpiredContent(
		any author,
		numeric max    = 0,
		numeric offset = 0,
		string siteID  = ""
	){
		var c = newCriteria().createAlias(
			associationName: "contentVersions",
			alias          : "ac",
			withClause     : getRestrictions().isTrue( "ac.isActive" )
		);

		// only future published pages
		c.isTrue( "isPublished" )
			.isLT( "publishedDate", now() )
			.isLT( "expireDate", now() );

		// Site Filter
		if ( len( arguments.siteID ) ) {
			c.isEq( "site.siteID", arguments.siteID );
		}

		// author filter
		if ( structKeyExists( arguments, "author" ) ) {
			c.isEq( "ac.author", arguments.author );
		}

		return c.list(
			max       = arguments.max,
			offset    = arguments.offset,
			sortOrder = "expireDate desc",
			asQuery   = false
		);
	}

	/**
	 * Get all the future published content in the system by filters
	 *
	 * @author The author filtering if passed.
	 * @max    The maximum number of records to return
	 * @offset The pagination offset
	 * @siteID The site to filter on
	 */
	array function findFuturePublishedContent(
		any author,
		numeric max    = 0,
		numeric offset = 0,
		string siteID  = ""
	){
		var c = newCriteria().createAlias(
			associationName: "contentVersions",
			alias          : "ac",
			withClause     : getRestrictions().isTrue( "ac.isActive" )
		);

		// Only non-expired future publishing pages
		c.isTrue( "isPublished" ).isGT( "publishedDate", now() );

		// Site Filter
		if ( len( arguments.siteID ) ) {
			c.isEq( "site.siteID", arguments.siteID );
		}

		// author filter
		if ( structKeyExists( arguments, "author" ) ) {
			c.isEq( "ac.author", arguments.author );
		}

		return c.list(
			max       = arguments.max,
			offset    = arguments.offset,
			sortOrder = "publishedDate desc",
			asQuery   = false
		);
	}

	/**
	 * Get latest edits according to criteria
	 *
	 * @author      The author object to use for retrieval
	 * @isPublished If passed, check if content is published or in draft mode. Else defaults to all states
	 * @max         The maximum number of records to return
	 * @siteID      The site to get edits from
	 */
	array function getLatestEdits(
		any author,
		boolean isPublished,
		numeric max   = 25,
		string siteID = ""
	){
		// Get only active content joins
		return newCriteria()
			.createAlias(
				associationName: "contentVersions",
				alias          : "ac",
				withClause     : getRestrictions().isTrue( "ac.isActive" )
			)
			// isPublished filter
			.when( !isNull( arguments.isPublished ), function( c ){
				c.isEq( "isPublished", javacast( "boolean", isPublished ) );
			} )
			// Site Filter
			.when( !isNull( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			// author filter
			.when( !isNull( arguments.author ), function( c ){
				c.isEq( "ac.author", author );
			} )
			.list( max: arguments.max, sortOrder: "ac.createdDate desc" );
	}

	/**
	 * Get the top visited content entries
	 *
	 * @max    The maximum to retrieve, defaults to 5 entries
	 * @siteID The site to filter on
	 */
	array function getTopVisitedContent( numeric max = 5, string siteID = "" ){
		return newCriteria()
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.joinTo( "stats", "stats" )
			.list( max = arguments.max, sortOrder = "stats.hits desc" );
	}

	/**
	 * Get the top commented content entries
	 *
	 * @max    The maximum to retrieve, defaults to 5 entries
	 * @siteID The site to filter on
	 */
	array function getTopCommentedContent( numeric max = 5, string siteID = "" ){
		return executeQuery(
			query: "
				SELECT new map( content as content, count( comments.commentID ) AS commentCount )
				FROM cbContent content JOIN content.comments comments
				WHERE content.site.siteID = :siteID
				GROUP BY content
				ORDER BY count( comments.commentID ) DESC
			",
			params    : { siteID : arguments.siteID },
			max       : arguments.max,
			ignoreCase: true
		)
			// We just need the content objects, not the comments count
			.map( function( item ){
				return item[ "content" ];
			} );
	}

	/**
	 * Get all content for export as flat data
	 *
	 * @inData The data to use for exporting, usually concrete implementtions can override this.
	 */
	array function getAllForExport( any inData ){
		if ( isNull( arguments.inData ) ) {
			arguments.inData = newCriteria().isNull( "parent" ).list();
		}
		return arguments.inData.map( function( thisItem ){
			return arguments.thisItem.getMemento( profile: "export" );
		} );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The json file to import
	 * @override   Override content if found in the database, defaults to false
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw( message: "Cannot import file as the contents is not JSON", type: "InvalidImportFormat" );
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures or a single structure of data
	 *
	 * @importData A struct or array of data to import
	 * @override   Override content if found in the database, defaults to false
	 * @importLog  The import log buffer
	 * @site       If passed, we use this specific site, else we discover it via content data
	 *
	 * @return The console log of the import
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		required importLog,
		site
	){
		// Setup logging function
		var logThis = function( message ){
			variables.logger.info( arguments.message );
			importLog.append( arguments.message & "<br>" );
		};

		var siteService = getWireBox().getInstance( "siteService@contentbox" );

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisContent in arguments.importData ) {
				// Determine Site if not passed from import data
				if ( isNull( arguments.site ) ) {
					logThis( "+ Site not passed, inflating from import data (#thisContent.site.slug#)" );
					arguments.site = siteService.getBySlugOrFail( thisContent.site.slug );
				}

				logThis(
					"+ Starting to import content (#thisContent.contentType#:#thisContent.slug#) to site (#arguments.site.getSlug()#)"
				);

				// Import it
				importFromStruct(
					contentData: thisContent,
					importLog  : arguments.importLog,
					site       : arguments.site,
					override   : arguments.override
				);
			}
			// end import loop

			// Save content
			if ( !arrayLen( arguments.importData ) ) {
				logThis( "No content imported as none where found or able to be overriden from the import file." );
			}
		}
		// end transaction

		return arguments.importLog.toString();
	}

	/**
	 * Import a content object from a ContentBox JSON structure
	 *
	 * @contentData The content structure inflated from JSON
	 * @importLog   The string builder import log
	 * @parent      If the inflated content object has a parent then it can be linked directly, no inflating necessary. Usually for recursions
	 * @newContent  Map of new content by slug; useful for avoiding new content collisions with recusive relationships
	 * @site        The site we are using for the content
	 * @override    Are we overriding persisted data or not?
	 *
	 * @return The content object representing the struct
	 */
	any function importFromStruct(
		required any contentData,
		required any importLog,
		any parent,
		struct newContent = {},
		required site,
		boolean override = false
	){
		// Setup logging function
		var logThis = function( message ){
			variables.logger.info( arguments.message );
			importLog.append( arguments.message & "<br>" );
		};
		// setup
		var thisContent = arguments.contentData;
		// Get content by slug, if not found then it returns a new entity so we can persist it.
		var oContent    = findWhere( { "slug" : thisContent.slug, "site" : arguments.site } );
		if ( isNull( oContent ) ) {
			logThis(
				"! Content (#thisContent.contentType#:#thisContent.slug#) not found in site, proceeding to import as new content."
			);
			oContent = this.new();
		} else {
			logThis(
				"! Content (#thisContent.contentType#:#thisContent.slug#) found in site, proceeding to check if we can import."
			);
		}

		// Check if loaded and override selected
		if ( oContent.isLoaded() && !arguments.override ) {
			logThis(
				"!! Skipping persisted content (#thisContent.contentType#:#thisContent.slug#) no override selected"
			);
			return;
		}
		// Link to site
		oContent.setSite( arguments.site );
		// add to newContent map so we can avoid slug collisions in recursive relationships
		arguments.newContent[ thisContent.slug ] = oContent;

		// populate content from data and ignore relationships, we need to build those manually.
		var excludedFields = [
			"categories",
			"children",
			"comments",
			"commentSubscriptions",
			"contentversions",
			"creator",
			"customfields",
			"linkedContent",
			"parent",
			"relatedContent",
			"site",
			"stats"
		];
		getBeanPopulator().populateFromStruct(
			target               = oContent,
			memento              = thisContent,
			exclude              = arrayToList( excludedFields ),
			composeRelationships = false,
			nullEmptyInclude     = "publishedDate,expireDate"
		);

		// determine author else ignore import
		var oAuthor = variables.authorService.findByEmail( thisContent.creator.email );
		if ( isNull( oAuthor ) ) {
			logThis(
				"!! Author (#thisContent.creator.email#) not found in ContentBox for: (#thisContent.contentType#:#thisContent.slug#)"
			);
			return oContent;
		}

		// AUTHOR CREATOR
		oContent.setCreator( oAuthor );
		logThis( "+ Content author linked for: (#thisContent.contentType#:#thisContent.slug#)" );

		// PARENT
		if ( !isNull( arguments.parent ) and isObject( arguments.parent ) ) {
			oContent.setParent( arguments.parent );
			arguments.parent.addChild( oContent );
			logThis(
				"+ Content parent (#arguments.parent.getSlug()#) passed and linked for: (#thisContent.contentType#:#thisContent.slug#)"
			);
		} else if ( structCount( thisContent.parent ) ) {
			var oParent = findWhere( {
				"slug" : thisContent.parent.slug,
				"site" : arguments.site
			} );
			// assign if persisted
			if ( !isNull( oParent ) ) {
				oContent.setParent( oParent );
				logThis(
					"+ Content parent (#oParent.getSlug()#) found and linked to: (#thisContent.contentType#:#thisContent.slug#)"
				);
			} else {
				logThis(
					"+ Content parent (#thisContent.parent.toString()#) not found for : (#thisContent.contentType#:#thisContent.slug#)"
				);
			}
		}

		// CUSTOM FIELDS
		if ( arrayLen( thisContent.customfields ) ) {
			// wipe out custom fileds if they exist
			oContent.removeAllCustomFields();
			logThis(
				"+ Content custom fields (#arrayLen( thisContent.customfields )#) found, about to start import for : (#thisContent.contentType#:#thisContent.slug#)"
			);
			// add new custom fields
			for ( var thisCF in thisContent.customfields ) {
				// explicitly convert value to string...
				// ACF doesn't handle string values well when they look like numbers :)
				oContent.addCustomField(
					customFieldService.new( {
						key            : thisCF.key,
						value          : toString( thisCF.value ),
						relatedContent : oContent
					} )
				);
				logThis( "+ Custom field (#thisCF.key#) imported for : (#thisContent.contentType#:#thisContent.slug#)" );
			}
		}

		// CATEGORIES
		if ( arrayLen( thisContent.categories ) ) {
			oContent.setCategories(
				thisContent.categories.map( function( thisCategory ){
					var oSiteCategory = site.getCategory( arguments.thisCategory );
					return (
						!isNull( oSiteCategory ) ? oSiteCategory : variables.categoryService.getOrCreateBySlug(
							arguments.thisCategory,
							site
						)
					);
				} )
			);
			logThis(
				"+ Categories (#thisContent.categories.toString()#) imported for : (#thisContent.contentType#:#thisContent.slug#)"
			);
		}

		// We now persist it to do child relationships
		entitySave( oContent );

		// STATS
		if ( structCount( thisContent.stats ) && thisContent.stats.hits > 0 ) {
			if ( oContent.hasStats() ) {
				oContent.getStats().setHits( thisContent.stats.hits );
				logThis( "+ Content stats found and updated for : (#thisContent.contentType#:#thisContent.slug#)" );
			} else {
				logThis( "+ Content stats imported for : (#thisContent.contentType#:#thisContent.slug#)" );
				variables.statsService.save(
					variables.statsService.new( { hits : thisContent.stats.hits, relatedContent : oContent } )
				);
			}
		}

		// CHILDREN
		if ( arrayLen( thisContent.children ) ) {
			logThis(
				"+ Content children (#arrayLen( thisContent.children )#) found, about to start import for : (#thisContent.contentType#:#thisContent.slug#)"
			);
			// recurse on them and inflate hiearchy
			for ( var thisChild in thisContent.children ) {
				var oChild = importFromStruct(
					contentData = thisChild,
					importLog   = arguments.importLog,
					parent      = oContent,
					newContent  = arguments.newContent,
					site        = arguments.site,
					override    = arguments.override
				);

				// continue to next record if author not found
				if ( !oChild.hasCreator() ) {
					logThis(
						"!! Import skipped, Author (#thisChild.creator.email#) not found when importing child (#thisChild.slug#) for : (#thisContent.contentType#:#thisContent.slug#)"
					);
				} else {
					logThis(
						"+ Content child (#thisChild.slug#) imported for : (#thisContent.contentType#:#thisContent.slug#)"
					);
				}
			}
		}

		// RELATED CONTENT
		if ( arrayLen( thisContent.relatedContent ) ) {
			var allRelatedContent = [];
			logThis(
				"+ Content related content (#arrayLen( thisContent.relatedContent )#) found, about to start import for : (#thisContent.contentType#:#thisContent.slug#)"
			);
			for ( var thisRelatedContent in thisContent.relatedContent ) {
				// if content has already been inflated as part of another process, just use that instance so we don't collide keys
				if ( structKeyExists( arguments.newContent, thisRelatedContent.slug ) ) {
					arrayAppend( allRelatedContent, arguments.newContent[ thisRelatedContent.slug ] );
					logThis(
						"+ Related content (#thisRelatedContent.slug#) already imported, linking to : (#thisContent.contentType#:#thisContent.slug#)"
					);
				}
				// otherwise, we need to get it
				else {
					var oRelatedContent = getServiceByType( thisRelatedContent.contentType ).findWhere( {
						"slug" : thisRelatedContent.slug,
						"site" : arguments.site
					} );
					if ( !isNull( oRelatedContent ) ) {
						arrayAppend( allRelatedContent, oRelatedContent );
						logThis(
							"+ Related content (#thisRelatedContent.slug#) linked to : (#thisContent.contentType#:#thisContent.slug#)"
						);
					} else {
						logThis(
							"!! Skipping related content (#thisRelatedContent.slug#) as it was not found for : (#thisContent.contentType#:#thisContent.slug#)"
						);
					}
				}
			}
			oContent.setRelatedContent( allRelatedContent );
		}

		// COMMENTS
		if ( arrayLen( thisContent.comments ) ) {
			logThis(
				"+ Content comments (#arrayLen( thisContent.comments )#) found, about to start import for : (#thisContent.contentType#:#thisContent.slug#)"
			);
			oContent.setComments(
				thisContent.comments.map( function( thisComment ){
					return getBeanPopulator()
						.populateFromStruct(
							target               = variables.commentService.new(),
							memento              = thisComment,
							exclude              = "commentID",
							composeRelationships = false
						)
						.setRelatedContent( oContent );
				} )
			);
			logThis( "+ Content comments imported to: (#thisContent.contentType#:#thisContent.slug#)" );
		}

		// SUBSCRIPTIONS
		if ( arrayLen( thisContent.commentSubscriptions ) ) {
			var allSubscriptions = [];
			logThis(
				"+ Content comment subscriptions (#arrayLen( thisContent.commentSubscriptions )#) found, about to start import for : (#thisContent.contentType#:#thisContent.slug#)"
			);
			// recurse on them and inflate hiearchy
			for ( var thisSubscription in thisContent.commentSubscriptions ) {
				// Subscription
				var oSubscription = variables.commentSubscriptionService.new( {
					relatedContent    : oContent,
					subscriptionToken : thisSubscription.subscriptionToken,
					type              : thisSubscription.type
				} );
				// Subscriber
				var oSubscriber = variables.subscriberService.findBySubscriberEmail(
					thisSubscription.subscriber.subscriberEmail
				);
				if ( isNull( oSubscriber ) ) {
					oSubscriber = variables.subscriberService.new( {
						subscriberEmail : thisSubscription.subscriber.subscriberEmail,
						subscriberToken : thisSubscription.subscriber.subscriberToken
					} );
				}
				oSubscriber.addSubscription( oSubscription );
				oSubscription.setSubscriber( oSubscriber );
				// Save subscriber subscription
				variables.subscriberService.save( oSubscriber );
				// add to import
				// arrayAppend( allSubscriptions, oSubscription );
				logThis(
					"+ Content comment subscription for (#thisSubscription.subscriber.subscriberEmail#) imported to: (#thisContent.contentType#:#thisContent.slug#)"
				);
			}
			// oContent.setCommentSubscriptions( allSubscriptions );
			logThis( "+ Content comment subscriptions imported to: (#thisContent.contentType#:#thisContent.slug#)" );
		}

		// CONTENT VERSIONS
		if ( arrayLen( thisContent.contentversions ) ) {
			logThis(
				"+ Content versions (#arrayLen( thisContent.contentversions )#) found, about to start import for : (#thisContent.contentType#:#thisContent.slug#)"
			);
			oContent.setContentVersions(
				thisContent.contentVersions.map( function( thisVersion ){
					logThis(
						"+ Importing content version (#thisVersion.version#) to : (#thisContent.contentType#:#thisContent.slug#)"
					);
					var oVersion = getBeanPopulator().populateFromStruct(
						target               = variables.contentVersionService.new(),
						memento              = thisVersion,
						exclude              = "contentVersionID,author",
						composeRelationships = false
					);
					var oEditor = variables.authorService.findByEmail( thisVersion.author.email );
					return oVersion.setAuthor( isNull( oEditor ) ? oAuthor : oEditor ).setRelatedContent( oContent );
				} )
			);
		}

		return oContent;
	}

	/**
	 * Update a content's hits with some async flava
	 *
	 * @content A content object or id to update the hits on
	 * @async   Async or not
	 */
	ContentService function updateHits( required content, boolean async = true ){
		// Inflate it if it's just an ID
		if ( isSimpleValue( arguments.content ) ) {
			arguments.content = get( arguments.content );
		}
		// Record the hit
		variables.statsService.syncUpdateHits( arguments.content );
		return this;
	}

	/**
	 * Returns an array of slugs of all the content objects in the system.
	 */
	array function getAllFlatSlugs(){
		var c = newCriteria();

		return c.withProjections( property = "slug" ).list( sortOrder = "slug asc" );
	}

	/**
	 * Returns an array of [contentID, title, slug, createdDate, modifiedDate, featuredImageURL] structures of all the content in the system
	 *
	 * @sortOrder    The sort ordering of the results
	 * @isPublished  Show all content or true/false published content
	 * @showInSearch Show all content or true/false showInSearch flag
	 * @siteID       The site id to use to filter on
	 *
	 * @return Array of content data {contentID, title, slug, createdDate, modifiedDate, featuredImageURL}
	 */
	array function getAllFlatContent(
		sortOrder = "title asc",
		boolean isPublished,
		boolean showInSearch,
		string siteID = ""
	){
		var c = newCriteria();

		// only published content
		if (
			structKeyExists( arguments, "isPublished" )
			&&
			isBoolean( arguments.isPublished )
		) {
			// Published bit
			c.isEq( "isPublished", javacast( "Boolean", arguments.isPublished ) );
			// Published eq true evaluate other params
			if ( arguments.isPublished ) {
				c.isLt( "publishedDate", now() )
					.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
					.isEq( "passwordProtection", "" );
			}
		}

		// Site Filter
		if ( len( arguments.siteID ) ) {
			c.isEq( "site.siteID", arguments.siteID );
		}

		// Show in Search
		if (
			structKeyExists( arguments, "showInSearch" )
			&&
			isBoolean( arguments.showInSearch )
		) {
			// showInSearch bit
			c.isEq( "showInSearch", javacast( "Boolean", arguments.showInSearch ) );
		}

		return c
			.withProjections( property = "contentID,title,slug,createdDate,modifiedDate,featuredImageURL" )
			.asStruct()
			.list( sortOrder = arguments.sortOrder );
	}

	/********************************************* PRIVATE *********************************************/

	/**
	 * Get the appropriate service by passed content type.
	 * If an invalid type is passed, we return ourselves
	 *
	 * @type The content type to detect
	 */
	private function getServiceByType( required type ){
		switch ( arguments.type ) {
			case "Page":
				return variables.pageService;
				break;
			case "Entry":
				return variables.entryService;
				break;
			case "ContentStore":
				return variables.contentStoreService;
				break;
		}
		return this;
	}
	/**
	 * Get a unique slug hash
	 *
	 * @slug The slug to unique it
	 */
	private function getUniqueSlugHash( required string slug ){
		return "#arguments.slug#-#lCase( left( hash( now() ), 5 ) )#";
	}

}
