component {

	function up( schema, query ) {
		schema.create(
				"cb_setting",
				( table ) => {
					table.string( "settingID", 36 ).primaryKey();
					table.datetime( "createdDate" ).withCurrent();
					table.datetime( "modifiedDate" ).withCurrent();
					table.boolean( "isDeleted" ).default( false );

					table.string( "name" );
					table.longText( "value" );
					table.boolean( "isCore" ).default( false );

					table.string( "FK_siteID", 36 ).nullable();
					table
						.foreignKey( "FK_siteID" )
						.references( "siteID" )
						.onTable( "cb_site" );

					table.index( [ "isCore"], "idx_core" );
					table.index( [ "isDeleted"], "idx_settings_deleted" );
				}
			);
	}

}