/**
* A mapped super class used for contentbox content: entries and pages
*/
component persistent="true" entityname="cbContent" table="cb_content" cachename="cbContent" cacheuse="read-write" discriminatorColumn="contentType"{

	// DI Injections
	property name="cachebox" 				inject="cachebox" 					persistent="false";
	property name="settingService"			inject="id:settingService@cb" 		persistent="false";
	property name="interceptorService"		inject="coldbox:interceptorService" persistent="false";
	property name="customFieldService" 	 	inject="customFieldService@cb" 		persistent="false";
	property name="categoryService" 	 	inject="categoryService@cb" 		persistent="false";
	property name="contentService"			inject="contentService@cb"			persistent="false";
	property name="contentVersionService"	inject="contentVersionService@cb"	persistent="false";

	// Non-Persistable Properties
	property name="renderedContent" persistent="false";

	// Properties
	property name="contentID" 				notnull="true"	fieldtype="id" generator="native" setter="false";
	property name="contentType" 			setter="false" update="false" insert="false" index="idx_discriminator,idx_published" default="" dbdefault="";
	property name="title"					notnull="true"  length="200" default="" index="idx_search";
	property name="slug"					notnull="true"  length="200" default="" unique="true" index="idx_slug,idx_publishedSlug";
	property name="createdDate" 			notnull="true"  ormtype="timestamp" update="false" index="idx_createdDate";
	property name="publishedDate"			notnull="false" ormtype="timestamp" index="idx_publishedDate";
	property name="expireDate"				notnull="false" ormtype="timestamp" default="" index="idx_expireDate";
	property name="isPublished" 			notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_published,idx_search,idx_publishedSlug";
	property name="allowComments" 			notnull="true"  ormtype="boolean" default="true" dbdefault="1";
	property name="passwordProtection"		notnull="false" length="100" default="" index="idx_published";
	property name="HTMLKeywords"			notnull="false" length="160" default="";
	property name="HTMLDescription"			notnull="false" length="160" default="";
	property name="hits"					notnull="false" ormtype="long" default="0" dbdefault="0";
	property name="cache"					notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_cache";
	property name="cacheLayout"				notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_cachelayout";
	property name="cacheTimeout"			notnull="false" ormtype="integer" default="0" dbdefault="0" index="idx_cachetimeout";
	property name="cacheLastAccessTimeout"	notnull="false" ormtype="integer" default="0" dbdefault="0" index="idx_cachelastaccesstimeout";
	property name="markup"					notnull="true" length="100" default="html" dbdefault="'HTML'";
	
	// M20 -> creator loaded as a proxy and fetched immediately
	property name="creator" notnull="true" cfc="contentbox.model.security.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true" fetch="join";
	
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25" orderby="createdDate"
			  cfc="contentbox.model.comments.Comment" fkcolumn="FK_contentID" inverse="true" cascade="all-delete-orphan";

	// O2M -> CustomFields
	property name="customFields" singularName="customField" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25"
			  cfc="contentbox.model.content.CustomField" fkcolumn="FK_contentID" inverse="true" cascade="all-delete-orphan";

	// O2M -> ContentVersions
	property name="contentVersions" singularName="contentVersion" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25"
			  cfc="contentbox.model.content.ContentVersion" fkcolumn="FK_contentID" inverse="true" cascade="all-delete-orphan";

	// Active Content Pseudo-Collection
	property name="activeContent" fieldtype="one-to-many" type="array" lazy="extra" cascade="save-update" inverse="true"
			  cfc="contentbox.model.content.ContentVersion" fkcolumn="FK_contentID" where="isActive=1" ;

	// M20 -> Parent Page loaded as a proxy
	property name="parent" cfc="contentbox.model.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_parentID" lazy="true";

	// O2M -> Sub Content Inverse
	property name="children" singularName="child" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25" orderby="createdDate"
			 cfc="contentbox.model.content.BaseContent" fkcolumn="FK_parentID" inverse="true" cascade="all-delete-orphan";

	// M2M -> Categories
	property name="categories" fieldtype="many-to-many" type="array" lazy="extra" orderby="category" inverse="true" cascade="all"  
			  cfc="contentbox.model.content.Category" fkcolumn="FK_contentID" linktable="cb_contentCategories" inversejoincolumn="FK_categoryID";

	// M2M -> Related Content - Content related from this content to other content
	property name="relatedContent" fieldtype="many-to-many" type="array" lazy="extra" orderby="title" cascade="all"  
			  cfc="contentbox.model.content.BaseContent" fkcolumn="FK_contentID" linktable="cb_relatedContent" inversejoincolumn="FK_relatedContentID";
	// M2M -> Linked Content - Content related to this content from other content
	property name="linkedContent" fieldtype="many-to-many" type="array" lazy="extra" inverse="true" orderby="title" 
			  cfc="contentbox.model.content.BaseContent" fkcolumn="FK_relatedContentID" linktable="cb_relatedContent" inversejoincolumn="FK_contentID";

	// Calculated Fields
	property name="numberOfVersions" 			formula="select count(*) from cb_contentVersion cv where cv.FK_contentID=contentID" default="0";
	property name="numberOfComments" 			formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID" default="0";
	property name="numberOfApprovedComments" 	formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID and comment.isApproved = 1" default="0";
	property name="numberOfChildren"			formula="select count(*) from cb_content content where content.FK_parentID=contentID" default="0";

	/************************************** VERIONING METHODS *********************************************/

	/**
	* Add a new content version to save for this content object
	*/
	function addNewContentVersion(required content, changelog="", required author){
		// lock it for new content creation
		lock name="contentbox.addNewContentVersion.#getSlug()#" type="exclusive" timeout="10" throwOnTimeout=true{
			// get a new version object
			var newVersion = contentVersionService.new(properties={
				content		= arguments.content,
				changelog 	= arguments.changelog
			});

			// join them to author and related content
			newVersion.setAuthor( arguments.author );
			newVersion.setRelatedContent( this );

			// Do we already have an active version?
			if( hasActiveContent() ){
				// deactive the curent version
				var activeVersion = getActiveContent();
				activeVersion.setIsActive( false );
				// increase the new version number
				newVersion.setVersion( activeVersion.getVersion() + 1 );
				// cap checks
				maxContentVersionChecks();
			}
			// Activate the new version
			newVersion.setIsActive( true );

			// Add it to the content so it can be saved as part of this content object
			addContentVersion( newVersion );
		}
		return this;
	}
	
	/**
	 * Returns a list of active related content for this piece of content
	 */
	public string function getRelatedContentIDs() {
		var relatedContentIDs = "";
		// if we have related content...
		if( hasRelatedContent() ) {
			// loop over related content and add ids to list
			for( var currentContent in getRelatedContent() ) {
				relatedContentIDs = listAppend( relatedContentIDs, currentContent.getContentID() );
			}
		}
		return relatedContentIDs;
	}

	/**
	 * Override the setRelatedContent
	 * @relatedContent.hint The related content to set
	 */
	BaseContent function setRelatedContent( required array relatedContent ) {
		if( hasRelatedContent() ) {
			variables.relatedContent.clear();
			variables.relatedContent.addAll( arguments.relatedContent );
		}
		else {
			variables.relatedContent = arguments.relatedContent;
		}
		return this;
	}

	/**
	* Inflates from comma-delimited list (or array) of id's
	* @relatedContent.hint The list or array of relatedContent ids
	*/
	BaseContent function inflateRelatedContent( required any relatedContent ){
		var allContent = [];
		// convert to array
		if( isSimpleValue( arguments.relatedContent ) ){
			arguments.relatedContent = listToArray( arguments.relatedContent );
		}
		// iterate over array
		for( var x=1; x <= arrayLen( arguments.relatedContent ); x++){
			var id 	= trim( arguments.relatedContent[ x ] );
			// get content from id
			var extantContent = contentService.get( id );
			// if found, add to array
			if( !isNull( extantContent ) ) {
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
	BaseContent function setComments(required array comments){
		if( hasComment() ){
			variables.comments.clear();
			variables.comments.addAll( arguments.comments );
		}
		else{
			variables.comments = arguments.comments;
		}
		return this;
	}
	
	/**
	* Override the setCustomFields
	*/
	BaseContent function setCustomFields(required array customFields){
		if( hasCustomField() ){
			variables.customFields.clear();
			variables.customFields.addAll( arguments.customFields );
		}
		else{
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
		if( !hasCustomField() ){ return results; }

		// iterate and create
		for( var thisField in variables.customFields ){
			results[ thisField.getKey() ] = thisField.getValue();
		}

		return results;
	}
	
	/**
	* Override the setContentVersions
	*/
	BaseContent function setContentVersions(required array contentVersions){
		if( hasContentVersion() ){
			variables.contentVersions.clear();
			variables.contentVersions.addAll( arguments.contentVersions );
		}
		else{
			variables.contentVersions = arguments.contentVersions;
		}
		return this;
	}
	
	/**
	* Override the setCategories
	*/
	BaseContent function setCategories(required array categories){
		
		// Relate the incoming suckers
		for( var oCat in arguments.categories ){
			if( !oCat.hasContent( this ) ){
				oCat.addContent( this );
			}
		}
		
		if( hasCategories() ){
			// loop and remove yourself from categories
			for( var oCat in variables.categories ){
				if( !arrayContains( arguments.categories, oCat ) ){
					oCat.removeContent( this );
				}
			}
		}
		
		variables.categories = arguments.categories;
		
		return this;
	}
	
	/*
	* I remove all category associations
	*/
	BaseContent function removeAllCategories(){
		if ( hasCategories() ){
			for(var oCat in variables.categories ){
				oCat.removeContent( this );
			}
			variables.categories.clear();
		}
		else{
			variables.categories = [];
		}
		return this;
	}

	/*
	* I remove all linked content associations
	*/
	BaseContent function removeAllLinkedContent(){
		if ( hasLinkedContent() ){
			for( var item in variables.linkedContent ){
				item.removeRelatedContent( this );
			}
		}
		return this;
	}

	/**
	* Bi directional add
	*/
	BaseContent function addCategories(required category){
		if( !hasCategories( arguments.category ) ){
			arguments.category.addContent( this );
			arrayAppend( variables.categories, arguments.category );
		}
		return this;
	}
	
	/**
	* Bi directional remove
	*/
	BaseContent function removeCategories(required category){
		if( hasCategories( arguments.category ) ){
			arguments.category.removeContent( this );
			arrayDelete( variables.categories, arguments.category );
		}
		return this;
	}
	
	/**
	* Override the setChildren
	*/
	BaseContent function setChildren(required array children){
		if( hasChild() ){
			variables.children.clear();
			variables.children.addAll( arguments.children );
		}
		else{
			variables.children = arguments.children;
		}
		return this;
	}
	
	/**
	* Get a flat representation of this entry
	* slugCache.hint Cache of slugs to prevent infinite recursions
	*/
	function getMemento( required array slugCache=[], counter=0 ){
		var pList = contentService.getPropertyNames();
		var result = {};
		
		// Do simple properties only
		for(var x=1; x lte arrayLen( pList ); x++ ){
			if( structKeyExists( variables, pList[ x ] ) ){
				if( isSimpleValue( variables[ pList[ x ] ] ) ){
					result[ pList[ x ] ] = variables[ pList[ x ] ];	
				}
			}
			else{
				result[ pList[ x ] ] = "";
			}
		}
		
		// Do Author Relationship
		if( hasCreator() ){
			result[ "creator" ] = {
				creatorID = getCreator().getAuthorID(),
				firstname = getCreator().getFirstname(),
				lastName = getCreator().getLastName(),
				email = getCreator().getEmail(),
				username = getCreator().getUsername()
			};
		}

		// Comments
		if( hasComment() ){
			result[ "comments" ] = [];
			for( var thisComment in variables.comments ){
				arrayAppend( result[ "comments" ], thisComment.getMemento() );	
			}
		}
		else{
			result[ "comments" ] = [];
		}
		// Custom Fields
		if( hasCustomField() ){
			result[ "customfields" ] = [];
			for( var thisField in variables.customfields ){
				arrayAppend( result[ "customfields" ], thisField.getMemento() );	
			}
		}
		else{
			result[ "customfields" ] = [];
		}
		// Versions
		if( hasContentVersion() ){
			result[ "contentversions" ] = [];
			for( var thisVersion in variables.contentversions ){
				arrayAppend( result[ "contentversions" ], thisVersion.getMemento() );	
			}
		}
		else{
			result[ "contentversions" ] = [];
		}
		// Parent
		if( hasParent() ){
			result[ "parent" ] = {
				contentID = getParent().getContentID(),
				slug = getParent().getSlug(),
				title = getParent().getTitle()
			};
		}
		// Children
		if( hasChild() ){
			result[ "children" ] = [];
			for( var thisChild in variables.children ){
				arrayAppend( result[ "children" ], thisChild.getMemento() );	
			}
		}
		else{
			result[ "children" ] = [];
		}
		// Categories
		if( hasCategories() ){
			result[ "categories" ] = [];
			for( var thisCategory in variables.categories ){
				arrayAppend( result[ "categories" ], thisCategory.getMemento() );
			}
		}
		else{
			result[ "categories" ] = [];
		}
		
		// Related Content
		result[ "relatedcontent" ] = [];
		if( hasRelatedContent() && !arrayFindNoCase( arguments.slugCache, getSlug() ) ) {	
			// add slug to cache
			arrayAppend( arguments.slugCache, getSlug() );		
			for( var content in variables.relatedContent ) {
				arrayAppend( result[ "relatedcontent" ], content.getMemento( slugCache=arguments.slugCache ) );
			}
		}
		return result;
	}
	
	private function maxContentVersionChecks(){
		if( !len( settingService.getSetting( "cb_versions_max_history" ) )  ){ return; }

		// How many versions do we have?
		var versionCounts = contentVersionService.newCriteria().isEq("relatedContent.contentID", getContentID() ).count();
		// Have we passed the limit?
		if( (versionCounts+1) GT settingService.getSetting( "cb_versions_max_history" ) ){
			var oldestVersion = contentVersionService.newCriteria()
				.isEq( "relatedContent.contentID", getContentID() )
				.isEq( "isActive", javaCast("boolean", false) )
				.withProjections( id="true" )
				.list( sortOrder="createdDate DESC", offset=settingService.getSetting( "cb_versions_max_history" ) - 2 );
			// delete by primary key IDs found
			contentVersionService.deleteByID( arraytoList( oldestVersion ) );
		}
	}

	/**
	* Get recursive slug paths to get ancestry, DEPRECATED.
	* @deprecated
	*/
	function getRecursiveSlug(separator="/"){
		var pPath = "";
		if( hasParent() ){ pPath = getParent().getRecursiveSlug(); }
		return pPath & arguments.separator & getSlug();
	}


	// Retrieves the latest content string from the latest version un-translated
	function getContent(){
		// return active content if we have any
		if( hasActiveContent() ){
			return getActiveContent().getContent();
		}
		// else return nothing.
		return '';
	}

	// Get the latest active content object, null if none has been assigned yet.
	function getActiveContent(){
		if( hasActiveContent() ){
			return activeContent[1];
		}
	}
	
	/**
	* Shorthand Creator name
	*/
	string function getCreatorName(){
		if( hasCreator() ){
			return getCreator().getName();
		}
		return '';
	}

	/**
	* Shorthand Creator email
	*/
	string function getCreatorEmail(){
		if( hasCreator() ){
			return getCreator().getEmail();
		}
		return '';
	}

	/**
	* Shorthand Author name from latest version
	*/
	string function getAuthorName(){
		if( hasActiveContent() ){
			return getActiveContent().getAuthorName();
		}
		return '';
	}

	/**
	* Shorthand Author email from latest version
	*/
	string function getAuthorEmail(){
		if( hasActiveContent() ){
			return getActiveContent().getAuthorEmail();
		}
		return '';
	}

	/**
	* Shorthand Author from latest version or null if any yet
	*/
	any function getAuthor(){
		if( hasActiveContent() ){
			return getActiveContent().getAuthor();
		}
	}

	/************************************** PUBLIC *********************************************/

	/**
	* Get parent ID if set or empty if none
	*/
	function getParentID(){
		if( hasParent() ){ return getParent().getContentID(); }
		return "";
	}

	/**
	* Get parent name or empty if none
	*/
	function getParentName(){
		if( hasParent() ){ return getParent().getTitle(); }
		return "";
	}

	/**
	* Bit that denotes if the content has expired or not, in order to be expired the content must have been published as well
	*/
	boolean function isExpired(){
		return ( isContentPublished() AND !isNull(expireDate) AND expireDate lte now() ) ? true : false;
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
	* is loaded?
	*/
	boolean function isLoaded(){
		return ( len( getContentID() ) ? true : false );
	}

	/**
	* Wipe primary key, and descendant keys, and prepare for cloning of entire hierarchies
	* @author.hint The author doing the cloning
	* @original.hint The original content object that will be cloned into this content object
	* @originalService.hint The ContentBox content service object
	* @publish.hint Publish pages or leave as drafts
	* @originalSlugRoot.hint The original slug that will be replaced in all cloned content
	* @newSlugRoot.hint The new slug root that will be replaced in all cloned content
	*/
	BaseContent function prepareForClone(required any author,
										 required any original,
										 required any originalService,
										 required boolean publish,
										 required any originalSlugRoot,
										 required any newSlugRoot){
		// set not published
		setIsPublished( arguments.publish);
		// reset creation date
		setCreatedDate( now() );
		setPublishedDate( now() );
		// reset hits
		hits = 0;
		// remove all comments
		comments = [];
		// get latest content versioning
		var latestContent = arguments.original.getActiveContent().getContent();
		// Original slug updates on all content
		latestContent = reReplaceNoCase(latestContent, "page\:\[#arguments.originalSlugRoot#\/", "page:[#arguments.newSlugRoot#/", "all");
		// reset versioning, and start with one
		addNewContentVersion(content=latestContent, changelog="Content Cloned!", author=arguments.author);
		
		// safe clone custom fields
		var newFields = arguments.original.getCustomFields();
		for(var thisField in newFields){
			var newField = customFieldService.new({key=thisField.getKey(),value=thisField.getValue()});
			newField.setRelatedContent( this );
			addCustomField( newField );
		}
		
		// safe clone categories
		var newCategories = arguments.original.getCategories();
		for(var thisCategory in newCategories){
			addCategories( categoryService.findBySlug( thisCategory.getSlug() ) );
		}
		
		// clone related content
		var newRelatedContent = arguments.original.getRelatedContent();
		for( var thisRelatedContent in newRelatedContent ) {
			addRelatedContent( thisRelatedContent );
		}

		// now clone children
		if( original.hasChild() ){
			var allChildren = original.getChildren();
			// iterate and copy
			for(var thisChild in allChildren){
				var newChild = originalService.new();
				// attach to new parent copy
				newChild.setParent( this );
				// attach creator
				newChild.setCreator( arguments.author );
				// Setup the Page Title
				newChild.setTitle( thisChild.getTitle() );
				// Create the new hierarchical slug
				newChild.setSlug( this.getSlug() & "/" & listLast( thisChild.getSlug(), "/" ) );
				// now deep clone until no more child is left behind.
				newChild.prepareForClone(author=arguments.author,
										 original=thisChild,
										 originalService=originalService,
										 publish=arguments.publish,
										 originalSlugRoot=arguments.originalSlugRoot,
										 newSlugRoot=arguments.newSlugRoot);
				// now attach it
				addChild( newChild );
			}
		}
		// evict original entity, just in case
		contentService.evictEntity( arguments.original );

		return this;
	}

	/**
	* Get display publishedDate
	*/
	string function getPublishedDateForEditor(boolean showTime=false){
		var pDate = getPublishedDate();
		if( isNull(pDate) ){ pDate = now(); }
		// get formatted date
		var fDate = dateFormat( pDate, "yyyy-mm-dd" );
		if( arguments.showTime ){
			fDate &=" " & timeFormat(pDate, "hh:mm:ss tt");
		}
		return fDate;
	}

	/**
	* Get display expireDate
	*/
	string function getExpireDateForEditor(boolean showTime=false){
		var pDate = getExpireDate();
		if( isNull(pDate) ){ pDate = ""; }
		// get formatted date
		var fDate = dateFormat( pDate, "yyyy-mm-dd" );
		if( arguments.showTime ){
			fDate &=" " & timeFormat(pDate, "hh:mm:ss tt");
		}
		return fDate;
	}

	/**
	* Get display publishedDate
	*/
	string function getDisplayPublishedDate(){
		var publishedDate = getPublishedDate();
		return dateFormat( publishedDate, "mm/dd/yyyy" ) & " " & timeFormat(publishedDate, "hh:mm:ss tt");
	}

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}

	/**
	* Get formatted expireDate
	*/
	string function getDisplayExpireDate(){
		if( isNull(expireDate) ){ return "N/A"; }
		return dateFormat( expireDate, "mm/dd/yyyy" ) & " " & timeFormat(expireDate, "hh:mm:ss tt");
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
	any function addPublishedTime(required hour, required minute){
		if( !isDate( getPublishedDate() ) ){ return this; }
		var time = timeformat("#arguments.hour#:#arguments.minute#", "hh:MM:SS tt");
		setPublishedDate( getPublishedDate() & " " & time);
		return this;
	}

	/**
	* add expired timestamp to property
	*/
	any function addExpiredTime(required hour, required minute){
		if( !isDate( getExpireDate() ) ){ return this; }
		var time = timeformat("#arguments.hour#:#arguments.minute#", "hh:MM:SS tt");
		setExpireDate( getExpireDate() & " " & time);
		return this;
	}

	/**
	* Build content cache keys according to sent content object
	*/
	string function buildContentCacheKey(){
		return "cb-content-#getContentType()#-#getContentID()#";
	}

	/**
	* Verify we can do content caching on this content object using global and local rules
	*/
	boolean function canCacheContent(){
		var settings = settingService.getAllSettings(asStruct=true);

		// check global caching first
		if( (getContentType() eq "page" AND settings.cb_content_caching) OR (getContentType() eq "entry" AND settings.cb_entry_caching)	){
			// check override?
			return ( getCache() ? true : false );
		}
		return false;
	}

	boolean function isPage() {
		return getContentType()=="Page" ? true : false;
	}

	boolean function isEntry() {
		return getContentType()=="Entry" ? true : false;
	}

	boolean function isContentStore() {
		return getContentType()=="ContentStore" ? true : false;
	}

	/**
	* Render content out using translations, caching, etc.
	*/
	any function renderContent() profile{
		var settings = settingService.getAllSettings(asStruct=true);

		// caching enabled?
		if( canCacheContent() ){
			// Build Cache Key
			var cacheKey = buildContentCacheKey();
			// Get appropriate cache provider
			var cache = cacheBox.getCache( settings.cb_content_cacheName );
			// Try to get content?
			var cachedContent = cache.get( cacheKey );
			// Verify it exists, if it does, return it
			if( !isNull( cachedContent ) AND len( cachedContent ) ){ return cachedContent; }
		}

		// Check if we need to translate
		if( NOT len(renderedContent) ){
			lock name="contentbox.contentrendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len(renderedContent) ){
					// save content
					renderedContent = renderContentSilent();
				}
			}
		}

		// caching enabled?
		if( canCacheContent() ){
			// Store content in cache, of local timeouts are 0 then use global timeouts.
			cache.set(cacheKey,
					  renderedContent,
					  (getCacheTimeout() eq 0 ? settings.cb_content_cachingTimeout : getCacheTimeout()),
					  (getCacheLastAccessTimeout() eq 0 ? settings.cb_content_cachingTimeoutIdle : getCacheLastAccessTimeout()) );
		}

		// renturn translated content
		return renderedContent;
	}

	/**
	* Renders the content silently so no caching, or extra fluff is done, just content translation rendering.
	* @content.hint The content markup to translate, by default it uses the active content version's content
	*/
	any function renderContentSilent(any content=getContent()) profile{
		// render content out, prepare builder
		var b = createObject("java","java.lang.StringBuilder").init( arguments.content );

		// announce renderings with data, so content renderers can process them
		var iData = {
			builder = b,
			content	= this
		};
		interceptorService.processState("cb_onContentRendering", iData);

		// return processed content
		return b.toString();
	}

	/**
	* Inflate custom fields from the incoming count and memento structure
	*/
	any function inflateCustomFields(required numeric fieldCount, required struct memento){

		// remove original custom fields
		getCustomFields().clear();

		// inflate custom fields start at 0 as it is incoming javascript counting of arrays
		for( var x=0; x lt arguments.fieldCount; x++ ){
			// get custom field from incoming data
			var args = {
				key 	= arguments.memento["CustomFieldKeys_#x#"],
				value 	= arguments.memento["CustomFieldValues_#x#"]
			};
			// only add if key has value
			if( len(trim( args.key )) ){
				var thisField = customFieldService.new(properties=args);
				thisField.setRelatedContent( this );
				addCustomField( thisField );
			}
		}

		return this;
	}

	/**
	* get flat categories list
	*/
	function getCategoriesList(){
		if( NOT hasCategories() ){ return "Uncategorized"; }
		var cats 	= getCategories();
		var catList = [];
		for(var x=1; x lte arrayLen(cats); x++){
			arrayAppend( catList , cats[x].getCategory() );
		}
		return replace(arrayToList( catList ), ",",", ","all");
	}

}