component{

	function up( schema, query ){

		schema.create( "cb_author", ( table ) => {
			// Base Columns
			table.string( "authorID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "firstName", 100 );
			table.string( "lastName", 100 );
			table.string( "email" );
			table.string( "username" ).unique();
			table.string( "password" );
			table.boolean( "isActive" ).default( true );
			table.datetime( "lastLogin" ).nullable();
			table.longText( "biography" ).nullable();
			table.longText( "preferences" ).nullable();
			table.boolean( "isPasswordReset" ).default( false );
			table.boolean( "is2FactorAuth" ).default( false );

			// Relationships
			table.string( "FK_roleID", 36 );
			table.foreignKey( "FK_roleID" ).references( "roleID" ).onTable( "cb_role" );

			// Indexes
			table.index( [ "email" ], "idx_email" );
			table.index( [ "isDeleted" ], "idx_deleted" );
			table.index( [ "isActive" ], "idx_activeAuthor" );
			table.index( [ "isPasswordReset" ], "idx_passwordReset" );
			table.index( [ "is2FactorAuth" ], "idx_2factorauth" );
			table.index( [ "username", "password", "isActive" ], "idx_login" );
		} );

	}


}
