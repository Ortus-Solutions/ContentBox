/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Custom HTML service for ContentBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	// Dependencies
	property name="htmlHelper" 		inject="coldbox:plugin:HTMLHelper";
	property name="populator"  		inject="wirebox:populator";
	property name="authorService"	inject="id:authorService@cb";
	
	/**
	* Constructor
	*/
	CustomHTMLService function init(){
		// init it
		super.init(entityName="cbCustomHTML");
		
		return this;
	}
	
	/**
	* Save a custom HTML snippet
	*/
	function saveCustomHTML(required customHTML){
		var c = newCriteria();
		
		// Prepare for slug uniqueness
		c.eq("slug", arguments.customHTML.getSlug() );
		if( arguments.customHTML.isLoaded() ){ c.ne("contentID", arguments.customHTML.getContentID() ); }
		
		// Verify uniqueness of slug
		if( c.count() GT 0){
			// make slug unique
			arguments.customHTML.setSlug( arguments.customHTML.getSlug() & "-#left(hash(now()),5)#");
		}
		
		// send to saving.
		save( arguments.customHTML );
	}
	
	/**
	* custom HTML search returns struct with keys [entries,count]
	* @search.hint The search term to search on
	* @max.hint The max records to return
	* @offset.hint The offset in the return of records
	* @sortOrder.hint The sorting required. Title by default
	*/
	struct function search(search="", isPublished, author, max=0, offset=0, sortOrder="title", boolean searchActiveContent=true){
		var results = {};
		// criteria queries
		var c = newCriteria();
		
		// Author Filter
		if( structKeyExists( arguments, "author" ) AND arguments.author NEQ "all"){
			c.isEq("creator.authorID", javaCast( "int", arguments.author ) );
		}
		// Search Criteria
		if( len( arguments.search ) ){
			if( arguments.searchActiveContent ){
				// like disjunctions
				c.or( c.restrictions.like("slug","%#arguments.search#%"),
					  c.restrictions.like("title","%#arguments.search#%"),
					  c.restrictions.like("description","%#arguments.search#%"),
					  c.restrictions.like("content","%#arguments.search#%") );
			}
			else{
				// like disjunctions
				c.or( c.restrictions.like("slug","%#arguments.search#%"),
					  c.restrictions.like("title","%#arguments.search#%"),
					  c.restrictions.like("description","%#arguments.search#%") );
			}
			
		}
		
		// run criteria query and projections count
		results.count 	= c.count( "contentID" );
		results.entries = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list(offset=arguments.offset, max=arguments.max, sortOrder=arguments.sortOrder, asQuery=false);
		
		return results;
	}
	
	/**
	* Retrieve a content piece by slug
	* @slug The unique slug this content is tied to
	*/
	function findBySlug(required slug){
		var html = findWhere({slug=arguments.slug});
		
		if( !isNull(html) ){ return html; }
		
		throw(message="Custom HTML cannot be found using slug: #arguments.slug#",type="ContentBox.CustomHTMLService.NoContentFound");
	}
	
	/**
	* Verify an incoming slug is unique or not
	* @slug.hint The slug to search for uniqueness
	*/
	function isSlugUnique(required slug, contentID=""){
		var c = newCriteria()
			.isEq( "slug", arguments.slug );
		
		if( len( arguments.contentID ) ){
			c.ne( "contentID", javaCast( "int", arguments.contentID ) );
		}

		return ( c.count() gt 0 ? false : true );
	}
	
	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		var result = [];
		var data = getAll();
		
		for( var thisItem in data ){
			arrayAppend( result, thisItem.getMemento() );	
		}
		
		return result;
	}
	
	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile(required importFile, boolean override=false){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject("java", "java.lang.StringBuilder").init("Starting import with override = #arguments.override#...<br>");
		
		if( !isJSON( data ) ){
			throw(message="Cannot import file as the contents is not JSON", type="InvalidImportFormat");
		}
		
		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );
		
	}
	
	/**
	* Import data from an array of structures of customHTML 
	*/
	string function importFromData(required importData, boolean override=false, importLog){
		var allContent = [];
		
		// iterate and import
		for( var thisContent in arguments.importData ){
			var oCustomHTML = this.findBySlug( thisContent.slug );
			oCustomHTML = ( isNull( oCustomHTML) ? new() : oCustomHTML );
			
			// populate content from data
			populator.populateFromStruct( target=oCustomHTML, memento=thisContent, exclude="contentID,creator", composeRelationships=false );
			
			// determine author else ignore
			var oAuthor = authorService.findByUsername( ( structKeyExists( thisContent.creator, "username" ) ? thisContent.creator.username : "" ) );
			if( !isNull( oAuthor ) ){
				oCustomHTML.setCreator( oAuthor );
				importLog.append( "Content author found and linked: #thisContent.slug#<br>" );
			}	
			else{
				importLog.append( "Content author not found (#thisContent.creator.toString()#): #thisContent.slug#<br>" );
			}
			
			// if new or persisted with override then save.
			if( !oCustomHTML.isLoaded() ){
				importLog.append( "New content imported: #thisContent.slug#<br>" );
				arrayAppend( allContent, oCustomHTMl );
			}
			else if( oCustomHTML.isLoaded() and arguments.override ){
				importLog.append( "Persisted content overriden: #thisContent.slug#<br>" );
				arrayAppend( allContent, oCustomHTMl );
			}
			else{
				importLog.append( "Skipping persisted content: #thisContent.slug#<br>" );
			}
		} // end import loop

		// Save them?
		if( arrayLen( allContent ) ){
			saveAll( allContent );
			importLog.append( "Saved all imported and overriden content!" );
		}
		else{
			importLog.append( "No content imported as none where found or able to be overriden from the import file." );
		}
		
		return importLog.toString(); 
	}
}