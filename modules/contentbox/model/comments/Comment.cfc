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
* I am a Comment Entity
*/
component persistent="true" entityname="cbComment" table="cb_comment" batchsize="25" cachename="cbComment" cacheuse="read-write" {

	// PROPERTIES
	property name="commentID" fieldtype="id" generator="native" setter="false";
	property name="content" 		ormtype="text" 	notnull="true";
	property name="author"			length="100" 	notnull="true";
	property name="authorIP"		length="100" 	notnull="true";
	property name="authorEmail"		length="255" 	notnull="true";
	property name="authorURL"		length="255" 	notnull="false";
	property name="createdDate" 	notnull="true"  ormtype="timestamp"	update="false" default="" index="idx_createdDate";
	property name="isApproved" 		notnull="true"  ormtype="boolean" 	default="false" dbdefault="0" index="idx_contentComment,idx_approved";

	// M20 -> Content loaded as a proxy
	property name="relatedContent" notnull="true" cfc="contentbox.model.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" index="idx_contentComment";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		createdDate		= now();
	}

	/************************************** PUBLIC *********************************************/

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}

	/**
	* Get parent slug from either the page it belongs or the entry it belongs to.
	*/
	function getParentSlug(){
		if( hasRelatedContent() ){ return getRelatedContent().getSlug(); }
		return "";
	}

	/**
	* Get parent title from either the page it belongs or the entry it belongs to.
	*/
	function getParentTitle(){
		if( hasRelatedContent() ){ return getRelatedContent().getTitle(); }
		return "";
	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCommentID() );
	}

	/**
	* Get memento
	*/
	struct function getMemento(){
		var r = {
			author = variables.author,
			authorIP = variables.authorIP,
			authorEmail = variables.authorEmail,
			authorURL = variables.authorURL,
			createdDate = variables.createdDate,
			isApproved = variables.isApproved,
			content = variables.content
		};

		return r;

	}
}