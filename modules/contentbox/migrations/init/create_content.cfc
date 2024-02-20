component {

	function up( schema, query ){
		schema.create( "cb_content", function( table ){
			// Base Columns
			table.string( "contentID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );
			// Content Columns
			table.string( "contentType" );
			table.string( "title", 500 );
			table.string( "slug" );
			table.datetime( "publishedDate" ).nullable();
			table.datetime( "expireDate" ).nullable();
			table.boolean( "isPublished" ).default( true );
			table.boolean( "allowComments" ).default( true );
			table.string( "passwordProtection", 100 ).nullable();
			table.string( "HTMLKeywords", 160 ).nullable();
			table.string( "HTMLDescription", 160 ).nullable();
			table.string( "HTMLTitle" ).nullable();
			table.boolean( "cache" ).default( true );
			table.integer( "cacheTimeout" ).default( 0 );
			table.integer( "cacheLastAccessTimeout" ).default( 0 );
			table.string( "markup", 100 ).default( "HTML" );
			table.boolean( "showInSearch" ).default( true );
			table.string( "featuredImage", 500 ).nullable();

			// Relationships
			table.string( "FK_siteID", 36 );
			table
				.foreignKey( "FK_siteID" )
				.references( "siteID" )
				.onTable( "cb_site" );
			table.string( "FK_authorID", 36 );
			table
				.foreignKey( "FK_authorID" )
				.references( "authorID" )
				.onTable( "cb_author" );
			table.string( "FK_parentID", 36 ).nullable();
			table
				.foreignKey( "FK_parentID" )
				.references( "contentID" )
				.onTable( "cb_content" );

			// Index
			table.index( [ "contentType" ], "idx_discriminator" );
			table.index( [ "isPublished", "contentType" ], "idx_published" );
			table.index( [ "slug" ], "idx_slug" );
			table.index( [ "slug", "isPublished" ], "idx_publishedSlug" );
			table.index( [ "publishedDate" ], "idx_publishedDate" );
			table.index( [ "expireDate" ], "idx_expireDate" );
			table.index( [ "title", "isPublished" ], "idx_search" );
			table.index( [ "cache" ], "idx_cache" );
			table.index( [ "cacheTimeout" ], "idx_cachetimeout" );
			table.index( [ "cacheLastAccessTimeout" ], "idx_cachelastaccesstimeout" );
			table.index( [ "showInSearch" ], "idx_showInSearch" );
		} );
	}

	function down( schema, query ){
	}

}
