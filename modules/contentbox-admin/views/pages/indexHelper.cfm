<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// global ids
	$pageForm = $("##pageForm");
	$pages	  = $("##pages");
	$cloneDialog = $("##cloneDialog");
	// sorting and filtering
	$("##pages").tablesorter();
	$("##pageFilter").keyup(function(){
		$.uiTableFilter( $pages, this.value );
	});
	// quick look
	$pages.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-contentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehPageQuickLook)#/contentID/' + $(this).attr('data-contentID'));
				e.preventDefault();
			}
	    }
	});
	<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
	$pages.tableDnD({
		onDragClass: "selected",
		onDragStart : function(table,row){
			$(row).css("cursor","grab");
			$(row).css("cursor","-moz-grabbing");
			$(row).css("cursor","-webkit-grabbing");
		},
		onDrop: function(table, row){
			$(row).css("cursor","progress");
			var newRulesOrder  =  $(table).tableDnDSerialize();
			var rows = table.tBodies[0].rows;
			$.post('#event.buildLink(prc.xehPageOrder)#',{newRulesOrder:newRulesOrder},function(){
				for (var i = 0; i < rows.length; i++) {
					var oID = '##' + rows[i].id + '_order';
					$(oID).html(i+1);
				}
				$(row).css("cursor","move");
			});
		}
	});
	</cfif>
});
function showActions(contentID){
	$("##pageActions_" + contentID).slideToggle();
	return false;
}
function remove(contentID){
	if( contentID != null ){
		$('##delete_'+contentID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);		
	}
	$pageForm.submit();
}
function openCloneDialog(contentID, title){
	// local id's
	var $cloneForm = $("##cloneForm");
	// open modal for cloning options
	openModal( $cloneDialog, 500, 500 );
	// form validator and data
	$cloneForm.validator({
		position:'top left', 
		onSuccess:function(e,els){
			$cloneForm.find("##bottomCenteredBar").slideUp();
			$cloneForm.find("##clonerBarLoader").slideDown();
		} 
	});
	$cloneForm.find("##contentID").val( contentID );
	$cloneForm.find("##title").val( title ).focus();
	// close button
	$cloneForm.find("##closeButton").click(function(e){
		closeModal( $cloneDialog ); return false;
	});
	// clone button
	$cloneForm.find("##cloneButton").click(function(e){
		$cloneForm.submit();
	});
}
function bulkChangeStatus(status, contentID){
	$pageForm.attr("action","#event.buildlink(linkTo=prc.xehPageBulkStatus)#");
	$pageForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$('##status_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);	
	}
	$pageForm.submit();
}
</script>
</cfoutput>