/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Permissions service for contentbox
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="dateUtil" inject="DateUtil@contentbox";

	/**
	 * Constructor
	 */
	PermissionService function init(){
		// init it
		super.init( entityName = "cbPermission" );

		return this;
	}

	/**
	 * Delete a Permission which also removes itself from all many-to-many relationships
	 *
	 * @permissionID The permission ID to remove
	 */
	boolean function deletePermission( required permissionID ){
		transaction {
			// We do SQL deletions as those relationships are not bi-directional
			// delete role relationships
			var q = new Query( sql = "delete from cb_rolePermissions where FK_permissionID = :permissionID" );
			q.addParam(
				name      = "permissionID",
				value     = arguments.permissionID,
				cfsqltype = "varchar"
			);
			q.execute();
			// delete user relationships
			var q = new Query( sql = "delete from cb_authorPermissions where FK_permissionID = :permissionID" );
			q.addParam(
				name      = "permissionID",
				value     = arguments.permissionID,
				cfsqltype = "varchar"
			);
			q.execute();
			// delete group permissions now
			var q = new Query( sql = "delete from cb_groupPermissions where FK_permissionID = :permissionID" );
			q.addParam(
				name      = "permissionID",
				value     = arguments.permissionID,
				cfsqltype = "varchar"
			);
			q.execute();
			// delete permission now
			var q = new Query( sql = "delete from cb_permission where permissionID = :permissionID" );
			q.addParam(
				name      = "permissionID",
				value     = arguments.permissionID,
				cfsqltype = "varchar"
			);
			q.execute();
		}

		return true;
	}

	/**
	 * Get all data prepared for export
	 *
	 * @return Array of struct permission data
	 */
	array function getAllForExport(){
		return newCriteria()
			.withProjections( property = "permissionID,permission,description,createdDate,modifiedDate,isDeleted" )
			.asStruct()
			.list( sortOrder = "permission" )
			// output conversions
			.map( function( item ){
				item[ "createdDate" ]  = variables.dateUtil.toUTC( item[ "createdDate" ], "", "UTC" );
				item[ "modifiedDate" ] = variables.dateUtil.toUTC( item[ "modifiedDate" ], "", "UTC" );
				return item;
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
		var allPermissions = [];

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisPermission in arguments.importData ) {
				// Get new or persisted
				var oPermission = this.findByPermission( thisPermission.permission );
				oPermission     = ( isNull( oPermission ) ? new () : oPermission );

				// populate content from data
				getBeanPopulator().populateFromStruct(
					target               = oPermission,
					memento              = thisPermission,
					exclude              = "permissionID",
					composeRelationships = false
				);

				// if new or persisted with override then save.
				if ( !oPermission.isLoaded() ) {
					arguments.importLog.append( "New permission imported: #thisPermission.permission#<br>" );
					arrayAppend( allPermissions, oPermission );
				} else if ( oPermission.isLoaded() and arguments.override ) {
					arguments.importLog.append( "Permission overriden: #thisPermission.permission#<br>" );
					arrayAppend( allPermissions, oPermission );
				} else {
					arguments.importLog.append( "Permission skipped: #thisPermission.permission#<br>" );
				}
			}
			// end import loop

			// Save them?
			if ( arrayLen( allPermissions ) ) {
				saveAll( allPermissions );
				arguments.importLog.append( "Saved all imported and overriden permissions!" );
			} else {
				arguments.importLog.append(
					"No permissions imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end of transaction

		return arguments.importLog.toString();
	}

}
