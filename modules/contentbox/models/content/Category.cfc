/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am an awesome content category
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
		inject    ="provider:categoryService@contentbox"
		persistent="false";

	property
		name      ="pageService"
		inject    ="provider:pageService@contentbox"
		persistent="false";

	property
		name      ="entryService"
		inject    ="provider:entryService@contentbox"
		persistent="false";

	property
		name      ="contentStoreService"
		inject    ="provider:contentStoreService@contentbox"
		persistent="false";

	property
		name      ="settingService"
		inject    ="provider:settingService@contentbox"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="categoryID"
		column   ="categoryID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="category"
		column ="category"
		notnull="true"
		length ="200"
		index  ="idx_categoryName";

	property
		name   ="slug"
		column ="slug"
		notnull="true"
		length ="200"
		index  ="idx_categorySlug";

	property
		name   ="isPublic"
		column ="isPublic"
		ormtype="boolean"
		notnull="false"
		default="true"
		index  ="idx_isPublic";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteID"
		lazy     ="true"
		fetch    ="join";

	/* *********************************************************************
	 **							CALCULATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfContentStore"
		formula="select count(*)
				from cb_contentCategories as contentCategories, cb_contentStore as contentStore, cb_content as content
				where contentCategories.FK_categoryID=categoryID
					and contentCategories.FK_contentID = contentStore.contentID
					and contentStore.contentID = content.contentID";

	property
		name   ="numberOfEntries"
		formula="select count(*)
				from cb_contentCategories as contentCategories, cb_entry as entry, cb_content as content
				where contentCategories.FK_categoryID=categoryID
					and contentCategories.FK_contentID = entry.contentID
					and entry.contentID = content.contentID";

	property
		name   ="numberOfPages"
		formula="select count(*)
				from cb_contentCategories as contentCategories, cb_page as page, cb_content as content
				where contentCategories.FK_categoryID=categoryID
					and contentCategories.FK_contentID = page.contentID
					and page.contentID = content.contentID";

	/* *********************************************************************
	 **							PK + CONSTRAINTS + MEMENTO
	 ********************************************************************* */

	this.pk = "categoryID";

	this.memento = {
		defaultIncludes : [
			"category",
			"isPublic",
			"numberOfContentStore",
			"numberOfEntries",
			"numberOfPages",
			"slug",
			"siteSnapshot:site"
		],
		defaultExcludes : [ "site" ]
	};

	this.constraints = {
		"category" : { required : true, size : "1..200" },
		"isPublic" : { required : true, type : "boolean" },
		"slug"     : {
			required   : true,
			size       : "1..200",
			udfMessage : "The 'slug' is not unique",
			udf        : function( value, target ){
				return arguments.target
					.getCategoryService()
					.isSlugUnique(
						slug      : arguments.value,
						categoryID: arguments.target.isLoaded() ? arguments.target.getCategoryID() : "",
						siteID    : arguments.target.hasSite() ? arguments.target.getSite().getSiteID() : ""
					);
			}
		}
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
		variables.isPublic                      = true;

		super.init();

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
			variables.numberOfPublishedContentStore = getNumberOfPublishedContent( variables.contentStoreService );
		}
		return variables.numberOfPublishedContentStore;
	}

	/**
	 * Helper to get the count of published entries for this category.
	 */
	numeric function getNumberOfPublishedEntries(){
		// Caching per load basis
		if ( !len( variables.numberOfPublishedEntries ) ) {
			variables.numberOfPublishedEntries = getNumberOfPublishedContent( variables.entryService );
		}
		return variables.numberOfPublishedEntries;
	}

	/**
	 * Build a site snapshot
	 */
	struct function getSiteSnapshot(){
		return ( hasSite() ? getSite().getInfoSnapshot() : {} );
	}

	/**
	 * Shortcut to get the site id
	 */
	function getSiteID(){
		if ( hasSite() ) {
			return getSite().getsiteID();
		}
		return "";
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
					.isEq( "categories.categoryID", getCategoryID() )
					.isTrue( "isPublished" )
					.isLE( "publishedDate", now() )
					.isEq( "passwordProtection", "" )
					.$or(
						service.getRestrictions().isNull( "expireDate" ),
						service.getRestrictions().isGT( "expireDate", now() )
					)
					.cache( true )
					.count( "contentID" );
			} );
	}

}
