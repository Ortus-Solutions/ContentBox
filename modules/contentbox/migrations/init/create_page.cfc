component {
	function up( schema, query ){

		schema.create( "cb_page", function(table) {

			table.string( "contentID", 36 ).primaryKey();
			table.boolean( "showInMenu" ).default( true );
			table.integer( "order" ).default( 0 ).nullable();
			table.longtext( "excerpt" ).nullable();
			table.string( "layout", 200 ).nullable();

			// Relationships
			table.foreignKey( "contentID" ).references( "contentID" ).onTable( "cb_content" );
		} );

	}

	function down( schema, query ){
	}

}
