<cfscript>
	param name="url.version" default="0";

	version = url.version;
	colddoc = new colddoc.ColdDoc();

	// Prepare copy of original source
	directoryCopy( expandPath( "../../modules/contentbox" ), expandPath( "/contentbox" ), true );

	// Cleanup of what to document
	cleanupDirs = listToArray( "content,email_templates,layouts," );
	for( thisCleanupDir in cleanupDirs ){
		directoryDelete( expandPath( "/contentbox/#thisCleanupDir#" ), true );
	}

	// Core
	docName 	= "ContentBox_API_#version#";
	docBase		= expandPath( "/contentbox" );
	docOutput 	= expandPath( "exports/" & docName );
	strategy 	= new ColdDoc.strategy.api.HTMLAPIStrategy( docOutput, "ContentBox Modular CMS v#version#" );
	colddoc.setStrategy( strategy );
	colddoc.generate( inputSource=docBase, outputDir=docOutput, inputMapping="contentbox" );

	// remove copy of original source and create it again
	directoryDelete( expandPath( "/contentbox" ), true );
	directoryCreate( expandPath( "/contentbox" ) );
</cfscript>

<!--- Zip Files --->
<cfzip action="zip" file="#docOutput#.zip" source="#docOutput#" overwrite="true" recurse="yes">
<!--- Remove old files --->
<cfset directoryDelete( docOutput, true )>

<cfoutput>
<h1>Done!</h1>
</cfoutput>
