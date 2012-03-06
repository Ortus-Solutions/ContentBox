/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
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
		var args = { "name" = "cb_active" };
		if( countWhere(argumentCollection=args) ){ return true; }
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

	/**
	* Build file browser settings structure
	*/
	struct function buildFileBrowserSettings(){
		var cbSettings = getAllSettings(asStruct=true);
		var settings = {
			directoryRoot	= cbSettings.cb_media_directoryRoot,
			createFolders	= cbSettings.cb_media_createFolders,
			deleteStuff		= cbSettings.cb_media_allowDelete,
			allowDownload	= cbSettings.cb_media_allowDownloads,
			allowUploads	= cbSettings.cb_media_allowUploads,
			acceptMimeTypes	= cbSettings.cb_media_acceptMimeTypes,
			quickViewWidth	= cbSettings.cb_media_quickViewWidth,
			uploadify = {
				fileDesc 	= cbSettings.cb_media_uplodify_fileDesc,
				fileExt 	= cbSettings.cb_media_uplodify_fileExt,
				multi 		= cbSettings.cb_media_uploadify_allowMulti,
				sizeLimit 	= cbSettings.cb_media_uploadify_sizeLimit,
				customJSONOptions = cbSettings.cb_media_uploadify_customOptions
			}
		};
		return settings;
	}

}