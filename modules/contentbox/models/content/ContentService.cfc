/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* A generic content service for content objects
*/
component extends="cborm.models.VirtualEntityService" singleton{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="cacheBox"				inject="cachebox";
	property name="log"						inject="logbox:logger:{this}";
	property name="customFieldService" 	 	inject="customFieldService@cb";
	property name="categoryService" 	 	inject="categoryService@cb";
	property name="commentService" 	 		inject="commentService@cb";
	property name="contentVersionService"	inject="contentVersionService@cb";
	property name="authorService"			inject="authorService@cb";
	property name="contentStoreService"		inject="contentStoreService@cb";
	property name="pageService"				inject="pageService@cb";
	property name="entryService"			inject="entryService@cb";
	property name="populator"				inject="wirebox:populator";
	property name="systemUtil"				inject="SystemUtil@cb";
	property name="statsService"			inject="statsService@cb";

	/**
	* Constructor
	* @entityName.hint The content entity name to bind this service to.
	*/
	ContentService function init(entityName="cbContent" ){
		// init it
		super.init(entityName=arguments.entityName, useQueryCaching=true);

		return this;
	}

	/**
	* Clear all content caches
	* @async.hint Run it asynchronously or not, defaults to false
	*/
	function clearAllCaches( boolean async=false ){
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		cache.clearByKeySnippet(keySnippet="cb-content",async=arguments.async);
		return this;
	}

	/**
	* Clear all page wrapper caches
	* @async.hint Run it asynchronously or not, defaults to false
	*/
	function clearAllPageWrapperCaches( boolean async=false ){
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		cache.clearByKeySnippet(keySnippet="cb-content-wrapper",async=arguments.async);
		return this;
	}

	/**
	* Clear all page wrapper caches
	* @slug.hint The slug partial to clean on
	* @async.hint Run it asynchronously or not, defaults to false
	*/
	function clearPageWrapperCaches( required any slug, boolean async=false ){
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		cache.clearByKeySnippet(keySnippet="cb-content-wrapper-#cgi.http_host#-#arguments.slug#",async=arguments.async);
		return this;
	}

	/**
	* Clear a page wrapper cache
	* @slug.hint The slug to clean
	* @async.hint Run it asynchronously or not, defaults to false
	*/
	function clearPageWrapper( required any slug, boolean async=false ){
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		cache.clear( "cb-content-wrapper-#cgi.http_host#-#arguments.slug#/" );
		return this;
	}

	/**
	* Searches published content with cool paramters, remember published content only
	* @searchTerm.hint The search term to search
	* @max.hint The maximum number of records to paginate
	* @offset.hint The offset in the pagination
	* @asQuery.hint Return as query or array of objects, defaults to array of objects
	* @sortOrder.hint The sorting of the search results, defaults to publishedDate DESC
	* @isPublished.hint Search for published, non-published or both content objects [true, false, 'all']
	* @searchActiveContent.hint Search only content titles or both title and active content. Defaults to both.
	* @contentTypes.hint Limit search to list of content types (comma-delimited). Leave blank to search all content types
	* @excludeIDs.hint List of IDs to exclude from search
	* @showInSearch.hint If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	*/
	function searchContent(
		any searchTerm="",
		numeric max=0,
		numeric offset=0,
		boolean asQuery=false,
		any sortOrder="publishedDate DESC",
		any isPublished=true,
		boolean searchActiveContent=true,
		string contentTypes="",
		any excludeIDs="",
		boolean showInSearch=false
	){

		var results = {};
		var c = newCriteria();

		// only published content
		if( isBoolean( arguments.isPublished ) ){
			// Published bit
			c.isEq( "isPublished", javaCast( "Boolean", arguments.isPublished ) );
			// Published eq true evaluate other params
			if( arguments.isPublished ){
				c.isLt( "publishedDate", now() )
				.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
				.isEq( "passwordProtection","" );
			}
		}

		// only search shownInSearch bits
		if( arguments.showInSearch ){
			c.isTrue( "showInSearch" );
		}

		// Search Criteria
		if( len( arguments.searchTerm ) ){
			// like disjunctions
			c.createAlias( "activeContent","ac" );
			// Do we search title and active content or just title?
			if( arguments.searchActiveContent ){
				c.$or( c.restrictions.like( "title","%#arguments.searchTerm#%" ),
				  	  c.restrictions.like( "ac.content", "%#arguments.searchTerm#%" ) );
			}
			else{
				c.like( "title", "%#arguments.searchTerm#%" );
			}
		}
		// Content Types
		if( len( arguments.contentTypes ) ) {
			c.isIn( 'contentType', arguments.contentTypes );
		}
		// excludeIDs
		if( len( arguments.excludeIDs ) ) {
			// if not an array, inflate list
			if( !isArray( arguments.excludeIDs ) ) {
				arguments.excludeIDs = listToArray( arguments.excludeIDs );
			}
			c.isNot( c.restrictions.in( 'contentID', JavaCast( "java.lang.Integer[]", arguments.excludeIDs ) ) );
		}

		// run criteria query and projections count
		results.count = c.count( "contentID" );
		results.content = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list(offset=arguments.offset, max=arguments.max, sortOrder=arguments.sortOrder, asQuery=arguments.asQuery);

		return results;
	}

	/**
	* Get an id from a slug of a content object
	* @slug.hint The slug to search an ID for.
	*/
	function getIDBySlug(required any slug){
		var results = newCriteria()
			.isEq( "slug", arguments.slug)
			.withProjections(property="contentID" )
			.get();
		// verify results
		if( isNull( results ) ){ return "";}
		return results;
	}

	/**
	* Find a published content object by slug and published unpublished flags, if not found it returns
	* a new content object
	* @slug.hint The slug to search
	* @showUnpublished.hint To also show unpublished content, defaults to false.
	*/
	function findBySlug(required any slug, required boolean showUnpublished=false){
		var c = newCriteria();
		// Override usually for admins
		if( !showUnpublished ){
			c.isTrue( "isPublished" )
				.isLT( "publishedDate", now())
				.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) );
		}
		// By criteria now
		var content = c.isEq( "slug",arguments.slug).get();
		// return accordingly
		return ( isNull( content ) ? new() : content );
	}

	/**
	* Verify an incoming slug is unique or not
	* @slug.hint The slug to search for uniqueness
	* @contentID.hint Limit the search to the passed contentID usually for updates
	*/
	function isSlugUnique(required any slug, any contentID="" ){
		var c = newCriteria()
			.isEq( "slug", arguments.slug );

		if( len( arguments.contentID ) ){
			c.ne( "contentID", javaCast( "int", arguments.contentID ) );
		}

		return ( c.count() gt 0 ? false : true );
	}

	/**
	* Delete a content object safely via hierarchies
	* @content.hint the Content object to delete
	*/
	ContentService function deleteContent(required any content){
		// Check for dis-associations
		if( arguments.content.hasParent() ){
			arguments.content.getParent().removeChild( arguments.content );
		}
		if( arguments.content.hasCategories() ){
			arguments.content.removeAllCategories();
		}
		if( arguments.content.hasRelatedContent() ) {
			arguments.content.getRelatedContent().clear();
		}
		if( arguments.content.hasLinkedContent() ) {
			arguments.content.removeAllLinkedContent();
		}
		if( arguments.content.hasStats() ){
			delete( arguments.content.getStats() );
		}
		// now delete it
		delete( arguments.content );

		// return service
		return this;
	}

	/**
	* Find published content objects
	* @max.hint The maximum number of records to paginate
	* @offset.hint The offset in the pagination
	* @searchTerm.hint The search term to search
	* @category.hint The category to filter the content on
	* @asQuery.hint Return as query or array of objects, defaults to array of objects
	* @parent.hint The parent ID to filter on or not
	* @showInMenu.hint Whether to filter with the show in menu bit or not
	*/
	function findPublishedContent(
		numeric max=0,
		numeric offset=0,
		any searchTerm="",
		any category="",
		boolean asQuery=false,
		any parent,
		boolean showInMenu){

		var results = {};
		var c = newCriteria();
		// sorting
		var sortOrder = "publishedDate DESC";

		// only published pages
		c.isTrue( "isPublished" )
			.isLT( "publishedDate", Now())
			.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
			// only non-password pages
			.isEq( "passwordProtection","" );

		// Show only pages with showInMenu criteria?
		if( structKeyExists(arguments,"showInMenu" ) ){
			c.isEq( "showInMenu", javaCast( "boolean", arguments.showInMenu ) );
		}

		// Category Filter
		if( len(arguments.category) ){
			// create association with categories by slug.
			c.createAlias( "categories","cats" ).isIn( "cats.slug", listToArray( arguments.category ) );
		}

		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.createAlias( "activeContent","ac" );
			c.or( c.restrictions.like( "title","%#arguments.searchTerm#%" ),
				  c.restrictions.isEq( "ac.content", "%#arguments.searchTerm#%" ) );
		}

		// parent filter
		if( structKeyExists(arguments,"parent" ) ){
			if( len( trim( arguments.parent ) ) ){
				c.eq( "parent.contentID", javaCast( "int", arguments.parent ) );
			} else {
				c.isNull( "parent" );
			}
		}

		// run criteria query and projections count
		results.count 	= c.count( "contentID" );
		results.content = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list( offset=arguments.offset, max=arguments.max, sortOrder=sortOrder, asQuery=arguments.asQuery );

		return results;
	}

	/**
	* Bulk Publish Status Updates
	* @contentID.hint The list or array of ID's to bulk update
	* @status.hint The status either 'publish' or 'draft'
	*/
	any function bulkPublishStatus(required any contentID, required any status){
		var publish = false;

		// publish flag
		if( arguments.status eq "publish" ){
			publish = true;
		}

		// Get all by id
		var contentObjects = getAll(id=arguments.contentID);
		for(var x=1; x lte arrayLen( contentObjects ); x++){
			contentObjects[ x ].setpublishedDate( now() );
			contentObjects[ x ].setisPublished( publish );
		}

		// transaction the save of all the content objects
		saveAll( contentObjects );

		return this;
	}

	/**
	* Get the top visited content entries
	* @max.hint The maximum to retrieve, defaults to 5 entries
	*/
	array function getTopVisitedContent( numeric max=5 ){
		var c = newCriteria()
			.list( max=arguments.max, sortOrder="numberOfHits desc", asQuery=false );
		return c;
	}

	/**
	* Get the top commented content entries
	* @max.hint The maximum to retrieve, defaults to 5 entries
	*/
	array function getTopCommentedContent( numeric max=5 ){
		var c = newCriteria()
			.list( max=arguments.max, sortOrder="numberOfComments desc", asQuery=false );
		return c;
	}

	/**
	* Get all content for export as flat data
	* @inData.hint The data to use for exporting, usually concrete implementtions can override this.
	*/
	array function getAllForExport(any inData){
		var result = [];

		if( !structKeyExists( arguments, "inData" ) ){
			// export from the root node, instead of everything.
			var data = newCriteria().isNull( "parent" ).list();
		}
		else{
			data = arguments.inData;
		}

		for( var thisItem in data ){
			arrayAppend( result, thisItem.getMemento() );
		}

		return result;
	}

	/**
	* Import data from a ContentBox JSON file. Returns the import log
	* @importFile.hint The absolute file path to use for importing
	* @override.hint Override records or not
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
	* Import data from an array of structures of content or just one structure of a content entry
	* @importData.hint The data to import
	* @override.hint Override records or not
	* @importLog.hint The import log buffer
	*/
	string function importFromData(
		required any importData,
		boolean override=false,
		required any importLog){

		var allContent = [];

		// if struct, inflate into an array
		if( isStruct( arguments.importData ) ){
			arguments.importData = [ arguments.importData ];
		}

		// iterate and import
		for( var thisContent in arguments.importData ){

			// Inflate content from data
			var inflateResults = inflateFromStruct( thisContent, arguments.importLog );

			// continue to next record if author not found
			if( !inflateResults.authorFound ){ continue; }

			// if new or persisted with override then save.
			if( !inflateResults.content.isLoaded() ){
				arguments.importLog.append( "New content imported: #thisContent.slug#<br>" );
				arrayAppend( allContent, inflateResults.content );
			}
			else if( inflateResults.content.isLoaded() and arguments.override ){
				arguments.importLog.append( "Persisted content overriden: #thisContent.slug#<br>" );
				arrayAppend( allContent, inflateResults.content );
			}
			else{
				arguments.importLog.append( "Skipping persisted content: #thisContent.slug#<br>" );
			}

		} // end import loop

		// Save content
		if( arrayLen( allContent ) ){
			saveAll( allContent );
			arguments.importLog.append( "Saved all imported and overriden content!" );
		}
		else{
			arguments.importLog.append( "No content imported as none where found or able to be overriden from the import file." );
		}

		return arguments.importLog.toString();
	}

	/**
	* Inflate a content object from a ContentBox JSON structure
	* @contentData.hint The content structure inflated from JSON
	* @importLog.hint The string builder import log
	* @parent.hint If the inflated content object has a parent then it can be linked directly, no inflating necessary. Usually for recursions
	* @newContent.hint Map of new content by slug; useful for avoiding new content collisions with recusive relationships
	*/
	public function inflateFromStruct(
		required any contentData,
		required any importLog,
		any parent,
		struct newContent={} ){

		// setup
		var thisContent 	= arguments.contentData;
		var badDateRegex  = " -\d{4}$";
		// Get content by slug, if not found then it returns a new entity so we can persist it.
		var oContent = findBySlug( slug=thisContent.slug, showUnpublished=true );
		// add to newContent map so we can avoid slug collisions in recursive relationships
		newContent[ thisContent.slug ] = oContent;
		// date conversion tests
		thisContent.publishedDate 	= reReplace( thisContent.publishedDate, badDateRegex, "" );
		thisContent.createdDate 	= reReplace( thisContent.createdDate, badDateRegex, "" );
		if( len( thisContent.expireDate ) ){
			thisContent.expireDate = reReplace( thisContent.expireDate, badDateRegex, "" );
		}

		// populate content from data and ignore relationships, we need to build those manually.
		populator.populateFromStruct( target=oContent,
									  memento=thisContent,
									  exclude="creator,parent,children,categories,customfields,contentversions,comments",
									  composeRelationships=false,
									  nullEmptyInclude="publishedDate,expireDate" );

		// determine author else ignore import
		var oAuthor = authorService.findByUsername( ( structKeyExists( thisContent.creator, "username" ) ? thisContent.creator.username : "" ) );
		if( !isNull( oAuthor ) ){

			// AUTHOR CREATOR
			oContent.setCreator( oAuthor );
			arguments.importLog.append( "Content author found and linked: #thisContent.slug#<br>" );

			// PARENT
			if( structKeyExists( arguments, "parent" ) and isObject( arguments.parent ) ){
				oContent.setParent( arguments.parent );
				arguments.importLog.append( "Content parent passed and linked: #arguments.parent.getSlug()#<br>" );
			}
			else if( isStruct( thisContent.parent ) and structCount( thisContent.parent ) ){
				var oParent = findBySlug( slug=thisContent.parent.slug, showUnpublished=true );
				// assign if persisted
				if( oParent.isLoaded() ){
					oContent.setParent( oParent );
					arguments.importLog.append( "Content parent found and linked: #thisContent.parent.slug#<br>" );
				}
				else{
					arguments.importLog.append( "Content parent slug: #thisContent.parent.toString()# was not found so not assigned!<br>" );
				}
			}

			// CHILDREN
			if( arrayLen( thisContent.children ) ){
				var allChildren = [];
				// recurse on them and inflate hiearchy
				for( var thisChild in thisContent.children ){
					var inflateResults = inflateFromStruct( contentData=thisChild, importLog=arguments.importLog, parent=oContent );
					// continue to next record if author not found
					if( !inflateResults.authorFound ){ continue; }
					// Add to array of children to add.
					arrayAppend( allChildren, inflateResults.content );
				}
				oContent.setChildren( allChildren );
			}

			// CUSTOM FIELDS
			if( arrayLen( thisContent.customfields ) ){
				// wipe out custom fileds if they exist
				if( oContent.hasCustomField() ){ oContent.getCustomFields().clear(); }
				// add new custom fields
				for( var thisCF in thisContent.customfields ){
					// explicitly convert value to string...
					// ACF doesn't handle string values well when they look like numbers :)
					var args = { key = thisCF.key, value = toString( thisCF.value ) };
					var oField = customFieldService.new(properties=args);
					oField.setRelatedContent( oContent );
					oContent.addCustomField( oField );
				}
			}

			// CATEGORIES
			if( arrayLen( thisContent.categories ) ){
				// Create categories that don't exist first
				var allCategories = [];
				for( var thisCategory in thisContent.categories ){
					var oCategory = categoryService.findBySlug( thisCategory.slug );
					oCategory = ( isNull( oCategory ) ? populator.populateFromStruct( target=categoryService.new(), memento=thisCategory, exclude="categoryID" ) : oCategory );
					// save category if new only
					if( !oCategory.isLoaded() ){ categoryService.save( entity=oCategory ); }
					// append to add.
					arrayAppend( allCategories, oCategory );
				}
				// detach categories and re-attach
				oContent.setCategories( allCategories );
			}

			// RELATED CONTENT
			if( arrayLen( thisContent.relatedContent ) ) {
				var allRelatedContent = [];
				for( var thisRelatedContent in thisContent.relatedContent ) {
					var instanceService = "";
					switch( thisRelatedContent.contentType ) {
						case "Page":
							instanceService = PageService;
							break;
						case "Entry":
							instanceService = EntryService;
							break;
						case "ContentStore":
							instanceService = ContentStoreService;
							break;
					}
					// if content has already been inflated as part of another process, just use that instance so we don't collide keys
					if( structKeyExists( arguments.newContent, thisRelatedContent.slug ) ) {
						arrayAppend( allRelatedContent, arguments.newContent[ thisRelatedContent.slug ] );
					}
					// otherwise, we need to inflate the new instance
					else {
						var inflateResults = instanceService.inflateFromStruct(
							contentData = thisRelatedContent,
							importLog=arguments.importLog,
							newContent=newContent
						);
						arrayAppend( allRelatedContent, inflateResults.content );
					}

				}
				oContent.setRelatedContent( allRelatedContent );
			}

			// COMMENTS
			if( arrayLen( thisContent.comments ) ){
				var allComments = [];
				for( var thisComment in thisContent.comments ){
					// some conversions
					thisComment.createdDate = reReplace( thisComment.createdDate, badDateRegex, "" );
					// population
					var oComment = populator.populateFromStruct( target=commentService.new(),
															 	 memento=thisComment,
															 	 exclude="commentID",
															 	 composeRelationships=false );
					oComment.setRelatedContent( oContent );
					arrayAppend( allComments, oComment );
				}
				oContent.setComments( allComments );
			}

			// CONTENT VERSIONS
			if( arrayLen( thisContent.contentversions ) ){
				var allContentVersions = [];
				for( var thisVersion in thisContent.contentversions ){
					// some conversions
					thisVersion.createdDate = reReplace( thisVersion.createdDate, badDateRegex, "" );

					// population
					var oVersion = populator.populateFromStruct( target=contentVersionService.new(),
																 memento=thisVersion,
																 exclude="contentVersionID,author",
																 composeRelationships=false );
					// Get author
					var oAuthor = authorService.findByUsername( thisVersion.author.username );
					// Only add if author found
					if( !isNull( oAuthor ) ){
						oVersion.setAuthor( oAuthor );
						oVersion.setRelatedContent( oContent );
						arrayAppend( allContentVersions, oVersion );
					}
					else{
						arguments.importLog.append( "Skipping importing version content #thisVersion.version# as author (#thisVersion.author.toString()#) not found!<br>" );
					}
				}
				oContent.setContentVersions( allContentVersions );
			}
		} // end if author found
		else{
			arguments.importLog.append( "Content author not found (#thisContent.creator.toString()#) skipping: #thisContent.slug#<br>" );
		}

		return { content=oContent, authorFound=( !isNull( oAuthor ) ) };
	}

	/**
	* Update a content's hits with some async flava
	* @contentID.hint The content id to update
	* @async.hint Async or not
	*/
	ContentService function updateHits(required contentID, boolean async=true){
		// if in thread already or not async
		if( systemUtil.inThread() OR !arguments.async ){
			statsService.syncUpdateHits( arguments.contentID );
			return this;
		}

		var threadName = "updateHits_#hash( arguments.contentID & now() )#";
		thread name="#threadName#" contentID="#arguments.contentID#"{
			statsService.syncUpdateHits( attributes.contentID );
		}

		return this;
	}

	/**
	* Returns an array of slugs of all the content objects in the system.
	*/
	array function getAllFlatSlugs(){
		var c = newCriteria();

		return c.withProjections( property="slug" )
			.list( sortOrder="slug asc" );
	}

	/**
	* Returns an array of [contentID, title, slug] structures of all the content in the system
	*/
	array function getAllFlatContent(){
		var c = newCriteria();

		return c.withProjections( property="contentID,title,slug" )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder="slug asc" );
	}

/********************************************* PRIVATE *********************************************/

	/**
	* Get a unique slug hash
	* @slug.hint The slug to unique it
	*/
	private function getUniqueSlugHash( required string slug ){
		return "#arguments.slug#-#lcase( left( hash( now() ), 5 ) )#";
	}

}