/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Category service for contentbox
*/
component extends="cborm.models.VirtualEntityService" singleton{

	// Dependencies
	property name="htmlHelper" 		inject="HTMLHelper@coldbox";
	property name="populator"  		inject="wirebox:populator";
	property name="contentService"	inject="contentService@cb";
	property name="dateUtil"		inject="DateUtil@cb";
	
	/**
	* Constructor
	*/
	CategoryService function init(){
		// init it
		super.init(entityName="cbCategory",useQueryCaching=true);

		return this;
	}

	/**
	* Create categories via a comma delimited list and return the entities created
	*/
	array function createCategories(categories){
		var allCats = [];

		// convert to array
		if( isSimpleValue(arguments.categories) ){
			arguments.categories = listToArray( arguments.categories );
		}

		// iterate and create
		for(var x=1; x lte arrayLen(arguments.categories); x++){
			var thisCat 	= trim(arguments.categories[ x ]);
			var properties 	= {category=thisCat, slug=htmlHelper.slugify( thisCat )};
			// check that category doesn't exist already
			var extantCategory = findWhere( criteria = properties );
			// if no match is found, add to array
			if( isNull( extantCategory ) ) {
				// append to array all new categories populate with sent cat and slug
				arrayAppend( allCats, new(properties=properties) );
			}
		}

		// Save all cats
		if( arrayLen(allCats) ){
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
		var c = newCriteria();
		
		return c.withProjections( property="categoryID,category,slug,createdDate,modifiedDate,isDeleted" )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list(sortOrder="category" );
			 
	}

	/**
	* Get an array of names of all categories in the system
	*/
	array function getAllNames(){
		var c = newCriteria();
		
		return c.withProjections( property="category" )
			//.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder="category" );
	}
	
	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile(required importFile, boolean override=false){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );
		
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
			oCategory = ( isNull( oCategory) ? new() : oCategory );
			
			// date cleanups, just in case.
			var badDateRegex  	= " -\d{4}$";
			thisCategory.createdDate 	= reReplace( thisCategory.createdDate, badDateRegex, "" );
			thisCategory.modifiedDate 	= reReplace( thisCategory.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisCategory.createdDate 	= dateUtil.epochToLocal( thisCategory.createdDate );
			thisCategory.modifiedDate 	= dateUtil.epochToLocal( thisCategory.modifiedDate );

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