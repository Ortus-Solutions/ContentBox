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

	property
		name="assignedContentItems"
		ormtype="integer"
		default=0
		formula="select count(*) from cb_content WHERE FK_contentTemplate = id or FK_childContentTemplate = id";


	function init(){
		variables.schema = {
			"name" : {
				"required"   : true,
				"type"       : "string"
			},
			"description" : {
				"required" : false,
				"type" : "string"
			},
			"definition" : {
				"required" : true,
				"type" : "string"
			},
			"site" : {
				"required" : true
			}
		}

		return this;
	}

	this.memento = {
		"defaultIncludes" : {
			"contentTemplateID",
			"contentType",
			"name",
			"description",
			"definition",
			"assignedContentItems"
		},
		profiles : {
			export : {
				defaultIncludes : [
					"contentTemplateID",
					"contentType",
					"name",
					"description",
					"definition",
					"schema",
					"createdDate",
					"modifiedDate",
					"creator",
					"site.id",
					"site.slug"
				],
				defaultExcludes : [
					"assignedContentItems"
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

	boolean function isNameUniqueInSite( value = variables.name ){
		return !! getContentTemplateService()
					.newCriteria()
					.isEq( "site", getSite() )
					.isNE( "contentTemplateID", variables.contentTemplateID )
					.isEq( "name", arguments.value )
					.count();
	}

}