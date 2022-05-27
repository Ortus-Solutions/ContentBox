/**
 * This migration will remove the 'SSLOnly' column from the 'cb_page' table because this bit was not nullable,
 * had a default value and we won't use it anymore, So we need to remove it, else all page editing will fail.
 *
 * @see     CONTENTBOX-1437 - https://ortussolutions.atlassian.net/browse/CONTENTBOX-1437
 * @version 5.3.0
 * @author  Jon Clausen
 */
component {

	function up( schema, qb ){
		try{
			// Remove the sslonly column from the `cb_page` table
			schema.alter( "cb_content", ( table ) => {
				table.dropColumn( "cacheLayout" );
			} );
		} catch( any e ){
			// If this query errors, then the schema was created by a version greater than 5.0
		}
	}

	function down( schema, qb ){
	}

}
