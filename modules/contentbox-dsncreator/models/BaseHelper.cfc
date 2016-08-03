<!---
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
--->
<cfcomponent output="false" hint="ContentBox DSN Base helper">

	<!--- Constructor --->
	<cffunction name="init" output="false" returntype="BaseHelper" hint="constructor" access="public">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

	<!--- verifyDSN --->
    <cffunction name="verifyDSN" output="false" access="public" returntype="struct" hint="Verify the DSN exists, returns struct: {error:boolean, exists:boolean, messages:string}">
    	<cfargument name="dsnName" required="true"/>

    	<cfset var results = { "ERROR" = false, "EXISTS" = false, "MESSAGES" = "" }>
    	<cftry>

			<cfdbinfo type="version" name="dbResults" datasource="#arguments.dsnName#">
			<cfset results.messages = "Datasource verified">
			<cfset results.exists = true>

			<cfcatch type="any">
				<cfset results.error = true>
				<cfset results.exists = false>
				<cfset results.messages = "#cfcatch.message# #cfcatch.detail#">
			</cfcatch>
		</cftry>

		<cfreturn results>
    </cffunction>

    <!--- updateAPP --->
    <cffunction name="updateAPP" output="false" access="public" returntype="any" hint="Update the application's DSN and data">
    	<cfargument name="dsnName" required="true"/>
    	<cfscript>
			var appCFCPath = expandPath( "/appShell/Application.cfc" );
			var c = fileRead( appCFCPath );

			// Update DSN
			c = replacenocase( c, 'this.datasource = "contentbox"','this.datasource = "#arguments.dsnName#"' );
			// Update relocations
			c = replacenocase( c, 'include "modules/contentbox-installer/includes/dsn_relocation.cfm";','' );

			// CF9 stupid cached dsn
			if( listFirst( server.coldfusion.productVersion ) eq 9 ){
				var cf9OnErrorPath = getDirectoryFromPath( getMetadata( this ).path ) & "cf9-OnError.txt";
				c = replacenocase( c, '//@cf9-onError@', fileRead( cf9OnErrorPath ) );
			}

			// Write out new Application.cfc
			fileWrite( appCFCPath, c );

    	</cfscript>
    </cffunction>

    <!------------------------------------------- PRIVATE ------------------------------------------>

</cfcomponent>