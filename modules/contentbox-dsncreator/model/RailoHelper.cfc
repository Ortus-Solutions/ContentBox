<!--- 
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
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
	<cffunction name="init" output="false" returntype="RailoHelper" hint="constructor" access="public">
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