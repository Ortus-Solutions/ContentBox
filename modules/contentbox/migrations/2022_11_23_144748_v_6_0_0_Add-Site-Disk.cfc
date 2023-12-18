/**
 * CONTENTBOX-1452- Add mediaDisk column to cb_site table
 * https://ortussolutions.atlassian.net/browse/CONTENTBOX-1452
 */
component {

	// Include Utils
	include template="./util/MigrationUtils.cfm";

	function up( schema, qb ){
		if ( !hasColumn( "cb_site", "mediaDisk" ) ) {
			schema.alter( "cb_site", function( table ){
				table.addColumn( table.string( "mediaDisk", 50 ).nullable() );
			} );
		}
	}

	function down( schema, qb ){
	}

}
