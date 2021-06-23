<cfscript>
if( findNoCase( "coldfusion", server.coldfusion.productName ) ){
	// Adobe has weird issues, we have to use this approach
	getPageContext().getResponse().sendRedirect( "modules/contentbox-dsncreator" );
} else {
	location( "modules/contentbox-dsncreator", false );
}
</cfscript>
