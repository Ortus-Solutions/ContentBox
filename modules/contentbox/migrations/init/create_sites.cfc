component {

	function up( schema, query ){
		schema.create( "cb_site", ( table ) => {
			// Base Columns
			table.string( "siteID", 36 ).primaryKey();
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.boolean( "isDeleted" ).default( false );

			table.string( "name" );
			table.string( "slug" ).unique();
			table.longText( "description" ).nullable();
			table.string( "domainRegex" ).nullable();
			table.string( "keywords" ).nullable();
			table.string( "tagline" ).nullable();
			table.string( "homepage" ).nullable();
			table.boolean( "isBlogEnabled" ).default( true );
			table.boolean( "isSitemapEnabled" ).default( true );
			table.boolean( "poweredByHeader" ).default( true );
			table.boolean( "adminBar" ).default( true );
			table.boolean( "isSSL" ).default( false );
			table.string( "activeTheme" ).nullable();
			table.longText( "notificationEmails" ).nullable();
			table.boolean( "notifyOnEntries" ).default( true );
			table.boolean( "notifyOnPages" ).default( true );
			table.boolean( "notifyOnContentStore" ).default( true );
			table.string( "domain" ).nullable();
			table.boolean( "isActive" ).default( true );
			table.string( "mediaDisk", 50 ).nullable();
			table.text( "domainAliases" ).nullable();

			// Indexes
			table.index( [ "slug" ], "idx_siteSlug" );
			table.index( [ "isDeleted" ], "idx_sites_deleted" );
		} );
	}

}
