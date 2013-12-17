<cfparam name="url.version" default="0">
<!---
Copies a directory.
@author Joe Rinehart (joe.rinehart@gmail.com), mod by Luis Majano 2010
--->
<cffunction name="copyDirectory" output="true" hint="Copies an entire source directory to a destination directory" returntype="void">
	<cfargument name="source" 		required="true" type="string">
	<cfargument name="destination" 	required="true" type="string">
	<cfargument name="nameconflict" required="true" default="overwrite">

	<cfset var contents = "" />

	<cfif not(directoryExists(arguments.destination))>
		<cfdirectory action="create" directory="#arguments.destination#">
	</cfif>

	<cfdirectory action="list" directory="#arguments.source#" name="contents">

	<cfloop query="contents">
		<cfif contents.type eq "file">
			<cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">
		<cfelseif contents.type eq "dir">
			<cfset copyDirectory( arguments.source & "/" & name, arguments.destination & "/" & name, arguments.nameconflict ) />
		</cfif>
	</cfloop>
</cffunction>
<cfscript>
	version = url.version;
	colddoc = new colddoc.ColdDoc();

	// Prepare copy of original source
	copyDirectory(source=expandPath("../../modules/contentbox"), destination=expandPath("/contentbox"));
	// cleanup the modules
	directoryDelete( expandPath("/contentbox/modules"), true );
	// Core
	docName 	= "ContentBox-API-#version#";
	docBase		= expandPath("/contentbox");
	docOutput 	= expandPath("exports/" & docName);
	strategy 	= new ColdDoc.strategy.api.HTMLAPIStrategy(docOutput, "ContentBox Core API #version#");
	colddoc.setStrategy(strategy);
	colddoc.generate(inputSource=docBase, outputDir=docOutput, inputMapping="contentbox");

	// remove copy of original source and create it again
	directoryDelete( expandPath("/contentbox"), true );
	directoryCreate( expandPath("/contentbox") );
</cfscript>

<!--- Zip Files --->
<cfzip action="zip" file="#docOutput#.zip" source="#docOutput#" overwrite="true" recurse="yes">
<!--- Remove old files --->
<cfset directoryDelete( docOutput, true )>

<cfoutput>
<h1>Done!</h1>
</cfoutput>
