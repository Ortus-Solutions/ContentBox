/**
 * This migration will remove the 'cacheLayout' column from the 'cb_content' as it is no longer in use
 *
 * @see     CONTENTBOX-1437 - https://ortussolutions.atlassian.net/browse/CONTENTBOX-1437
 * @version 5.3.0
 * @author  Jon Clausen
 */
component {

	// DI
	property name="migrationService" inject="MigrationService@cfmigrations";

	// Include Utils
	include template="./_MigrationUtils.cfm";

	function up( schema, qb ){
		if ( hasColumn( "cb_content", "cacheLayout" ) ) {
			schema.alter( "cb_content", ( table ) => {
				table.dropColumn( "cacheLayout" );
			} );
		} else {
			systemOutput( "- skipping 'cacheLayout' removal, cb_content doesn't have the column", true );
		}
	}

	function down( schema, qb ){
	}

}
