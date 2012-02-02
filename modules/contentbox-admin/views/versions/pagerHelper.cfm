<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$versionsPager = $("##versionsHistoryTable");
	$versionsPager.find("tr:even").addClass("even");
	// quick look
	$versionsPager.find("tr").bind("contextmenu",function(e) {
		if (e.which === 3) {
			if( $(this).attr('data-versionID') != null ){
				openRemoteModal('#event.buildLink(prc.xehVersionQuickLook)#/versionID/' + $(this).attr('data-versionID'));
				e.preventDefault();
			}
		}
	});
});
function versionsPagerRemove(versionID){
	$('##version_delete_'+versionID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// ajax remove change
	$.post("#event.buildlink(linkTo=prc.xehVersionRemove)#",{versionID:versionID},function(data){
		if( data ){
			$('##version_row_'+versionID).fadeOut().remove();		
		}
		else{
			alert("Weird error removing version. Please try again or check the logs.");
			$('##version_delete_'+versionID).attr('src','#prc.cbRoot#/includes/images/delete.png');
		}
	},"json");	
}
function versionsPagerRollback(versionID){
	$('##version_rollback_'+versionID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// ajax rollback change
	$.post("#event.buildlink(linkTo=prc.xehVersionRollback)#",{revertID:versionID},function(data){
		if( data ){
			location.reload();	
		}
		else{
			alert("Weird error rolling back version. Please try again or check the logs.");
			$('##version_rollback_'+versionID).attr('src','#prc.cbRoot#/includes/images/arrow_merge.png');
		}
	},"json");	
}
</script>
</cfoutput>