component {
	function up( schema, query ){

		schema.create( "cb_entry", function(table) {

			table.string( "contentID", 36 ).primaryKey();
			table.longtext( "excerpt" ).nullable();

			// Relationships
			table.foreignKey( "contentID" ).references( "contentID" ).onTable( "cb_content" );
		} );

	}

	function down( schema, query ){
	}

}
