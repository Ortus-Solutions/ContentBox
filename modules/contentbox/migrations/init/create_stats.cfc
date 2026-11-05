component {

	function up( schema, query ) {
		schema.create(
				"cb_stats",
				function( table ) {
					table.string( "statsID", 36 ).primaryKey();
					table.datetime( "createdDate" ).withCurrent();
					table.datetime( "modifiedDate" ).withCurrent();
					table.boolean( "isDeleted" ).default( false );

					table.bigInteger( "hits" ).default( 0 );

					table.string( "FK_contentID", 36 );
					table
						.foreignKey( "FK_contentID" )
						.references( "contentID" )
						.onTable( "cb_content" );

					table.index( [ "isDeleted"], "idx_stats_deleted" );
				}
			);
	}

	function down( schema, query ) {

	}

}