component {
	function up( schema, query ){

		schema.create( "cb_rolePermissions", function(table) {

			table.string( "FK_permissionID", 36 );
			table.string( "FK_roleID", 36 );

			table.foreignKey( "FK_permissionID" ).references( "permissionID" ).onTable( "cb_permission" );
			table.foreignKey( "FK_roleID" ).references( "roleID" ).onTable( "cb_role" );
		} );

	}

	function down( schema, query ){
	}

}
