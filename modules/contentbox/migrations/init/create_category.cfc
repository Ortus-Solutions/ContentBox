component {
	function up( schema, query ){

		schema.create( "cb_category", function(table) {

			// Base Columns
			table.string( "categoryID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "slug" );
			table.string( "category" );
			table.boolean( "isPublic" ).default( true );

			// Relationships
			table.string( "FK_siteID", 36 );
			table.foreignKey( "FK_siteID" ).references( "siteID" ).onTable( "cb_site" );

			// Index
			table.index( [ "isPublic" ], "idx_isPublic" );
			table.index( [ "slug" ], "idx_categorySlug" );
			table.index( [ "category" ], "idx_categoryName" );
			table.index( [ "isDeleted" ], "idx_deleted" );
		} );

	}

	function down( schema, query ){
	}

}
