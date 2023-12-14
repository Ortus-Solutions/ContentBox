component {

	function up( schema, query ){
		schema.create( "cb_role", function( table ){
			// Base Columns
			table.string( "roleID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "role" ).unique();
			table.longText( "description" ).nullable();
		} );
	}

	function down( schema, query ){
	}

}
