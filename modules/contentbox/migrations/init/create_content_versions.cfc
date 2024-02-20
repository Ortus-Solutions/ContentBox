component {

	function up( schema, query ){
		schema.create( "cb_contentVersion", function( table ){
			// Base Columns
			table.string( "contentVersionID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );
			// Content Version Columns
			table.longText( "content" );
			table.longText( "changelog" ).nullable();
			table.integer( "version" ).default( 1 );
			table.boolean( "isActive" ).default( true );

			// Relationships
			table.string( "FK_authorID", 36 );
			table
				.foreignKey( "FK_authorID" )
				.references( "authorID" )
				.onTable( "cb_author" );
			table.string( "FK_contentID", 36 );
			table
				.foreignKey( "FK_contentID" )
				.references( "contentID" )
				.onTable( "cb_content" );

			// Index
			table.index( [ "version" ], "idx_version" );
			table.index( [ "isActive" ], "idx_activeContentVersion" );
			table.index( [ "FK_contentID", "isActive" ], "idx_contentVersions" );
			table.index( [ "isActive" ], "idx_content_isActive" );
		} );
	}

	function down( schema, query ){
	}

}
