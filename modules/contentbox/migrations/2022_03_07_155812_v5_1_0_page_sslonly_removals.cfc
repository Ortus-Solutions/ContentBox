/**
 * This migration will remove the 'SSLOnly' column from the 'cb_page' table because this bit was not nullable,
 * had a default value and we won't use it anymore, So we need to remove it, else all page editing will fail.
 *
 * @see     CONTENTBOX-1394 - https://ortussolutions.atlassian.net/browse/CONTENTBOX-1394
 * @version 5.1.0
 * @author  Davis Vega
 */
component {

	function up( schema, qb ){
		// Remove the sslonly column from the `cb_page` table
		schema.alter( "cb_page", ( table ) => {
			table.dropColumn( "SSLOnly" );
		} );
	}

	function down( schema, qb ){
	}

}
