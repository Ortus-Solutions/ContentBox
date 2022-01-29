/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A content template for a base content item
 */
component
persistent         ="true"
entityname         ="cbContentTemplate"
table              ="cb_contentTemplate"
extends            ="contentbox.models.BaseEntityMethods"
cachename          ="cbContentTemplate"
cacheuse           ="read-write"
{

	/**
	 * --------------------------------------------------------------------------
	 * STUPID PROPERTIES DUE TO ACF BUG
	 * --------------------------------------------------------------------------
	 * There is a bug in acf2016, 2018, 2021 dealing with table inheritance. It
	 * has never been fixed. Until it does, keep these.
	 */
	property
		name   ="createdDate"
		column ="createdDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true"
		update ="false";

	property
		name   ="modifiedDate"
		column ="modifiedDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true";

	property
		name   ="isDeleted"
		column ="isDeleted"
		ormtype="boolean"
		notnull="true"
		default="false";

	/**
	 * --------------------------------------------------------------------------
	 * PROPERTIES
	 * --------------------------------------------------------------------------
	 */

	property
		name     ="contentTemplateID"
		column   ="templateID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	// The content type to restrict this template to.  If left blank, all content types are eligible
	property
		name   ="contentType"
		column ="contentType"
		length ="50"
		default=""
		index  ="idx_templateContentType";


	property
		name   ="name"
		column ="name"
		notnull="true"
		length ="500"
		default="";

	property
		name   ="description"
		column ="description"
		notnull="false"
		length ="1000";

	property
		name="definition"
		column="definition"
		notnull="true"
		ormtype="text"
		default="";

	// M20 -> creator loaded as a proxy and fetched immediately
	property
		name     ="creator"
		notnull  ="true"
		cfc      ="contentbox.models.security.Author"
		fieldtype="many-to-one"
		fkcolumn ="FK_authorID";

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteID"
		lazy     ="true"
		fetch    ="join";

	// The non-persistent schema of the JSON definition
	property
		name ="schema"
		persistent="false";


	function init(){
		variables.schema = {
			"title" : {
				"required" : false,
				"type" : "string"
			},
			"content" : {
				"required" : false,
				"type" : "string"
			},
			"markup" : {
				"required" : false,
				"type" : "string"
			},
			"description" : {
				"required" : false,
				"type" : "string"
			},
			"excerpt" : {
				"required" : false,
				"type" : "string"
			},
			"featuredImage" :{
				"required" : false,
				"type" : "string"
			},
			// SEO
			"HTMLTitle" : {
				"required" : false,
				"type" : "string"
			},
			"HTMLKeywords" : {
				"required" : false,
				"type" : "string"
			},
			"HTMLDescription" : {
				"required" : false,
				"type" : "string"
			},
			// Modifiers
			"parent" : {
				"required" : false,
				"type" : "string"
			},
			"allowComments" : {
				"required" : false,
				"type" : "boolean"
			},
			"passwordProtection" : {
				"required" : false,
				"type" : "string"
			},
			"SSLOnly" : {
				"required" : false,
				"type" : "boolean"
			},
			// Caching
			"cache" : {
				"required" : false,
				"type" : "boolean"
			},
			"cacheTimeout" : {
				"required" : false,
				"type" : "integer"
			},
			"cacheLastAccessTimeout" : {
				"required" : false,
				"type" : "integer"
			},
			// Display Options
			"layout" : {
				"required" : false,
				"type" : "string"
			},
			"childLayout" : {
				"required" : false,
				"type" : "string"
			},
			"showInMenu" : {
				"required" : false,
				"type" : "boolean"
			},
			"showInSearch" : {
				"required" : false,
				"type" : "boolean"
			},
			// Collections
			"customFields" : {
				"required" : false,
				"type" : "array",
				"schema" : {
					"name" : {
						"required" : true,
						"type" : "string"
					},
					"type" : {
						"required" : true,
						"type" : "string"
					},
					"defaultValue" : {
						"required" : true,
						"type" : "string"
					}
				}
			},
			"categories" : {
				"required" : false,
				"type" : "array",
				"schema" : {
					"slug" : {
						"required" : true,
						"type" : "string"
					}
				}
			}

		};

		return this;
	}

	this.memento = {
		"defaultIncludes" : [
			"contentTemplateID",
			"contentType",
			"name",
			"description",
			"definition",
			"schema"
		]
	};

	this.constraints = {
		"name" : { requred: true, size : "1..200" },
		"definition" : { required : true, type : "string" },
		"isPublic" : { required : true, type : "boolean" },
		"site" : { required : true }
	};


	/**
	 * Overload getter for definition to deal with JSON conversion
	 * @overload
	 */
	function getDefinition(){
		return deSerializeJSON( variables.definition );
	}

	/**
	 * Overload setter for definition to deal with JSON conversion
	 * @overload
	 */
	function setDefinition( definition ){
		return serializeJSON(
			arguments.definition,
			false,
			listFindNoCase( "Lucee", server.coldfusion.productname ) ? "utf-8" : false
		);
	}



}