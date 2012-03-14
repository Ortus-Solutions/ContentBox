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
* A generic content service for content objects
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{

	// DI
	property name="settingService"		inject="id:settingService@cb";
	property name="cacheBox"			inject="cachebox";
	property name="log"					inject="logbox:logger:{this}";

	/**
	* Constructor
	*/
	ContentService function init(entityName="cbContent"){
		// init it
		super.init(entityName=arguments.entityName,useQueryCaching=true);

		return this;
	}

	/**
	* Clear all content caches
	* @async.hint Run it asynchronously or not, defaults to false
	*/
	function clearAllCaches(boolean async=false){
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
	function clearAllPageWrapperCaches(boolean async=false){
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		cache.clearByKeySnippet(keySnippet="cb-content-pagewrapper",async=arguments.async);
		return this;
	}

	/**
	* Clear all page wrapper caches
	* @slug.hint The slug partial to clean on
	* @async.hint Run it asynchronously or not, defaults to false
	*/
	function clearPageWrapperCaches(required string slug, boolean async=false){
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		cache.clearByKeySnippet(keySnippet="cb-content-pagewrapper-#arguments.slug#",async=arguments.async);
		return this;
	}

	/**
	* Clear a page wrapper cache
	* @slug.hint The slug to clean
	* @async.hint Run it asynchronously or not, defaults to false
	*/
	function clearPageWrapper(required string slug, boolean async=false){
		var settings = settingService.getAllSettings(asStruct=true);
		// Get appropriate cache provider
		var cache = cacheBox.getCache( settings.cb_content_cacheName );
		cache.clear("cb-content-pagewrapper-#arguments.slug#/");
		return this;
	}

	/**
	* Searches published content with cool paramters, remember published content only
	* @searchTerm.hint The search term to search
	* @max.hint The maximum number of records to paginate
	* @offset.hint The offset in the pagination
	* @asQuery.hint Return as query or array of objects, defaults to array of objects
	*/
	function searchContent(searchTerm="",max=0,offset=0,asQuery=false){
		var results = {};
		var c = newCriteria();

		// only published content
		c.isTrue("isPublished")
			.isLt("publishedDate", now() )
			.$or( c.restrictions.isNull("expireDate"), c.restrictions.isGT("expireDate", now() ) )
			.isEq("passwordProtection","");

		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.createAlias("activeContent","ac");
			c.or( c.restrictions.like("title","%#arguments.searchTerm#%"),
				  c.restrictions.like("ac.content", "%#arguments.searchTerm#%") );
		}

		// run criteria query and projections count
		results.count 	= c.count();
		results.content = c.list(offset=arguments.offset,max=arguments.max,sortOrder="publishedDate DESC",asQuery=arguments.asQuery);

		return results;
	}

	/**
	* Get an id from a slug of a content object
	* @slug.hint The slug to search an ID for.
	*/
	string function getIDBySlug(required slug){
		var results = newCriteria()
			.isEq("slug", arguments.slug)
			.withProjections(property="contentID")
			.get();
		// verify results
		if( isNull( results ) ){ return "";}
		return results;
	}

	/**
	* Find a published content object by slug and published unpublished flags
	* @slug.hint The slug to search
	* @showUnpublished.hint To also show unpublished content, defaults to false.
	*/
	function findBySlug(required slug, required showUnpublished=false){
		var c = newCriteria();
		// Override usually for admins
		if (!showUnpublished){
			c.isTrue("isPublished")
				.isLT("publishedDate", now())
				.$or( c.restrictions.isNull("expireDate"), c.restrictions.isGT("expireDate", now() ) );
		}
		// By criteria now
		var content = c.isEq("slug",arguments.slug).get();

		// if not found, send and empty one
		if( isNull(content) ){ return new(); }

		return content;
	}

	/**
	* Delete a content object safely via hierarchies
	* @content.hint the Content object to delete
	*/
	ContentService function deleteContent(required content){
		// Check for dis-associations
		if( arguments.content.hasParent() ){
			arguments.content.getParent().removeChild( arguments.content );
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
	function findPublishedContent(max=0,offset=0,searchTerm="",category="",asQuery=false,parent,boolean showInMenu){
		var results = {};
		var c = newCriteria();
		// sorting
		var sortOrder = "publishedDate DESC";

		// only published pages
		c.isTrue("isPublished")
			.isLT("publishedDate", Now())
			.$or( c.restrictions.isNull("expireDate"), c.restrictions.isGT("expireDate", now() ) )
			// only non-password pages
			.isEq("passwordProtection","");

		// Show only pages with showInMenu criteria?
		if( structKeyExists(arguments,"showInMenu") ){
			c.isTrue("showInMenu");
		}

		// Category Filter
		if( len(arguments.category) ){
			// create association with categories by slug.
			c.createAlias("categories","cats").isEq("cats.slug",arguments.category);
		}

		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.createAlias("activeContent","ac");
			c.or( c.restrictions.like("title","%#arguments.searchTerm#%"),
				  c.restrictions.isEq("ac.content", "%#arguments.searchTerm#%") );
		}

		// parent filter
		if( structKeyExists(arguments,"parent") ){
			if( len( trim(arguments.parent) ) ){
				c.eq("parent.contentID", javaCast("int",arguments.parent) );
			}
			else{
				c.isNull("parent");
			}
			sortOrder = "order asc";
		}

		// run criteria query and projections count
		results.count 	= c.count();
		results.content = c.list(offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=arguments.asQuery);

		return results;
	}

}