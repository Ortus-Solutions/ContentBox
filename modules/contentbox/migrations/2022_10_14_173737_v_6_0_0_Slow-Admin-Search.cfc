/**
 * CONTENTBOX-1429: Add index to cb_contentVersion table
 * https://ortussolutions.atlassian.net/browse/CONTENTBOX-1429
 */
component {

	function up( schema, qb ){
		schema.alter( "cb_contentVersion", function( table ){
			table.index( [ "isActive", "content" ], "idx_content_isActive" );
		} );
	}

	function down( schema, qb ){
	}

}
