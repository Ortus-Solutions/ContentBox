<cfscript>
if( !structKeyExists( server, "railo") and listFirst( server.coldfusion.productVersion ) gte 11 ){
	getPageContext().getResponse().sendRedirect( "modules/contentbox-dsncreator" );
} else {
	location( "modules/contentbox-dsncreator", false );
}
</cfscript>
