/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I content category
 */
component
	persistent="true"
	entityname="cbCategory"
	table     ="cb_category"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbCategory"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							DI
	 ********************************************************************* */

	property
		name      ="categoryService"
		inject    ="categoryService@cb"
		persistent="false";
	property
		name      ="pageService"
		inject    ="pageService@cb"
		persistent="false";
	property
		name      ="entryService"
		inject    ="entryService@cb"
		persistent="false";
	property
		name      ="contentStoreService"
		inject    ="contentStoreService@cb"
		persistent="false";

	property
		name      ="cachebox"
		inject    ="cachebox"
		persistent="false";

	property
		name      ="settingService"
		inject    ="settingService@cb"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name   ="category"
		notnull="true"
		length ="200"
		index  ="idx_categoryName";

	property
		name   ="slug"
		notnull="true"
		length ="200"
		index  ="idx_categorySlug";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteId"
		lazy     ="true"
		fetch    ="join";

	/* *********************************************************************
	 **							CALCULATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfContentStore"
		formula="select count(*)
				from cb_contentCategories as contentCategories, cb_contentStore as contentStore, cb_content as content
				where contentCategories.FK_categoryID=id
					and contentCategories.FK_contentID = contentStore.contentID
					and contentStore.contentID = content.id";

	property
		name   ="numberOfEntries"
		formula="select count(*)
				from cb_contentCategories as contentCategories, cb_entry as entry, cb_content as content
				where contentCategories.FK_categoryID=id
					and contentCategories.FK_contentID = entry.contentID
					and entry.contentID = content.id";

	property
		name   ="numberOfPages"
		formula="select count(*)
				from cb_contentCategories as contentCategories, cb_page as page, cb_content as content
				where contentCategories.FK_categoryID=id
					and contentCategories.FK_contentID = page.contentID
					and page.contentID = content.id";

	/* *********************************************************************
	 **							CONSTRAINTS
	 ********************************************************************* */

	this.constraints = {
		"category" : { required : true, size : "1..200" },
		"slug"     : { required : true, size : "1..200" }
	};

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.category                      = "";
		variables.slug                          = "";
		variables.numberOfPublishedPages        = "";
		variables.numberOfPublishedEntries      = "";
		variables.numberOfPublishedContentStore = "";

		return this;
	}

	/**
	 * Helper to get the count of published pages for this category.
	 */
	numeric function getNumberOfPublishedPages(){
		// Caching per load basis
		if ( !len( variables.numberOfPublishedPages ) ) {
			variables.numberOfPublishedPages = getNumberOfPublishedContent( variables.pageService );
		}
		return variables.numberOfPublishedPages;
	}

	/**
	 * Helper to get the count of published content store for this category.
	 */
	numeric function getNumberOfPublishedContentStore(){
		// Caching per load basis
		if ( !len( variables.numberOfPublishedContentStore ) ) {
			variables.numberOfPublishedContentStore = getNumberOfPublishedContent(
				variables.contentStoreService
			);
		}
		return variables.numberOfPublishedContentStore;
	}

	/**
	 * Helper to get the count of published entries for this category.
	 */
	numeric function getNumberOfPublishedEntries(){
		// Caching per load basis
		if ( !len( variables.numberOfPublishedEntries ) ) {
			variables.numberOfPublishedEntries = getNumberOfPublishedContent(
				variables.entryService
			);
		}
		return variables.numberOfPublishedEntries;
	}

	/**
	 * Get memento representation
	 *
	 * @excludes properties to exclude
	 */
	struct function getMemento( excludes = "" ){
		var pList = listToArray(
			"category,slug,numberOfPages,numberOfEntries,numberOfContentStore"
		);
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		// Site Snapshot
		result[ "site" ] = {};
		if ( hasSite() ) {
			result.site[ "id" ] = getSite().getId();
			result.site[ "name" ]   = getSite().getName();
			result.site[ "slug" ]   = getSite().getSlug();
		}

		return result;
	}

	/********************************** PRIVATE **********************************/

	/**
	 * Get the number of published content by category and service type
	 *
	 * @service The target service to use.
	 */
	private numeric function getNumberOfPublishedContent( required service ){
		return variables.cacheBox
			.getCache( variables.settingService.getSetting( "cb_content_cacheName" ) )
			.getOrSet( "cb-content-category-counts-#getSlug()#", function(){
				return service
					.newCriteria()
					.createAlias( "categories", "categories" )
					.isEq( "categories.id", getId() )
					.isTrue( "isPublished" )
					.isLE( "publishedDate", now() )
					.isEq( "passwordProtection", "" )
					.$or(
						service.getRestrictions().isNull( "expireDate" ),
						service.getRestrictions().isGT( "expireDate", now() )
					)
					.cache( true )
					.count( "id" );
			} );
	}

}
