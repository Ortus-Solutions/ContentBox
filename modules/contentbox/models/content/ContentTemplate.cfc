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

	property
		name      ="contentTemplateService"
		inject    ="provider:ContentTemplateService@contentbox"
		persistent="false";
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

	property
		name   ="isGlobal"
		column ="isGlobal"
		ormtype="boolean"
		notnull="true"
		default="false";

	/**
	 * --------------------------------------------------------------------------
	 * PROPERTIES
	 * --------------------------------------------------------------------------
	 */

	property
		name     ="templateID"
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
		length ="225"
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
		default="{}";

	// M20 -> creator loaded as a proxy and fetched immediately
	property
		name     ="creator"
		notnull  ="true"
		cfc      ="contentbox.models.security.Author"
		fieldtype="many-to-one"
		fkcolumn ="FK_authorID"
		insert 	 =true
		update 	 =false;

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteID"
		lazy     ="true"
		fetch    ="join"
		insert 	 =true
		update 	 =false;


	property
		name="assignedContentItems"
		ormtype="integer"
		default=0
		formula="select count(*) from cb_content cbc2 WHERE cbc2.FK_contentTemplateID=templateID or cbc2.FK_childContentTemplateID=templateID";

	// The non-persistent schema of the JSON definition
	property
		name ="schema"
		persistent="false";


	function init(){
		variables.createdDate = now();
		variables.modifiedDate = now();
		variables.schema = {
			"title"                  : { "label" : "Title", "type" : "string" },
			"content"                : { "label" : "Content", "type" : "text" },
			"markup"                 : { "label" : "Markup", "type" : "markdown" },
			"excerpt"                : { "label" : "Excerpt", "type" : "text" },
			"featuredImage"          : { "label" : "Featured Image", "type" : "file" },
			// SEO
			"HTMLTitle"              : { "label" : "HTML Title", "type" : "string" },
			"HTMLKeywords"           : { "label" : "HTML Keywords", "type" : "string" },
			"HTMLDescription"        : { "label" : "HTML Description", "type" : "text" },
			// Modifiers
			"parent"                 : {
				"label" : "Content Parent",
				"type" : "typeahead",
				"search" : "/cbapi/v1/sites/:siteId/pages",
				"options" : "filteredParents",
				"optionId" : "contentID",
				"optionLabel" : "title"
			},
			"allowComments"          : { "label" : "Comments Enabled", "type" : "boolean", "default" : true },
			"passwordProtection"     : { "label" : "Access Password", "type" : "string" },
			"SSLOnly"                : { "label" : "Force SSL", "type" : "boolean", "default" : false },
			// Caching
			"cache"                  : { "label" : "Cache Enabled", "type" : "boolean", "default" : true },
			"cacheTimeout"           : { "label" : "Cache Timeout", "type" : "integer", "default" : 0 },
			"cacheLastAccessTimeout" : { "label" : "Cache Last Access Timeout", "type" : "integer", "default" : 0 },
			// Display Options
			"layout"                 : { "label" : "Layout", "type" : "select", "options" : "availableLayouts" },
			"childLayout"            : { "label" : "Child Layout", "type" : "select", "options" : "availableLayouts" },
			"showInMenu"             : { "label" : "Show In Menu", "type" : "boolean", "default" : true },
			"showInSearch"           : { "label" : "Show In Search", "type" : "boolean", "default" : true },
			// Collections
			"customFields"           : {
				"label" : "Custom Fields",
				"type"     : "array",
				"schema"   : {
					"name"         : { "label" : "Field Name", "required" : true, "type" : "string" },
					"defaultValue" : { "label" : "Default Value", "type" : "string" }
				},
				"presentation" : "input"
			},
			"categories" : {
				"label" : "Assigned Categories",
				"type" : "select",
				"options" : "availableCategories",
				"multiple" : true
			}
		};

		return this;
	}

	this.memento = {
		"defaultIncludes" : [
			"templateID",
			"contentType",
			"name",
			"description",
			"definition",
			"assignedContentItems"
		],
		profiles : {
			export : {
				defaultIncludes : [
					"templateID",
					"contentType",
					"name",
					"description",
					"definition",
					"createdDate",
					"modifiedDate"
				],
				defaultExcludes : [
					"assignedContentItems",
					"site",
					"creator"
				]
			}
		}
	};

	this.constraints = {
		"name" : {
			required     : true,
			size         : "1..200",
			"udf"        : ( value, target ) => target.isNameUniqueInSite( value )
		},
		"definition" : { required : true },
		"site" : { required : true },
		"isGlobal" : ( value, target ) => target.isGlobalUniqueInSite( value )
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
		variables.definition = isSimpleValue( arguments.definition )
								? arguments.definition
								: serializeJSON(
									arguments.definition,
									false,
									listFindNoCase( "Lucee", server.coldfusion.productname ) ? "utf-8" : false
								);
		return this;
	}

	boolean function isNameUniqueInSite( value = variables.name ){
		var c = getContentTemplateService()
					.newCriteria()
					.isEq( "site", getSite() )
					.isEq( "name", arguments.value );

		if( !isNull( variables.templateID ) ){
			c.ne( "templateID", variables.templateID );
		}

		return !c.count();
	}

	boolean function isGlobalUniqueInSite(){
		var c = getContentTemplateService()
					.newCriteria()
					.isEq( "site", getSite() )
					.isEq( "isGlobal", javacast( "boolean", true ) );

		if( !isNull( variables.templateID ) ){
			c.ne( "templateID", variables.templateID );
		}

		return !c.count();
	}

}