<cfoutput>
<script type="text/javascript">
$(document).ready(function() {

} );
function switchLibrary(library){
	if( library == "null" ){ return; }
	to( "#event.buildLink(prc.xehMediaManager)#/library/" + library);
}
</script>
</cfoutput>