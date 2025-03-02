component {

	function up( schema, query ){
		schema.create( "cb_securityRule", ( table ) => {
			// Base Columns
			table.string( "ruleID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "whitelist" ).nullable();
			table.string( "securelist" );
			table.string( "match", 50 ).nullable();
			table.string( "roles", 500 ).nullable();
			table.string( "permissions", 500 ).nullable();
			table.string( "redirect", 500 ).nullable();
			table.string( "overrideEvent", 500 ).nullable();
			table.boolean( "useSSL" ).default( false );
			table
				.string( "action", 50 )
				.nullable()
				.default( "redirect" );
			table.string( "module", 500 ).nullable();
			table
				.string( "httpMethods" )
				.nullable()
				.default( "*" );
			table
				.string( "allowedIPs" )
				.nullable()
				.default( "*" );
			table.integer( "order" ).default( 0 );
			table.string( "message" ).nullable();
			table
				.string( "messageType", 50 )
				.nullable()
				.default( "info" );

			// Indexes
			table.index( [ "isDeleted" ], "idx_securityrules_deleted" );
		} );
	}

}
