component {

    function up( schema, qb ) {

		if( !schema.hasColumn( "cb_site", "mediaDisk" ) ){
			schema.alter( "cb_site", function( table ){
				table.addColumn( table.string( "mediaDisk", 50 ).nullable() );
			} );
		}

    }

    function down( schema, qb ) {

    }

}
