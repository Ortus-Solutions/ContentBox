<cfoutput>
<!--- Custom Javascript --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
		// Load My Latest Drafts
		$( "##latestSystemEdits" ).load( '#event.buildLink( prc.xehLatestSystemEdits )#' );
		// Load Future Published Content
		$( "##futurePublished" ).load( '#event.buildLink( prc.xehPublishedContent )#' );
		// Load expired content
		$( "##expiredContent" ).load( '#event.buildLink( prc.xehExpiredContent )#' );
		// Load latest System Edits
		$( "##latestUserDrafts" ).load( '#event.buildLink( prc.xehLatestUserDrafts )#' );
 	</cfif>

	 // Load news
	$( "##latestNews" ).load( '#event.buildLink( prc.xehLatestNews )#' );

	<cfif prc.oCurrentAuthor.checkPermission( "COMMENTS_ADMIN" )>
		// Load comments
		$( "##latestComments" ).load( '#event.buildLink( prc.xehLatestComments )#' );
	</cfif>

	<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR,COMMENTS_ADMIN" )>
		// Load snapshots
		$( "##latestSnapshot" ).load( '#event.buildLink( prc.xehLatestSnapshot )#' );
	</cfif>

	<cfif prc.oCurrentAuthor.checkPermission( "SYSTEM_AUTH_LOGS" )>
		// Load latest logsin
		$( "##latestLogins" ).load( '#event.buildLink( prc.xehLatestLogins )#' );
	</cfif>

	// Select first dashboard tab
	$( "##dashboardTabs a:first" ).tab( 'show' )
} );
<!--- If Admin, show Module Cleanups --->
<cfif prc.oCurrentAuthor.checkPermission( "SYSTEM_TAB" )>
function deleteInstaller(){
	deleteModule( '#event.buildLink( prc.xehDeleteInstaller )#', "installerCheck" );
}
function deleteModule(link, id){
	$.post( link, {}, function( data ){
		if( data.ERROR ){
			alert( data.MESSAGE );
		} else {
			$( "##" + id ).html( data.MESSAGE ).delay( 2000 ).fadeOut();
		}
	},
	"JSON" );
}
</cfif>
</script>
</cfoutput>