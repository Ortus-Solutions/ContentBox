component {
	function up( schema, query ){

		schema.create( "cb_contentCategories", function(table) {

			table.string( "FK_contentID", 36 );
			table.string( "FK_categoryID", 36 );

			table.foreignKey( "FK_contentID" ).references( "contentID" ).onTable( "cb_content" );
			table.foreignKey( "FK_categoryID" ).references( "categoryID" ).onTable( "cb_category" );
		} );

	}

	function down( schema, query ){
	}

}
