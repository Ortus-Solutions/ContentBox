﻿/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A mapped super class used for contentbox content: entries and pages
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

	/* *********************************************************************
	 **							DI INJECTIONS
	 ********************************************************************* */

	property
		name      ="wirebox"
		inject    ="wirebox"
		persistent="false";

	property
		name      ="cachebox"
		inject    ="cachebox"
		persistent="false";

	property
		name      ="settingService"
		inject    ="id:settingService@cb"
		persistent="false";

	property
		name      ="interceptorService"
		inject    ="coldbox:interceptorService"
		persistent="false";

	property
		name      ="customFieldService"
		inject    ="customFieldService@cb"
		persistent="false";

	property
		name      ="categoryService"
		inject    ="categoryService@cb"
		persistent="false";

	property
		name      ="contentService"
		inject    ="contentService@cb"
		persistent="false";

	property
		name      ="contentVersionService"
		inject    ="contentVersionService@cb"
		persistent="false";

	property
		name      ="i18n"
		inject    ="i18n@cbi18n"
		persistent="false";

	/* *********************************************************************
	 **							NON PERSISTED PROPERTIES
	 ********************************************************************* */

	property
		name      ="renderedContent"
		persistent="false"
		default   ="";

	/* *********************************************************************
	 **							STUPID PROPERTIES DUE TO ACF BUG
	 ********************************************************************* */

	property
		name   ="createdDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true"
		update ="false";

	property
		name   ="modifiedDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true";

	property
		name     ="isDeleted"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		notnull  ="true"
		default  ="false"
		dbdefault="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="contentID"
		fieldtype="id"
		generator="uuid"
		setter   ="false"
		update   ="false";

	property
		name   ="contentType"
		setter ="false"
		update ="false"
		insert ="false"
		index  ="idx_discriminator,idx_published"
		default="";

	property
		name   ="title"
		notnull="true"
		length ="200"
		default=""
		index  ="idx_search";

	property
		name   ="slug"
		notnull="true"
		length ="200"
		default=""
		index  ="idx_slug,idx_publishedSlug";

	property
		name   ="publishedDate"
		notnull="false"
		ormtype="timestamp"
		index  ="idx_publishedDate";

	property
		name   ="expireDate"
		notnull="false"
		ormtype="timestamp"
		default=""
		index  ="idx_expireDate";

	property
		name     ="isPublished"
		notnull  ="true"
		ormtype  ="boolean"
		dbdefault="true"
		default  ="true"
		index    ="idx_published,idx_search,idx_publishedSlug";

	property
		name     ="allowComments"
		notnull  ="true"
		ormtype  ="boolean"
		default  ="true"
		dbdefault="true";

	property
		name   ="passwordProtection"
		notnull="false"
		length ="100"
		default=""
		index  ="idx_published";

	property
		name   ="HTMLKeywords"
		notnull="false"
		length ="160"
		default="";

	property
		name   ="HTMLDescription"
		notnull="false"
		length ="160"
		default="";

	property
		name   ="HTMLTitle"
		notnull="false"
		length ="255"
		default="";

	property
		name     ="cache"
		notnull  ="true"
		ormtype  ="boolean"
		default  ="true"
		dbdefault="true"
		index    ="idx_cache";

	property
		name     ="cacheLayout"
		notnull  ="true"
		ormtype  ="boolean"
		default  ="true"
		dbdefault="true"
		index    ="idx_cachelayout";

	property
		name   ="cacheTimeout"
		notnull="false"
		ormtype="integer"
		default="0"
		index  ="idx_cachetimeout";

	property
		name   ="cacheLastAccessTimeout"
		notnull="false"
		ormtype="integer"
		default="0"
		index  ="idx_cachelastaccesstimeout";

	property
		name   ="markup"
		notnull="true"
		length ="100"
		default="HTML";

	property
		name     ="showInSearch"
		notnull  ="true"
		ormtype  ="boolean"
		default  ="true"
		dbdefault="true"
		index    ="idx_showInSearch";

	property
		name   ="featuredImage"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="featuredImageURL"
		notnull="false"
		default=""
		length ="255";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> creator loaded as a proxy and fetched immediately
	property
		name     ="creator"
		notnull  ="true"
		cfc      ="contentbox.models.security.Author"
		fieldtype="many-to-one"
		fkcolumn ="FK_authorID"
		lazy     ="true"
		fetch    ="join";

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
		lazy        ="extra"
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
		lazy        ="extra"
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
		lazy        ="extra"
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
		lazy             ="extra"
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
		lazy             ="extra"
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
		lazy             ="extra"
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
		lazy     ="true"
		fetch    ="join";

	/* *********************************************************************
	 **							CALCULATED FIELDS
	 ********************************************************************* */

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

	/* *********************************************************************
	 **							PK + CONSTRAINTS + STATIC VARS
	 ********************************************************************* */

	this.pk = "contentID";

	this.memento = {
		defaultIncludes : [
			"allowComments",
			"cache",
			"cacheLastAccessTimeout",
			"cacheLayout",
			"cacheTimeout",
			"categoriesList:categories",
			"contentID",
			"contentType",
			"createdDate",
			"creatorSnapshot:creator", // Creator
			"expireDate",
			"featuredImage",
			"featuredImageURL",
			"HTMLDescription",
			"HTMLKeywords",
			"HTMLTitle",
			"isPublished",
			"lastEditorSnapshot:lastEditor",
			"markup",
			"modifiedDate",
			"numberOfChildren",
			"numberOfComments",
			"numberOfHits",
			"numberOfVersions",
			"parentSnapshot:parent", // Parent
			"publishedDate",
			"showInSearch",
			"slug",
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
		mappers      : {
			"categories" : function( item, memento ){
				return listToArray( arguments.item );
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

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Base constructor
	 */
	function init(){
		variables.isPublished            = true;
		variables.publishedDate          = now();
		variables.allowComments          = true;
		variables.cache                  = true;
		variables.cacheLayout            = true;
		variables.cacheTimeout           = 0;
		variables.cacheLastAccessTimeout = 0;
		variables.markup                 = "HTML";
		variables.contentType            = "";
		variables.showInSearch           = true;
		variables.renderedContent        = "";

		super.init();

		return this;
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
		return (
			isLoaded() ? variables.contentVersionService.getNumberOfVersions( getContentId() ) : 0
		);
	}

	/**
	 * Get the total number of active versions this content object has
	 */
	numeric function getNumberOfActiveVersions(){
		return (
			isLoaded() ? variables.contentVersionService.getNumberOfVersions( getContentId(), true ) : 0
		);
	}

	/**
	 * Add a new content version to the content object.  This does not persist the version.
	 * It just makes sure that the content object receives a new active version and it
	 * deactivates the previous version.  Persisting is done by the handler/service not by
	 * this method.
	 *
	 * @content The incoming content string to store as the new version content
	 * @changelog The changelog commit message, defaults to empty string
	 * @author The author object that is making the edit
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
		lock
			name           ="contentbox.addNewContentVersion.#getSlug()#"
			type           ="exclusive"
			timeout        ="10"
			throwOnTimeout =true {
			// get a new version object with our incoming content + relationships
			var oNewVersion= variables.contentVersionService.new( {
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
	 * @key The custom field key to get
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
	 * Get a flat representation of this entry but for UI response format which
	 * restricts the data being generated.
	 * @slugCache Cache of slugs to prevent infinite recursions
	 * @showComments Show comments in memento or not
	 * @showCustomFields Show comments in memento or not
	 * @showParent Show parent in memento or not
	 * @showChildren Show children in memento or not
	 * @showCategories Show categories in memento or not
	 * @showRelatedContent Show related Content in memento or not
	 * @excludes Excludes
	 * @properties Additional properties to incorporate in the memento
	 */
	struct function getResponseMemento(
		required array slugCache   = [],
		boolean showAuthor         = true,
		boolean showComments       = true,
		boolean showCustomFields   = true,
		boolean showParent         = true,
		boolean showChildren       = true,
		boolean showCategories     = true,
		boolean showRelatedContent = true,
		excludes                   = "",
		array properties
	){
		var pList = [
			"title",
			"slug",
			"allowComments",
			"HTMLKeywords",
			"HTMLDescription",
			"HTMLTitle",
			"featuredImageURL",
			"contentType"
		];
		// Add incoming properties
		if ( structKeyExists( arguments, "properties" ) ) {
			pList.addAll( arguments.properties );
		}
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		// Properties
		result[ "content" ]       = renderContent();
		result[ "createdDate" ]   = getDisplayCreatedDate();
		result[ "publishedDate" ] = getDisplayPublishedDate();
		result[ "expireDate" ]    = getDisplayExpireDate();

		// Comments
		if ( arguments.showComments && hasComment() ) {
			result[ "comments" ] = [];
			for ( var thisComment in variables.comments ) {
				arrayAppend(
					result[ "comments" ],
					{
						"content"     : thisComment.getContent(),
						"createdDate" : thisComment.getDisplayCreatedDate(),
						"authorURL"   : thisComment.getAuthorURL(),
						"author"      : thisComment.getAuthor()
					}
				);
			}
		} else if ( arguments.showComments ) {
			result[ "comments" ] = [];
		}

		// Custom Fields
		if ( arguments.showCustomFields && hasCustomField() ) {
			result[ "customfields" ] = getCustomFieldsAsStruct();
		} else if ( arguments.showCustomFields ) {
			result[ "customfields" ] = [];
		}

		// Parent
		if ( arguments.showParent && hasParent() ) {
			result[ "parent" ] = {
				"slug"        : getParent().getSlug(),
				"title"       : getParent().getTitle(),
				"contentType" : getParent().getContentType()
			};
		}
		// Children
		if ( arguments.showChildren && hasChild() ) {
			result[ "children" ] = [];
			for ( var thisChild in variables.children ) {
				arrayAppend(
					result[ "children" ],
					{
						"slug"  : thisChild.getSlug(),
						"title" : thisChild.getTitle()
					}
				);
			}
		} else if ( arguments.showChildren ) {
			result[ "children" ] = [];
		}
		// Categories
		if ( arguments.showCategories && hasCategories() ) {
			result[ "categories" ] = [];
			for ( var thisCategory in variables.categories ) {
				arrayAppend(
					result[ "categories" ],
					{
						"category" : thisCategory.getCategory(),
						"slug"     : thisCategory.getSlug()
					}
				);
			}
		} else if ( arguments.showCategories ) {
			result[ "categories" ] = [];
		}

		// Related Content
		if (
			arguments.showRelatedContent && hasRelatedContent() && !arrayFindNoCase(
				arguments.slugCache,
				getSlug()
			)
		) {
			result[ "relatedcontent" ] = [];
			// add slug to cache
			arrayAppend( arguments.slugCache, getSlug() );
			for ( var content in variables.relatedContent ) {
				arrayAppend(
					result[ "relatedcontent" ],
					{
						"slug"        : content.getSlug(),
						"title"       : content.getTitle(),
						"contentType" : content.getContentType()
					}
				);
			}
		} else if ( arguments.showRelatedContent ) {
			result[ "relatedcontent" ] = [];
		}

		return result;
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
		if (
			( versionCounts + 1 ) GT variables.settingService.getSetting(
				"cb_versions_max_history"
			)
		) {
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
		return getActiveContent().getContent();
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
		if ( !isLoaded() ) {
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
		return ( isContentPublished() AND !isNull( expireDate ) AND expireDate lte now() ) ? true : false;
	}

	/**
	 * Bit that denotes if the content has been published or not
	 */
	boolean function isContentPublished(){
		return ( getIsPublished() AND !isNull( publishedDate ) AND getPublishedDate() LTE now() ) ? true : false;
	}

	/**
	 * Bit that denotes if the content has been published or not in the future
	 */
	boolean function isPublishedInFuture(){
		return ( getIsPublished() AND getPublishedDate() GT now() ) ? true : false;
	}

	/**
	 * Is entity loaded
	 */
	boolean function isLoaded(){
		return ( len( getContentID() ) ? true : false );
	}

	/**
	 * Prepare a content object for cloning. This processes several things:
	 *
	 * - Wipe primary key, and descendant keys
	 * - Prepare for cloning of entire hierarchies
	 * - Make sure categories are cloned
	 *
	 * @author The author doing the cloning
	 * @original The original content object that will be cloned into this content object
	 * @originalService The ContentBox content service object
	 * @publish Publish pages or leave as drafts
	 * @originalSlugRoot The original slug that will be replaced in all cloned content
	 * @newSlugRoot The new slug root that will be replaced in all cloned content
	 */
	BaseContent function prepareForClone(
		required any author,
		required any original,
		required any originalService,
		required boolean publish,
		required any originalSlugRoot,
		required any newSlugRoot
	){
		// Base Content Property cloning
		variables.isPublished            = arguments.publish;
		variables.createdDate            = now();
		variables.modifiedDate           = variables.createdDate;
		variables.HTMLKeywords           = arguments.original.getHTMLKeywords();
		variables.HTMLDescription        = arguments.original.getHTMLDescription();
		variables.HTMLTitle              = arguments.original.getHTMLTitle();
		variables.markup                 = arguments.original.getMarkup();
		variables.cache                  = arguments.original.getCache();
		variables.cacheLayout            = arguments.original.getCacheLayout();
		variables.cacheTimeout           = arguments.original.getCacheTimeout();
		variables.cacheLastAccessTimeout = arguments.original.getCacheLastAccessTimeout();
		variables.showInSearch           = arguments.original.getShowInSearch();
		variables.featuredImage          = arguments.original.getFeaturedImage();
		variables.featuredImageURL       = arguments.original.getFeaturedImageURL();
		// remove all comments
		variables.comments               = [];
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
				addCategories(
					variables.categoryService.getOrCreate( arguments.thisCategory, getSite() )
				);
			} );

		// now clone children
		if ( arguments.original.hasChild() ) {
			arguments.original
				.getChildren()
				.each( function( thisChild ){
					// Preapre new Child
					var newChild = originalService
						.new( {
							parent  : this,
							creator : author,
							title   : arguments.thisChild.getTitle(),
							slug    : this.getSlug() & "/" & listLast(
								arguments.thisChild.getSlug(),
								"/"
							),
							site : getSite()
						} )
						// now deep clone until no more child is left behind.
						.prepareForClone(
							author           = author,
							original         = arguments.thisChild,
							originalService  = originalService,
							publish          = publish,
							originalSlugRoot = originalSlugRoot,
							newSlugRoot      = newSlugRoot
						);

					// now attach it to this piece of content
					addChild( newChild );
				} );
		}

		// evict original entity from hibernate cache, just in case
		variables.contentService.evict( arguments.original );

		return this;
	}

	/**
	 * Get's the published date of the content object in UI format.
	 * If no publish date is found, we use now()
	 *
	 * @showTime Show time on return string or not
	 */
	string function getPublishedDateForEditor( boolean showTime = false ){
		var pDate = getPublishedDate();
		if ( isNull( pDate ) ) {
			pDate = now();
		}

		// get formatted date
		var fDate = dateFormat( pDate, this.DATE_FORMAT );
		if ( arguments.showTime ) {
			fDate &= " " & timeFormat( pDate, this.TIME_FORMAT_SHORT );
		}

		return fDate;
	}

	/**
	 * Get the expire date for the content object in UI format
	 * If no expire date is found, we return an empty string
	 *
	 * @showTime Show time on return string or not
	 */
	string function getExpireDateForEditor( boolean showTime = false ){
		var pDate = getExpireDate();
		if ( isNull( pDate ) ) {
			pDate = "";
		}

		// get formatted date
		var fDate = dateFormat( pDate, this.DATE_FORMAT );
		if ( arguments.showTime ) {
			fDate &= " " & timeFormat( pDate, this.TIME_FORMAT_SHORT );
		}

		return fDate;
	}

	/**
	 * Get display publishedDate
	 */
	string function getDisplayPublishedDate(){
		var publishedDate = getPublishedDate();
		if ( isNull( publishedDate ) ) {
			return "";
		}
		return dateFormat( publishedDate, this.DATE_FORMAT ) & " " & timeFormat(
			publishedDate,
			this.TIME_FORMAT_SHORT
		);
	}

	/**
	 * Get formatted expireDate
	 */
	string function getDisplayExpireDate(){
		if ( isNull( expireDate ) ) {
			return "N/A";
		}
		return dateFormat( expireDate, this.DATE_FORMAT ) & " " & timeFormat(
			expireDate,
			this.TIME_FORMAT_SHORT
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
				(
					getCacheLastAccessTimeout() eq 0 ? settings.cb_content_cachingTimeoutIdle : getCacheLastAccessTimeout()
				)
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
		var b = createObject( "java", "java.lang.StringBuilder" ).init( arguments.content );

		// announce renderings with data, so content renderers can process them
		interceptorService.announce( "cb_onContentRendering", { builder : b, content : this } );

		// return processed content
		return b.toString();
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
	 * Get a list string of the categories this content object has.
	 *
	 * @return The category list or `Uncategorized` if it doesn't have any
	 */
	function getCategoriesList(){
		if ( NOT hasCategories() ) {
			return "Uncategorized";
		}
		return arrayMap( variables.categories, function( item ){
			return item.getCategory();
		} ).toList();
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
	function getsiteID(){
		return getSite().getsiteID();
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
		// Welcome home papa!
		variables.parent = arguments.parent;

		// Nulllify?
		if ( isNull( arguments.parent ) ) {
			return this;
		}

		// Update slug, if parent slug is not set
		if ( !variables.slug.findNoCase( arguments.parent.getSlug() ) ) {
			variables.slug = arguments.parent.getSlug() & "/" & variables.slug;
		}

		return this;
	}

}
