<!--- Params --->
<cfparam name="errors" 		default="">
<cfparam name="action" 		default="view">

<cfscript>
	// Asset root
	assetRoot = "../contentbox-admin";

	// Create or Use
	if( action eq "process" ){

		// Process or create?
		if( dsnCreated ){
			// Update datasource
			request.cfHelper.updateAPP( dsnName );
			// Relocate to installer now
			location( url="../../index.cfm", addToken="false" );
		}
		// Create new DSN
		else{
			results = request.cfHelper.createDSN(
				cfmlPassword	= cfpassword,
				dsnName			= dsnCreateName,
				dbType			= dbType,
				dbHost			= dbServer,
				dbName			= dbName,
				dbUsername		= dbUsername,
				dbPassword		= dbPassword
			);
			// Check for errors?
			if( !results.error ){
				// Update APP DSN Now!
				request.cfHelper.updateAPP( dsnCreateName );
				// Relocate to installer now
				location( url="../../index.cfm?cbInstaller=true", addToken="false" );
			} else {
				// Mark Errors
				errors = results.messages;
			}
		}
	}
</cfscript>