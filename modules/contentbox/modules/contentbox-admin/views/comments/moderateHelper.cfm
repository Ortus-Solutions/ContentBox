<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$commentForm = $( "##commentForm" );
} );
function removeComment(){
	$commentForm.attr( "action", "#event.buildlink( rc.xehCommentRemove )#" );
}
</script>
</cfoutput>