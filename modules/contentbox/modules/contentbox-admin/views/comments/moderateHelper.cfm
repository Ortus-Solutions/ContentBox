<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$commentForm = $( "##commentForm" );
} );
function removeComment(){
	$commentForm.attr( "action","#event.buildlink(linkTo=rc.xehCommentRemove)#" );
}
</script>
</cfoutput>