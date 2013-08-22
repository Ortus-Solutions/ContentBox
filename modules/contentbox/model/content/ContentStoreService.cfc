﻿/**
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
* Entry service for contentbox
*/
component extends="ContentService" singleton{

	/**
	* Constructor
	*/
	ContentStoreService function init(){
		// init it
		super.init(entityName="cbContentStore", useQueryCaching=true);

		return this;
	}

	/**
	* Save content
	* @content.hint The content object
	* @transactional.hint Use a transaction or not.
	*/
	function saveContent(
		any content, 
		boolean transactional=true){
		
		var c = newCriteria();

		// Prepare for slug uniqueness
		c.eq("slug", arguments.content.getSlug() );
		if( arguments.content.isLoaded() ){ c.ne("contentID", arguments.content.getContentID() ); }

		// Verify uniqueness of slug
		if( c.count() GT 0){
			// make slug unique
			arguments.content.setSlug( arguments.content.getSlug() & "-#left(hash(now()),5)#");
		}

		// save entry
		save(entity=arguments.content, transactional=arguments.transactional);
	}

	/**
	* content search returns struct with keys [content,count]
	* @search.hint The search string to search
	* @isPublished.hint Can be 'any', 'true' or 'false'
	* @category.hint one or more categories to search content for 
	* @author.hint The author ID to filter on or use 'any' for all
	* @max.hint The maximum number of records to retrieve
	* @offset.hint Where to start in the pagination
	* @sortOrder.hint The sort ordering to apply to the results
	* @searchActiveContent.hint Whether active content will be searched or not, by default it does
	*/
	struct function search(
		any search="",
		any isPublished,
		any category,
		any author,
		numeric max=0,
		numeric offset=0,
		any sortOrder="publishedDate DESC",
		boolean searchActiveContent=true){

		var results = {};
		// criteria queries
		var c = newCriteria();
		// stub out activeContent alias based on potential conditions...
		// this way, we don't have to worry about accidentally creating it twice, or not creating it at all
		if(
			( structKeyExists(arguments,"author") AND arguments.author NEQ "all" ) ||
			( len(arguments.search) ) ||
			( findNoCase( "modifiedDate", arguments.sortOrder ) )
		) {
			c.createAlias( "activeContent", "ac" );
		}
		// create sort order for aliased property
		if( findNoCase( "modifiedDate", arguments.sortOrder ) ) {
			sortOrder = replaceNoCase( arguments.sortOrder, "modifiedDate", "ac.createdDate" );
		}
		// isPublished filter
		if( structKeyExists(arguments,"isPublished") AND arguments.isPublished NEQ "any"){
			c.eq("isPublished", javaCast("boolean",arguments.isPublished));
		}
		// Author Filter
		if( structKeyExists(arguments,"author") AND arguments.author NEQ "all"){
			c.isEq("ac.author.authorID", javaCast("int",arguments.author) );
		}
		// Search Criteria
		if( len(arguments.search) ){
			// Search with active content
			if( arguments.searchActiveContent ){
				// like disjunctions
				c.or( c.restrictions.like("title","%#arguments.search#%"),
					  c.restrictions.like("slug","%#arguments.search#%"),
					  c.restrictions.like("description","%#arguments.search#%"),
					  c.restrictions.like("ac.content", "%#arguments.search#%") );
			}
			else{
				c.or( c.restrictions.like("title","%#arguments.search#%"),
					  c.restrictions.like("slug","%#arguments.search#%"),
					  c.restrictions.like("description","%#arguments.search#%") );
			}
		}
		// Category Filter
		if( structKeyExists(arguments,"category") AND arguments.category NEQ "all"){
			// Uncategorized?
			if( arguments.category eq "none" ){
				c.isEmpty("categories");
			}
			// With categories
			else{
				// search the association
				c.createAlias("categories","cats")
					.isIn("cats.categoryID", JavaCast("java.lang.Integer[]",[arguments.category]) );
			}
		}

		// run criteria query and projections count
		results.count 	= c.count( "contentID" );
		results.content = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list(offset=arguments.offset,max=arguments.max,sortOrder=arguments.sortOrder,asQuery=false);

		return results;
	}

	/**
	* Entry listing by Date
	* @year.hint The year to search
	* @month.hint The month to search
	* @day.hint The day to search
	* @max.hint The maximum number of records to retrieve
	* @offset.hint Where to start in the pagination
	* @asQuery.hint Return results as query or array of objects. Defaults to false
	*/
	function findPublishedEntriesByDate(
		numeric year=0,
		numeric month=0, 
		numeric day=0,
		numeric max=0,
		numeric offset=0,
		boolean asQuery=false){

		var results = {};
		var hql = "FROM cbEntry
				  WHERE isPublished = true
				    AND passwordProtection = ''
				    AND publishedDate <= :now";
		var params = {};
		params["now"] = now();
		// year lookup mandatory
		if( arguments.year NEQ 0 ){
			params["year"] = arguments.year;
			hql &= " AND YEAR(publishedDate) = :year";
		}
		// month lookup
		if( arguments.month NEQ 0 ){
			params["month"] = arguments.month;
			hql &= " AND MONTH(publishedDate) = :month";
		}
		// day lookup
		if( arguments.day NEQ 0 ){
			params["day"] = arguments.day;
			hql &= " AND DAY(publishedDate) = :day";
		}

		// Get Count
		results.count 	= executeQuery(query="select count(*) #hql#",params=params,max=1,asQuery=false)[1];
		// Add Ordering
		hql &= " ORDER BY publishedDate DESC";
		// find entries
		results.entries = executeQuery(query=hql,params=params,max=arguments.max,offset=arguments.offset,asQuery=arguments.asQuery);

		return results;
	}

	/**
	* Find published entries by filters
	* @max.hint The maximum number of records to retrieve
	* @offset.hint Where to start in the pagination
	* @category.hint One or more categories to filter on
	* @searchTerm.hint The search term to use for search
	* @asQuery.hint Return results as query or array of objects. Defaults to false
	*/
	function findPublishedEntries(
		numeric max=0,
		numeric offset=0,
		any category="",
		any searchTerm="",
		boolean asQuery=false){

		var results = {};
		var c = newCriteria();

		// only published entries
		c.isTrue("isPublished")
			.isLt("publishedDate", now() )
			.$or( c.restrictions.isNull("expireDate"), c.restrictions.isGT("expireDate", now() ) )
			// only non-password protected ones
			.isEq("passwordProtection","");

		// Category Filter
		if( len(arguments.category) ){
			// create association with categories by slug.
			c.createAlias("categories","cats").isIn("cats.slug", listToArray( arguments.category ) );
		}

		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.createAlias("activeContent","ac");
			c.or( c.restrictions.like("title","%#arguments.searchTerm#%"),
				  c.restrictions.like("ac.content", "%#arguments.searchTerm#%") );
		}

		// run criteria query and projections count
		results.count 	= c.count("contentID");
		results.entries = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list(offset=arguments.offset,max=arguments.max,sortOrder="publishedDate DESC",asQuery=arguments.asQuery);

		return results;
	}
	
	/**
	* Get all content for export as flat data
	*/
	array function getAllForExport(){
		return super.getAllForExport( getAll() );
	}
	
}
