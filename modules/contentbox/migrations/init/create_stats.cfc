component {

	function up( schema, query ){
		schema.create( "cb_stats", function( table ){
			// Base Columns
			table.string( "statsID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.bigInteger( "hits" ).default( 0 );

			// Relationships
			table.string( "FK_contentID", 36 );
			table
				.foreignKey( "FK_contentID" )
				.references( "contentID" )
				.onTable( "cb_content" );

			// Index
			table.index( [ "isDeleted" ], "idx_deleted" );
		} );
	}

	function down( schema, query ){
	}

}
