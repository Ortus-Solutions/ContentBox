<cfparam name="cfmlPassword" default="">
<cfscript>
	results = { error = false, messages = "" };
	
	try{
		// CF
		if( server.coldfusion.productName eq "ColdFusion Server" ){
			results.error = ( !createObject("component","cfide.adminapi.administrator").login( cfmlPassword ) );
			if( !results.error ){
				results.messages = "CFML Password verified";
			}
			else{
				results.messages = "Invalid CFML Password";
			}
		}
		// RAILO
		else{
			
		}
	}
	catch(Any e){
		results.error = true;
		results.messages = "#e.message# #e.detail#";
	}
</cfscript>
<cfsetting showdebugoutput="false" >
<cfcontent reset="true" type="application/json">
<cfoutput>#serializeJSON( results )#</cfoutput>