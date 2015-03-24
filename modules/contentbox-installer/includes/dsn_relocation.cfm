<cfscript>
if( findNoCase( "coldfusion", server.coldfusion.productName ) and listFirst( server.coldfusion.productVersion ) gte 11 ){
	getPageContext().getResponse().sendRedirect( "modules/contentbox-dsncreator" );
} else {
	location( "modules/contentbox-dsncreator", false );
}
</cfscript>
