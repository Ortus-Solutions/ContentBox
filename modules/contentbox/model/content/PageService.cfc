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
* Page service for contentbox
*/
component extends="ContentService" singleton{

	/**
	* Constructor
	*/
	PageService function init(){
		// init it
		super.init(entityName="cbPage", useQueryCaching=true);

		return this;
	}

	/**
	* Save a page and do necessary updates
	* @page.hint The page to save or update
	* @originalSlug.hint If an original slug is passed, then we need to update hierarchy slugs.
	*/
	function savePage(required page, string originalSlug="") transactional{
		var c = newCriteria();

		// Prepare for slug uniqueness
		c.eq("slug", arguments.page.getSlug() );
		if( arguments.page.isLoaded() ){ c.ne("contentID", arguments.page.getContentID() ); }

		// Verify uniqueness of slug
		if( c.count() GT 0){
			// make slug unique
			arguments.page.setSlug( arguments.page.getSlug() & "-#left(hash(now()),5)#" );
		}
		// Save the target page
		save(entity=arguments.page,transactional=false);

		// Update all affected child pages if any on slug updates, much like nested set updates its nodes, we update our slugs
		if( structKeyExists(arguments, "originalSlug") AND len(arguments.originalSlug) ){
			var pagesInNeed = newCriteria().like("slug","#arguments.originalSlug#/%").list();
			for(var thisPage in pagesInNeed){
				thisPage.setSlug( replaceNoCase(thisPage.getSlug(), arguments.originalSlug, arguments.page.getSlug()) );
				save(entity=thisPage,transactional=false);
			}
		}

		return this;
	}

	/**
	* page search returns struct with keys [pages,count]
	*/
	struct function search(search="",isPublished,author,parent,category,max=0,offset=0,sortOrder="title asc"){
		var results = {};
		// criteria queries
		var c = newCriteria();

		// isPublished filter
		if( structKeyExists(arguments,"isPublished") AND arguments.isPublished NEQ "any"){
			c.eq("isPublished", javaCast("boolean",arguments.isPublished));
		}
		// Author Filter
		if( structKeyExists(arguments,"author") AND arguments.author NEQ "all"){
			c.createAlias("activeContent","ac")
				.isEq("ac.author.authorID", javaCast("int",arguments.author) );
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
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			c.createAlias("activeContent","ac");
			c.or( c.restrictions.like("title","%#arguments.search#%"),
				  c.restrictions.isEq("ac.content", "%#arguments.search#%") );
		}

		// run criteria query and projections count
		results.count 	= c.count();
		results.pages 	= c.list(offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=false);
		return results;
	}

	// Page listing for UI
	function findPublishedPages(max=0,offset=0,searchTerm="",category="",asQuery=false,parent,boolean showInMenu){
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
		results.pages 	= c.list(offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=arguments.asQuery);

		return results;
	}

}