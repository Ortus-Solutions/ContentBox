component {

    function up( schema, query ) {
		var today = now();

		arguments.query
			.newQuery()
			.from( "cb_site" )
			.insert( {
				"createdDate" : today,
				"modifiedDate" : today,
				"isDeleted" : 0,
				"siteId" : 1,
				"name" : "Default Site",
				"slug" : "default",
				"description" : "The default site",
				"domainRegex" : ".*"
			} );
    }

    function down( schema, query ) {
		arguments.query
			.newQuery()
			.from( "cb_site" )
			.where( "siteId", 1 )
			.delete();
    }

}
