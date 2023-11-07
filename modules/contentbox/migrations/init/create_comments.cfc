component{

	function up( schema, query ){

		schema.create( "cb_comment", ( table ) => {

			// Base Columns
			table.string( "commentID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.longText( "content" );
			table.string( "author", 100 );
			table.string( "authorIP", 100 );
			table.string( "authorEmail" );
			table.string( "authorURL" ).nullable();
			table.boolean( "isApproved" ).default( false );

			// Relationships
			table.string( "FK_contentID", 36 );
			table.foreignKey( "FK_contentID" ).references( "contentID" ).onTable( "cb_content" );

			// Indexes
			table.index( [ "isApproved", "FK_contentID" ], "idx_contentComment" );
			table.index( [ "isApproved" ], "idx_approved" );
			table.index( [ "isDeleted" ], "idx_deleted" );
		} );

	}


}
