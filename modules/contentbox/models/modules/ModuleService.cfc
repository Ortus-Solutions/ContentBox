/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage ContentBox Modules
*/
component extends="cborm.models.VirtualEntityService" accessors="true" singleton threadsafe{

	// Dependecnies
	property name="settingService"			inject="id:settingService@cb";
	property name="contentBoxSettings"		inject="coldbox:moduleConfig:contentbox";
	property name="coldboxModuleService"	inject="coldbox:moduleService";
	property name="log"						inject="logbox:logger:{this}";
	property name="zipUtil" 				inject="zipUtil@cb";


	// Local properties
	property name="modulesPath" type="string";
	property name="modulesInvocationPath" type="string";
	property name="moduleWidgetCache" type="struct";

	/**
	* Constructor
	*/
	ModuleService function init(){
		// init it
		super.init( entityName="cbModule" );
		modulesPath 			= "";
		modulesInvocationPath 	= "";
		moduleWidgetCache 		= {};
		return this;
	}

	/**
	* onDIComplete
	*/
	function onDIComplete(){
		modulesPath 			= contentBoxSettings.path & "/modules_user";
		modulesInvocationPath 	= contentBoxSettings.invocationPath & ".modules_user";
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
		if( structKeyExists(arguments.config,"forgeboxslug" ) ){
			module.setForgeBoxSlug( arguments.config.forgeboxSlug );
		}
		return module;
	}

	/**
	* findModuleByEntryPoint
	*/
	Module function findModuleByEntryPoint(required entryPoint){
		var module = findWhere( {entryPoint=arguments.entryPoint} );
		return ( isNull(module) ? new() : module );
	}

	/**
	* findModules
	* @isActive.hint The active criteria, true, false or any for all modules
	*/
	struct function findModules(isActive="any" ){
		var results = {};
		var criteria = newCriteria();

		// isApproved filter
		if( structKeyExists(arguments,"isActive" ) AND arguments.isActive NEQ "any" ){
			criteria.eq( "isActive", javaCast( "Boolean", arguments.isActive ) );
		}
		// run criteria query and projections count
		results.count 	 = criteria.count();
		results.modules  = criteria.list(sortOrder="title",asQuery=false);

		return results;
	}
	
	/**
	 * gets path for requested widget from modules' widget cache
	 * @widgetName {String}
	 * returns String
	 */
	string function getModuleWidgetPath( required string widgetName ) {
		var path = "";
		// if widget name is in module widget cache, return its path
		if( structKeyExists( moduleWidgetCache, arguments.widgetName ) ) {
			path = moduleWidgetCache[ arguments.widgetName ];
		}
		else {
			log.error( "Could not find #arguments.widgetname# widget in the module." );	
		}
		return path;
	}
	
	/**
	* Register a new module and return the module representation, this does not activate, just registers
	*/
	Module function registerNewModule(required name){
		if( fileExists( modulesPath & "/#arguments.name#/ModuleConfig.cfc" ) ){
			var config = createObject( "component", modulesInvocationPath & ".#arguments.name#.ModuleConfig" );
			var module = new();
			module.setName( arguments.name );
			populateModule( module, config );
			save( module );
			return module;
		}
		else{
			log.error( "Cannot register new module #arguments.name# as it is not a valid ContentBox Module. No ModuleConfig.cfc found." );
		}
		return new();
	}

	/**
	* Deactivate a module from ContentBox
	*/
	ModuleService function deactivateModule(required name){
		var module = findWhere( {name=arguments.name} );
		// deactivate record
		module.setIsActive( false );
		// Call deactivate on module if it exists
		var configCache = coldboxModuleService.getModuleConfigCache();
		if( structKeyExists(configCache, arguments.name) ){
			var config = configCache[arguments.name];
			// Call deactivate if it exists
			if( structKeyExists(config,"onDeactivate" ) ){
				config.onDeactivate();
			}
			// deactivate from ColdBox
			coldboxModuleService.unload( arguments.name );
			detachColdBoxModuleRegistration( arguments.name );
		}
		// save deactivated module status
		save( module );
		//rebuild widgets cache
		buildModuleWidgetsCache();
		
		return this;
	}

	/**
	* Detach coldbox module configuration registrations
	*/
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
		var module = findWhere( {name=arguments.name} );
		// Set module as active
		module.setIsActive( true );
		// detach from coldbox just in case
		detachColdBoxModuleRegistration( arguments.name );
		// Activate module in ColdBox
		coldboxModuleService.registerAndActivateModule(arguments.name, modulesInvocationPath);
		// Get loaded configuration object
		var config = coldboxModuleService.getModuleConfigCache()[arguments.name];
		// Repopulate module, just in case
		populateModule( module, config );
		// Call activate now if found
		if( structKeyExists(config,"onActivate" ) ){
			try{
				config.onActivate();
			}
			catch(Any e){
				// deactivate module, it did not activate correctly
				module.setIsActive( false );
				// deactivate from ColdBox as it did not activate correctly
				coldboxModuleService.unload( arguments.name );
				detachColdBoxModuleRegistration( arguments.name );
				// Now throw the exception
				rethrow;
			}
		}
		// save module status
		save( module );
		//rebuild widgets cache
		buildModuleWidgetsCache();
		
		return this;
	}

	/**
	* Delete Module, should only be done on deactivated modules
	*/
	ModuleService function deleteModule(required name){
		var args = {"name" = arguments.name};
		var configPath = modulesInvocationPath & ".#name#.ModuleConfig";
		
		// Try to do an onDelete() callback.
		var config = createObject( "component", configPath);
		if( structKeyExists( config, "onDelete" ) ){
			config.onDelete();
		}
		
		// Now delete it		
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
		// Get Core Modules From Disk
		var qModules = getModulesOnDisk( modulesPath );
		// Register each module as it is found on disk
		for(var x=1; x lte qModules.recordCount; x++){
			// Only look at directories
			if( qModules.type[ x ] eq "dir" and left(qModules.name[ x ],1) neq '.'){
				var moduleName = qModules.name[ x ];
				var thisModule = findWhere( {name=moduleName} );
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
		// build widget cache
		buildModuleWidgetsCache();
		return this;
	}

	/**
	* Upload Module, returns structure with [error:boolean, logInfo=string]
	*/
	struct function uploadModule(required fileField){
		var destination 	= getModulesPath();
		var installLog 		= createObject( "java","java.lang.StringBuilder" ).init( "" );
		var results 		= {error=true, logInfo=""};

		// Upload the module zip
		var fileResults = fileUpload(destination, arguments.fileField, "application/octet-stream,application/x-zip-compressed,application/zip", "overwrite" );

		// Unzip File?
		if ( listLast(fileResults.clientFile, "." ) eq "zip" ){
			// test zip has files?
			try{
				var listing = zipUtil.list( "#destination#/#fileResults.clientFile#" );
			}
			catch(Any e){
				// bad zip file.
				installLog.append( "Error getting listing of zip archive (#destination#/#fileResults.clientFile#), bad zip, file will be removed.<br />" );
				fileDelete( destination & "/" & fileResults.clientFile );
				// flatten messages;
				results.logInfo = installLog.toString();
				return results;
			}
			// extract it
			zipUtil.extract(zipFilePath="#destination#/#fileResults.clientFile#", extractPath="#destination#" );
			// Removal of Mac stuff
			if( directoryExists( destination & "/__MACOSX" ) ){
				directoryDelete( destination & "/__MACOSX", true);
			}
			// rescan and startup the modules
			startup();
			// success
			results.error = false;
		}
		else{
			installLog.append( "File #fileResults.clientFile# is not a zip file, so cannot extract it or use it, file will be removed.<br/>" );
			fileDelete( destination & "/" & fileResults.clientFile );
		}
		// flatten messages;
		results.logInfo = installLog.toString();
		// return results
		return results;
	}

	/**
     * Iterates over all registered, active modules and sets any found widgets into a cache in moduleservice
     * return null
     */
	private void function buildModuleWidgetsCache() {
		// get all active modules
		var activeModules = findModules( isActive=true );
		var cache = {};
		// loop over active modules
		for( var module in activeModules.modules ) {
			// Widgets path
			var thisWidgetsPath = modulesPath & "/" & module.getName() & "/widgets";
			// check that module widgets folder exists on disk, if so, iterate and register
			if( directoryExists( thisWidgetsPath ) ) {
				var directory = directoryList( thisWidgetsPath, false, "query" );
				// make sure there are widgets in the directory
				if( directory.recordCount ) {
					var moduleWidgets = [];
					// loop over widgets
    				for( var i=1; i <= directory.recordCount; i++ ) {
    					// set widget properties in cache
    					var widgetName = reReplaceNoCase( directory.name[ i ], ".cfc", "", "all" );
    					var widget = {
    						name = widgetName,
    						path = modulesInvocationPath & ".#module.getName()#.widgets.#widgetName#"
    					};
    					cache[ widgetName & "@" & module.getName() ] = widget.path;
    				}
    				
    			}
			}
		}
		// Store constructed cache
		moduleWidgetCache = cache;
	}

	private query function getModulesOnDisk(required path){
		return directoryList( arguments.path, false, "query", "", "name asc" );
	}
}
