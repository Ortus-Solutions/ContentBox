/**
 * Editors can publish now
 *
 * @see     CONTENTBOX-1399 - https://ortussolutions.atlassian.net/browse/CONTENTBOX-1399
 * @version 6.0.0
 * @author  Luis Majano
 */
component {

	// DI
	property name="migrationService" inject="MigrationService@cfmigrations";

	// Include Utils
	include template="./util/MigrationUtils.cfm";

	function up( schema, qb ){
		var today  = now();
		var permID = createUUID();
		qb.newQuery()
			.from( "cb_permission" )
			.insert( {
				"permissionID" : permID,
				"createdDate"  : today,
				"modifiedDate" : today,
				"isDeleted"    : 0,
				"permission"   : "RELOAD_CACHES",
				"description"  : "Ability to reload caches"
			} );
		systemOutput( "√ - Reload Caches permission created", true );

		// Assign to Editors and Administrators
		var admin = qb
			.newQuery()
			.select( "roleID" )
			.from( "cb_role" )
			.where( "role", "Administrator" )
			.first();

		qb.newQuery()
			.from( "cb_rolePermissions" )
			.insert( { "FK_roleID" : admin.roleID, "FK_permissionID" : permID } );
		systemOutput( "√ - Admin role updated with new permissions", true );

		var editor = qb
			.newQuery()
			.select( "roleID" )
			.from( "cb_role" )
			.where( "role", "Editor" )
			.first();

		qb.newQuery()
			.from( "cb_rolePermissions" )
			.insert( { "FK_roleID" : editor.roleID, "FK_permissionID" : permID } );
		systemOutput( "√ - Editor role updated with new permissions", true );
	}

	function down( schema, qb ){
	}

}
