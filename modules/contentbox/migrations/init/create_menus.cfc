component{

	function up( schema, query ){

		schema.create( "cb_menu", ( table ) => {

			// Base Columns
			table.string( "menuID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "title", 200 );
			table.string( "slug", 200 );
			table.string( "menuClass", 160 ).nullable();
			table.string( "listClass", 160 ).nullable();
			table.string( "listType", 20 ).nullable();

			// Relationships
			table.string( "FK_siteID", 36 );
			table.foreignKey( "FK_siteID" ).references( "siteID" ).onTable( "cb_site" );

			// Index
			table.index( [ "title" ], "idx_menutitle" );
			table.index( [ "slug" ], "idx_menuslug" );

		} );

	}


}
