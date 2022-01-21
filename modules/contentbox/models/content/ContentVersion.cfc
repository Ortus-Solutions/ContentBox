/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a versioned piece of content
 */
component
	persistent="true"
	entityname="cbContentVersion"
	table     ="cb_contentVersion"
	batchsize ="25"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbContentVersion"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							DI
	 ********************************************************************* */

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="contentVersionID"
		column   ="contentVersionID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="content"
		column ="content"
		notnull="true"
		ormtype="text"
		length ="8000"
		default="";

	property
		name   ="changelog"
		column ="changelog"
		notnull="false"
		ormtype="text"
		length ="8000"
		default="";

	property
		name   ="version"
		column ="version"
		notnull="true"
		ormtype="integer"
		default="1"
		index  ="idx_version";

	property
		name   ="isActive"
		column ="isActive"
		notnull="true"
		ormtype="boolean"
		default="false"
		index  ="idx_activeContentVersion,idx_contentVersions";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> Author loaded as a proxy and fetched immediately
	property
		name     ="author"
		notnull  ="true"
		cfc      ="contentbox.models.security.Author"
		fieldtype="many-to-one"
		fkcolumn ="FK_authorID"
		lazy     ="true"
		fetch    ="join";

	// M20 -> relatedContent
	property
		name     ="relatedContent"
		notnull  ="true"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="many-to-one"
		fkcolumn ="FK_contentID"
		lazy     ="true"
		fetch    ="join"
		index    ="idx_contentVersions";

	/* *********************************************************************
	 **							NON PERSISTED PROPERTIES
	 ********************************************************************* */

	property name="renderedContent" persistent="false";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "contentVersionID";

	this.memento = {
		defaultIncludes : [
			"content",
			"changelog",
			"version",
			"isActive",
			"authorSnapshot:author"
		],
		defaultExcludes : [ "relatedContent" ],
		neverInclude    : [ "" ]
	};

	this.constraints = {
		"content" : { required : true },
		"version" : { required : true, type : "integer" }
	};

	function init(){
		variables.createdDate     = now();
		variables.isActive        = false;
		variables.version         = 1;
		variables.content         = "";
		variables.changelog       = "";
		variables.renderedContent = "";

		super.init();

		return this;
	}

	/**
	 * Build the author snapshot
	 */
	struct function getAuthorSnapshot(){
		return ( hasAuthor() ? getAuthor().getInfoSnapshot() : {} );
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
	 * Shorthand Author name
	 */
	string function getAuthorName(){
		if ( hasAuthor() ) {
			return getAuthor().getFullName();
		}
		return "";
	}

	/**
	 * Shorthand Author email
	 */
	string function getAuthorEmail(){
		if ( hasAuthor() ) {
			return getAuthor().getEmail();
		}
		return "";
	}

	/**
	 * Get parent slug from the related content it belongs to
	 */
	function getParentSlug(){
		if ( hasRelatedContent() ) {
			return getRelatedContent().getSlug();
		}
		return "";
	}

	/**
	 * Get parent title from the related content it belongs to
	 */
	function getParentTitle(){
		if ( hasRelatedContent() ) {
			return getRelatedContent().getTitle();
		}
		return "";
	}

	/**
	 * Render version content out
	 */
	any function renderContent(){
		// Check if we need to translate
		if ( NOT len( variables.renderedContent ) ) {
			lock
				name          ="contentbox.versionrendering.#getContentVersionID()#"
				type          ="exclusive"
				throwontimeout="true"
				timeout       ="10" {
				if ( NOT len( variables.renderedContent ) ) {
					// else render content out, prepare builder
					var builder = createObject( "java", "java.lang.StringBuilder" ).init( variables.content );
					// announce renderings with data, so content renderers can process them
					variables.interceptorService.announce(
						"cb_onContentRendering",
						{ builder : builder, content : this }
					);

					// save content
					variables.renderedContent = builder.toString();
				}
			}
		}

		// renturn translated content
		return variables.renderedContent;
	}

}
