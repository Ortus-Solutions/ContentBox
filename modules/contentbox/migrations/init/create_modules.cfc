component {

	function up( schema, query ){
		schema.create( "cb_module", ( table ) => {
			// Base Columns
			table.string( "moduleID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "name" );
			table.string( "title" ).nullable();
			table.string( "version" ).nullable();
			table.string( "entryPoint" ).nullable();
			table.string( "author" ).nullable();
			table.string( "webURL", 500 ).nullable();
			table.string( "forgeBoxSlug" ).nullable();
			table.longText( "description" ).nullable();
			table.boolean( "isActive" ).default( false );
			table.string( "moduleType" ).nullable();

			// Indexes
			table.index( [ "name" ], "idx_moduleName" );
			table.index( [ "entryPoint" ], "idx_entryPoint" );
			table.index( [ "isActive" ], "idx_activeModule" );
			table.index( [ "moduleType" ], "idx_moduleType" );
			table.index( [ "isDeleted" ], "idx_modules_deleted" );
		} );
	}

}
