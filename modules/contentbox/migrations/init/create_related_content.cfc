component {

	function up( schema, query ){
		schema.create( "cb_relatedContent", function( table ){
			table.string( "FK_contentID", 36 );
			table.string( "FK_relatedContentID", 36 );

			table
				.foreignKey( "FK_contentID" )
				.references( "contentID" )
				.onTable( "cb_content" );
			table
				.foreignKey( "FK_relatedContentID" )
				.references( "contentID" )
				.onTable( "cb_content" );
		} );
	}

	function down( schema, query ){
	}

}
