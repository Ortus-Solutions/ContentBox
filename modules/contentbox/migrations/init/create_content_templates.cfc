/**
 * CONTENTBOX-1270 - Content Templates
 * https://ortussolutions.atlassian.net/browse/CONTENTBOX-1270
 */
component {

	function up( schema, qb ){
		schema.create( "cb_contentTemplate", ( table ) => {

			// Base Columns
			table.string( "templateID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.boolean( "isGlobal" ).default( false );
			table.string( "contentType", 50 ).nullable();
			table.string( "name", 255 );
			table.string( "description", 1000 ).nullable();
			table.longText( "definition" );

			// Relationships
			table.string( "FK_authorID", 36 );
			table.foreignKey( "FK_authorID" ).references( "authorID" ).onTable( "cb_author" );
			table.string( "FK_siteID", 36 );
			table.foreignKey( "FK_siteID" ).references( "siteID" ).onTable( "cb_site" );

			// Indexes
			table.index( [ "contentType" ], "idx_contentType" );
		} );

		// Relationship between Content Templates and Content
		schema.alter( "cb_content", ( table ) => {
			table.addColumn( table.string( "FK_contentTemplateID", 36 ).nullable() );
			table
				.foreignKey( "FK_contentTemplateID" )
				.references( "templateID" )
				.onTable( "cb_contentTemplate" );
		} );

		schema.alter( "cb_content", ( table ) => {
			table.addColumn( table.string( "FK_childContentTemplateID", 36 ).nullable() );
			table
				.foreignKey( "FK_childContentTemplateID" )
				.references( "templateID" )
				.onTable( "cb_contentTemplate" );
		} );
	}

	function down( schema, qb ){
	}

}
