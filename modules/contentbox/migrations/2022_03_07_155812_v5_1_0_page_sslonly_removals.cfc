/**
 * This migration will remove the 'SSLOnly' column from the 'cb_page' table because this bit was not nullable,
 * had a default value and we won't use it anymore, So we need to remove it, else all page editing will fail.
 *
 * @see     CONTENTBOX-1394 - https://ortussolutions.atlassian.net/browse/CONTENTBOX-1394
 * @version 5.1.0
 * @author  Davis Vega
 */
component {

	// DI
	property name="migrationService" inject="MigrationService@cfmigrations";

	// Include Utils
	include template="./_MigrationUtils.cfm";

	function up( schema, qb ){
		if ( hasColumn( "cb_page", "SSLOnly" ) ) {
			schema.alter( "cb_page", ( table ) => {
				table.dropColumn( "SSLOnly" );
			} );
		} else {
			systemOutput( "- skipping 'sslonly' removal, cb_page doesn't have the column", true );
		}
	}

	function down( schema, qb ){
	}

}
