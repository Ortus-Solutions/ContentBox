component {

	function up( schema, query ){
		schema.create( "cb_groupPermissions", function( table ){
			table.string( "FK_permissionGroupID", 36 );
			table.string( "FK_permissionID", 36 );

			table
				.foreignKey( "FK_permissionGroupID" )
				.references( "permissionGroupID" )
				.onTable( "cb_permissionGroup" );
			table
				.foreignKey( "FK_permissionID" )
				.references( "permissionID" )
				.onTable( "cb_permission" );
		} );
	}

	function down( schema, query ){
	}

}
