/**
* Setting Service for BlogBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton{
	
	// DI
	property name="cache" inject="cachebox:default";
	property name="requestService" inject="coldbox:requestService";
	
	/**
	* Constructor
	*/
	SettingService function init(){
		// init it
		super.init(entityName="bbSetting");
		// settings cache key
		cacheKey = "bb-settings";
		
		return this;
	}
	
	/**
	* Get all settings
	*/
	function getAllSettings(asStruct=false){
		// retrieve from cache
		var settings = cache.get( cacheKey );
	
		// found in cache?
		if( isNull(settings) ){
			// not found, so query db
			var settings = list(sortOrder="name");	
		}
		
		// convert to struct
		if( arguments.asStruct ){
			var s = {};
			for(var x=1; x lte settings.recordcount; x++){
				s[ settings.name[x] ] = settings.value[x];
			}
			return s;
		}
		
		return settings;
	}
	
	/**
	* flush settings cache
	*/
	function flushSettingsCache(){
		cache.clear( cacheKey );
	}
	
}