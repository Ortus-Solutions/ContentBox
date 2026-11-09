component {

	function up( schema, query ) {
		schema.create(
				"cb_jwt",
				( table ) => {
					table.string( "id", 36 ).primaryKey();
					table.datetime( "expiration" );
					table.datetime( "issued" );
					table.longtext( "token" );
					table.string( "cacheKey" );
					table.string( "subject" );

					table.index( [ "cacheKey"], "idx_cacheKey" );
				}
			);
	}

}