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
	<cffunction name="init" output="false" returntype="CFHelper" hint="constructor" access="public">
		<cfscript>
			super.init();
			return this;
		</cfscript>
	</cffunction> 
    
    <!--- verifyCFMLAdmin --->    
    <cffunction name="verifyCFMLAdmin" output="false" access="public" returntype="struct" hint="Verify if the cf admin password validates. Returns struct: {error:boolean, messages:string}">    
    	<cfargument name="cfmlPassword" required=true>
    	<cfscript>
			var results = { error = false, messages = "" };
    		try{
    			var isValid = loginCFML( arguments.cfmlPassword );
    			
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
		<cfscript>
			var results = { error = false, messages = "" };
    		
			try{
				// Login First
				loginCFML( arguments.cfmlPassword );	    
				// Create CF DSN Manager
				var oDSNManager = createObject( "component","cfide.adminapi.datasource" );
				// Verify DSN Does not Exist yet
				if( structKeyExists( oDSNManager.getDatasources(), arguments.dsnName ) ){
					throw(message="Datsource #arguments.dsnName# already exists!", type="DuplicateDSNException" );
				}
				// Create DSN data struct
				var data = {
					name = arguments.dsnName,
					host = arguments.dbHost,
					database = arguments.dbName,
					username = arguments.dbUsername,
					password = arguments.dbPassword
				};
				// Create DSN
				switch( arguments.dbType ){
					case "mssql" : {
						oDSNManager.setMSSQL(argumentCollection=data);
						break;
					}
					case "mysql" : {
						oDSNManager.setMySQL5(argumentCollection=data);
						break;
					}
					case "postgresql" : {
						oDSNManager.setPostgreSQL(argumentCollection=data);
						break;
					}
					case "derby" : { 
						data.isnewdb = true;
						oDSNManager.setDerbyEmbedded(argumentCollection=data);
						break;
					}
					case "oracle" : {
						oDSNManager.setOracle(argumentCollection=data);
						break;
					}
				}
				
				// Verify It
				var isVerified = oDSNManager.verifyDsn( arguments.dsnName );
				// Check if it verified
				if( NOT isVerified ){
					oDSNManager.deleteDatasource( arguments.dsnName );
					results.error = true;
					results.messages = "Datasource could not be verified, please check your settings.";
				}
				else{
					results.error = false;
					results.messages = "DSN created and verified";
				}
			}
			catch(Any e){
				results.error = true;
				results.messages = "Error creating DSN: #e.message# #e.detail#";
			}
			
			return results;
    	</cfscript>    
    </cffunction>
    
    <!------------------------------------------- PRIVATE ------------------------------------------>
		
	<!--- loginCFML --->    
    <cffunction name="loginCFML" output="false" access="private" returntype="any" hint="Login to CFML admin">    
    	<cfargument name="cfmlPassword" required=true>
    	<cfscript>	
			return createObject( "component","cfide.adminapi.administrator" ).login( arguments.cfmlPassword );    
    	</cfscript>    
    </cffunction>
			
</cfcomponent>