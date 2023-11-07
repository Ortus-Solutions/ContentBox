component {
	function up( schema, query ){

		schema.create( "cb_authorPermissions", function(table) {

			table.string( "FK_permissionID", 36 );
			table.string( "FK_authorID", 36 );

			table.foreignKey( "FK_permissionID" ).references( "permissionID" ).onTable( "cb_permission" );
			table.foreignKey( "FK_authorID" ).references( "authorID" ).onTable( "cb_author" );
		} );

	}

	function down( schema, query ){
	}

}
