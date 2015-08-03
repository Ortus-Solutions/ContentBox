<cfoutput>
<!--- Render Commong editor functions --->
#renderView(view="_tags/editors",prePostExempt=true)#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Editor Pointers
	$contentForm 		= $( "##contentForm" );
    // setup clockpicker
    $( '.clockpicker' ).clockpicker();
	// setup editors via _tags/editors.cfm by passing the form container
	setupEditors( $contentForm, false, '#event.buildLink(prc.xehContentSave)#' );
} );
</script>
</cfoutput>