component{

	function up( schema, query ){

		schema.create( "cb_setting", ( table ) => {

			// Base Columns
			table.string( "settingID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "name" );
			table.longText( "value" );
			table.boolean( "isCore" ).default( false );

			// Relationships
			table.string( "FK_siteID", 36 ).nullable();
			table.foreignKey( "FK_siteID" ).references( "siteID" ).onTable( "cb_site" );

			// Indexes
			table.index( [ "isCore" ], "idx_core" );
			table.index( [ "isDeleted" ], "idx_deleted" );
		} );

	}

}
