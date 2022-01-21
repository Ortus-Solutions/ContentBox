/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Roles service for contentbox
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="permissionService" inject="permissionService@contentbox";
	property name="dateUtil" inject="DateUtil@contentbox";

	/**
	 * Constructor
	 */
	RoleService function init(){
		// init it
		super.init( entityName = "cbRole" );

		return this;
	}

	/**
	 * Get all data prepared for export
	 */
	array function getAllForExport(){
		return getAll().map( function( thisItem ){
			return thisItem.getMemento( includes = "permissions" );
		} );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The json file to import
	 * @override   Override content if found in the database, defaults to false
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw( message = "Cannot import file as the contents is not JSON", type = "InvalidImportFormat" );
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures or a single structure of data
	 *
	 * @importData A struct or array of data to import
	 * @override   Override content if found in the database, defaults to false
	 * @importLog  The import log buffer
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		importLog
	){
		var allRoles = [];

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisRole in arguments.importData ) {
				// Get new or persisted
				var oRole = this.findByRole( thisRole.role );
				oRole     = ( isNull( oRole ) ? new () : oRole );

				// populate content from data
				getBeanPopulator().populateFromStruct(
					target               = oRole,
					memento              = thisRole,
					exclude              = "roleID,permissions",
					composeRelationships = false
				);

				// PERMISSIONS
				if ( arrayLen( thisRole.permissions ) ) {
					// Create permissions that don't exist first
					var allPermissions = [];
					for ( var thisPermission in thisRole.permissions ) {
						var oPerm = variables.permissionService.findByPermission( thisPermission.permission );
						oPerm     = (
							isNull( oPerm ) ? getBeanPopulator().populateFromStruct(
								target  = variables.permissionService.new(),
								memento = thisPermission,
								exclude = "permissionID"
							) : oPerm
						);
						// save oPerm if new only
						if ( !oPerm.isLoaded() ) {
							variables.permissionService.save( entity = oPerm, transactional = false );
						}
						// append to add.
						arrayAppend( allPermissions, oPerm );
					}
					// detach permissions and re-attach
					oRole.setPermissions( allPermissions );
				}

				// if new or persisted with override then save.
				if ( !oRole.isLoaded() ) {
					arguments.importLog.append( "New role imported: #thisRole.role#<br>" );
					arrayAppend( allRoles, oRole );
				} else if ( oRole.isLoaded() and arguments.override ) {
					arguments.importLog.append( "Persisted role overriden: #thisRole.role#<br>" );
					arrayAppend( allRoles, oRole );
				} else {
					arguments.importLog.append( "Skipping persisted role: #thisRole.role#<br>" );
				}
			}
			// end import loop

			// Save them?
			if ( arrayLen( allRoles ) ) {
				saveAll( allRoles );
				arguments.importLog.append( "Saved all imported and overriden roles!" );
			} else {
				arguments.importLog.append(
					"No roles imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end transaction

		return arguments.importLog.toString();
	}

}
