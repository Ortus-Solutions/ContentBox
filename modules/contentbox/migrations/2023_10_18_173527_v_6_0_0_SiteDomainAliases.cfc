/**
 * Sites can now have domain aliases for matching on the request
 */
component {

    // Include Utils
	include template="./_MigrationUtils.cfm";

	function up( schema, qb ){
		if ( !hasColumn( "cb_site", "domainAliases" ) ) {
			schema.alter( "cb_site", function( table ){
				table.addColumn( table.text( "domainAliases" ).nullable() );
			} );
			queryExecute( "update cb_site set domainAliases = '[]'" );
		}
	}

    function down( schema, qb ) {

    }

}
