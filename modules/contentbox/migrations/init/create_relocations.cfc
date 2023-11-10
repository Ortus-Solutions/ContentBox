/**
 * CONTENTBOX-1296: Relocations table should have a unique constraint on slug and siteID
 * https://ortussolutions.atlassian.net/browse/CONTENTBOX-1296
 */
component {

	function up( schema, qb ){
		schema.create( "cb_relocations", ( table ) => {
			table.string( "relocationID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "slug", 500 );
			table.string( "target", 500 ).nullable();

			// Relationships
			table.string( "FK_siteID", 36 );
			table
				.foreignKey( "FK_siteID" )
				.references( "siteID" )
				.onTable( "cb_site" );
			table.string( "FK_contentID", 36 ).nullable();
			table
				.foreignKey( "FK_contentID" )
				.references( "contentID" )
				.onTable( "cb_content" );

			// Indexes
			table.unique( [ "slug", "FK_siteID" ] );
		} );
	}

	function down( schema, qb ){
	}

}
