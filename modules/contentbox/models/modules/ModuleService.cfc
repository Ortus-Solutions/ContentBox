/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage ContentBox Modules
 */
component
	extends  ="cborm.models.VirtualEntityService"
	accessors="true"
	singleton
	threadsafe
{

	// DI
	property name="settingService" inject="settingService@contentbox";
	property name="widgetService" inject="provider:widgetService@contentbox";
	property name="contentBoxSettings" inject="coldbox:moduleConfig:contentbox";
	property name="customModuleSettings" inject="coldbox:moduleConfig:contentbox-custom";
	property name="coldboxModuleService" inject="coldbox:moduleService";
	property name="log" inject="logbox:logger:{this}";

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
		super.init( entityName = "cbModule" );

		variables.customModulesPath           = "";
		variables.customModulesInvocationPath = "";
		variables.coreModulesPath             = "";
		variables.coreModulesInvocationPath   = "";
		variables.moduleWidgetCache           = {};
		variables.moduleRegistry              = {};
		variables.moduleConfigCache           = {};
		/**
		 * Stores all module information when loaded:
		 * {
		 * 		type : "The module type : core or custom",
		 * 		path : The absolute path,
		 * 		invocationPath : The invocation path
		 * }
		 */
		variables.moduleMap = {};

		return this;
	}

	/**
	 * Executes after DI completion
	 */
	function onDIComplete(){
		// Setup Core Modules
		variables.coreModulesPath           = variables.contentBoxSettings.path & "/modules_user";
		variables.coreModulesInvocationPath = variables.contentBoxSettings.invocationPath & ".modules_user";

		// Setup Custom Modules
		variables.customModulesPath           = variables.customModuleSettings.path & "/_modules";
		variables.customModulesInvocationPath = variables.customModuleSettings.invocationPath & "._modules";

		// Module Registry + Config Cache References
		variables.moduleRegistry    = variables.coldboxModuleService.getModuleRegistry();
		variables.moduleConfigCache = variables.coldboxModuleService.getModuleConfigCache();
	}

	/**
	 * Populate module from Module Configuration CFC and returns the module
	 *
	 * @model  The module object
	 * @config The config object to populate with
	 *
	 * @return The module populated
	 */
	any function populateModule( any module, any config ){
		arguments.module.setTitle( arguments.config.title ?: "" );
		arguments.module.setAuthor( arguments.config.author ?: "" );
		arguments.module.setWebURL( arguments.config.webURL ?: "" );
		arguments.module.setDescription( arguments.config.description ?: "" );
		arguments.module.setVersion( arguments.config.version ?: "" );
		arguments.module.setEntryPoint( arguments.config.entryPoint ?: "" );
		arguments.module.setForgeBoxSlug( arguments.config.forgeboxSlug ?: "" );
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
		var module = findWhere( { entryPoint : arguments.entryPoint } );
		return ( isNull( module ) ? new () : module );
	}

	/**
	 * Find modules in ContentBox using the active criteria or `any`
	 *
	 * @isActive   The active criteria, true, false or any for all modules
	 * @moduleType The module type criteria
	 *
	 * @return struct:{ count:numeric, modules:array of objects }
	 */
	struct function findModules( isActive = "any", moduleType ){
		var results  = {};
		var criteria = newCriteria();

		// isApproved filter
		if ( !isNull( arguments.isActive ) AND arguments.isActive NEQ "any" ) {
			criteria.isEq( "isActive", javacast( "Boolean", arguments.isActive ) );
		}

		// moduleType filter
		if ( !isNull( arguments.moduleType ) ) {
			criteria.isEq( "moduleType", arguments.moduleType );
		}

		// run criteria query and projections count
		results.count   = criteria.count();
		results.modules = criteria.list( sortOrder = "title", asQuery = false );

		return results;
	}

	/**
	 * Shortcut to get the invocation path for requested widget from modules' widget cache
	 *
	 * @widgetName {String}
	 *
	 * @return The invocation path or empty if not found
	 */
	string function getModuleWidgetInvocationPath( required string widgetName ){
		var path = "";

		// if widget name is in module widget cache, return its invocation path
		if ( structKeyExists( variables.moduleWidgetCache, arguments.widgetName ) ) {
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
	Module function registerNewModule( required name, required type ){
		var thisPath           = variables[ arguments.type & "ModulesPath" ];
		var thisInvocationPath = variables[ arguments.type & "ModulesInvocationPath" ];

		if ( fileExists( thisPath & "/#arguments.name#/ModuleConfig.cfc" ) ) {
			var oConfig = createObject( "component", thisInvocationPath & ".#arguments.name#.ModuleConfig" );
			var oModule = new ( { name : arguments.name, moduleType : arguments.type } );

			save( populateModule( oModule, oConfig ) );

			return oModule;
		} else {
			log.error(
				"Cannot register new module #arguments.name# as it is not a valid ContentBox Module. No ModuleConfig.cfc found."
			);
		}

		return new ( { name : arguments.name } );
	}

	/**
	 * Deactivate a module from ContentBox
	 *
	 * @name The module to deactivate
	 */
	ModuleService function deactivateModule( required name ){
		// Get Module Record
		var oModule = findWhere( { name : arguments.name } );

		// deactivate record
		oModule.setIsActive( false );

		// Call deactivate on module if it exists
		if ( structKeyExists( variables.moduleConfigCache, arguments.name ) ) {
			var config = variables.moduleConfigCache[ arguments.name ];

			// Call deactivate if it exists
			if ( structKeyExists( config, "onDeactivate" ) ) {
				try {
					config.onDeactivate();
				} catch ( Any e ) {
					log.error( "Error deactivating module: #arguments.name# with #e.message & e.detail#", e );
					// dont' throw. just log and continue deactivating modules.
				}
			}

			// deactivate from ColdBox
			coldboxModuleService.unload( arguments.name );
			detachColdBoxModuleRegistration( arguments.name );
		}

		// save deactivated module status
		save( oModule );

		// rebuild widgets cache
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
		if ( structKeyExists( variables.moduleRegistry, arguments.name ) ) {
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
		var oModule    = findWhere( { name : arguments.name } );
		var sModuleMap = variables.moduleMap[ arguments.name ];

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
		if ( structKeyExists( oConfig, "onActivate" ) ) {
			try {
				oConfig.onActivate();
			} catch ( Any e ) {
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

		// rebuild widgets cache
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

		// Try to do an onDelete() callback if it exists
		if ( fileExists( moduleEntry.path & "/#arguments.name#/ModuleConfig.cfc" ) ) {
			var oConfig = createObject( "component", moduleEntry.invocationPath & ".#arguments.name#.ModuleConfig" );
			if ( structKeyExists( oConfig, "onDelete" ) ) {
				oConfig.onDelete();
			}
		}

		// Now delete it
		deleteWhere( name = arguments.name );
		if ( directoryExists( moduleEntry.path & "/#arguments.name#" ) ) {
			directoryDelete( moduleEntry.path & "/#arguments.name#", true );
		}

		return this;
	}

	/**
	 * Reset all modules by deactivating all of them and cleaning our db history
	 */
	ModuleService function resetModules(){
		var aModules = list( asQuery = false );

		transaction {
			for ( var thisModule in aModules ) {
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
		// Get all modules
		var aModules = getAll();

		// Register ColdBox Module Closure
		var registerColdBoxModule = function( name, moduleType, invocationPath, path ){
			// var oModule = findWhere( { name : arguments.name } );
			var oModule = aModules.reduce( function( results, thisModule ){
				return ( thisModule.getName() == name ? thisModule : results );
			}, {} );

			// Register type lookup for faster finding, instead of querying the db.
			variables.moduleMap[ arguments.name ] = {
				type           : arguments.moduleType,
				path           : arguments.path,
				invocationPath : arguments.invocationPath
			};

			// check if module already in database records or new
			if ( !isObject( oModule ) ) {
				// new record, so register it
				oModule = registerNewModule( arguments.name, arguments.moduleType );
				arrayAppend( aModules, oModule );
			}

			// If we get here, the module is loaded in the database now
			if ( oModule.getIsActive() AND !structKeyExists( variables.moduleRegistry, arguments.name ) ) {
				// Register with ColdBox now
				variables.coldboxModuleService.registerModule(
					moduleName     = arguments.name,
					invocationPath = arguments.invocationPath
				);
				// Module registered, move to activation
				return true;
			}

			// Filter this sucker out
			return false;
		};

		// Register and Activate Core Modules First
		getModulesOnDisk( variables.coreModulesPath )
			.filter( function( name ){
				return registerColdBoxModule(
					arguments.name,
					"core",
					variables.coreModulesInvocationPath,
					variables.coreModulesPath
				);
			} )
			.each( function( name ){
				variables.coldboxModuleService.activateModule( arguments.name );
			} );

		// Register and Activate Custom Modules
		getModulesOnDisk( variables.customModulesPath )
			.filter( function( name ){
				return registerColdBoxModule(
					arguments.name,
					"custom",
					variables.customModulesInvocationPath,
					variables.customModulesPath
				);
			} )
			.each( function( name ){
				variables.coldboxModuleService.activateModule( arguments.name );
			} );

		// build widget cache
		buildModuleWidgetsCache(
			aModules.filter( function( thisModule ){
				return arguments.thisModule.getIsActive();
			} )
		);

		return this;
	}

	/**
	 * Iterates over all registered, active modules and sets any found widgets into a cache in moduleservice
	 *
	 * @modules Optional passed array to use to build the module cache with, else query the database
	 */
	private ModuleService function buildModuleWidgetsCache( array modules ){
		// Init Module Widget Cache
		variables.moduleWidgetCache = {};

		// Did we pass or discover?
		if ( isNull( arguments.modules ) ) {
			arguments.modules = findModules( isActive = true ).modules;
		}

		// Process Module Widgets
		arguments.modules
			.filter( function( thisModule ){
				// Active and On Disk Module?
				if ( variables.moduleMap.keyExists( thisModule.getName() ) ) {
					return true;
				}

				// Deactivate it, not fond in registry, might be an orphaned record
				if ( log.canWarn() ) {
					log.warn( "Orphaned module discovered: #thisModule.getName()#, deactiving it from the database" );
				}
				deactivateModule( thisModule.getName() );
				return false;
			} )
			.each( function( thisModule ){
				// Module reference maps pointer
				var moduleRecord    = variables.moduleMap[ thisModule.getName() ];
				// Widgets path + local Reference
				var thisWidgetsPath = moduleRecord.path & "/" & thisModule.getName() & "/widgets";

				// check that module widgets folder exists on disk, if so, iterate and register
				if ( directoryExists( thisWidgetsPath ) ) {
					directoryList( thisWidgetsPath, false, "name", "*.cfc" ).each( function( thisWidget ){
						var widgetName                                                         = reReplaceNoCase( thisWidget, ".cfc", "", "all" );
						// Store Record
						variables.moduleWidgetCache[ widgetName & "@" & thisModule.getName() ] = {
							name           : widgetName,
							invocationPath : moduleRecord.invocationPath & ".#thisModule.getName()#.widgets.#widgetName#",
							path           : thisWidgetsPath & "/" & thisWidget,
							module         : thisModule.getName()
						};
					} );
				}
				// end if widgets found
			} );

		// Force Reload all widgets
		variables.widgetService.getWidgets( reload = true );

		return this;
	}

	/**
	 * Get a collection of directory modules on disk at a specific location
	 *
	 * @path The path to check
	 *
	 * @return An array of names found on disk
	 */
	private array function getModulesOnDisk( required path ){
		// path, recurse, listInfo, filter, sort, type
		return directoryList(
			arguments.path,
			false,
			"name",
			"",
			"name asc",
			"dir"
		).filter( function( name ){
			return ( left( name, 1 ) neq "." );
		} );
	}

}
