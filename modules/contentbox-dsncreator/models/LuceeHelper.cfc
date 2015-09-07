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
<cfcomponent output="false" hint="ContentBox DSN creator helper" extends="BaseHelper">

	<!--- Constructor --->
	<cffunction name="init" output="false" returntype="LuceeHelper" hint="constructor" access="public">
		<cfscript>
			super.init();
			return this;
		</cfscript>
	</cffunction>

    <!--- verifyCFMLAdmin --->
    <cffunction name="verifyCFMLAdmin" output="false" access="public" returntype="struct" hint="Verify if the cf admin password validates. Returns struct: {error:boolean, messages:string}">
    	<cfargument name="cfmlPassword" required=true>
    	<cfscript>
			var results = { "ERROR" = false, "MESSAGES" = "" };
    		try{
    			var isValid = isValidRailoPassword( arguments.cfmlPassword );

    			if( isValid ){
    				results.messages = "CFML Password Verified!";
    			}
    			else{
    				results.error = true;
    				results.messages = "Invalid CFML Password!";
    			}
    		}
    		catch(Any e){
    			results.error = true;
    			results.messages = "Error validating password: #e.message# #e.detail#";
    		}

    		return results;
    	</cfscript>
    </cffunction>

    <!--- createDSN --->
    <cffunction name="createDSN" output="false" access="public" returntype="any" hint="Create the DSN, returns struct: {error:boolean, messages:string}">
    	<cfargument name="cfmlPassword" 	required=true>
		<cfargument name="dsnName" 			required="true">
    	<cfargument name="dbType" 			required="true">
    	<cfargument name="dbHost" 			required="true">
    	<cfargument name="dbName" 			required="true">
		<cfargument name="dbUsername" 		required="false" default="">
		<cfargument name="dbPassword" 		required="false" default="">

		<cfset var results = { "ERROR" = false, "MESSAGES" = "" }>

		<cftry>
			<!---Get Datasources --->
			<cfadmin
				action="getDatasources"
				type="web"
				password="#arguments.cfmlPassword#"
				returnVariable="local.datasources">
			<!---Verify it --->
			<cfif ListFindNoCase( ValueList( local.datasources.name ), arguments.dsnName )>
				<cfthrow type="DuplicateDSNException" message="Datsource #arguments.dsnName# already exists!">
			</cfif>

			<cfswitch expression="#arguments.dbType#">
				<cfcase value="mssql">
					<cfset local.dsnString = "jdbc:sqlserver://{host}:{port}">
					<cfset local.dbPort = "1433">
					<cfset local.className = "com.microsoft.jdbc.sqlserver.SQLServerDriver">
				</cfcase>
				<cfcase value="mysql">
					<cfset local.dsnString = "jdbc:mysql://{host}:{port}/{database}">
					<cfset local.dbPort = "3306">
					<cfset local.className = "org.gjt.mm.mysql.Driver">
				</cfcase>
				<cfcase value="oracle">
					<cfset local.dsnString = "jdbc:oracle:{drivertype}:@{host}:{port}:{database}">
					<cfset local.dbPort = "1521">
					<cfset local.className = "oracle.jdbc.driver.OracleDriver">
				</cfcase>
				<cfcase value="postgresql">
					<cfset local.dsnString = "jdbc:postgresql://{host}:{port}/{database}">
					<cfset local.dbPort = "5432">
					<cfset local.className = "org.postgresql.Driver">
				</cfcase>
				<cfcase value="h2">
					<cfset local.dsnString = "jdbc:h2:{path}{database};MODE={mode}">
					<cfset local.dbPort = "">
					<cfset local.className = "org.h2.Driver">
				</cfcase>
				<cfcase value="HSQLDB">
					<cfset local.dsnString = "jdbc:hsqldb:file:{database}">
					<cfset local.dbPort = "">
					<cfset local.className = "org.hsqldb.jdbcDriver">
				</cfcase>				
			</cfswitch>

			<!---Create Datasource --->
			<cfadmin
				action="updateDatasource"
				type="web"
				password="#arguments.cfmlPassword#"
				name = "#arguments.dsnName#"
				newname = "#arguments.dsnName#"
				dsn = "#local.dsnString#"
				host = "#arguments.dbHost#"
				database = "#arguments.dbName#"
				dbusername = "#arguments.dbUsername#"
				dbpassword = "#arguments.dbPassword#"
				classname = "#local.className#"
				port = "#local.dbPort#"
				connectionLimit = -1
				connectionTimeout = 1
				blob = "true"
				clob = "true"
				allowed_select = "true"
				allowed_insert = "true"
				allowed_update = "true"
				allowed_delete = "true"
				allowed_alter = "true"
				allowed_drop = "true"
				allowed_revoke = "true"
				allowed_create = "true"
				allowed_grant = "true"
				custom="#structNew()#">

			<!---Verify it --->
			<cftry>
				<cfadmin
					action="verifyDatasource"
					type="web"
					password="#arguments.cfmlPassword#"
					name="#arguments.dsnName#"
					dbusername = "#arguments.dbUsername#"
					dbpassword = "#arguments.dbPassword#">
				<cfcatch>
					<!--- Roll back --->
					<cfadmin
						action="removeDatasource"
						type="web"
						password="#arguments.cfmlPassword#"
						name="#arguments.dsnName#">
					<cfset results.error = true>
					<cfset results.messages = "Datasource could not be verified, please check your settings.">
				</cfcatch>
			</cftry>

			<cfset results.error = false>
			<cfset results.messages = "DSN created and verified">

			<cfcatch type="any">
				<cfset results.error = true>
				<cfset results.messages = "Error creating DSN: #cfcatch.message# #cfcatch.detail#">
			</cfcatch>
		</cftry>

		<cfreturn results>
    </cffunction>

    <!------------------------------------------- PRIVATE ------------------------------------------>

    <!--- isValidRailoPassword --->
    <cffunction name="isValidRailoPassword" output="false" access="private" returntype="boolean" hint="Validates Railo Admin password">
    	<cfargument name="cfmlPassword" required=true>

    	<cftry>
	    	<cfadmin
			    action="connect"
			    type="web"
			    password="#arguments.cfmlPassword#">
			<cfreturn true>
			<cfcatch type="any">
				<cfreturn false>
			</cfcatch>
		</cftry>
    </cffunction>


</cfcomponent>
