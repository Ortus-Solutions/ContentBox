component {
	function up( schema, query ){
		schema.create( "user", function(table) {
			table.string( "userId" ).primaryKey();
			table.string( "userType", 50 );
			table.datetime( "createdDate" ).withCurrent();
			table.datetime( "modifiedDate" ).withCurrent();
			table.tinyInteger( "isActive", 1 ).default( 1 );
			table.string( "fname", 100 );
			table.string( "lname", 100 );
			table.string( "title" );
			table.string( "email" ).unique();
			table.string( "password" );
			table.datetime( "lastLogin" ).nullable();
			table.string( "mobilePhone", 100 ).nullable();
			table.string( "homePhone", 100 ).nullable();
			table.date( "dob", 100 ).nullable();
			table.string( "tshirtSize", 100 ).nullable();
			table.longText( "preferences" ).default( "" ).nullable();
			table.string( "facebookURL" ).nullable();
			table.string( "twitterURL" ).nullable();
			table.string( "blogURL" ).nullable();
			table.string( "linkedinURL" ).nullable();
			table.string( "githubURL" ).nullable();
			table.tinyInteger( "isPasswordReset", 1 ).default( 1 );
			table.longText( "biography" ).nullable();
			table.string( "address" ).nullable();
			table.string( "city", 75  ).nullable();
			table.string( "stateOrProvince" ).nullable();
			table.string( "postalCode" ).nullable();
			table.string( "country", 75 );
			table.string( "timeZone", 150 );
			table.string( "FK_roleId" );
			table.string( "FK_clientId" ).nullable();
			table.string( "FK_managerId" ).nullable();
		} );
	}

	function down( schema, query ){
		schema.drop( "user" );
	}

}
