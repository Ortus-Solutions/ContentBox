<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$commentForm = $( "##commentForm" );
	//$commentForm.find( "##comments" ).tablesorter();
	$commentForm.find( "##commentFilter" ).keyup(function(){
		$.uiTableFilter( $( "##comments" ), this.value );
	} );
	// comment quick look
	$commentForm.find( "##comments" ).find( "tr" ).bind( "contextmenu",function(e) {
	    if (e.which === 3) {
	    	if ($(this).attr('data-commentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehCommentQuickLook)#', {
					commentID: $(this).attr('data-commentID')
				} );
				e.preventDefault();
			}
	    }
	} );
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
<cfif prc.oAuthor.checkPermission( "COMMENTS_ADMIN" )>
function changeStatus(status,recordID){
	$commentForm.attr( "action","#event.buildlink(linkTo=prc.xehCommentstatus)#" );
	$commentForm.find( "##commentStatus" ).val(status);
	if( recordID != null ){
		$( "##status_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "fa fa-spinner fa-spin" );
		checkByValue('commentID',recordID);	
	}
	$commentForm.submit();
}
function remove(recordID){
	if( recordID != null ){
		$( "##delete_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "fa fa-spinner fa-spin" );
		checkByValue('commentID',recordID);		
	}
	//Submit Form
	$commentForm.submit();
}
function removeAllModerated(){
	$commentForm.attr( "action","#event.buildlink(linkTo=prc.xehCommentRemoveAllModerated)#" );
	$commentForm.submit();
}
</cfif>
</script>
</cfoutput>