component {
	function up( schema, query ){

		schema.create( "cb_contentStore", function(table) {

			table.string( "contentID", 36 ).primaryKey();
			table.integer( "order" ).default( 0 ).nullable();
			table.string( "description", 500 ).nullable();

			// Relationships
			table.foreignKey( "contentID" ).references( "contentID" ).onTable( "cb_content" );
		} );

	}

	function down( schema, query ){
	}

}
