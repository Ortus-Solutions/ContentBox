component {
	function up( schema, query ){

		schema.create( "cb_authorPermissionGroups", function(table) {

			table.string( "FK_permissionGroupID", 36 );
			table.string( "FK_authorID", 36 );

			table.foreignKey( "FK_permissionGroupID" ).references( "permissionGroupID" ).onTable( "cb_permissionGroup" );
			table.foreignKey( "FK_authorID" ).references( "authorID" ).onTable( "cb_author" );
		} );

	}

	function down( schema, query ){
	}

}
