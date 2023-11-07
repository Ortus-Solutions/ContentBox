component{

	function up( schema, query ){

		schema.create( "cbsecurity_logs", ( table ) => {

			// Base Columns
			table.string( "id", 36 ).primaryKey();
			table.datetime( "logDate" ).withCurrent();
			table.longText( "securityRule" );
			table.string( "action", 20 );
			table.string( "blockType", 20 );
			table.string( "ip", 100 );
			table.string( "host" );
			table.string( "httpMethod", 25 );
			table.string( "path" );
			table.string( "queryString" );
			table.string( "referer" );
			table.string( "userAgent" );
			table.string( "userId", 36 );

			// Index
			table.index( [ "logDate", "action", "blockType" ], "idx_cbsecurity" );
			table.index( [ "userId" ], "idx_cbsecurity_userId" );
			table.index( [ "userAgent" ], "idx_cbsecurity_userAgent" );
			table.index( [ "ip" ], "idx_cbsecurity_ip" );
			table.index( [ "host" ], "idx_cbsecurity_host" );
			table.index( [ "httpMethod" ], "idx_cbsecurity_httpMethod" );
			table.index( [ "path" ], "idx_cbsecurity_path" );
			table.index( [ "referer" ], "idx_cbsecurity_referer" );
		} );

	}


}
