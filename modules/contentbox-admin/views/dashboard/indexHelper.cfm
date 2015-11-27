<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
 	$( "##latestEntries" ).load( '#event.buildLink( prc.xehLatestEntries )#' );
	$( "##latestPages" ).load( '#event.buildLink( prc.xehLatestPages )#' );
	$( "##latestContentStore" ).load( '#event.buildLink( prc.xehLatestContentStore )#' );
	</cfif>
	$( "##latestNews" ).load( '#event.buildLink( prc.xehLatestNews )#' );
	<cfif prc.oAuthor.checkPermission( "COMMENTS_ADMIN" )>
	$( "##latestComments" ).load( '#event.buildLink( prc.xehLatestComments )#' );
	</cfif>
	<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR,COMMENTS_ADMIN" )>
	$( "##latestSnapshot" ).load( '#event.buildLink( prc.xehLatestSnapshot )#' );
	</cfif>
	<cfif prc.oAuthor.checkPermission( "SYSTEM_AUTH_LOGS" )>
		$( "##latestLogins" ).load( '#event.buildLink( prc.xehLatestLogins )#' );		
	</cfif>
	$( "##dashboardTabs a:first" ).tab( 'show' )
} );
<cfif prc.oAuthor.checkPermission( "SYSTEM_TAB" )>
function deleteInstaller(){
	deleteModule( '#event.buildLink(prc.xehDeleteInstaller)#', "installerCheck" );
}
function deleteDSNCreator(){
	deleteModule( '#event.buildLink(prc.xehDeleteDSNCreator)#', "dsnCreatorCheck" );
}
function deleteModule(link, id){
	$.post( link, {}, function(data){
		if( data.ERROR ){
			alert( data.MESSAGE );
		} 
		else{
			$( "##" + id ).html( data.MESSAGE ).delay( 2000 ).fadeOut();
		}
	},
	"JSON" );
}
</cfif>
</script>
</cfoutput>