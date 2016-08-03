<cfoutput>
<!--- Render Commong editor functions --->
#renderView( view="_tags/editors", prePostExempt=true )#
<!--- Custom Javascript --->
<script>
$( document ).ready( function(){
 	// Editor Pointers
	$entryForm = $( "##entryForm" );
	// setup editors via _tags/editors.cfm by passing the form container
	setupEditors( $entryForm, true, '#event.buildLink( prc.xehEntrySave )#' );
} );
</script>
</cfoutput>
