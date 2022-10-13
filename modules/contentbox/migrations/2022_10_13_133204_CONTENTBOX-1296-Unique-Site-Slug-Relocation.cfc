component {

    function up( schema, qb ) {
		if( schema.hasTable( "cb_relocations" ) ){
			schema.alter( "cb_relocations", function( table ) {
				table.unique( [ "slug", "FK_siteID" ] );
			} );
		} else {
			arguments.schema.create( "cb_relocations", ( table ) => {
				table.string( "relocationID", 36 ).primaryKey();
				table.dateTime( "createdDate" );
				table.dateTime( "modifiedDate" );
				table.boolean( "isDeleted" ).default( false );
				table.string( "slug", 500 );
				table.string( "target", 500 ).nullable();
				table.string( "FK_siteID", 36 );
				table.string( "FK_contentID", 36 ).nullable();
				table.unique( [ "slug", "FK_siteID" ] );
			} );
		}
    }

    function down( schema, qb ) {

    }

}
