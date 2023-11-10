component {

	function up( schema, query ){
		schema.create( "cb_menuItem", ( table ) => {
			// Base Columns
			table.string( "menuItemID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.boolean( "active" ).default( false );
			table.string( "title", 200 );
			table.string( "label", 200 ).nullable();
			table.string( "itemClass", 200 ).nullable();
			table.string( "data", 200 ).nullable();
			table.string( "menuType" );
			table.string( "menuSlug" ).nullable();
			table.string( "contentSlug" ).nullable();
			table.string( "url" ).nullable();
			table.string( "js" ).nullable();
			table.string( "target" ).nullable();
			table.string( "urlClass" ).nullable();

			// Relationships
			table.string( "FK_menuID", 36 );
			table
				.foreignKey( "FK_menuID" )
				.references( "menuID" )
				.onTable( "cb_menu" );
			table.string( "FK_parentID", 36 );
			table
				.foreignKey( "FK_parentID" )
				.references( "menuItemID" )
				.onTable( "cb_menuItem" );

			// Index
			table.index( [ "title" ], "idx_menuItemTitle" );
			table.index( [ "isDeleted" ], "idx_deleted" );
		} );
	}

}
