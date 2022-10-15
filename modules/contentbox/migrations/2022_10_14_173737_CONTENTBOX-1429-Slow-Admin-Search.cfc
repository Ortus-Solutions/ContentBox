component {

    function up( schema, qb ) {
		schema.alter( "cb_contentVersion", function( table ) {
			table.index( [ "isActive", "content" ], "idx_publishedContentSearch" );
		} );
    }

    function down( schema, qb ) {

    }

}
