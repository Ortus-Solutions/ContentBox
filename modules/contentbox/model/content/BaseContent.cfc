/**
* A mapped super class used for contentbox content: entries and pages
*/
component persistent="true" entityname="cbContent" table="cb_content" discriminatorColumn="contentType"{
	
	// DI Injections
	property name="cachebox" 				inject="cachebox" 					persistent="false";
	property name="settingService"			inject="id:settingService@cb" 		persistent="false";
	property name="interceptorService"		inject="coldbox:interceptorService" persistent="false";
	property name="customFieldService" 	 	inject="customFieldService@cb" 		persistent="false";
	property name="contentVersionService"	inject="contentVersionService@cb"	persistent="false";
	
	// Non-Persistable Properties
	property name="renderedContent" persistent="false";
	
	// Properties
	property name="contentID" 			notnull="true"	fieldtype="id" generator="native" setter="false";
	property name="contentType" 		notnull="true"	setter="false" update="false" insert="false" index="idx_discriminator,idx_published";
	property name="title"				notnull="true"  length="200" default="" index="idx_search";
	property name="slug"				notnull="true"  length="200" default="" unique="true" index="idx_slug,idx_publishedSlug";
	property name="createdDate" 		notnull="true"  ormtype="timestamp" update="false" index="idx_createdDate";
	property name="publishedDate"		notnull="false" ormtype="timestamp" idx="idx_publishedDate";
	property name="isPublished" 		notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_published,idx_search,idx_publishedSlug";
	property name="allowComments" 		notnull="true"  ormtype="boolean" default="true" dbdefault="1";
	property name="passwordProtection" 	notnull="false" length="100" default="" index="idx_published";
	property name="HTMLKeywords"		notnull="false" length="160" default="";
	property name="HTMLDescription"		notnull="false" length="160" default="";
	property name="hits"				notnull="false" ormtype="long" default="0" dbdefault="0";

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
	
	// Calculated Fields
	property name="numberOfVersions" 			formula="select count(*) from cb_contentVersion cv where cv.FK_contentID=contentID" default="0";
	property name="numberOfComments" 			formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID" default="0";
	property name="numberOfApprovedComments" 	formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID and comment.isApproved = 1" default="0";
	
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
			
			// Set the right versions if we have already content
			if( hasActiveContent() ){
				// deactive the curent one
				var activeVersion = getActiveContent();
				activeVersion.setIsActive( false );
				newVersion.setVersion( activeVersion.getVersion() + 1 );
			}
			// Activate the version
			newVersion.setIsActive( true );
			
			// Add it to the content so it can be saved.
			addContentVersion( newVersion );
		}
		return this;
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
	
	/************************************** PUBLIC *********************************************/
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getContentID() );
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
	* Get display publishedDate
	*/
	string function getDisplayPublishedDate(){
		var publishedDate = getPublishedDate();
		return dateFormat( publishedDate, "mm/dd/yyy" ) & " " & timeFormat(publishedDate, "hh:mm:ss tt");
	}
	
	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}
		
	/**
	* isPassword Protected
	*/
	boolean function isPasswordProtected(){
		return len( getPasswordProtection() );
	}
	
	/**
	* addPublishedtime
	*/
	any function addPublishedtime(hour,minute){
		var time = timeformat("#arguments.hour#:#arguments.minute#", "hh:MM:SS tt");
		setPublishedDate( getPublishedDate() & " " & time);
		return this;
	}
	
	/**
	* Build content cache keys according to sent content object
	*/
	string function buildContentCacheKey(){
		return "cb-content-#getContentType()#-#getContentID()#";
	}
	
	/**
	* Render content out
	*/
	any function renderContent(){
		var settings = settingService.getAllSettings(asStruct=true);
		
		// caching enabled?
		if( (getContentType() eq "page" AND settings.cb_content_caching) OR 
			(getContentType() eq "entry" AND settings.cb_entry_caching)
		){
			// Build Cache Key
			var cacheKey = buildContentCacheKey();
			// Get appropriate cache provider
			var cache = cacheBox.getCache( settings.cb_content_cacheName );
			// Try to get content?
			var cachedContent = cache.get( cacheKey );
			// Verify it exists, if it does, return it
			if( !isNull( cachedContent ) ){ return cachedContent; }
		}
		
		// Check if we need to translate
		if( NOT len(renderedContent) ){
			lock name="contentbox.contentrendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len(renderedContent) ){
					// else render content out, prepare builder
					var b = createObject("java","java.lang.StringBuilder").init( getContent() );
					
					// announce renderings with data, so content renderers can process them
					var iData = {
						builder = b,
						content	= this
					};
					interceptorService.processState("cb_onContentRendering", iData);
					
					// save content
					renderedContent = b.toString();
				}
			}
		}
		
		// caching enabled?
		if( (getContentType() eq "page" AND settings.cb_content_caching) OR 
			(getContentType() eq "entry" AND settings.cb_entry_caching)
		){
			// Store content in cache	
			cache.set(cacheKey, renderedContent, settings.cb_content_cachingTimeout, settings.cb_content_cachingTimeoutIdle);
		}
		
		// renturn translated content
		return renderedContent;
	}
	
	/**
	* Inflate custom fields from a list of keys and values, it will remove original custom values as well.
	*/
	any function inflateCustomFields(required string keys, required string values){
		
		// remove original custom fields
		getCustomFields().clear();
		
		// inflate custom fields
		arguments.keys   = listToArray(arguments.keys,",");
		arguments.values = listToArray(arguments.values,",");
		for(var x=1; x lte arrayLen(arguments.keys); x++){
			if( len(trim(arguments.keys[x])) ){
				var args = { key = arguments.keys[x], value="" };
				if( arrayIsDefined(arguments.values, x) ){
					args.value = arguments.values[x];
				}
				var thisField = customFieldService.new(properties=args);
				thisField.setRelatedContent( this );
				addCustomField( thisField );
			}
		}
		return this;
	}
	
	/**
	* Update a content's hits
	*/
	any function updateHits(){
		var q = new Query(sql="UPDATE cb_content SET hits = hits + 1 WHERE contentID = #getContentID()#").execute();
		return this;
	}
}