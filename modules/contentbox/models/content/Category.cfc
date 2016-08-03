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

	property name="categoryService" inject="categoryService@cb" persistent="false";

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
				length="200";

	property 	name="slug"			
				notnull="true"  
				length="200" 
				unique="true" 
				index="idx_categorySlug";
	
	/* *********************************************************************
	**							CALCULATED FIELDS									
	********************************************************************* */

	property 	name="numberOfEntries" 
				formula="select count(*) 
						from cb_contentCategories as contentCategories, cb_entry as entry, cb_content as content
						where contentCategories.FK_categoryID=categoryID
							and contentCategories.FK_contentID = entry.contentID
						   	and entry.contentID = content.contentID
						  	and content.isPublished = 1" ;

	property 	name="numberOfPages" 	
				formula="select count(*) 
						from cb_contentCategories as contentCategories, cb_page as page, cb_content as content
						where contentCategories.FK_categoryID=categoryID
							and contentCategories.FK_contentID = page.contentID
							and page.contentID = content.contentID
							and content.isPublished = 1" ;

	/* *********************************************************************
	**							PK + CONSTRAINTS									
	********************************************************************* */

	this.pk = "categoryID";

	this.constrains = {
		"category" 	= { required = true, size = "1..200" },
		"slug" 		= { required = true, size = "1..200" }
	};

	/* *********************************************************************
	**							PUBLIC FUNCTIONS									
	********************************************************************* */

	/**
	* Get memento representation
	*/
	struct function getMemento( excludes="" ){
		var pList 	= listToArray( "category,slug,numberOfEntries,numberOfPages" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		return result;
	}
}