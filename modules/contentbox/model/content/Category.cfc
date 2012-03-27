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
* I am a blog entry category
*/
component persistent="true" entityname="cbCategory" table="cb_category"{

	// Properties
	property name="categoryID" fieldtype="id" generator="native" setter="false";
	property name="category"		notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200" unique="true" index="idx_slug";

	// Calculated properties
	property name="numberOfEntries" formula="select count(*) from cb_contentCategories as contentCategories, cb_entry as entry, cb_content as content
											 where contentCategories.FK_categoryID=categoryID
											   and contentCategories.FK_contentID = entry.contentID
											   and entry.contentID = content.contentID
											   and content.isPublished = 1" ;
	property name="numberOfPages" 	formula="select count(*) from cb_contentCategories as contentCategories, cb_page as page, cb_content as content
											 where contentCategories.FK_categoryID=categoryID
											   and contentCategories.FK_contentID = page.contentID
											   and page.contentID = content.contentID
											   and content.isPublished = 1" ;

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCategoryID() );
	}
}