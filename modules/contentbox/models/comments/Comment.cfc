/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a Comment Entity
 */
component
	persistent="true"
	entityname="cbComment"
	table     ="cb_comment"
	batchsize ="25"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbComment"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							DI
	 ********************************************************************* */

	property
		name      ="markdown"
		inject    ="provider:Processor@cbmarkdown"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="commentID"
		column   ="commentID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="content"
		ormtype="text"
		notnull="true";

	property
		name   ="author"
		length ="100"
		notnull="true";

	property
		name   ="authorIP"
		column ="authorIP"
		length ="100"
		notnull="true";

	property
		name   ="authorEmail"
		column ="authorEmail"
		length ="255"
		notnull="true";

	property
		name   ="authorURL"
		column ="authorURL"
		length ="255"
		notnull="false";

	property
		name   ="isApproved"
		column ="isApproved"
		notnull="true"
		ormtype="boolean"
		default="false"
		index  ="idx_contentComment,idx_approved";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> Content loaded as a proxy
	property
		name     ="relatedContent"
		notnull  ="true"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="many-to-one"
		fkcolumn ="FK_contentID"
		lazy     ="true"
		fetch    ="join"
		index    ="idx_contentComment";

	/* *********************************************************************
	 **							CONSTRAINTS + PK
	 ********************************************************************* */

	this.pk = "commentID";

	this.memento = {
		defaultIncludes : [
			"content",
			"displayContent:renderedContent",
			"author",
			"authorIP",
			"authorEmail",
			"authorURL",
			"isApproved"
		],
		defaultExcludes : [ "relatedContent" ]
	};

	this.constraints = {
		"content"        : { required : true },
		"author"         : { required : true, size : "1..100" },
		"authorIP"       : { required : true, size : "1..100" },
		"authorEmail"    : { required : true, size : "1..255", type : "email" },
		"authorURL"      : { required : true, size : "1..255", type : "URL" },
		"isApproved"     : { required : true, type : "boolean" },
		"relatedContent" : { required : true }
	};

	function init(){
		variables.isApproved  = false;
		variables.createdDate = now();

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

	/**
	 * Render the comment using markdown and encoding it for HTML output
	 */
	string function getDisplayContent(){
		return variables.markdown.toHTML( getContent().reReplace( "##{1,6}\s", "", "all" ) );
	}

	/**
	 * Get parent slug from either the page it belongs or the entry it belongs to.
	 */
	function getParentSlug(){
		if ( hasRelatedContent() ) {
			return getRelatedContent().getSlug();
		}
		return "";
	}

	/**
	 * Get parent title from either the page it belongs or the entry it belongs to.
	 */
	function getParentTitle(){
		if ( hasRelatedContent() ) {
			return getRelatedContent().getTitle();
		}
		return "";
	}

}
