component {
	function up( schema, query ){

		schema.create( "cb_commentSubscriptions", function(table) {

			table.string( "subscriptionID", 36 );
			table.string( "FK_contentID", 36 );

			table.foreignKey( "subscriptionID" ).references( "subscriptionID" ).onTable( "cb_subscriptions" );
			table.foreignKey( "FK_contentID" ).references( "contentID" ).onTable( "cb_content" );
		} );

	}

	function down( schema, query ){
	}

}
