/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Category service for contentbox
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// Dependencies
	property name="htmlHelper" inject="HTMLHelper@coldbox";
	property name="contentService" inject="contentService@contentbox";
	property name="dateUtil" inject="DateUtil@contentbox";

	/**
	 * Constructor
	 */
	CategoryService function init(){
		// init it
		super.init( entityName = "cbCategory", useQueryCaching = true );

		return this;
	}

	/**
	 * Category search with filters
	 *
	 * @search    The search term for the name
	 * @siteID    The site id to filter on
	 * @isPublic  Filter on this public (true) / private (false) or all (null)
	 * @max       The max records
	 * @offset    The offset to use
	 * @sortOrder The sort order
	 *
	 * @return struct of { count, categories }
	 */
	struct function search(
		search = "",
		siteID = "",
		boolean isPublic,
		max       = 0,
		offset    = 0,
		sortOrder = "category asc"
	){
		var results = { "count" : 0, "categories" : [] };
		var c       = newCriteria()
			// Search Criteria
			.when( len( arguments.search ), function( c ){
				c.like( "category", "%#search#%" );
			} )
			// Site Filter
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			// IsPublic Filter
			.when( !isNull( arguments.isPublic ), function( c ){
				c.isEq( "isPublic", javacast( "Boolean", isPublic ) );
			} );

		// run criteria query and projections count
		results.count      = c.count( "categoryID" );
		results.categories = c.list(
			offset   : arguments.offset,
			max      : arguments.max,
			sortOrder: arguments.sortOrder
		);

		return results;
	}

	/**
	 * This function allows you to receive a category object from a site and
	 * tries to see if it exists in a new site via slug comparison.
	 * If it exists, it returns it, else it creates it and returns it.
	 *
	 * @category The target category object to check
	 * @site     The target site this category should be created in
	 *
	 * @return The target site category
	 */
	Category function getOrCreate( required category, required site ){
		// Verify the incoming category exists in the target site or not
		var oTargetCategory = newCriteria()
			.isEq( "slug", arguments.category.getSlug() )
			.joinTo( "site", "site" )
			.isEq( "site.slug", arguments.site.getSlug() )
			.get();

		// Return or Create
		if ( isNull( oTargetCategory ) ) {
			oTargetCategory = save(
				new ( {
					category : arguments.category.getCategory(),
					slug     : arguments.category.getSlug(),
					site     : arguments.site
				} )
			);
		}

		return oTargetCategory;
	}

	/**
	 * This function allows you to receive a category slug string from a site and
	 * tries to see if it exists in a new site via slug comparison.
	 * If it exists, it returns it, else it creates it and returns it.
	 *
	 * @category The target category slug to check
	 * @site     The target site this category should be created in
	 *
	 * @return The target site category object
	 */
	Category function getOrCreateBySlug( required string category, required site ){
		// Verify the incoming category exists in the target site or not
		if ( arguments.site.isLoaded() ) {
			var oTargetCategory = newCriteria()
				.isEq( "site.siteID", arguments.site.getsiteID() )
				.isEq( "slug", arguments.category )
				.get();
		}

		// Return or Create
		if ( isNull( oTargetCategory ) ) {
			var oTargetCategory = save(
				new ( {
					category : arguments.category,
					slug     : arguments.category,
					site     : arguments.site
				} )
			);
		}

		return oTargetCategory;
	}

	/**
	 * Get the total category counts for the entire installation or by site
	 *
	 * @siteID The site to filter on
	 */
	numeric function getTotalCategoryCount( string siteID = "" ){
		return newCriteria()
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.count();
	}

	/**
	 * Save a category in the system
	 *
	 * @category The category object
	 *
	 * @return The saved category
	 *
	 * @throws UniqueCategoryException
	 */
	function save( required category ){
		return super.save( arguments.category );
	}

	/**
	 * Verify an incoming slug is unique or not
	 *
	 * @slug       The slug to search for uniqueness
	 * @categoryId Limit the search to the passed categoryId usually for updates
	 * @siteID     The site to filter on
	 *
	 * @return True if the slug is unique or false if it's already used
	 */
	boolean function isSlugUnique(
		required any slug,
		any categoryID = "",
		string siteID  = ""
	){
		return newCriteria()
			.isEq( "slug", arguments.slug )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.when( len( arguments.categoryID ), function( c ){
				c.ne( "categoryID", categoryID );
			} )
			.count() > 0 ? false : true;
	}

	/**
	 * Create categories via a comma delimited list and return the entities created
	 *
	 * @categories A list or array of categories to create
	 * @site       The site to attach them to, this must be a site object
	 * @isPublic   Create public or private categories
	 */
	array function createCategories(
		required categories,
		required site,
		boolean isPublic = true
	){
		// convert to array
		if ( isSimpleValue( arguments.categories ) ) {
			arguments.categories = listToArray( arguments.categories );
		}

		var allCats = arguments.categories
			// Only create categories that do not exist already
			.filter( function( thisCategory ){
				return newCriteria()
					.isEq( "category", arguments.thisCategory )
					.isEq( "site.siteID", site.getsiteID() )
					.count() == 0;
			} )
			.map( function( thisCategory ){
				return new ( {
					"category" : thisCategory,
					"slug"     : variables.htmlHelper.slugify( thisCategory ),
					"site"     : site,
					"isPublic" : isPublic
				} );
			} );

		// Save all cats
		if ( arrayLen( allCats ) ) {
			saveAll( allCats );
		}

		// return them
		return allCats;
	}

	/**
	 * Inflate categories from a collection via 'category_X' pattern and returns an array of category objects
	 * as its representation. This is done by the content editors to display the categories for selection.
	 *
	 * @return array of categories
	 */
	array function inflateCategories( struct memento ){
		var categories = [];
		// iterate all memento keys
		for ( var key in arguments.memento ) {
			// match our prefix
			if ( findNoCase( "category_", key ) ) {
				// inflate key
				var thisCat = get( arguments.memento[ key ] );
				// validate it
				if ( !isNull( thisCat ) ) {
					arrayAppend( categories, thisCat );
				}
			}
		}
		return categories;
	}

	/**
	 * Delete a category which also removes itself from all many-to-many relationships
	 *
	 * @category The category object to remove from the system
	 */
	boolean function delete( required category ){
		transaction {
			// Remove content relationships
			var aRelatedContent = removeAllRelatedContent( arguments.category );
			// Save the related content
			if ( arrayLen( aRelatedContent ) ) {
				contentService.saveAll( aRelatedContent );
			}
			// Remove it
			super.delete( arguments.category );
			// evict queries
			ormEvictQueries( getQueryCacheRegion() );
		}

		// return results
		return true;
	}

	/*
	 * Remove all content associations from a category and returns all the content objects it was removed from
	 * @category.hint The category object
	 */
	array function removeAllRelatedContent( required category ){
		var aRelatedContent = contentService
			.newCriteria()
			.createAlias( "categories", "c" )
			.isEq( "c.categoryID", arguments.category.getCategoryID() )
			.list();

		// Remove associations
		for ( var thisContent in aRelatedContent ) {
			thisContent.removeCategories( arguments.category );
		}

		return aRelatedContent;
	}

	/**
	 * Get all data prepared for export
	 *
	 * @site The site to export from
	 */
	array function getAllForExport( required site ){
		return findAllWhere( { site : arguments.site } ).map( function( thisItem ){
			return thisItem.getMemento( profile: "export" );
		} );
	}

	/**
	 * Get an array of names of all categories in the system or by site
	 *
	 * @siteId   The site to filter the names from
	 * @isPublic If passed, show by this filter, else all categories
	 */
	array function getAllNames( string siteID = "", boolean isPublic ){
		return newCriteria()
			.withProjections( property: "category" )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.when( !isNull( arguments.isPublic ), function( c ){
				c.isEq( "isPublic", javacast( "Boolean", isPublic ) );
			} )
			.list( sortOrder: "category" );
	}

	/**
	 * Get an array of slugs of all categories in the system
	 *
	 * @siteId   The site to filter the names from
	 * @isPublic If passed, show by this filter, else all categories
	 */
	array function getAllSlugs( string siteID = "", boolean isPublic ){
		return newCriteria()
			.withProjections( property: "slug" )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.when( !isNull( arguments.isPublic ), function( c ){
				c.isEq( "isPublic", javacast( "Boolean", isPublic ) );
			} )
			.list( sortOrder: "slug" );
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
			throw( message = "Cannot import file as the contents is not JSON", type = "InvalidImportFormat" );
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
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		importLog
	){
		var allCategories = [];
		var siteService   = getWireBox().getInstance( "siteService@contentbox" );

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisCategory in arguments.importData ) {
				// Get new or persisted
				var oCategory = this.findBySlug( slug: thisCategory.slug );
				oCategory     = ( isNull( oCategory ) ? new () : oCategory );

				// populate content from data
				getBeanPopulator().populateFromStruct(
					target              : oCategory,
					memento             : thisCategory,
					exclude             : "categoryID",
					composeRelationships: false
				);

				// Link the site
				oCategory.setSite( siteService.getBySlugOrFail( thisCategory.site.slug ) );

				// if new or persisted with override then save.
				if ( !oCategory.isLoaded() ) {
					arguments.importLog.append( "New category imported: #thisCategory.slug#<br>" );
					arrayAppend( allCategories, oCategory );
				} else if ( oCategory.isLoaded() and arguments.override ) {
					arguments.importLog.append( "Persisted category overriden: #thisCategory.slug#<br>" );
					arrayAppend( allCategories, oCategory );
				} else {
					arguments.importLog.append( "Skipping persisted category: #thisCategory.slug#<br>" );
				}
			}
			// end import loop

			// Save them?
			if ( arrayLen( allCategories ) ) {
				saveAll( allCategories );
				arguments.importLog.append( "Saved all imported and overriden categories!" );
			} else {
				arguments.importLog.append(
					"No categories imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end of transaction

		return arguments.importLog.toString();
	}

}
