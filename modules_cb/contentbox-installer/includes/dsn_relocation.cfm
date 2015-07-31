<cfscript>
if( findNoCase( "coldfusion", server.coldfusion.productName ) and listFirst( server.coldfusion.productVersion ) gte 11 ){
	getPageContext().getResponse().sendRedirect( "modules_cb/contentbox-dsncreator" );
} else {
	location( "modules_cb/contentbox-dsncreator", false );
}
</cfscript>
