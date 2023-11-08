/**
 * CONTENTBOX-1452: Remove featuredImageURL column from cb_content
 * https://ortussolutions.atlassian.net/browse/CONTENTBOX-1452
 */
component {

	// Include Utils
	include template="./util/MigrationUtils.cfm";

	function up( schema, qb ){
		var mediaRoot = qb
			.newQuery()
			.from( "cb_setting" )
			.where( "name", "cb_media_directoryRoot" )
			.where( "isCore", 1 )
			.first();

		if( !structKeyExists( mediaRoot, "value" ) ){
			systemoutput( "Media root doesn't exist, skipping migration", true );
			return;
		}

		mediaRoot = mediaRoot.value;

		qb.newQuery()
			.from( "cb_content" )
			.where( "featuredImage", "!=", "%:%" )
			.select( [ "contentID", "featuredImage" ] )
			.get()
			.each( function( item ){
				if ( findNoCase( mediaRoot, item.featuredImage ) ) {
					qb.newQuery()
						.from( "cb_content" )
						.where( "contentID", item.contentID )
						.update( { "featuredImage" : replaceNoCase( item.featuredImage, mediaRoot, "contentbox:" ) } );
				}
			} );

		if ( hasColumn( "cb_content", "featuredImageURL" ) ) {
			schema.alter( "cb_content", function( table ){
				table.dropColumn( "featuredImageURL" );
			} );
		}
	}

	function down( schema, qb ){
	}

}
