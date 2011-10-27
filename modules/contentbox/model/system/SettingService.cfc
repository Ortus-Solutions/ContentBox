/**
* Setting Service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton{
	
	// DI properties
	property name="cache" inject="cachebox:default";
	
	// Properties
	property name="settingsCacheKey" type="string";
	 
	/**
	* Constructor
	*/
	SettingService function init(){
		// init it
		super.init(entityName="cbSetting");
		// settings cache key
		setSettingsCacheKey("cb-settings");
		return this;
	}
	
	/**
	* Check if contentbox has been installed by checking if there are no settings and no cb_active ONLY
	*/
	boolean function isCBReady(){
		if( count() AND countWhere(name="cb_active") ){ return true; }
		return false;
	}
	
	/**
	* Mark cb as ready to serve
	*/
	function activateCB(){
		var s = new(properties={name="cb_active",value="true"});
		save( s );
		return this;
	}
	
	/**
	* Get a setting
	*/
	function getSetting(required name,defaultValue){
		var s = getAllSettings(asStruct=true);
		if( structKeyExists(s,arguments.name) ){
			return s[arguments.name];
		}
		if( structKeyExists(arguments,"defaultValue") ){
			return arguments.defaultValue;
		}
		throw(message="Setting #arguments.name# not found in settings collection",
			  detail="Registered settings are: #structKeyList(s)#",
			  type="contentbox.SettingService.SettingNotFound");
	}
	
	/**
	* Get all settings
	*/
	function getAllSettings(asStruct=false){
		// retrieve from cache
		var settings = cache.get( settingsCacheKey );
	
		// found in cache?
		if( isNull(settings) ){
			// not found, so query db
			var settings = list(sortOrder="name");	
			// cache them for an hour
			cache.set(settingsCacheKey,settings,60);
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
		cache.clear( settingsCacheKey );
	}
	
	/**
	* Bulk saving of options using a memento structure of options
	*/
	any function bulkSave(struct memento){
		var settings 	= getAllSettings(asStruct=true);
		var oOption  	= "";
		var newOptions 	= [];
		
		// iterate over settings
		for(var key in settings){
			// save only sent in setting keys
			if( structKeyExists(memento, key) ){
				oOption = findWhere({name=key});
				oOption.setValue( memento[key] );
				arrayAppend( newOptions, oOption );
			}						
		}
		
		// save new settings and flush cache
		saveAll( newOptions );
		flushSettingsCache();
		
		return this;
	}
	
}