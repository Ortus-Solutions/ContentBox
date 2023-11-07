component{

	function up( schema, query ){

		schema.create( "cb_customfield", ( table ) => {

			// Base Columns
			table.string( "customFieldID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "key" );
			table.longText( "value" );

			// Relationships
			table.string( "FK_contentID", 36 );
			table.foreignKey( "FK_contentID" ).references( "contentID" ).onTable( "cb_content" );
		} );

	}


}
