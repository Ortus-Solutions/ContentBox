component {

	function up( schema, query ) {
		schema.create(
				"cb_permissionGroup",
				function( table ) {
					table.string( "permissionGroupID", 36 ).primaryKey();
					table.datetime( "createdDate" ).withCurrent();
					table.datetime( "modifiedDate" ).withCurrent();
					table.boolean( "isDeleted" ).default( false );

					table.string( "name" ).unique();
					table.longText( "description" ).nullable();
				}
			);
	}

	function down( schema, query ) {

	}

}