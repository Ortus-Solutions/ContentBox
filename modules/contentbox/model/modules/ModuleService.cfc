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
* Manage ContentBox Modules
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton{

	// Dependecnies
	property name="settingService"			inject="id:settingService@cb";
	property name="contentBoxSettings"		inject="coldbox:moduleConfig:contentbox";
	property name="coldboxModuleService"	inject="coldbox:moduleService";
	property name="log"						inject="logbox:logger:{this}";
	property name="zipUtil" 				inject="coldbox:plugin:Zip";


	// Local properties
	property name="modulesPath" type="string";
	property name="modulesInvocationPath" type="string";

	/**
	* Constructor
	*/
	ModuleService function init(){
		// init it
		super.init(entityName="cbModule");
		modulesPath = "";
		modulesInvocationPath = "";
		return this;
	}

	/**
	* onDIComplete
	*/
	function onDIComplete(){
		modulesPath = contentBoxSettings.path & "/modules";
		modulesInvocationPath = contentBoxSettings.invocationPath & ".modules";
	}

	/**
	* Populate module from Module Configuration CFC and returns the module
	*/
	any function populateModule(any module, any config){
		module.setTitle( arguments.config.title );
		module.setAuthor( arguments.config.author );
		module.setWebURL( arguments.config.webURL );
		module.setDescription( arguments.config.description );
		module.setVersion( arguments.config.version );
		module.setEntryPoint( arguments.config.entryPoint );
		if( structKeyExists(arguments.config,"forgeboxslug") ){
			module.setForgeBoxSlug( arguments.config.forgeboxSlug );
		}
		return module;
	}

	/**
	* findModuleByEntryPoint
	*/
	Module function findModuleByEntryPoint(required entryPoint){
		var module = findWhere({entryPoint=arguments.entryPoint});
		return ( isNull(module) ? new() : module );
	}

	/**
	* findModules
	* @isActive.hint The active criteria, true, false or any for all modules
	*/
	struct function findModules(isActive="any"){
		var results = {};
		var criteria = newCriteria();

		// isApproved filter
		if( structKeyExists(arguments,"isActive") AND arguments.isActive NEQ "any"){
			criteria.eq("isActive", javaCast("boolean",arguments.isActive));
		}
		// run criteria query and projections count
		results.count 	 = criteria.count();
		results.modules  = criteria.list(sortOrder="title",asQuery=false);

		return results;
	}

	/**
	* Register a new module and return the module representation, this does not activate, just registers
	*/
	Module function registerNewModule(required name){
		if( fileExists( modulesPath & "/#arguments.name#/ModuleConfig.cfc") ){
			var config = createObject("component", modulesInvocationPath & ".#arguments.name#.ModuleConfig");
			var module = new();
			module.setName( arguments.name );
			populateModule( module, config );
			save( module );
			return module;
		}
		else{
			log.error("Cannot register new module #arguments.name# as it is not a valid ContentBox Module. No ModuleConfig.cfc found.");
		}
		return new();
	}

	/**
	* Deactivate a module from ContentBox
	*/
	ModuleService function deactivateModule(required name){
		var module = findWhere({name=arguments.name});
		module.setIsActive( false );
		// Call deactivate on module if it exists
		var configCache = coldboxModuleService.getModuleConfigCache();
		if( structKeyExists(configCache, arguments.name) ){
			var config = configCache[arguments.name];
			// Call deactivate if it exists
			if( structKeyExists(config,"onDeactivate") ){
				config.onDeactivate();
			}
			// deactivate from ColdBox
			coldboxModuleService.unload( arguments.name );
			detachColdBoxModuleRegistration( arguments.name );
		}
		// save deactivated module
		save( module );

		return this;
	}

	 private ModuleService function detachColdBoxModuleRegistration(required name){
		// Verify in module registry
		if( structKeyExists(coldboxModuleService.getModuleRegistry(), arguments.name) ){
			structDelete( coldboxModuleService.getModuleRegistry(), arguments.name );
		}
		return this;
	}

	/**
	* Activate a module from ContentBox
	*/
	ModuleService function activateModule(required name){
		var module = findWhere({name=arguments.name});
		module.setIsActive( true );
		// detach from coldbox just in case
		detachColdBoxModuleRegistration( arguments.name );
		// Activate module in ColdBox
		coldboxModuleService.registerAndActivateModule(arguments.name, modulesInvocationPath);
		// Get loaded configuration object
		var config = coldboxModuleService.getModuleConfigCache()[arguments.name];
		// Repopulate module, just in case
		populateModule( module, config );
		// save activated module
		save( module );
		// Call activate now if found
		if( structKeyExists(config,"onActivate") ){
			config.onActivate();
		}

		return this;
	}

	/**
	* Delete Module, should only be done on deactivated modules
	*/
	ModuleService function deleteModule(required name){
		var args = {"name" = arguments.name};
		deleteWhere(argumentCollection=args);
		if( directoryExists( modulesPath & "/#arguments.name#" ) ){
			directoryDelete( modulesPath & "/#arguments.name#", true );
		}
		return this;
	}

	/**
	* Reset all modules by deactivating all of them and cleaning our db history
	*/
	ModuleService function resetModules(){
		var modules = list(asQuery=false);
		for(var thisModule in modules){
			deactivateModule( thisModule.getName() );
		}
		// remove all modules
		deleteAll();
		// now start them up again
		startup();

		return this;
	}

	/**
	* Startup the modules
	*/
	ModuleService function startup(){
		var qModules = getModulesOnDisk();
		// Register each module as it is found on disk
		for(var x=1; x lte qModules.recordCount; x++){
			// Only look at directories
			if( qModules.type[x] eq "dir" ){
				var moduleName = qModules.name[x];
				var thisModule = findWhere({name=moduleName});
				// check if module already in database records or new
				if( isNull(thisModule) ){
					// new record, so register it
					thisModule = registerNewModule( moduleName );
				}
				// If we get here, the module is loaded in the database now
				if( thisModule.getIsActive() AND not structKeyExists(coldboxModuleService.getModuleRegistry(), moduleName)){
					// load only active modules via ColdBox if they are not loaded already
					coldboxModuleService.registerAndActivateModule(moduleName, modulesInvocationPath);
				}
			}
		}
		return this;
	}

	/**
	* Upload Module
	*/
	ModuleService function uploadModule(required fileField){
		var destination = getModulesPath();
		var results = fileUpload(destination,arguments.fileField,"application/zip","overwrite");
		// extract it
		zipUtil.extract(zipFilePath="#destination#/#results.clientFile#", extractPath="#destination#");
		// rescan
		startup();
		return this;
	}

	private query function getModulesOnDisk(){
		return directoryList( modulesPath,false,"query","","name asc");
	}
}