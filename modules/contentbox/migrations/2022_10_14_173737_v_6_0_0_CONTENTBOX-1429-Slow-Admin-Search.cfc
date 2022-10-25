component {

	function up( schema, qb ){
		schema.alter( "cb_contentVersion", function( table ){
			table.index( [ "isActive", "content" ], "idx_content_isActive" );
		} );
	}

	function down( schema, qb ){
	}

}
