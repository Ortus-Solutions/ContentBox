<cfoutput>
<!--- Render Commong editor functions --->
#renderView(view="_tags/editors",prePostExempt=true)#
<!--- Custom Javascript --->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lz-string/1.4.4/lz-string.min.js"></script>
<script src="#prc.cbroot#/includes/js/cb-autosave.js"></script>
<script type="text/javascript">
$(document).ready(function() {
 	// Editor Pointers
	$entryForm 		= $( "##entryForm" );
    // setup clockpicker
    $( '.clockpicker' ).clockpicker();
	// setup editors via _tags/editors.cfm by passing the form container
	setupEditors( $entryForm, true, '#event.buildLink(prc.xehEntrySave)#' );

	AutoSave($content,$contentID,'contentAutoSave');


} );
</script>
</cfoutput>
