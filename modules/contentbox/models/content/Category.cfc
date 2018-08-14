/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I content category
*/
component 	persistent="true"
			entityname="cbCategory"
			table="cb_category"
			extends="contentbox.models.BaseEntity"
			cachename="cbCategory"
			cacheuse="read-write"{

	/* *********************************************************************
	**							DI
	********************************************************************* */

	property name="categoryService" 		inject="categoryService@cb" persistent="false";
	property name="pageService" 			inject="pageService@cb" 	persistent="false";
	property name="entryService" 			inject="entryService@cb" 	persistent="false";
	property name="contentStoreService" 	inject="contentStoreService@cb" 	persistent="false";

	/* *********************************************************************
	**							PROPERTIES
	********************************************************************* */

	property 	name="categoryID"
				fieldtype="id"
				generator="native"
				setter="false"
				params="{ allocationSize = 1, sequence = 'categoryID_seq' }";

	property 	name="category"
				notnull="true"
				length="200"
				index="idx_categoryName";

	property 	name="slug"
				notnull="true"
				length="200"
				unique="true"
				index="idx_categorySlug";

	/* *********************************************************************
	**							CALCULATED FIELDS
	********************************************************************* */

	property 	name="numberOfContentStore"
				formula="select count(*)
						from cb_contentCategories as contentCategories, cb_contentStore as contentStore, cb_content as content
						where contentCategories.FK_categoryID=categoryID
							and contentCategories.FK_contentID = contentStore.contentID
						   	and contentStore.contentID = content.contentID" ;

	property 	name="numberOfEntries"
				formula="select count(*)
						from cb_contentCategories as contentCategories, cb_entry as entry, cb_content as content
						where contentCategories.FK_categoryID=categoryID
							and contentCategories.FK_contentID = entry.contentID
						   	and entry.contentID = content.contentID" ;

	property 	name="numberOfPages"
				formula="select count(*)
						from cb_contentCategories as contentCategories, cb_page as page, cb_content as content
						where contentCategories.FK_categoryID=categoryID
							and contentCategories.FK_contentID = page.contentID
							and page.contentID = content.contentID" ;

	/* *********************************************************************
	**							PK + CONSTRAINTS
	********************************************************************* */

	this.pk = "categoryID";

	this.constraints = {
		"category" 	= { required = true, size = "1..200", validator = "UniqueValidator@cborm" },
		"slug"		= { required = true, size = "1..200", validator = "UniqueValidator@cborm" }
	};

	/* *********************************************************************
	**							PUBLIC FUNCTIONS
	********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.category 						= "";
		variables.slug 							= "";
		variables.numberOfPublishedPages 		= "";
		variables.numberOfPublishedEntries 		= "";
		variables.numberOfPublishedContentStore	= "";

		return this;
	}

	/**
	 * Helper to get the count of published pages for this category.
	 */
	numeric function getNumberOfPublishedPages(){
		// Caching per load basis
		if( !len( variables.numberOfPublishedPages ) ){
			variables.numberOfPublishedPages = getNumberOfPublishedContent( pageService );
		}
		return variables.numberOfPublishedPages;
	}

	/**
	 * Helper to get the count of published content store for this category.
	 */
	numeric function getNumberOfPublishedContentStore(){
		// Caching per load basis
		if( !len( variables.numberOfPublishedContentStore ) ){
			variables.numberOfPublishedContentStore = getNumberOfPublishedContent( contentStoreService );
		}
		return variables.numberOfPublishedContentStore;
	}

	/**
	 * Helper to get the count of published entries for this category.
	 */
	numeric function getNumberOfPublishedEntries(){
		// Caching per load basis
		if( !len( variables.numberOfPublishedEntries ) ){
			variables.numberOfPublishedEntries = getNumberOfPublishedContent( entryService );
		}
		return variables.numberOfPublishedEntries;
	}

	/**
	* Get memento representation
	* @excludes properties to exclude
	*/
	struct function getMemento( excludes="" ){
		var pList 	= listToArray( "category,slug" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );

		return result;
	}

	/********************************** PRIVATE **********************************/

	/**
	 * Get the number of published content by category and service type
	 * @service The target service to use.
	 */
	private numeric function getNumberOfPublishedContent( required service ){
		var c = arguments.service.newCriteria();

		c.createAlias( "categories", "categories" )
			.isEq( "categories.categoryID", javaCast( "int", getCategoryID() ) )
			.isTrue( "isPublished" )
			.isLE( "publishedDate", now() )
			.isEq( "passwordProtection", "" )
			.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) );

		return c.count( "contentID" );
	}
}
