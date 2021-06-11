/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A generic content service for content objects
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="settingService" inject="id:settingService@cb";
	property name="cacheBox" inject="cachebox";
	property name="log" inject="logbox:logger:{this}";
	property name="customFieldService" inject="customFieldService@cb";
	property name="categoryService" inject="categoryService@cb";
	property name="commentService" inject="commentService@cb";
	property name="contentVersionService" inject="contentVersionService@cb";
	property name="authorService" inject="authorService@cb";
	property name="contentStoreService" inject="contentStoreService@cb";
	property name="pageService" inject="pageService@cb";
	property name="entryService" inject="entryService@cb";
	property name="systemUtil" inject="SystemUtil@cb";
	property name="statsService" inject="statsService@cb";
	property name="dateUtil" inject="DateUtil@cb";
	property name="commentSubscriptionService" inject="CommentSubscriptionService@cb";
	property name="subscriberService" inject="subscriberService@cb";
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
	 * @siteID The site to filter on
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
	 * @slug The slug partial to clean on
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
	 * @slug The slug to clear
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
	 * @searchTerm The search term to search
	 * @max The maximum number of records to paginate
	 * @offset The offset in the pagination
	 * @asQuery Return as query or array of objects, defaults to array of objects
	 * @sortOrder The sorting of the search results, defaults to publishedDate DESC
	 * @isPublished Search for published, non-published or both content objects [true, false, 'all']
	 * @searchActiveContent Search only content titles or both title and active content. Defaults to both.
	 * @contentTypes Limit search to list of content types (comma-delimited). Leave blank to search all content types
	 * @excludeIDs List of IDs to exclude from search
	 * @showInSearch If true, it makes sure content has been stored as searchable, defaults to null, which means it searches no matter what this bit says
	 * @siteID The site ID to filter on
	 *
	 * @returns struct = { content, count }
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
		string siteID = ""
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
					.$or(
						c.restrictions.isNull( "expireDate" ),
						c.restrictions.isGT( "expireDate", now() )
					)
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
		results.count   = c.count( "contentID" );
		results.content = c
			.resultTransformer( c.DISTINCT_ROOT_ENTITY )
			.list(
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
	 * @slug The slug to search an ID for.
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
	 * @throws EntityNotFound
	 *
	 * @return The found entity
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
			throw(
				message = "No entity found for ID/Slug #arguments.id.toString()#",
				type    = "EntityNotFound"
			);
		}

		return oEntity;
	}

	/**
	 * Find a published content object by slug and published unpublished flags, if not found it returns
	 * a new content object
	 *
	 * @slug The slug to search
	 * @showUnpublished To also show unpublished content, defaults to false.
	 * @siteID The site this slug belongs to
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
					.$or(
						c.restrictions.isNull( "expireDate" ),
						c.restrictions.isGT( "expireDate", now() )
					);
			} )
			.get();

		// return accordingly
		return isNull( oContent ) ? new () : oContent;
	}

	/**
	 * Verify an incoming slug is unique or not
	 *
	 * @slug The slug to search for uniqueness
	 * @contentID Limit the search to the passed contentID usually for updates
	 * @siteID The site to filter on
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
	 * @max The maximum number of records to paginate
	 * @offset The offset in the pagination
	 * @searchTerm The search term to search
	 * @category The category to filter the content on
	 * @asQuery Return as query or array of objects, defaults to array of objects
	 * @sortOrder how we need to sort the results
	 * @parent The parentID or parent entity to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @slugPrefix If passed, this will do a hierarchical search according to this slug prefix. Remember that all hierarchical content's slug field contains its hierarchy: /products/awesome/product1. This prefix will be appended with a `/`
	 * @siteID If passed, filter by site id
	 * @properties The list of properties to project on instead of giving you full object graphs
	 * @authorID The authorID to filter on
	 * @criteria The criteria object to use if passed, else we create a new one.
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
			.$or(
				c.restrictions.isNull( "expireDate" ),
				c.restrictions.isGT( "expireDate", now() )
			)
			// only non-password pages
			.isEq( "passwordProtection", "" )
			// Category Filter
			.when( len( arguments.category ), function( c ){
				// create association with categories by slug.
				arguments.c
					.joinTo( "categories", "cats" )
					.isIn( "cats.slug", listToArray( category ) );
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
	 * @status The status either 'publish' or 'draft'
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
	 * @max The maximum number of records to return
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
	 * @max The maximum number of records to return
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
	 * @author The author object to use for retrieval
	 * @isPublished	If passed, check if content is published or in draft mode. Else defaults to all states
	 * @max The maximum number of records to return
	 * @siteID The site to get edits from
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
	 * @max The maximum to retrieve, defaults to 5 entries
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
	 * @max The maximum to retrieve, defaults to 5 entries
	 * @siteID The site to filter on
	 */
	array function getTopCommentedContent( numeric max = 5, string siteID = "" ){
		return executeQuery(
			query: "
				SELECT new map( content as content, count( comments.commentID ) AS commentCount )
				FROM cbContent content JOIN content.comments comments
				GROUP BY content
				ORDER BY count( comments.commentID ) DESC
			",
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
		// export from the root node, instead of everything.
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
	 * @override Override content if found in the database, defaults to false
	 *
	 * @throws InvalidImportFormat
	 *
	 * @return The console log of the import
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw(
				message: "Cannot import file as the contents is not JSON",
				type   : "InvalidImportFormat"
			);
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
	 * @override Override content if found in the database, defaults to false
	 * @importLog The import log buffer
	 *
	 * @return The console log of the import
	 */
	string function importFromData(
		required any importData,
		boolean override = false,
		required any importLog
	){
		var allContent  = [];
		var siteService = getWireBox().getInstance( "siteService@cb" );

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisContent in arguments.importData ) {
				// Inflate content from data: { content, authorFound }
				var inflatedResults = inflateFromStruct( thisContent, arguments.importLog );

				// continue to next record if author not found
				if ( !inflatedResults.authorFound ) {
					continue;
				}

				// if new or persisted with override then save.
				if ( !inflatedResults.content.isLoaded() ) {
					arguments.importLog.append( "New content imported: #thisContent.slug#<br>" );
					arrayAppend( allContent, inflatedResults.content );
				} else if ( inflatedResults.content.isLoaded() and arguments.override ) {
					arguments.importLog.append(
						"Persisted content overriden: #thisContent.slug#<br>"
					);
					arrayAppend( allContent, inflatedResults.content );
				} else {
					arguments.importLog.append(
						"Skipping persisted content: #thisContent.slug#<br>"
					);
				}
			}
			// end import loop

			// Save content
			if ( arrayLen( allContent ) ) {
				saveAll( allContent );
				arguments.importLog.append( "Saved all imported and overriden content!" );
			} else {
				arguments.importLog.append(
					"No content imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end transaction

		return arguments.importLog.toString();
	}

	/**
	 * Inflate a content object from a ContentBox JSON structure
	 *
	 * @contentData The content structure inflated from JSON
	 * @importLog The string builder import log
	 * @parent If the inflated content object has a parent then it can be linked directly, no inflating necessary. Usually for recursions
	 * @newContent Map of new content by slug; useful for avoiding new content collisions with recusive relationships
	 *
	 * @return struct of { content:contentObject, authorFound: }
	 */
	struct function inflateFromStruct(
		required any contentData,
		required any importLog,
		any parent,
		struct newContent = {}
	){
		var results     = { "content" : "", "authorFound" : false };
		// setup
		var thisContent = arguments.contentData;
		// Get content by slug, if not found then it returns a new entity so we can persist it.
		results.content = this.findBySlug(
			slug            = thisContent.slug,
			showUnpublished = true,
			siteID          = thisContent.site.siteID
		);
		results.content = ( isNull( results.content ) ? this.new() : results.content );

		// add to newContent map so we can avoid slug collisions in recursive relationships
		arguments.newContent[ thisContent.slug ] = results.content;

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
			"stats"
		];
		getBeanPopulator().populateFromStruct(
			target               = results.content,
			memento              = thisContent,
			exclude              = arrayToList( excludedFields ),
			composeRelationships = false,
			nullEmptyInclude     = "publishedDate,expireDate"
		);

		// Link the site
		results.content.setSite( siteService.getBySlugOrFail( thisContent.site.slug ) );

		// determine author else ignore import
		var oAuthor = variables.authorService.findByEmail( thisContent.creator.email );
		if ( isNull( oAuthor ) ) {
			arguments.importLog.append(
				"Content author not found (#thisContent.creator.toString()#) skipping: #thisContent.slug#<br>"
			);
			return results;
		}
		results.authorFound = true;

		// AUTHOR CREATOR
		results.content.setCreator( oAuthor );
		arguments.importLog.append( "Content author found and linked: #thisContent.slug#<br>" );

		// PARENT
		if ( !isNull( arguments.parent ) and isObject( arguments.parent ) ) {
			results.content.setParent( arguments.parent );
			arguments.importLog.append(
				"Content parent passed and linked: #arguments.parent.getSlug()#<br>"
			);
		} else if ( isStruct( thisContent.parent ) and structCount( thisContent.parent ) ) {
			var oParent = this.findBySlug( slug = thisContent.parent.slug, showUnpublished = true );
			// assign if persisted
			if ( oParent.isLoaded() ) {
				results.content.setParent( oParent );
				arguments.importLog.append(
					"Content parent found and linked: #thisContent.parent.slug#<br>"
				);
			} else {
				arguments.importLog.append(
					"Content parent slug: #thisContent.parent.toString()# was not found so not assigned!<br>"
				);
			}
		}

		// STATS
		if ( thisContent.stats.hits > 0 ) {
			results.content.setStats(
				variables.statsService.new( {
					hits           : thisContent.stats.hits,
					relatedContent : results.content
				} )
			);
		}

		// CHILDREN
		if ( arrayLen( thisContent.children ) ) {
			var allChildren = [];
			// recurse on them and inflate hiearchy
			for ( var thisChild in thisContent.children ) {
				var inflateResults = inflateFromStruct(
					contentData = thisChild,
					importLog   = arguments.importLog,
					parent      = results.content
				);
				// continue to next record if author not found
				if ( !inflateResults.authorFound ) {
					continue;
				}
				// Add to array of children to add, we have a good content object with a creator
				arrayAppend( allChildren, inflateResults.content );
			}
			results.content.setChildren( allChildren );
		}

		// CUSTOM FIELDS
		if ( arrayLen( thisContent.customfields ) ) {
			// wipe out custom fileds if they exist
			results.content.removeAllCustomFields();
			// add new custom fields
			for ( var thisCF in thisContent.customfields ) {
				// explicitly convert value to string...
				// ACF doesn't handle string values well when they look like numbers :)
				results.content.addCustomField(
					customFieldService.new( {
						key            : thisCF.key,
						value          : toString( thisCF.value ),
						relatedContent : results.content
					} )
				);
			}
		}

		// CATEGORIES
		if ( arrayLen( thisContent.categories ) ) {
			results.content.setCategories(
				thisContent.categories.map( function( thisCategory ){
					return variables.categoryService.getOrCreateBySlug(
						thisCategory,
						results.content.getSite()
					);
				} )
			);
		}

		// RELATED CONTENT
		if ( arrayLen( thisContent.relatedContent ) ) {
			var allRelatedContent = [];
			for ( var thisRelatedContent in thisContent.relatedContent ) {
				// if content has already been inflated as part of another process, just use that instance so we don't collide keys
				if ( structKeyExists( arguments.newContent, thisRelatedContent.slug ) ) {
					arrayAppend(
						allRelatedContent,
						arguments.newContent[ thisRelatedContent.slug ]
					);
				}
				// otherwise, we need to get it
				else {
					var oRelatedContent = getServiceByType( thisRelatedContent.contentType ).findBySlug(
						slug            = thisRelatedContent.slug,
						showUnpublished = true,
						siteID          = thisContent.site.siteID
					);
					if ( !isNull( oRelatedContent ) ) {
						arrayAppend( allRelatedContent, oRelatedContent );
					} else {
						arguments.importLog.append(
							"Related content not found, so skipping link: #thisRelatedContent.toString()#<br>"
						);
					}
				}
			}
			results.content.setRelatedContent( allRelatedContent );
		}

		// COMMENTS
		if ( arrayLen( thisContent.comments ) ) {
			results.content.setComments(
				thisContent.comments.map( function( thisComment ){
					return getBeanPopulator()
						.populateFromStruct(
							target               = variables.commentService.new(),
							memento              = thisComment,
							exclude              = "commentID",
							composeRelationships = false
						)
						.setRelatedContent( results.content );
				} )
			);
		}

		// SUBSCRIPTIONS
		if ( arrayLen( thisContent.commentSubscriptions ) ) {
			var allSubscriptions = [];
			// recurse on them and inflate hiearchy
			for ( var thisSubscription in thisContent.commentSubscriptions ) {
				// Subscription
				var oSubscription = variables.commentSubscriptionService.new( {
					relatedContent    : results.content,
					subscriptionToken : thisSubscription.subscriptionToken,
					type              : thisSubscription.type
				} );
				// Subscriber
				var oSubscriber = variables.inflateFromStruct.findBySubscriberEmail(
					thisSubscription.subscriber.subscriberEmail
				);
				if ( isNull( oSubscriber ) ) {
					oSubscriber = variables.subscriberService.new( {
						subscriberEmail : thisSubscription.subscriber.subscriberEmail,
						subscriberToken : thisSubscription.subscriber.subscriberToken
					} );
				}
				oSubscription.setSubscriber( oSubscriber );
				oSubscriber.addSubscription( oSubscription );
				// Save subscriber subscription
				variables.subscriberService.save( oSubscriber );
				// add to import
				arrayAppend( allSubscriptions, oSubscription );
			}
			results.content.setCommentSubscriptions( allSubscriptions );
		}

		// CONTENT VERSIONS
		if ( arrayLen( thisContent.contentversions ) ) {
			results.content.setContentVersions(
				thisContent.contentVersions.map( function( thisVersion ){
					var oVersion = getBeanPopulator().populateFromStruct(
						target               = variables.contentVersionService.new(),
						memento              = thisVersion,
						exclude              = "contentVersionID,author",
						composeRelationships = false
					);
					var oEditor = variables.authorService.findByEmail( thisVersion.author.email );
					return oVersion
						.setAuthor( isNull( oEditor ) ? oAuthor : oEditor )
						.setRelatedContent( results.content )
				} )
			);
		}

		return results;
	}

	/**
	 * Update a content's hits with some async flava
	 *
	 * @content A content object or id to update the hits on
	 * @async Async or not
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
	 * @sortOrder The sort ordering of the results
	 * @isPublished	Show all content or true/false published content
	 * @showInSearch Show all content or true/false showInSearch flag
	 * @siteID The site id to use to filter on
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
					.$or(
						c.restrictions.isNull( "expireDate" ),
						c.restrictions.isGT( "expireDate", now() )
					)
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
			.withProjections(
				property = "contentID,title,slug,createdDate,modifiedDate,featuredImageURL"
			)
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
		switch ( thisRelatedContent.contentType ) {
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
