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
	include template="./_MigrationUtils.cfm";

	function up( schema, qb ){
		// Update permission descriptions
		arguments.qb
			.newQuery()
			.from( "cb_permissions" )
			.update( { "description" : "Ability to create, edit and publish content store elements" } )
			.where( "permission", "CONTENTSTORE_EDITOR" );
		arguments.qb
			.newQuery()
			.from( "cb_permissions" )
			.update( { "description" : "Ability to create, edit and publish blog entries" } )
			.where( "permission", "ENTRIES_EDITOR" );
		arguments.qb
			.newQuery()
			.from( "cb_permissions" )
			.update( { "description" : "Ability to create, edit and publish pages" } )
			.where( "permission", "PAGES_EDITOR" );
	}

	function down( schema, qb ){
	}

}
