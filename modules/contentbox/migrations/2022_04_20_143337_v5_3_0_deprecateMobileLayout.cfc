/**
 * This migration will remove the 'mobileLayout' column from the 'cb_page' table because it is being deprecated.
 *
 * @see     CONTENTBOX-1372 - https://ortussolutions.atlassian.net/browse/CONTENTBOX-1372
 * @version 5.3.0
 * @author  Daniel Garcia
 */
component {

	// DI
	property name="migrationService" inject="MigrationService@cfmigrations";

	// Include Utils
	include template="./_MigrationUtils.cfm";

	function up( schema, qb ){
		if ( hasColumn( "cb_page", "mobileLayout" ) ) {
			// Remove the mobileLayout column from the `cb_page` table
			schema.alter( "cb_page", ( table ) => {
				table.dropColumn( "mobileLayout" );
			} );
		} else {
			systemOutput( "- skipping 'mobileLayout' removal, cb_page doesn't have the column", true );
		}
	}

	function down( schema, qb ){
	}

}
