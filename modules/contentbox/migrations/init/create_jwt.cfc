component {

	function up( schema, query ){
		schema.create( "cb_jwt", ( table ) => {
			// Base Columns
			table.string( "id", 36 ).primaryKey();
			table.datetime( "expiration" );
			table.datetime( "issued" );
			table.longtext( "token" );
			table.string( "cacheKey" );
			table.string( "subject" );

			// Indexes
			table.index( [ "cacheKey" ], "idx_cacheKey" );
		} );
	}

}
