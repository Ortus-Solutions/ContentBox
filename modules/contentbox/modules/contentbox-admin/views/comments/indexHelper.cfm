<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$commentForm = $( "##commentForm" );
	// Comment search
	$( "##commentSearch" ).keyup(
		_.debounce(
			function(){
				$.uiTableFilter( $( "##comments" ), this.value );
			},
			300
		)
	);

	// comment quick look
	$commentForm.find( "##comments" ).find( "tr" ).bind( "contextmenu",function(e) {
	    if( e.which === 3 ){
	    	if( $( this ).attr( 'data-commentID' ) != null){
				openRemoteModal( '#event.buildLink(prc.xehCommentQuickLook )#', {
					commentID : $( this ).attr( 'data-commentID' )
				} );
				e.preventDefault();
			}
	    }
	} );

	// Data table setup
	$commentForm.find( "##comments" ).dataTable( {
	    "paging": false,
	    "info": false,
	    "searching": false,
	    "columnDefs": [
	        {
	            "orderable": false,
	            "targets": '{sorter:false}'
	        }
	    ],
	    "order": []
	} );
} );
<cfif prc.oCurrentAuthor.checkPermission( "COMMENTS_ADMIN" )>
function changeStatus(status,recordID){
	$commentForm.attr( "action","#event.buildlink(to=prc.xehCommentstatus)#" );
	$commentForm.find( "##commentStatus" ).val(status);
	if( recordID != null ){
		$( "##status_"+ recordID).removeClass( "fa fa-minus-circle" ).addClass( "fa fa-spinner fa-spin" );
		checkByValue('commentID',recordID);
	}
	$commentForm.submit();
}
function remove( recordID ){
	checkAll( false, 'commentID' );
	if( recordID != null ){
		$( "##delete_"+ recordID)
			.removeClass( "fa fa-minus-circle" )
			.addClass( "fa fa-spinner fa-spin" );
		checkByValue( 'commentID', recordID );
		//Submit Form
		$commentForm.submit();
	}
}
function removeAllSelected(){
	$commentForm.submit();
}
function removeAllModerated(){
	$commentForm.attr( "action", "#event.buildlink( prc.xehCommentRemoveAllModerated )#" );
	$commentForm.submit();
}
</cfif>
</script>
</cfoutput>