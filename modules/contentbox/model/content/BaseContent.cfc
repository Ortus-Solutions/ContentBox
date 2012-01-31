/**
* A mapped super class used for contentbox content: entries and pages
*/
component persistent="true" entityname="cbContent" table="cb_content" discriminatorColumn="contentType"{
	
	// DI Injections
	property name="cachebox" 			inject="cachebox" 					persistent="false";
	property name="settingService"		inject="id:settingService@cb" 		persistent="false";
	property name="interceptorService"	inject="coldbox:interceptorService" persistent="false";
	property name="customFieldService"  inject="customFieldService@cb" 		persistent="false";
	
	// Non-Persistable
	property name="renderedContent" persistent="false";
	
	// Properties
	property name="contentID" 			notnull="true"	fieldtype="id" generator="native" setter="false";
	property name="contentType" 		notnull="true"	setter="false" update="false" insert="false" index="idx_discriminator";
	property name="title"				notnull="true"  length="200" default="" index="idx_search";
	property name="slug"				notnull="true"  length="200" default="" unique="true" index="idx_slug,idx_publishedSlug";
	property name="content"    			notnull="true"  ormtype="text" length="8000";
	property name="createdDate" 		notnull="true"  ormtype="timestamp" update="false" index="idx_createdDate";
	property name="publishedDate"		notnull="false" ormtype="timestamp" idx="idx_publishedDate";
	property name="isPublished" 		notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_published,idx_search,idx_publishedSlug";
	property name="allowComments" 		notnull="true"  ormtype="boolean" default="true" dbdefault="1";
	property name="passwordProtection" 	notnull="false" length="100" default="" index="idx_published";
	property name="HTMLKeywords"		notnull="false" length="160" default="";
	property name="HTMLDescription"		notnull="false" length="160" default="";
	property name="hits"				notnull="false" ormtype="long" default="0" dbdefault="0";

	// M20 -> Author loaded as a proxy and fetched immediately
	property name="author" cfc="contentbox.model.security.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true" fetch="join";
	
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25" orderby="createdDate"
			  cfc="contentbox.model.comments.Comment" fkcolumn="FK_contentID" inverse="true" cascade="all-delete-orphan"; 
	
	// O2M -> CustomFields
	property name="customFields" singularName="customField" fieldtype="one-to-many" type="array" lazy="extra" batchsize="10"
			  cfc="contentbox.model.content.CustomField" fkcolumn="FK_contentID" inverse="true" cascade="all-delete-orphan"; 
	
	// NON-persistent content type discriminator
	property name="type" persistent="false" type="string" hint="Valid content types are page,entry";
	
	// Calculated Fields
	property name="numberOfComments" 			formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID" default="0";
	property name="numberOfApprovedComments" 	formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID and comment.isApproved = 1" default="0";
	
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
	* Shorthand Author name
	*/
	string function getAuthorName(){
		return getAuthor().getName();
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
		return "cb-content-#getType()#-#getContentID()#";
	}
	
	/**
	* Render content out
	*/
	any function renderContent(){
		var settings = settingService.getAllSettings(asStruct=true);
		
		// caching enabled?
		if( (getType() eq "page" AND settings.cb_content_caching) OR 
			(getType() eq "entry" AND settings.cb_entry_caching)
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
			lock name="cb1.contentrendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len(renderedContent) ){
					// else render content out, prepare builder
					var b = createObject("java","java.lang.StringBuilder").init( content );
					
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
		if( (getType() eq "page" AND settings.cb_content_caching) OR 
			(getType() eq "entry" AND settings.cb_entry_caching)
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
				addCustomField( customFieldService.new(properties=args).setRelatedContent( this ) );
			}
		}
		return this;
	}

}