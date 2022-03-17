/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A mapped super class used for any ContentBox content object.  All concrete content objects
 * will inherit from this one.
 */
component
	persistent         ="true"
	entityname         ="cbContent"
	table              ="cb_content"
	extends            ="contentbox.models.BaseEntityMethods"
	cachename          ="cbContent"
	cacheuse           ="read-write"
	discriminatorColumn="contentType"
{

	/**
	 * --------------------------------------------------------------------------
	 * DI
	 * --------------------------------------------------------------------------
	 * All DI is done lazyly to avoid any performance issues. Thus the provider annotation
	 */

	property
		name      ="categoryService"
		inject    ="provider:categoryService@contentbox"
		persistent="false";

	property
		name      ="contentService"
		inject    ="provider:contentService@contentbox"
		persistent="false";

	property
		name      ="contentVersionService"
		inject    ="provider:contentVersionService@contentbox"
		persistent="false";

	property
		name      ="customFieldService"
		inject    ="provider:customFieldService@contentbox"
		persistent="false";

	property
		name      ="i18n"
		inject    ="provider:i18n@cbi18n"
		persistent="false";

	property
		name      ="JSONPrettyPrint"
		inject    ="provider:JSONPrettyPrint@JSONPrettyPrint"
		persistent="false";

	property
		name      ="settingService"
		inject    ="provider:settingService@contentbox"
		persistent="false";

	/**
	 * --------------------------------------------------------------------------
	 * NON PERSISTED PROPERTIES
	 * --------------------------------------------------------------------------
	 */

	property
		name      ="renderedContent"
		persistent="false"
		default   ="";

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
		name     ="contentID"
		column   ="contentID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="contentType"
		column ="contentType"
		setter ="false"
		update ="false"
		insert ="false"
		index  ="idx_discriminator,idx_published"
		default="";

	property
		name   ="title"
		column ="title"
		notnull="true"
		length ="500"
		default=""
		index  ="idx_search";

	property
		name   ="slug"
		column ="slug"
		notnull="true"
		length ="500"
		default=""
		index  ="idx_slug,idx_publishedSlug";

	property
		name   ="publishedDate"
		column ="publishedDate"
		notnull="false"
		ormtype="timestamp"
		index  ="idx_publishedDate";

	property
		name   ="expireDate"
		column ="expireDate"
		notnull="false"
		ormtype="timestamp"
		default=""
		index  ="idx_expireDate";

	property
		name   ="isPublished"
		column ="isPublished"
		notnull="true"
		ormtype="boolean"
		default="true"
		index  ="idx_published,idx_search,idx_publishedSlug";

	property
		name   ="allowComments"
		column ="allowComments"
		notnull="true"
		ormtype="boolean"
		default="true";

	property
		name   ="passwordProtection"
		column ="passwordProtection"
		notnull="false"
		length ="100"
		default="";

	property
		name   ="HTMLKeywords"
		column ="HTMLKeywords"
		notnull="false"
		length ="160"
		default="";

	property
		name   ="HTMLDescription"
		column ="HTMLDescription"
		notnull="false"
		length ="160"
		default="";

	property
		name   ="HTMLTitle"
		column ="HTMLTitle"
		notnull="false"
		length ="255"
		default="";

	property
		name   ="cache"
		column ="cache"
		notnull="true"
		ormtype="boolean"
		default="true"
		index  ="idx_cache";

	property
		name   ="cacheTimeout"
		column ="cacheTimeout"
		notnull="false"
		ormtype="integer"
		default="0"
		index  ="idx_cachetimeout";

	property
		name   ="cacheLastAccessTimeout"
		column ="cacheLastAccessTimeout"
		notnull="false"
		ormtype="integer"
		default="0"
		index  ="idx_cachelastaccesstimeout";

	property
		name   ="markup"
		column ="markup"
		notnull="true"
		length ="100"
		default="HTML";

	property
		name   ="showInSearch"
		column ="showInSearch"
		notnull="true"
		ormtype="boolean"
		default="true"
		index  ="idx_showInSearch";

	property
		name   ="featuredImage"
		column ="featuredImage"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="featuredImageURL"
		column ="featuredImageURL"
		notnull="false"
		default=""
		length ="500";

	/**
	 * --------------------------------------------------------------------------
	 * RELATIONSHIPS
	 * --------------------------------------------------------------------------
	 */

	// M20 -> creator loaded as a proxy and fetched immediately
	property
		name     ="creator"
		notnull  ="true"
		cfc      ="contentbox.models.security.Author"
		fieldtype="many-to-one"
		fkcolumn ="FK_authorID"
		lazy     ="true";

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteID"
		lazy     ="true"
		fetch    ="join";

	// O2M -> Comments
	property
		name        ="comments"
		singularName="comment"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		batchsize   ="25"
		orderby     ="createdDate"
		cfc         ="contentbox.models.comments.Comment"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> CustomFields
	property
		name        ="customFields"
		singularName="customField"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		cfc         ="contentbox.models.content.CustomField"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> ContentVersions
	property
		name        ="contentVersions"
		singularName="contentVersion"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		batchsize   ="25"
		cfc         ="contentbox.models.content.ContentVersion"
		orderby     ="version desc"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// M20 -> Parent Page loaded as a proxy
	property
		name     ="parent"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="many-to-one"
		fkcolumn ="FK_parentID"
		lazy     ="true";

	// O2M -> Sub Content Inverse
	property
		name        ="children"
		singularName="child"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		orderby     ="createdDate"
		cfc         ="contentbox.models.content.BaseContent"
		fkcolumn    ="FK_parentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> Comment Subscribers
	property
		name        ="commentSubscriptions"
		singularName="commentSubscription"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		batchsize   ="25"
		cfc         ="contentbox.models.subscriptions.CommentSubscription"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// M2M -> Categories
	property
		name             ="categories"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="true"
		orderby          ="category"
		cascade          ="save-update"
		cfc              ="contentbox.models.content.Category"
		fkcolumn         ="FK_contentID"
		linktable        ="cb_contentCategories"
		inversejoincolumn="FK_categoryID";

	// M2M -> Related Content - Content related from this content to other content
	property
		name             ="relatedContent"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="true"
		orderby          ="title"
		cascade          ="save-update"
		cfc              ="contentbox.models.content.BaseContent"
		fkcolumn         ="FK_contentID"
		linktable        ="cb_relatedContent"
		inversejoincolumn="FK_relatedContentID";

	// M2M -> Linked Content - Content related to this content from other content
	property
		name             ="linkedContent"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="true"
		cascade          ="save-update"
		inverse          ="true"
		orderby          ="title"
		cfc              ="contentbox.models.content.BaseContent"
		fkcolumn         ="FK_relatedContentID"
		linktable        ="cb_relatedContent"
		inversejoincolumn="FK_contentID";

	// O2O -> Content Stats
	property
		name     ="stats"
		notnull  ="true"
		cfc      ="contentbox.models.content.Stats"
		fieldtype="one-to-one"
		mappedBy ="relatedContent"
		cascade  ="all-delete-orphan"
		fetch    ="join"
		lazy     ="true";

	/**
	 * --------------------------------------------------------------------------
	 * CALCULATED FIELDS
	 * --------------------------------------------------------------------------
	 */

	property
		name   ="numberOfHits"
		formula="select cbStats.hits
			from cb_stats cbStats
			where cbStats.FK_contentID=contentID"
		default="0";

	property
		name   ="numberOfChildren"
		formula="select count(*) from cb_content content where content.FK_parentID=contentID"
		default="0";

	property
		name   ="numberOfComments"
		formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID"
		default="0";

	property
		name   ="numberOfVersions"
		formula="select count(*) from cb_contentVersion versions where versions.FK_contentID=contentID"
		default="0";

	/**
	 * --------------------------------------------------------------------------
	 * MEMENTIFIER + CONSTRAINTS
	 * --------------------------------------------------------------------------
	 */

	this.pk = "contentID";

	this.memento = {
		defaultIncludes : [
			"allowComments",
			"cache",
			"cacheLastAccessTimeout",
			"cacheTimeout",
			"categoriesArray:categories",
			"contentID",
			"contentType",
			"createdDate",
			"creatorSnapshot:creator",
			"expireDate",
			"featuredImage",
			"featuredImageURL",
			"HTMLDescription",
			"HTMLKeywords",
			"HTMLTitle",
			"isPublished",
			"isDeleted",
			"lastEditorSnapshot:lastEditor",
			"markup",
			"modifiedDate",
			"numberOfChildren",
			"numberOfComments",
			"numberOfHits",
			"numberOfVersions",
			"parentSnapshot:parent",
			"publishedDate",
			"showInSearch",
			"slug",
			"siteID",
			"title"
		],
		defaultExcludes : [
			"children",
			"comments",
			"commentSubscriptions",
			"contentVersions",
			"customFields",
			"linkedContent",
			"parent",
			"relatedContent",
			"site",
			"stats"
		],
		neverInclude : [ "passwordProtection" ],
		mappers      : {},
		defaults     : { stats : {} },
		profiles     : {
			response : {
				defaultIncludes : [
					"categoriesArray:categories",
					"contentID",
					"contentType",
					"createdDate",
					"expireDate",
					"featuredImage",
					"featuredImageURL",
					"HTMLDescription",
					"HTMLKeywords",
					"HTMLTitle",
					"markup",
					"modifiedDate",
					"numberOfChildren",
					"numberOfComments",
					"parentSnapshot:parent",
					"publishedDate",
					"slug",
					"title",
					"renderedContent",
					"renderedExcerpt",
					"childrenSnapshot:children"
				],
				defaultExcludes : []
			},
			export : {
				defaultIncludes : [
					"allowComments",
					"cache",
					"cacheLastAccessTimeout",
					"cacheTimeout",
					"categoriesArray:categories",
					"contentID",
					"contentType",
					"createdDate",
					"creatorSnapshot:creator",
					"expireDate",
					"featuredImage",
					"featuredImageURL",
					"HTMLDescription",
					"HTMLKeywords",
					"HTMLTitle",
					"isPublished",
					"isDeleted",
					"markup",
					"modifiedDate",
					"parentSnapshot:parent",
					"publishedDate",
					"showInSearch",
					"siteSnapshot:site",
					"slug",
					"title",
					"children",
					// Relationships
					"comments",
					"commentSubscriptions",
					"contentVersions",
					"customFields",
					"linkedContentSnapshot:linkedContent",
					"relatedContentSnapshot:relatedContent",
					"stats"
				],
				defaultExcludes : [
					"commentSubscriptions.relatedContentSnapshot:relatedContent",
					"children.parentSnapshot:parent",
					"linkedContent",
					"parent",
					"relatedContent",
					"site"
				]
			}
		}
	};

	this.constraints = {
		"cacheLastAccessTimeout" : { required : false, type : "numeric" },
		"cacheTimeout"           : { required : false, type : "numeric" },
		"expireDate"             : { required : false, type : "date" },
		"featuredImage"          : { required : false, size : "1..255" },
		"featuredImageURL"       : { required : false, size : "1..255" },
		"HTMLDescription"        : { required : false, size : "1..160" },
		"HTMLKeywords"           : { required : false, size : "1..160" },
		"markup"                 : { required : true, size : "1..100" },
		"passwordProtection"     : { required : false, size : "1..100" },
		"publishedDate"          : { required : false, type : "date" },
		"site"                   : { required : true },
		"slug"                   : {
			required   : true,
			size       : "1..200",
			udfMessage : "The 'slug' is not unique",
			udf        : function( value, target ){
				return arguments.target
					.getContentService()
					.isSlugUnique(
						contentType: arguments.target.getContentType(),
						slug       : arguments.value,
						contentID  : arguments.target.isLoaded() ? arguments.target.getContentID() : "",
						siteID     : arguments.target.hasSite() ? arguments.target.getSite().getSiteID() : ""
					);
			}
		},
		"title" : { required : true, size : "1..200" }
	};

	/**
	 * Base constructor
	 */
	function init(){
		super.init();
		variables.isPublished            = true;
		variables.publishedDate          = now();
		variables.allowComments          = true;
		variables.cache                  = true;
		variables.cacheTimeout           = 0;
		variables.cacheLastAccessTimeout = 0;
		variables.markup                 = "HTML";
		variables.contentType            = "";
		variables.showInSearch           = true;
		variables.renderedContent        = "";
		variables.children               = [];
		return this;
	}

	/**
	 * Prepare the instance for usage
	 */
	function onDIComplete(){
		// Load up content helpers
		variables.wirebox
			.getInstance( dsl: "coldbox:moduleSettings:contentbox" )
			.contentHelpers
			.each( function( thisHelper ){
				includeMixin( arguments.thisHelper );
			} );
	}


	/**
	 * Utility method to get a snapshot of this content object
	 */
	struct function getInfoSnapshot(){
		if ( isLoaded() ) {
			return {
				"contentID"     : getContentID(),
				"title"         : getTitle(),
				"slug"          : getSlug(),
				"isPublished"   : getIsPublished(),
				"publishedDate" : getPublishedDate(),
				"createdDate"   : getCreatedDate(),
				"modifiedDate"  : getModifiedDate(),
				"expireDate"    : getExpireDate(),
				"contentType"   : getContentType()
			};
		}
		return {};
	}

	/**
	 * Build a parent snapshot
	 */
	struct function getParentSnapshot(){
		return ( hasParent() ? getParent().getInfoSnapshot() : {} );
	}

	/**
	 * Build a creator snapshot
	 */
	struct function getCreatorSnapshot(){
		return ( hasCreator() ? getCreator().getInfoSnapshot() : {} );
	}

	/**
	 * Build a last editor snapshot
	 */
	struct function getLastEditorSnapshot(){
		var activeContent = getActiveContent();
		return ( activeContent.hasAuthor() ? activeContent.getAuthor().getInfoSnapshot() : {} );
	}

	/**
	 * Build a site snapshot
	 */
	struct function getSiteSnapshot(){
		return ( hasSite() ? getSite().getInfoSnapshot() : {} );
	}

	/**
	 * Get the number of hits
	 */
	numeric function getNumberOfHits(){
		return ( isNull( variables.numberOfHits ) ? 0 : variables.numberOfHits );
	}

	/**
	 * Get the number of children
	 */
	numeric function getNumberOfChildren(){
		return ( isNull( variables.numberOfChildren ) ? 0 : variables.numberOfChildren );
	}

	/**
	 * Get the total number of comments this content object has
	 */
	numeric function getNumberOfComments(){
		return ( isNull( variables.numberOfComments ) ? 0 : variables.numberOfComments );
	}

	/**
	 * Get the total number of approved comments this content object has
	 */
	numeric function getNumberOfApprovedComments(){
		if ( !isLoaded() ) {
			return 0;
		}
		return variables.comments
			.filter( function( comment ){
				return comment.getIsApproved();
			} )
			.len();
	}

	/**
	 * Get the total number of versions this content object has
	 */
	numeric function getNumberOfVersions(){
		return ( isNull( variables.numberOfVersions ) ? 0 : variables.numberOfVersions );
	}

	/**
	 * Get the total number of active versions this content object has
	 */
	numeric function getNumberOfActiveVersions(){
		return ( isLoaded() ? variables.contentVersionService.getNumberOfVersions( getContentId(), true ) : 0 );
	}

	/**
	 * Add a new content version to the content object.  This does not persist the version.
	 * It just makes sure that the content object receives a new active version and it
	 * deactivates the previous version.  Persisting is done by the handler/service not by
	 * this method.
	 *
	 * @content   The incoming content string to store as the new version content
	 * @changelog The changelog commit message, defaults to empty string
	 * @author    The author object that is making the edit
	 * @isPreview Is this a preview version or a real version
	 *
	 * @return The same content object
	 */
	BaseContent function addNewContentVersion(
		required content,
		changelog = "",
		required author,
		boolean isPreview = false
	){
		// lock it for new content creation to avoid version overlaps
		lock name="contentbox.addNewContentVersion.#getSlug()#" type="exclusive" timeout="10" throwOnTimeout=true {
			// get a new version object with our incoming content + relationships
			var oNewVersion = variables.contentVersionService.new( {
				content        : arguments.content,
				changelog      : arguments.changelog,
				author         : arguments.author,
				relatedContent : this
			} );

			// Do we already have an active version?
			if ( hasActiveContent() ) {
				// cap checks if not in preview mode
				if ( !arguments.isPreview ) {
					maxContentVersionChecks();
				}
				// deactive the curent version, we do it after in case the content versions check kick off a transaction
				getActiveContent().setIsActive( false );
			}

			// Get the latest content version, to increase the new version number, collection is ordered by 'version' descending
			if ( hasContentVersion() ) {
				oNewVersion.setVersion( variables.contentVersions[ 1 ].getVersion() + 1 );
			}

			// Activate the new version
			oNewVersion.setIsActive( true );
			variables.activeContent   = oNewVersion;
			variables.renderedContent = "";
			// Add it to the content versions array so it can be saved as part of this content object
			addContentVersion( oNewVersion );
		}
		return this;
	}

	/**
	 * Build the array of linked content snapshots
	 */
	array function getLinkedContentSnapshot(){
		if ( hasLinkedContent() ) {
			return arrayMap( variables.linkedContent, function( thisItem ){
				return arguments.thisItem.getInfoSnapshot();
			} );
		}
		return [];
	}

	/**
	 * Build the array of children snapshots
	 */
	array function getChildrenSnapshot(){
		if ( hasChild() ) {
			return arrayMap( variables.children, function( thisItem ){
				return arguments.thisItem.getInfoSnapshot();
			} );
		}
		return [];
	}

	/**
	 * Build the array of related content snapshots
	 */
	array function getRelatedContentSnapshot(){
		if ( hasRelatedContent() ) {
			return arrayMap( variables.relatedContent, function( thisItem ){
				return arguments.thisItem.getInfoSnapshot();
			} );
		}
		return [];
	}

	/**
	 * Returns a list of active related content for this piece of content
	 */
	string function getRelatedContentIDs(){
		if ( hasRelatedContent() ) {
			return arrayMap( variables.relatedContent, function( thisItem ){
				return arguments.thisItem.getContentID();
			} ).toList();
		}
		return "";
	}

	/**
	 * Override the setRelatedContent
	 *
	 * @relatedContent The related content to set
	 */
	BaseContent function setRelatedContent( required array relatedContent ){
		if ( hasRelatedContent() ) {
			variables.relatedContent.clear();
			variables.relatedContent.addAll( arguments.relatedContent );
		} else {
			variables.relatedContent = arguments.relatedContent;
		}
		return this;
	}

	/**
	 * Inflates from comma-delimited list (or array) of id's
	 *
	 * @relatedContent The list or array of relatedContent ids
	 */
	BaseContent function inflateRelatedContent( required any relatedContent ){
		var allContent = [];
		// convert to array
		if ( isSimpleValue( arguments.relatedContent ) ) {
			arguments.relatedContent = listToArray( arguments.relatedContent );
		}
		// iterate over array
		for ( var x = 1; x <= arrayLen( arguments.relatedContent ); x++ ) {
			var id            = trim( arguments.relatedContent[ x ] );
			// get content from id
			var extantContent = contentService.get( id );
			// if found, add to array
			if ( !isNull( extantContent ) ) {
				// append to array all new relatedContent
				arrayAppend( allContent, extantContent );
			}
		}
		setRelatedContent( allContent );
		return this;
	}

	/**
	 * Determines if the content object can have comments or not
	 */
	boolean function commentsAllowed(){
		return !isContentStore();
	}

	/**
	 * Determines if the content object is a content store type
	 */
	boolean function isContentStore(){
		return getContentType() == "contentStore";
	}

	/**
	 * Override the setComments
	 */
	BaseContent function setComments( required array comments ){
		if ( hasComment() ) {
			variables.comments.clear();
			variables.comments.addAll( arguments.comments );
		} else {
			variables.comments = arguments.comments;
		}
		return this;
	}

	/**
	 * Override the setter
	 */
	BaseContent function setCustomFields( required array customFields ){
		if ( hasCustomField() ) {
			variables.customFields.clear();
			variables.customFields.addAll( arguments.customFields );
		} else {
			variables.customFields = arguments.customFields;
		}
		return this;
	}

	/**
	 * Get custom fields as a structure representation
	 */
	struct function getCustomFieldsAsStruct(){
		var results = {};

		// if no fields, just return empty
		if ( !hasCustomField() ) {
			return results;
		}

		// iterate and create
		for ( var thisField in variables.customFields ) {
			results[ thisField.getKey() ] = thisField.getValue();
		}

		return results;
	}

	/**
	 * Shortcut to get a custom field value
	 *
	 * @key          The custom field key to get
	 * @defaultValue The default value if the key is not found.
	 */
	any function getCustomField( required key, defaultValue ){
		var fields = getCustomFieldsAsStruct();
		if ( structKeyExists( fields, arguments.key ) ) {
			return fields[ arguments.key ];
		}
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}
		throw(
			message = "No custom field with key: #arguments.key# found",
			detail  = "The keys are #structKeyList( fields )#",
			type    = "InvalidCustomField"
		);
	}

	/**
	 * Override the setContentVersions
	 */
	BaseContent function setContentVersions( required array contentVersions ){
		if ( hasContentVersion() ) {
			variables.contentVersions.clear();
			variables.contentVersions.addAll( arguments.contentVersions );
		} else {
			variables.contentVersions = arguments.contentVersions;
		}
		return this;
	}

	/**
	 * Only adds it if not found in content object
	 */
	BaseContent function addCategories( required category ){
		if ( !hasCategories( arguments.category ) ) {
			arrayAppend( variables.categories, arguments.category );
		}
		return this;
	}

	/**
	 * Remove only if it's found in the content object
	 */
	BaseContent function removeCategories( required category ){
		if ( hasCategories( arguments.category ) ) {
			arrayDelete( variables.categories, arguments.category );
		}
		return this;
	}

	/*
	 * I remove all category associations
	 */
	BaseContent function removeAllCategories(){
		if ( hasCategories() ) {
			variables.categories.clear();
		} else {
			variables.categories = [];
		}
		return this;
	}

	/*
	 * I remove all custom fields
	 */
	BaseContent function removeAllCustomFields(){
		if ( hasCustomField() ) {
			variables.customFields.clear();
		} else {
			variables.customFields = [];
		}
		return this;
	}

	/*
	 * I remove all linked content associations
	 */
	BaseContent function removeAllLinkedContent(){
		if ( hasLinkedContent() ) {
			for ( var item in variables.linkedContent ) {
				item.removeRelatedContent( this );
			}
		}
		return this;
	}

	/**
	 * Override the setChildren
	 */
	BaseContent function setChildren( required array children ){
		if ( hasChild() ) {
			variables.children.clear();
			variables.children.addAll( arguments.children );
		} else {
			variables.children = arguments.children;
		}
		return this;
	}

	/**
	 * Verify and rotate maximum content versions
	 */
	private function maxContentVersionChecks(){
		if ( !len( variables.settingService.getSetting( "cb_versions_max_history" ) ) ) {
			return;
		}

		// How many versions do we have?
		var versionCounts = contentVersionService
			.newCriteria()
			.isEq( "relatedContent.contentID", getContentID() )
			.count();

		// Have we passed the limit?
		if ( ( versionCounts + 1 ) GT variables.settingService.getSetting( "cb_versions_max_history" ) ) {
			var oldestVersion = contentVersionService
				.newCriteria()
				.isEq( "relatedContent.contentID", getContentID() )
				.isEq( "isActive", javacast( "boolean", false ) )
				.withProjections( id = "true" )
				.list(
					sortOrder = "createdDate DESC",
					offset    = variables.settingService.getSetting( "cb_versions_max_history" ) - 2
				);
			// delete by primary key IDs found
			contentVersionService.deleteByID( arrayToList( oldestVersion ) );
		}
	}

	/**
	 * Retrieves the latest content string from the latest version un-translated
	 */
	string function getContent(){
		var thisContent = getActiveContent().getContent();

		// Check for json and format it for pretty print
		if ( isJSON( thisContent ) ) {
			return variables.JSONPrettyPrint.formatJson(
				json           : thisContent,
				lineEnding     : chr( 10 ),
				spaceAfterColon: true
			);
		}

		return thisContent;
	}

	/**
	 * Get the latest active version object, empty new one if none assigned
	 */
	ContentVersion function getActiveContent(){
		// If we don't have any versions, send back a new one
		if ( !hasContentVersion() ) {
			return variables.contentVersionService.new();
		}

		// Load up the active content if not set yet
		if ( isNull( variables.activeContent ) ) {
			// Iterate and find, they are sorted descending, so it should be quick, unless we don't have one and that's ok.
			for ( var thisVersion in variables.contentVersions ) {
				if ( thisVersion.getIsActive() ) {
					variables.activeContent = thisVersion;
					break;
				}
			}
			// We didn't find one, something is out of sync, return just an empty version
			if ( isNull( variables.activeContent ) ) {
				return variables.contentVersionService.new();
			}
		}

		return variables.activeContent;
	}

	/**
	 * Set the active content version manually, usually great for previews
	 *
	 * @content The content to set as the active version
	 */
	BaseContent function setActiveContent( required content ){
		variables.activeContent = arguments.content;
		return this;
	}

	/**
	 * Verify if this content object has an active version with content
	 */
	boolean function hasActiveContent(){
		// If we are not persisted, then no exit out.
		if ( !hasContentVersion() || !isLoaded() ) {
			return false;
		}
		// Iterate and find, they are sorted descending, so it should be quick, unless we don't have one and that's ok.
		for ( var thisVersion in variables.contentVersions ) {
			if ( thisVersion.getIsActive() ) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Shorthand Creator name
	 */
	string function getCreatorName(){
		if ( hasCreator() ) {
			return getCreator().getFullName();
		}
		return "";
	}

	/**
	 * Shorthand Creator email
	 */
	string function getCreatorEmail(){
		if ( hasCreator() ) {
			return getCreator().getEmail();
		}
		return "";
	}

	/**
	 * Shorthand Author name from latest version
	 */
	string function getAuthorName(){
		return getActiveContent().getAuthorName();
	}

	/**
	 * Shorthand Author email from latest version
	 */
	string function getAuthorEmail(){
		return getActiveContent().getAuthorEmail();
	}

	/**
	 * Shorthand Author from latest version or null if any yet
	 */
	any function getAuthor(){
		return getActiveContent().getAuthor();
	}

	/************************************** PUBLIC *********************************************/

	/**
	 * Get parent ID if set or empty if none
	 *
	 * @return The parent ID or empty value if none attached
	 */
	function getParentID(){
		return ( hasParent() ? getParent().getContentID() : "" );
	}

	/**
	 * Get parent name or empty if none
	 *
	 * @return The parent name or empty value if none attached
	 */
	function getParentName(){
		return ( hasParent() ? getParent().getTitle() : "" );
	}

	/**
	 * Bit that denotes if the content has expired or not, in order to be expired the content must have been published as well
	 */
	boolean function isExpired(){
		return (
			isContentPublished() AND
			!isNull( variables.expireDate ) AND
			len( variables.expireDate ) AND // In case of some odd empty string cases
			dateCompare( variables.expireDate, now() ) lte 0
		) ? true : false;
	}

	/**
	 * Bit that denotes if the content has been published or not
	 */
	boolean function isContentPublished(){
		return (
			getIsPublished() AND
			!isNull( variables.publishedDate ) AND
			dateCompare( variables.publishedDate, now() ) lte 0
		) ? true : false;
	}

	/**
	 * Bit that denotes if the content has been published or not in the future
	 */
	boolean function isPublishedInFuture(){
		return (
			getIsPublished() AND
			dateCompare( variables.publishedDate, now() ) eq 1
		) ? true : false;
	}

	/**
	 * Is entity loaded
	 */
	boolean function isLoaded(){
		return ( len( getContentID() ) ? true : false );
	}

	/**
	 * Clones the object and stores it in the database
	 *
	 * - Wipe primary key, and descendant keys
	 * - Prepare for cloning of entire hierarchies
	 * - Make sure categories are cloned
	 *
	 * @author           The author doing the cloning
	 * @original         The original content object that will be cloned into this content object
	 * @originalService  The ContentBox content service object
	 * @publish          Publish pages or leave as drafts
	 * @originalSlugRoot The original slug that will be replaced in all cloned content
	 * @newSlugRoot      The new slug root that will be replaced in all cloned content
	 */
	BaseContent function clone(
		required any author,
		required any original,
		required any originalService,
		required boolean publish,
		required any originalSlugRoot,
		required any newSlugRoot
	){
		transaction {
			// Base Content Property cloning
			variables.isPublished            = arguments.publish;
			variables.createdDate            = now();
			variables.modifiedDate           = variables.createdDate;
			variables.HTMLKeywords           = arguments.original.getHTMLKeywords();
			variables.HTMLDescription        = arguments.original.getHTMLDescription();
			variables.HTMLTitle              = arguments.original.getHTMLTitle();
			variables.markup                 = arguments.original.getMarkup();
			variables.cache                  = arguments.original.getCache();
			variables.cacheTimeout           = arguments.original.getCacheTimeout();
			variables.cacheLastAccessTimeout = arguments.original.getCacheLastAccessTimeout();
			variables.showInSearch           = arguments.original.getShowInSearch();
			variables.featuredImage          = arguments.original.getFeaturedImage();
			variables.featuredImageURL       = arguments.original.getFeaturedImageURL();
			variables.comments               = [];
			variables.children               = [];

			// Are we publishing?
			if ( arguments.publish ) {
				variables.publishedDate = now();
			}

			// get latest content versioning
			var latestContent = arguments.original.getActiveContent().getContent();
			// Original slug updates on all content
			latestContent     = reReplaceNoCase(
				latestContent,
				"page\:\[#arguments.originalSlugRoot#\/",
				"page:[#arguments.newSlugRoot#/",
				"all"
			);

			// reset versioning, and start with a new one
			addNewContentVersion(
				content  : latestContent,
				changelog: "Content Cloned!",
				author   : arguments.author
			);

			// safe clone custom fields
			variables.customFields = arguments.original
				.getCustomFields()
				.map( function( thisField ){
					return variables.customFieldService
						.new( {
							key   : arguments.thisField.getKey(),
							value : arguments.thisField.getValue()
						} )
						.setRelatedContent( this );
				} );

			// clone related content
			arguments.original
				.getRelatedContent()
				.each( function( thisRelatedContent ){
					addRelatedContent( arguments.thisRelatedContent );
				} );

			// clone categories
			arguments.original
				.getCategories()
				.each( function( thisCategory ){
					addCategories( variables.categoryService.getOrCreate( arguments.thisCategory, getSite() ) );
				} );

			// now clone children
			if ( arguments.original.hasChild() ) {
				// Save the parent first to avoid cascade issues
				arguments.originalService.save( this );
				// Continue down to clone the original children and attach them
				arguments.original
					.getChildren()
					.each( function( thisChild ){
						// Clone the child
						var newChild = originalService
							.new( {
								creator : author,
								title   : arguments.thisChild.getTitle(),
								slug    : listLast( arguments.thisChild.getSlug(), "/" ),
								site    : getSite()
							} )
							.setParent( this );

						// now deep clone until no more children are left behind.
						newChild.clone(
							author           = author,
							original         = arguments.thisChild,
							originalService  = originalService,
							publish          = publish,
							originalSlugRoot = arguments.thisChild.getSlug(),
							newSlugRoot      = newChild.getSlug()
						);
					} );
			} else {
				arguments.originalService.save( this );
			}
		}
		// end of cloning transaction

		return this;
	}

	/**
	 * This method retrieves the time of the publishing for the content object in UTC timezone.
	 * The format expected back is {hour}:{minute}. If the publish date is null an empty string is returned.
	 *
	 * @return The published date time as {hour}:{minute}.
	 */
	string function getPublishedDateTime(){
		if ( isNull( variables.publishedDate ) || !len( variables.publishedDate ) ) {
			return "";
		}
		return hour( variables.publishedDate ) & ":" & minute( variables.publishedDate );
	}

	/**
	 * This method retrieves the time of the expiration for the content object in UTC timezone.
	 * The format expected back is {hour}:{minute}. If the expire date is null an empty string is returned.
	 *
	 * @return The expire date time as {hour}:{minute}.
	 */
	string function getExpireDateTime(){
		if ( isNull( variables.expireDate ) || !len( variables.expireDate ) ) {
			return "";
		}
		return hour( variables.expireDate ) & ":" & minute( variables.expireDate );
	}

	/**
	 * Get the published date using the default date format and time format
	 * If the publish date is null or empty an empty string is returned.
	 *
	 * @dateFormat The date format to use, defaulted by ContentBox to mmm dd, yyyy
	 * @timeFormat The time format to use, defaulted by ContentBox to HH:mm:ss z
	 * @showTime   Show the time or just the date
	 */
	string function getDisplayPublishedDate(
		dateFormat       = this.DATE_FORMAT,
		timeFormat       = this.TIME_FORMAT,
		boolean showTime = true
	){
		if ( isNull( variables.publishedDate ) || !len( variables.publishedDate ) ) {
			return "";
		}
		if ( !arguments.showTime ) {
			return dateFormat( variables.publishedDate, arguments.dateFormat );
		}
		return dateFormat( variables.publishedDate, arguments.dateFormat ) & " " & timeFormat(
			variables.publishedDate,
			arguments.timeFormat
		);
	}

	/**
	 * Get the expire date using the default date format and time format
	 * If the expire date is null or empty an empty string is returned.
	 *
	 * @dateFormat The date format to use, defaulted by ContentBox to mmm dd, yyyy
	 * @timeFormat The time format to use, defaulted by ContentBox to HH:mm:ss z
	 * @showTime   Show the time or just the date
	 */
	string function getDisplayExpireDate(
		dateFormat       = this.DATE_FORMAT,
		timeFormat       = this.TIME_FORMAT,
		boolean showTime = true
	){
		if ( isNull( variables.expireDate ) || !len( variables.expireDate ) ) {
			return "";
		}
		if ( !arguments.showTime ) {
			return dateFormat( variables.expireDate, arguments.dateFormat );
		}
		return dateFormat( variables.expireDate, arguments.dateFormat ) & " " & timeFormat(
			variables.expireDate,
			arguments.timeFormat
		);
	}

	/**
	 * isPassword Protected
	 */
	boolean function isPasswordProtected(){
		return len( getPasswordProtection() );
	}

	/**
	 * add published timestamp to property
	 */
	any function addPublishedTime( required hour, required minute ){
		if ( !isDate( getPublishedDate() ) ) {
			return this;
		}
		var time = timeFormat( "#arguments.hour#:#arguments.minute#", this.TIME_FORMAT_SHORT );
		setPublishedDate( getPublishedDate() & " " & time );
		return this;
	}

	/**
	 * add published timestamp to property
	 *
	 * @timeString The joined time string (e.g., 12:00)
	 */
	any function addJoinedPublishedTime( required string timeString ){
		var splitTime = listToArray( arguments.timeString, ":" );
		if ( arrayLen( splitTime ) == 2 ) {
			return addPublishedTime( splitTime[ 1 ], splitTime[ 2 ] );
		} else {
			return this;
		}
	}

	/**
	 * add expired timestamp to property
	 */
	any function addExpiredTime( required hour, required minute ){
		if ( !isDate( getExpireDate() ) ) {
			return this;
		}
		// verify time and minute defaults, else default to midnight
		if ( !len( arguments.hour ) ) {
			arguments.hour = "0";
		}
		if ( !len( arguments.minute ) ) {
			arguments.minute = "00";
		}
		// setup the right time now.
		var time = timeFormat( "#arguments.hour#:#arguments.minute#", this.TIME_FORMAT_SHORT );
		setExpireDate( getExpireDate() & " " & time );
		return this;
	}

	/**
	 * add expired timestamp to property
	 *
	 * @timeString The joined time string (e.g., 12:00)
	 */
	any function addJoinedExpiredTime( required string timeString ){
		var splitTime = listToArray( arguments.timeString, ":" );
		if ( arrayLen( splitTime ) == 2 ) {
			return addExpiredTime( splitTime[ 1 ], splitTime[ 2 ] );
		} else {
			return this;
		}
	}

	/**
	 * Build content cache keys according to sent content object
	 */
	string function buildContentCacheKey(){
		var inputHash = hash( cgi.HTTP_HOST & cgi.query_string );
		return "cb-content-#getContentType()#-#getContentID()#-#i18n.getfwLocale()#-#inputHash#";
	}

	/**
	 * This builds a partial cache key so we can clean from the cache many permutations of the content object
	 */
	string function buildContentCacheCleanupKey(){
		return "cb-content-#getContentType()#-#getContentID()#";
	}

	/**
	 * Verify we can do content caching on this content object using global and local rules
	 */
	boolean function canCacheContent(){
		var settings = variables.settingService.getAllSettings();

		// check global caching first
		if (
			( getContentType() eq "page" AND settings.cb_content_caching ) OR
			( getContentType() eq "entry" AND settings.cb_entry_caching )
		) {
			// check override in local content bit
			return ( getCache() ? true : false );
		}
		return false;
	}

	/**
	 * Shortcut to get the rendered content
	 */
	any function getRenderedContent(){
		return this.renderContent();
	}

	/**
	 * Shortcut to get the rendered excerpt
	 */
	any function getRenderedExcerpt(){
		if ( !isNull( variables.excerpt ) ) {
			return this.renderExcerpt();
		}
		return "";
	}

	/**
	 * Render content out using translations, caching, etc.
	 */
	any function renderContent(){
		var settings = variables.settingService.getAllSettings();

		// caching enabled?
		if ( canCacheContent() ) {
			// Build Cache Key
			var cacheKey      = buildContentCacheKey();
			// Get appropriate cache provider
			var cache         = cacheBox.getCache( settings.cb_content_cacheName );
			// Try to get content?
			var cachedContent = cache.get( cacheKey );
			// Verify it exists, if it does, return it
			if ( !isNull( cachedContent ) AND len( cachedContent ) ) {
				return cachedContent;
			}
		}

		// Check if we need to translate
		if ( NOT len( variables.renderedContent ) ) {
			// save content
			variables.renderedContent = renderContentSilent();
		}

		// caching enabled?
		if ( canCacheContent() ) {
			// Store content in cache, of local timeouts are 0 then use global timeouts.
			cache.set(
				cacheKey,
				variables.renderedContent,
				( getCacheTimeout() eq 0 ? settings.cb_content_cachingTimeout : getCacheTimeout() ),
				( getCacheLastAccessTimeout() eq 0 ? settings.cb_content_cachingTimeoutIdle : getCacheLastAccessTimeout() )
			);
		}

		// renturn translated content
		return variables.renderedContent;
	}

	/**
	 * Renders the content silently so no caching, or extra fluff is done, just content translation rendering.
	 *
	 * @content The content markup to translate, by default it uses the active content version's content
	 */
	any function renderContentSilent( any content = getContent() ) profile{
		// render content out, prepare builder
		var builder = createObject( "java", "java.lang.StringBuilder" ).init( arguments.content );
		// announce renderings with data, so content renderers can process them
		interceptorService.announce( "cb_onContentRendering", { builder : builder, content : this } );
		// return processed content
		return builder.toString();
	}

	/**
	 * Inflate custom fields from the incoming count and memento structure
	 */
	any function inflateCustomFields( required numeric fieldCount, required struct memento ){
		// remove original custom fields
		getCustomFields().clear();

		// inflate custom fields start at 0 as it is incoming javascript counting of arrays
		for ( var x = 0; x lt arguments.fieldCount; x++ ) {
			// get custom field from incoming data
			var args = {
				key   : arguments.memento[ "CustomFieldKeys_#x#" ],
				value : arguments.memento[ "CustomFieldValues_#x#" ]
			};
			// only add if key has value
			if ( len( trim( args.key ) ) ) {
				var thisField = customFieldService.new( properties = args );
				thisField.setRelatedContent( this );
				addCustomField( thisField );
			}
		}

		return this;
	}

	/**
	 * Get an array of category slugs for this content object
	 */
	array function getCategoriesArray(){
		if ( NOT hasCategories() ) {
			return [];
		}
		return arrayMap( variables.categories, function( item ){
			return arguments.item.getCategory();
		} );
	}

	/**
	 * Get a list string of the categories this content object has.
	 *
	 * @return The category list or `Uncategorized` if it doesn't have any
	 */
	string function getCategoriesList(){
		return getCategoriesArray().toList();
	}

	/**
	 * Shortcut to get the site name
	 */
	function getSiteName(){
		return getSite().getName();
	}

	/**
	 * Shortcut to get the site slug
	 */
	function getSiteSlug(){
		return getSite().getSlug();
	}

	/**
	 * Shortcut to get the site id
	 */
	function getSiteID(){
		if ( hasSite() ) {
			return getSite().getsiteID();
		}
		return "";
	}

	/**
	 * Verifies that the incoming site is the same as the content has already
	 *
	 * @site The site id or site object to verify
	 */
	boolean function isSameSite( required site ){
		// If no site attached, break.
		if ( !hasSite() ) {
			return false;
		}

		// Simple Value Test
		if ( isSimpleValue( arguments.site ) ) {
			return arguments.site == getsiteID();
		}

		// Object test
		return getsiteID() == arguments.site.getsiteID();
	}

	/**
	 * Override setter as we do some hiearchy slug magic when setting a parent
	 *
	 * @parent The parent object or null
	 */
	BaseContent function setParent( parent ){
		// Nulllify?
		if ( isNull( arguments.parent ) ) {
			variables.parent = javacast( "null", "" );
			// remove the hierarchical information from our slug as we are promoting to the root
			variables.slug   = listLast( variables.slug, "/" );
			return this;
		} else {
			// Welcome home papa!
			variables.parent = arguments.parent;
			// I am a ColdBox Daddy!
			arguments.parent.addChild( this );
		}

		// Update slug according to parent hierarchy
		if ( !variables.slug.findNoCase( arguments.parent.getSlug() ) ) {
			variables.slug = arguments.parent.getSlug() & "/" & listLast( variables.slug, "/" );
		}

		return this;
	}

}
