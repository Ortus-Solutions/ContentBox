/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A class to track stats for content
 */
component
	persistent="true"
	entityname="cbStats"
	table     ="cb_stats"
	batchsize ="25"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbStats"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="statsID"
		column   ="statsID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="hits"
		column ="hits"
		notnull="false"
		ormtype="long"
		default="0";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// O2O -> Content
	property
		name     ="relatedContent"
		notnull  ="true"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="one-to-one"
		fkcolumn ="FK_contentID"
		lazy     ="true"
		fetch    ="join";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "statsID";

	this.memento = { defaultIncludes : [ "hits" ], defaultExcludes : [ "" ] };

	this.constraints = { "hits" : { required : false, type : "numeric" } };

	function init(){
		super.init();
		return this;
	}

	/**
	 * Build a snapshot of the related content
	 */
	struct function getRelatedContentSnapshot(){
		if ( hasRelatedContent() ) {
			return getRelatedContent().getInfoSnapshot();
		}
		return {};
	}

}
