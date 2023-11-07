component{

	function up( schema, query ){

		schema.create( "cb_subscriptions", ( table ) => {

			// Base Columns
			table.string( "subscriptionID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "type" );
			table.string( "subscriberToken" );

			// Relationships
			table.string( "FK_subscriberID", 36 );
			table.foreignKey( "FK_subscriberID" ).references( "subscriberID" ).onTable( "cb_subscribers" );

			// Indexes
			table.index( [ "isDeleted" ], "idx_deleted" );
		} );

	}


}
