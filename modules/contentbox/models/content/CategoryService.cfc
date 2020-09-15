/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Category service for contentbox
 */
component extends="cborm.models.VirtualEntityService" singleton{

	// Dependencies
	property name="htmlHelper"                                inject="HTMLHelper@coldbox";
	property name="populator"                                        inject="wirebox:populator";
	property name="contentService"inject="contentService@cb";
	property name="dateUtil"                                                inject="DateUtil@cb";

	/**
	 * Constructor
	 */
	CategoryService function init(){
		// init it
		super.init( entityName="cbCategory", useQueryCaching=true );

		return this;
	}

	/**
	 * Get the total category counts
	 *
	 * @siteId The site to filter on
	 */
	numeric function getTotalCategoryCount( string siteId = "" ){
		return newCriteria()
			.when( len( arguments.siteId ), function( c ){
				c.isEq( "site.siteId", javaCast( "int", siteId ) );
			} )
			.count();
	}

	/**
	 * Save a category in the system
	 *
	 * @category The category object
	 *
	 * @throws UniqueCategoryException
	 * @return The category sent for saving
	 */
	function save( required category ){
		// Verify uniqueness of slug
		if( !isSlugUnique(
				slug      : arguments.category.getSlug(),
				contentID : arguments.category.getCategoryId(),
				siteId    : arguments.category.getSite().getSiteId()
			)
		){
			// Throw exception
			throw(
				message : "The incoming category #arguments.category.getSlug()# already exists",
				type    : "UniqueCategoryException"
			);
		}

		// Save the category
		return super.save( arguments.category );
	}

	/**
	 * Verify an incoming slug is unique or not
	 *
	 * @slug The slug to search for uniqueness
	 * @categoryId Limit the search to the passed categoryId usually for updates
	 * @siteId The site to filter on
	 *
	 * @return True if the slug is unique or false if it's already used
	 */
	boolean function isSlugUnique( required any slug, any categoryID="", string siteId="" ){
		return newCriteria()
			.isEq( "slug", arguments.slug )
			.when( len( arguments.siteId ), function( c ){
				c.isEq( "site.siteId", javaCast( "int", siteId ) );
			} )
			.when( len( arguments.categoryID ), function( c ){
				c.ne( "categoryID", autoCast( "categoryID", categoryID ) );
			} )
			.count() > 0 ? false : true;
	}

	/**
	 * Create categories via a comma delimited list and return the entities created
	 *
	 * @categories A list or array of categories to create
	 * @site The site to attach them to, this must be a site object
	 */
	array function createCategories( required categories, required site ){
		// convert to array
		if( isSimpleValue( arguments.categories ) ){
			arguments.categories = listToArray( arguments.categories );
		}

		var allCats = arguments.categories
			// Only create categories that do not exist already
			.filter( function( thisCategory ){
				return newCriteria()
					.isEq( "category", arguments.thisCategory )
					.isEq( "site.siteId", javaCast( "int", site.getSiteId() ) )
					.count() == 0;
			})
			.map( function( thisCategory ){
				return new( {
					"category" : thisCategory,
					"slug"     : variables.htmlHelper.slugify( thisCategory ),
					"site"     : site
				} );
			} );

		// Save all cats
		if( arrayLen( allCats ) ){
			saveAll( allCats );
		}

		// return them
		return allCats;
	}

	/**
	 * Inflate categories from a collection via 'category_X' pattern and returns an array of category objects
	 * as its representation
	 *
	 * @return array of categories
	 */
	array function inflateCategories( struct memento ){
		var categories = [];
		// iterate all memento keys
		for( var key in arguments.memento ){
			// match our prefix
			if( findNoCase( "category_", key ) ){
				// inflate key
				var thisCat = get( arguments.memento[key] );
				// validate it
				if( !isNull( thisCat ) ){ arrayAppend( categories, thisCat ); }
			}
		}
		return categories;
	}

	/**
	 * Delete a category which also removes itself from all many-to-many relationships
	 * @category.hint The category object to remove from the system
	 */
	boolean function deleteCategory( required category ){

		transaction{
			// Remove content relationships
			var aRelatedContent = removeAllRelatedContent( arguments.category );
			// Save the related content
			if( arrayLen( aRelatedContent ) ){
				contentService.saveAll( entities=aRelatedContent, transactional=false );
			}
			// Remove it
			delete( entity=arguments.category, transactional=false );
			// evict queries
			ORMEvictQueries( getQueryCacheRegion() );
		}

		// return results
		return true;
	}

	/*
	* Remove all content associations from a category and returns all the content objects it was removed from
	* @category.hint The category object
	*/
	array function removeAllRelatedContent( required category ){
		var aRelatedContent = contentService.newCriteria()
			.createAlias( "categories", "c" )
			.isEq( "c.categoryID", arguments.category.getCategoryID() )
			.list();

		// Remove associations
		for( var thisContent in aRelatedContent ){
			thisContent.removeCategories( arguments.category );
		}

		return aRelatedContent;
	}

	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		return newCriteria()
			.withProjections( property : "categoryID,category,slug,createdDate,modifiedDate,isDeleted,site.siteId:site" )
			.asStruct()
			.list( sortOrder : "category" );

	}

	/**
	 * Get an array of names of all categories in the system
	 */
	array function getAllNames( string siteId="" ){
		return newCriteria()
			.withProjections( property : "category" )
			.when( len( arguments.siteId ), function( c ){
				c.isEq( "site.siteId", javaCast( "int", siteId ) );
			} )
			.list( sortOrder : "category" );
	}

	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile(required importFile, boolean override=false){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );

		if( !isJSON( data ) ){
			throw(message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );
	}

	/**
	* Import data from an array of structures of categories or just one structure of categories
	*/
	string function importFromData(required importData, boolean override=false, importLog){
		var allCategories = [];

		// if struct, inflate into an array
		if( isStruct( arguments.importData ) ){
			arguments.importData = [ arguments.importData ];
		}

		// iterate and import
		for( var thisCategory in arguments.importData ){
			// Get new or persisted
			var oCategory = this.findBySlug( slug=thisCategory.slug);
			oCategory     = ( isNull( oCategory) ? new() : oCategory );

			// date cleanups, just in case.
			var badDateRegex          = " -\d{4}$";
			thisCategory.createdDate  = reReplace( thisCategory.createdDate, badDateRegex, "" );
			thisCategory.modifiedDate = reReplace( thisCategory.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisCategory.createdDate  = dateUtil.epochToLocal( thisCategory.createdDate );
			thisCategory.modifiedDate = dateUtil.epochToLocal( thisCategory.modifiedDate );

			// populate content from data
			populator.populateFromStruct( target=oCategory, memento=thisCategory, exclude="categoryID", composeRelationships=false );

			// if new or persisted with override then save.
			if( !oCategory.isLoaded() ){
				arguments.importLog.append( "New category imported: #thisCategory.slug#<br>" );
				arrayAppend( allCategories, oCategory );
			}
			else if( oCategory.isLoaded() and arguments.override ){
				arguments.importLog.append( "Persisted category overriden: #thisCategory.slug#<br>" );
				arrayAppend( allCategories, oCategory );
			}
			else{
				arguments.importLog.append( "Skipping persisted category: #thisCategory.slug#<br>" );
			}
		} // end import loop

		// Save them?
		if( arrayLen( allCategories ) ){
			saveAll( allCategories );
			arguments.importLog.append( "Saved all imported and overriden categories!" );
		}
		else{
			arguments.importLog.append( "No categories imported as none where found or able to be overriden from the import file." );
		}

		return arguments.importLog.toString();
	}

}