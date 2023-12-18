component {

	function up( schema, query ){
		schema.create( "cb_permission", function( table ){
			// Base Columns
			table.string( "permissionID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "permission" ).unique();
			table.longText( "description" ).nullable();
		} );
	}

	function down( schema, query ){
	}

}
