/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage ContentBox Modules
*/
component extends="cborm.models.VirtualEntityService" accessors="true" singleton threadsafe{

	// DI
	property name="settingService"			inject="id:settingService@cb";
	property name="contentBoxSettings"		inject="coldbox:moduleConfig:contentbox";
	property name="customModuleSettings"	inject="coldbox:moduleConfig:contentbox-custom";
	property name="coldboxModuleService"	inject="coldbox:moduleService";
	property name="log"						inject="logbox:logger:{this}";
	property name="zipUtil" 				inject="zipUtil@cb";


	/**
	 * The absolute path to custom module locations
	 */
	property name="customModulesPath" type="string";

	/**
	 * The invocation path for custom modules
	 */
	property name="customModulesInvocationPath" type="string";

	/**
	 * The absolute path to core module locations
	 */
	property name="coreModulesPath" type="string";

	/**
	 * The invocation path for core modules
	 */
	property name="coreModulesInvocationPath" type="string";

	/**
	 * The module widget cache
	 */
	property name="moduleWidgetCache" type="struct";

	/**
	 * ColdBox Module Registry reference
	 */
	property name="moduleRegistry" type="struct";

	/**
	 * ColdBox Module Config Cache reference
	 */
	property name="moduleConfigCache" type="struct";

	/**
	 * Module Map References
	 */
	property name="moduleMap" type="struct";


	/**
	 * Constructor
	 */
	ModuleService function init(){
		// init it
		super.init( entityName="cbModule" );
		
		variables.customModulesPath 			= "";
		variables.customModulesInvocationPath 	= "";
		variables.coreModulesPath 				= "";
		variables.coreModulesInvocationPath 	= "";
		variables.moduleWidgetCache 			= {};
		variables.moduleRegistry 				= {};
		variables.moduleConfigCache 			= {};
		variables.moduleMap 					= {};
		
		return this;
	}

	/**
	 * Executes after DI completion
	 */
	function onDIComplete(){
		// Setup Core Modules
		variables.coreModulesPath 				= variables.contentBoxSettings.path & "/modules_user";
		variables.coreModulesInvocationPath 	= variables.contentBoxSettings.invocationPath & ".modules_user";

		// Setup Custom Modules
		variables.customModulesPath 			= variables.customModuleSettings.path & "/_modules";
		variables.customModulesInvocationPath 	= variables.customModuleSettings.invocationPath & "._modules";

		// Module Registry + Config Cache References
		variables.moduleRegistry 				= variables.coldboxModuleService.getModuleRegistry();
		variables.moduleConfigCache 			= variables.coldboxModuleService.getModuleConfigCache();
	}

	/**
	 * Populate module from Module Configuration CFC and returns the module
	 * 
	 * @model The module object
	 * @config The config object to populate with
	 * 
	 * @return The module populated
	 */
	any function populateModule( any module, any config ){
		arguments.module.setTitle( arguments.config.title );
		arguments.module.setAuthor( arguments.config.author );
		arguments.module.setWebURL( arguments.config.webURL );
		arguments.module.setDescription( arguments.config.description );
		arguments.module.setVersion( arguments.config.version );
		arguments.module.setEntryPoint( arguments.config.entryPoint );
		if( structKeyExists( arguments.config, "forgeboxslug" ) ){
			arguments.module.setForgeBoxSlug( arguments.config.forgeboxSlug );
		}
		return arguments.module;
	}

	/**
	 * Find a module in the DB by entry point
	 * 
	 * @entryPoint The point to find
	 * 
	 * @return The persisted module or a new module object representing not found.
	 */
	Module function findModuleByEntryPoint( required entryPoint ){
		var module = findWhere( { entryPoint=arguments.entryPoint } );
		return ( isNull( module ) ? new() : module );
	}

	/**
	 * Find modules in ContentBox using the active criteria or `any`
	 * 
	 * @isActive The active criteria, true, false or any for all modules
	 * @moduleType The module type criteria
	 * 
	 * @return struct:{ count:numeric, modules:array of objects }
	 */
	struct function findModules( isActive="any", moduleType ){
		var results 	= {};
		var criteria 	= newCriteria();

		// isApproved filter
		if( !isNull( arguments.isActive ) AND arguments.isActive NEQ "any" ){
			criteria.eq( "isActive", javaCast( "Boolean", arguments.isActive ) );
		}

		// moduleType filter
		if( !isNull( arguments.moduleType ) ){
			criteria.eq( "moduleType", arguments.moduleType );
		}

		// run criteria query and projections count
		results.count 	 = criteria.count();
		results.modules  = criteria.list( sortOrder="title", asQuery=false );

		return results;
	}
	
	/**
	 * Shortcut to get the invocation path for requested widget from modules' widget cache
	 * 
	 * @widgetName {String}
	 * 
	 * @return The invocation path or empty if not found
	 */
	string function getModuleWidgetInvocationPath( required string widgetName ) {
		var path = "";

		// if widget name is in module widget cache, return its invocation path
		if( structKeyExists( variables.moduleWidgetCache, arguments.widgetName ) ) {
			path = variables.moduleWidgetCache[ arguments.widgetName ].invocationPath;
		} else {
			log.error( "Could not find #arguments.widgetname# widget in the module." );
		}
		return path;
	}
	
	/**
	 * Register a new module and return the module representation, this does not activate, just registers
	 * 
	 * @name The name of the module to register
	 * @type The type of module: core or custom
	 */
	Module function registerNewModule( required name, required type, thisModuleInvocationPath="", thisModulePath ){
		var thisPath 			= arguments.thisModulePath 			?: variables[ arguments.type & "ModulesPath" ];
		var thisInvocationPath 	= arguments.thisModuleInvocationPath 	?: variables[ arguments.type & "ModulesInvocationPath" ];

		if( fileExists( thisPath & "/#arguments.name#/ModuleConfig.cfc" ) ){
			
			var oConfig = createObject( "component", thisInvocationPath & ".#arguments.name#.ModuleConfig" );
			var oModule = new( { name = arguments.name, moduleType = arguments.type } );

			save( populateModule( oModule, oConfig ) );

			return oModule;

		} else {
			log.error( "Cannot register new module #arguments.name# as it is not a valid ContentBox Module. No ModuleConfig.cfc found." );
		}

		return new( { name = arguments.name } );
	}

	/**
	 * Deactivate a module from ContentBox
	 * 
	 * @name The module to deactivate
	 */
	ModuleService function deactivateModule( required name ){
		// Get Module Record
		var oModule = findWhere( { name=arguments.name } );
		
		// deactivate record
		oModule.setIsActive( false );
		
		// Call deactivate on module if it exists
		if( structKeyExists( variables.moduleConfigCache, arguments.name ) ){
			var config = variables.moduleConfigCache[ arguments.name ];
			
			// Call deactivate if it exists
			if( structKeyExists( config, "onDeactivate" ) ){
				config.onDeactivate();
			}
			
			// deactivate from ColdBox
			coldboxModuleService.unload( arguments.name );
			detachColdBoxModuleRegistration( arguments.name );
		}

		// save deactivated module status
		save( oModule );
		
		//rebuild widgets cache
		buildModuleWidgetsCache();
		
		return this;
	}

	/**
	 * Detach coldbox module configuration registrations
	 * 
	 * @name The name of the module to detach
	 */
	private ModuleService function detachColdBoxModuleRegistration( required name ){
		// Verify in module registry
		if( structKeyExists( variables.moduleRegistry, arguments.name) ){
			structDelete( variables.moduleRegistry, arguments.name );
		}
		return this;
	}

	/**
	 * Activate a module from ContentBox
	 * 
	 * @name The name of the module to activate
	 */
	ModuleService function activateModule( required name ){
		var oModule 	= findWhere( { name = arguments.name } );
		var sModuleMap 	= variables.moduleMap[ arguments.name ];
		
		// Set module as active
		oModule.setIsActive( true );
		// detach from coldbox just in case
		detachColdBoxModuleRegistration( arguments.name );
		// Activate module in ColdBox
		coldboxModuleService.registerAndActivateModule( arguments.name, sModuleMap.invocationPath );
		// Get loaded configuration object
		var oConfig = variables.moduleConfigCache[ arguments.name ];
		// Repopulate module, just in case
		populateModule( oModule, oConfig );
		
		// Call activate now if found on Module Config
		if( structKeyExists( oConfig, "onActivate" ) ){
			try{
				oConfig.onActivate();
			} catch( Any e ) {
				// deactivate module, it did not activate correctly
				oModule.setIsActive( false );
				// deactivate from ColdBox as it did not activate correctly
				coldboxModuleService.unload( arguments.name );
				detachColdBoxModuleRegistration( arguments.name );
				// Now throw the exception
				rethrow;
			}
		}

		// save module status
		save( oModule );
		
		//rebuild widgets cache
		buildModuleWidgetsCache();
		
		return this;
	}

	/**
	 * Delete Module, should only be done on deactivated modules
	 * 
	 * @name The name of the module to delete
	 */
	ModuleService function deleteModule( required name ){
		var moduleEntry = variables.moduleMap[ arguments.name ];

		// Try to do an onDelete() callback.
		var oConfig = createObject( "component", moduleEntry.invocationPath & ".#name#.ModuleConfig" );
		if( structKeyExists( oConfig, "onDelete" ) ){
			oConfig.onDelete();
		}
		
		// Now delete it		
		deleteWhere( { "name" = arguments.name } );
		if( directoryExists( moduleEntry.path & "/#arguments.name#" ) ){
			directoryDelete( moduleEntry.path & "/#arguments.name#", true );
		}

		return this;
	}

	/**
	 * Reset all modules by deactivating all of them and cleaning our db history
	 */
	ModuleService function resetModules(){
		var aModules = list( asQuery=false );
		
		transaction{
			for( var thisModule in aModules ){
				deactivateModule( thisModule.getName() );
			}
			
			// remove all modules from the DB
			deleteAll();

			// Reset internal map
			variables.moduleMap = {};
		}
		
		// now start them up again
		startup();

		return this;
	}

	/**
	 * Startup the service. This iterates through all modules on disk and if it finds a module that it has not been
	 * registered, it will register it.  If it loads a module that is registered and marked as active it will activate it.
	 */
	ModuleService function startup(){
		// Get Core Modules From Disk
		var qCoreModules 	= getModulesOnDisk( variables.coreModulesPath );
		// Get Custom Modules From Disk
		var qCustomModules 	= getModulesOnDisk( variables.customModulesPath );

		// Registration closure
		var cModuleRegistration = function( row, moduleType, invocationPath, path ){
			// Only look at directories as modules
			if( arguments.row.type eq "dir" and left( arguments.row.name, 1 ) neq '.' ){
				var moduleName = arguments.row.name;
				var thisModule = findWhere( { name = moduleName } );

				// check if module already in database records or new
				if( isNull( thisModule ) ){
					// new record, so register it
					thisModule = registerNewModule( moduleName, arguments.moduleType, invocationPath, path );
				}

				// If we get here, the module is loaded in the database now
				if( thisModule.getIsActive() AND not structKeyExists( variables.moduleRegistry, moduleName ) ){
					// load only active modules via ColdBox if they are not loaded already
					variables.coldboxModuleService.registerAndActivateModule( moduleName, arguments.invocationPath );
				}

				// Register type lookup for faster finding, instead of querying the db.
				variables.moduleMap[ moduleName ] = { 
					type 			= arguments.moduleType,
					path 			= arguments.path,
					invocationPath 	= arguments.invocationPath
				};

				var qChildModules 	= getModulesOnDisk( arguments.path & "/#moduleName#" & "/modules" );
				qChildModules.each( function( row ){
					cModuleRegistration(
						arguments.row, 
						"custom", 
						variables.moduleMap[ moduleName ].invocationPath & ".#moduleName#" & ".modules",
						variables.moduleMap[ moduleName ].path & "/#moduleName#" & "/modules" 
					);
				} );
			}
		};

		// Register Core
		qCoreModules.each( function( row ){
			cModuleRegistration( 
				arguments.row, 
				"core", 
				variables.coreModulesInvocationPath, 
				variables.coreModulesPath
			);
		} );

		// Register Custom
		qCustomModules.each( function( row ){
			cModuleRegistration(
				arguments.row, 
				"custom", 
				variables.customModulesInvocationPath,
				variables.customModulesPath 
			);
		} );

		// build widget cache
		buildModuleWidgetsCache();

		return this;
	}

	/**
	 * Upload a Module to the custom modules location, returns structure with [error:boolean, logInfo=string]
	 * 
	 * @fileField The field it uploads from
	 */
	struct function uploadModule( required fileField ){
		var destination 	= variables.coreModulesPath;
		var installLog 		= createObject( "java","java.lang.StringBuilder" ).init( "" );
		var results 		= { 
			"error" 	= true, 
			"logInfo" 	= "" 
		};

		// Upload the module zip
		var fileResults = fileUpload(
			destination, 
			arguments.fileField, 
			"application/octet-stream,application/x-zip-compressed,application/zip", 
			"overwrite" 
		);

		// Unzip File?
		if ( listLast( fileResults.clientFile, "." ) eq "zip" ){
			// test zip has files?
			try{
				var listing = zipUtil.list( "#destination#/#fileResults.clientFile#" );
			} catch( Any e ) {
				// bad zip file.
				installLog.append( "Error getting listing of zip archive (#destination#/#fileResults.clientFile#), bad zip, file will be removed.<br />" );
				fileDelete( destination & "/" & fileResults.clientFile );
				// flatten messages;
				results.logInfo = installLog.toString();
				return results;
			}

			// extract it
			zipUtil.extract(
				zipFilePath = "#destination#/#fileResults.clientFile#", 
				extractPath = "#destination#" 
			);
			
			// Removal of Mac stuff
			if( directoryExists( destination & "/__MACOSX" ) ){
				directoryDelete( destination & "/__MACOSX", true);
			}
			
			// rescan and startup the modules
			startup();
			
			// success
			results.error = false;
		} else {
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
     */
	private ModuleService function buildModuleWidgetsCache() {
		// get all active modules
		var activeModules 	= findModules( isActive=true );
		var cache 			= {};

		// loop over active modules
		for( var module in activeModules.modules ) {
			// Module reference maps pointer
			var moduleRecord = variables.moduleMap[ module.getName() ];

			// Widgets path
			var thisWidgetsPath = moduleRecord.path & "/" & module.getName() & "/widgets";
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
    						name 			= widgetName,
							invocationPath 	= moduleRecord.invocationPath & ".#module.getName()#.widgets.#widgetName#",
							path 			= directory.directory[ i ] & "/" & directory.name[ i ],
							module 			= module.getName()
    					};
    					cache[ widgetName & "@" & module.getName() ] = widget;
    				}
    				
    			}
			}
		}

		// Store constructed cache
		moduleWidgetCache = cache;

		return this;
	}

	/**
	 * Get all modules loaded on disk path
	 *
	 * @path The path to check
	 */
	private query function getModulesOnDisk( required path ){
		return directoryList( arguments.path, false, "query", "", "name asc" );
	}
}
