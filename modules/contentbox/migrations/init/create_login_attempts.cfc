component{

	function up( schema, query ){

		schema.create( "cb_loginAttempts", ( table ) => {

			// Base Columns
			table.string( "loginAttemptsID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "value" );
			table.bigInteger( "attempts" );
			table.string( "lastLoginSuccessIP", 100 );

			// Index
			table.index( [ "value" ], "idx_values" );

		} );

	}


}
