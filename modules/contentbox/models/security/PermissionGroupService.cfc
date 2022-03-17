/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Permission Group Service for contentbox
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="permissionService" inject="permissionService@contentbox";
	property name="dateUtil" inject="DateUtil@contentbox";

	/**
	 * Constructor
	 */
	PermissionGroupService function init(){
		// init it
		super.init( entityName = "cbPermissionGroup" );

		return this;
	}

	/**
	 * Get all data prepared for export
	 */
	array function getAllForExport(){
		return getAll().map( function( thisItem ){
			return thisItem.getMemento();
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
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		importLog
	){
		var allGroups = [];

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisGroup in arguments.importData ) {
				// Get new or persisted
				var oGroup = this.findByName( thisGroup.name );
				oGroup     = ( isNull( oGroup ) ? new () : oGroup );

				// populate content from data
				getBeanPopulator().populateFromStruct(
					target               = oGroup,
					memento              = thisGroup,
					exclude              = "permissionGroupID,permissions",
					composeRelationships = false
				);

				// PERMISSIONS
				if ( arrayLen( thisGroup.permissions ) ) {
					// Create permissions that don't exist first
					var allPermissions = [];
					for ( var thisPermission in thisGroup.permissions ) {
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
					oGroup.setPermissions( allPermissions );
				}

				// if new or persisted with override then save.
				if ( !oGroup.isLoaded() ) {
					arguments.importLog.append( "New permission group imported: #thisGroup.name#<br>" );
					arrayAppend( allGroups, oGroup );
				} else if ( oGroup.isLoaded() and arguments.override ) {
					arguments.importLog.append( "Persisted permission group overriden: #thisGroup.name#<br>" );
					arrayAppend( allGroups, oGroup );
				} else {
					arguments.importLog.append( "Skipping permission group: #thisGroup.name#<br>" );
				}
			}
			// end import loop

			// Save them?
			if ( arrayLen( allGroups ) ) {
				saveAll( allGroups );
				arguments.importLog.append( "Saved all imported and overriden permission groups!" );
			} else {
				arguments.importLog.append(
					"No permission groups imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end of transaction

		return arguments.importLog.toString();
	}

}
