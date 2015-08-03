<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$versionsPagerForm = $( "##versionsPagerForm" );
	$versionsPager = $( "##versionsHistoryTable" );
	$versionsPager.find( "tr:even" ).addClass( "even" );
	// quick look
	$versionsPager.find( "tr" ).bind( "contextmenu",function(e) {
		if (e.which === 3) {
			if( $(this).attr('data-versionID') != null ){
				openRemoteModal('#event.buildLink(prc.xehVersionQuickLook)#/versionID/' + $(this).attr('data-versionID'));
				e.preventDefault();
			}
		}
	} );
} );
function versionsPagerDiff(){
	var oldVersion 	= $( ".rb_oldversion:checked" ).val();
	var cVersion 	= $( ".rb_version:checked" ).val();
	// open the diff window
	openRemoteModal('#event.buildLink(prc.xehVersionDiff)#',{oldVersion:oldVersion,version:cVersion},'95%');
	return false;
}
<cfif prc.oAuthor.checkPermission( "VERSIONS_DELETE" )>
function versionsPagerRemove(versionID){
	$('##version_delete_'+versionID).removeClass( "icon-remove-sign" ).addClass( "icon-spin icon-spinner" );
	// ajax remove change
	$.post( "#event.buildlink(linkTo=prc.xehVersionRemove)#", {versionID:versionID}, function(data){
		closeConfirmations();
		if( !data.ERROR ){
			$('##version_row_'+versionID).fadeOut().remove();
			adminNotifier( "info", data.MESSAGES, 10000 );
		}
		else{
			adminNotifier( "error", data.MESSAGES, 10000 );
			$('##version_delete_'+versionID).removeClass( "icon-spin icon-spinner" ).addClass( "icon-remove-sign" );
		}
	},"json" );	
}
</cfif>
<cfif prc.oAuthor.checkPermission( "VERSIONS_ROLLBACK" )>
function versionsPagerRollback(versionID){
	$('##version_rollback_'+versionID).addClass( "icon-spin" );
	// ajax rollback change
	$.post( "#event.buildlink(linkTo=prc.xehVersionRollback)#",{revertID:versionID},function(data){
		closeConfirmations();
		if( !data.ERROR ){
			location.reload();
			adminNotifier( "info", data.MESSAGES, 10000 );	
		}
		else{
			adminNotifier( "error", data.MESSAGES, 10000 );
			$('##version_rollback_'+versionID).removeClass( "icon-spin" );
		}
	},"json" );	
}
</cfif>
</script>
</cfoutput>