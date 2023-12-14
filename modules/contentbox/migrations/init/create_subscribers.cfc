component {

	function up( schema, query ){
		schema.create( "cb_subscribers", ( table ) => {
			// Base Columns
			table.string( "subscriberID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "subscriberEmail" );
			table.string( "subscriberToken" );

			// Indexes
			table.index( [ "subscriberEmail" ], "idx_subscriberEmail" );
			table.index( [ "isDeleted" ], "idx_deleted" );
		} );
	}

}
