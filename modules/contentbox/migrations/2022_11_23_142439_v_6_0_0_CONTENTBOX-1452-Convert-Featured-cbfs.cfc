component {

    function up( schema, qb ) {

		var mediaRoot = qb.newQuery().from( "cb_setting" ).where( "name", "cb_media_directoryRoot" ).where( "isCore", 1 ).first().value;

		qb.newQuery().from( "cb_content" )
					.where( "featuredImage", "!=", "%:%" )
					.select( [ "contentID", "featuredImage" ] )
					.get()
					.each( function( item ){
						if( findNoCase( mediaRoot, item.featuredImage ) ){
							qb.newQuery().from( "cb_content" ).where( "contentID", item.contentID ).update( { "featuredImage" : replaceNoCase( item.featuredImage, mediaRoot, "contentbox:" ) } );
						}
					} );

		schema.alter( "cb_content", function( table ) {
			table.dropColumn( "featuredImageURL" );
		} );


    }

    function down( schema, qb ) {

    }

}
