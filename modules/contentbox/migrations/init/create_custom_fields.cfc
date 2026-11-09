component {

	function up( schema, query ) {
		schema.create(
				"cb_customfield",
				( table ) => {
					table.string( "customFieldID", 36 ).primaryKey();
					table.datetime( "createdDate" ).withCurrent();
					table.datetime( "modifiedDate" ).withCurrent();
					table.boolean( "isDeleted" ).default( false );

					table.string( "key" );
					table.longText( "value" );

					table.string( "FK_contentID", 36 );
					table
						.foreignKey( "FK_contentID" )
						.references( "contentID" )
						.onTable( "cb_content" );
				}
			);
	}

}