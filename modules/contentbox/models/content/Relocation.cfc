/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A class to track stats for content
 */
component
	persistent="true"
	entityname="cbRelocation"
	table     ="cb_relocations"
	batchsize ="25"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbRelocation"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */
	property
		name     ="relocationID"
		column   ="relocationID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="slug"
		notnull="true"
		length ="500"
		default="";

	/** An optional manual target - may be used if no content is assigned **/
	property
		name   ="target"
		notnull="false"
		length ="500"
		default="";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteID"
		fetch    ="join";

	// O2O -> Content
	property
		name     ="relatedContent"
		notnull  ="false"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="many-to-one"
		fkcolumn ="FK_contentID"
		lazy     ="false"
		fetch    ="select";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "relocationID";

	this.memento = {
		defaultIncludes : [
			"relocationID",
			"createdDate",
			"modifiedDate",
			"slug",
			"target",
			"relatedContent"
		]
	};

	this.constraints = {
		"slug" : {
			required  : true,
			size      : "1..500",
			validator : "UniqueSiteFieldValidator@contentbox"
		}
	};

	// overload method to clean any leading or trailing slashes
	function setSlug( value ){
		variables.slug = arrayToList( listToArray( arguments.value, "/" ), "/" );
		return this;
	}

}
