/**
 * CONTENTBOX-1270 - Content Templates
 * https://ortussolutions.atlassian.net/browse/CONTENTBOX-1270
 */
component {

	// Include Utils
	include template="./util/MigrationUtils.cfm";

	function up( schema, qb ){
		// Content Templates
		if ( !schema.hasTable( "cb_contentTemplate" ) ) {
			arguments.schema.create( "cb_contentTemplate", ( table ) => {
				// Columns
				table.string( "templateID", 36 ).primaryKey();
				table.dateTime( "createdDate" );
				table.dateTime( "modifiedDate" );
				table.boolean( "isDeleted" ).default( false );
				table.boolean( "isGlobal" ).default( false );
				table.string( "contentType", 50 );
				table.string( "name", 255 );
				table.string( "description", 1000 );
				table.longText( "definition" );

				// Relationships
				table.string( "FK_authorID", 36 );
				table.string( "FK_siteID", 36 ).nullable();
				table
					.foreignKey( "FK_authorID" )
					.references( "authorID" )
					.onTable( "cb_author" );
				table
					.foreignKey( "FK_siteID" )
					.references( "siteID" )
					.onTable( "cb_site" );

				// Indexes
				table.index( [ "contentType" ], "idx_contentType" );
			} );
		} else {
			systemOutput( "- skipping 'cb_contentTemplate' creation, table already there", true );
		}

		// Relationship between Content Templates and Content
		if ( !hasColumn( "cb_content", "FK_contentTemplateID" ) ) {
			schema.alter( "cb_content", ( table ) => {
				table.addColumn( table.string( "FK_contentTemplateID", 36 ).nullable() );
				table
					.foreignKey( "FK_contentTemplateID" )
					.references( "templateID" )
					.onTable( "cb_contentTemplate" );
			} );
		} else {
			systemOutput( "- skipping 'cb_content.FK_contentTemplateID' creation, column already there", true );
		}

		if ( !hasColumn( "cb_content", "FK_childContentTemplateID" ) ) {
			schema.alter( "cb_content", ( table ) => {
				table.addColumn( table.string( "FK_childContentTemplateID", 36 ).nullable() );
				table
					.foreignKey( "FK_childContentTemplateID" )
					.references( "templateID" )
					.onTable( "cb_contentTemplate" );
			} );
		} else {
			systemOutput( "- skipping 'cb_content.FK_childContentTemplateID' creation, column already there", true );
		}
	}

	function down( schema, qb ){
	}

}
