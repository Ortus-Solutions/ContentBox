/**
 * Editors can publish now
 *
 * @see     CONTENTBOX-1436 - https://ortussolutions.atlassian.net/browse/CONTENTBOX-1436
 * @version 5.3.0
 * @author  Luis Majano
 */
component {

	// DI
	property name="migrationService" inject="MigrationService@cfmigrations";

	// Include Utils
	include template="./util/MigrationUtils.cfm";

	function up( schema, qb ){
		// Update permission descriptions
		arguments.qb
			.newQuery()
			.from( "cb_permission" )
			.where( "permission", "CONTENTSTORE_EDITOR" )
			.update( { "description" : "Ability to create, edit and publish content store elements" } );
		arguments.qb
			.newQuery()
			.from( "cb_permission" )
			.where( "permission", "ENTRIES_EDITOR" )
			.update( { "description" : "Ability to create, edit and publish blog entries" } );
		arguments.qb
			.newQuery()
			.from( "cb_permission" )
			.where( "permission", "PAGES_EDITOR" )
			.update( { "description" : "Ability to create, edit and publish pages" } );
	}

	function down( schema, qb ){
	}

}
