component {

	// Include Utils
	include template="./_MigrationUtils.cfm";

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
