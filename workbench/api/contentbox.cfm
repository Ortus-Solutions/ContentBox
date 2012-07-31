<cfparam name="url.version" default="0">
<!--- directoryRemove --->
<cffunction name="directoryRemove" output="false" access="public" returntype="void" hint="Remove an entire directory">
	<cfargument name="path" type="string" required="true" default="" hint="The full path to remove"/>
	<cfargument name="recurse" type="boolean" required="false" default="true" hint="Recurse or not"/>

	<cfdirectory action="delete" directory="#arguments.path#" recurse="#arguments.recurse#">
</cffunction>
<!---
Copies a directory.
@author Joe Rinehart (joe.rinehart@gmail.com), mod by Luis Majano 2010
--->
<cffunction name="directoryCopy" output="true" hint="Copies an entire source directory to a destination directory" returntype="void">
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
			<cfset directoryCopy(arguments.source & "/" & name, arguments.destination & "/" & name, arguments.nameconflict) />
		</cfif>
	</cfloop>
</cffunction>
<cfscript>
	version = url.version;
	colddoc = new colddoc.ColdDoc();

	// Prepare copy of original source
	directoryCopy(source=expandPath("../../modules/contentbox"), destination=expandPath("/contentbox"));
	// cleanup the modules
	directoryRemove( expandPath("/contentbox/modules") );
	// Core
	docName 	= "ContentBox-API-#version#";
	docBase		= expandPath("/contentbox");
	docOutput 	= expandPath("exports/" & docName);
	strategy 	= new ColdDoc.strategy.api.HTMLAPIStrategy(docOutput, "ContentBox Core API #version#");
	colddoc.setStrategy(strategy);
	colddoc.generate(inputSource=docBase, outputDir=docOutput, inputMapping="contentbox");

	// remove copy of original source and create it again
	directoryRemove( expandPath("/contentbox") );
	directoryCreate( expandPath("/contentbox") );
</cfscript>

<!--- Zip Files --->
<cfzip action="zip" file="#docOutput#.zip" source="#docOutput#" overwrite="true" recurse="yes">
<!--- Remove old files --->
<cfset directoryRemove( docOutput )>

<cfoutput>
<h1>Done!</h1>
</cfoutput>
