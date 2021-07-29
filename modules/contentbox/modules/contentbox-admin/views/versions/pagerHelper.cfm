<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$versionsPagerForm 	= $( "##versionsPagerForm" );
	$versionsPager 		= $( "##versionsHistoryTable" );
	// quick look
	$versionsPager.find( "tr" ).bind( "contextmenu", function( e ){
		if( e.which === 3 ){
			if( $( this ).attr( 'data-versionID' ) != null ){
				openRemoteModal( '#event.buildLink( prc.xehVersionQuickLook )#/versionID/' + $( this ).attr( 'data-versionID' ) );
				e.preventDefault();
			}
		}
	} );
} );
function versionsPagerDiff(){
	var oldVersion 	= $( ".rb_oldversion:checked" ).val();
	var cVersion 	= $( ".rb_version:checked" ).val();
	// open the diff window
	openRemoteModal( '#event.buildLink( prc.xehVersionDiff )#', { oldVersion : oldVersion, version : cVersion }, '95%' );
	return false;
}
<cfif prc.oCurrentAuthor.checkPermission( "VERSIONS_DELETE" )>
function versionsPagerRemove( versionID ){
	$( '##version_delete_' + versionID ).removeClass( "fa fa-minus-circle" ).addClass( "fa-spin fa-spinner" );
	// ajax remove change
	$.post(
		"#event.buildlink( prc.xehVersionRemove )#",
		{ versionID : versionID},
		function( data ){
			closeConfirmations();
			if( !data.ERROR ){
				$( '##version_row_' + versionID ).fadeOut().remove();
				adminNotifier( "info", data.MESSAGES, 10000 );
			} else {
				adminNotifier( "error", data.MESSAGES, 10000 );
				$( '##version_delete_' + versionID ).removeClass( "fa-spin fa-spinner" ).addClass( "fa fa-minus-circle" );
			}
		},
		"json"
	);
}
</cfif>
<cfif prc.oCurrentAuthor.checkPermission( "VERSIONS_ROLLBACK" )>
function versionsPagerRollback( versionID ){
	$( '##version_rollback_' + versionID ).addClass( "fa-spin" );
	// ajax rollback change
	$.post(
		"#event.buildlink( prc.xehVersionRollback )#",
		{ revertID : versionID },
		function( data ){
			closeConfirmations();
			if( !data.ERROR ){
				location.reload();
				adminNotifier( "info", data.MESSAGES, 10000 );
			} else{
				adminNotifier( "error", data.MESSAGES, 10000 );
				$( '##version_rollback_' + versionID ).removeClass( "fa-spin" );
			}
		},
		"json"
	);
}
</cfif>
</script>
</cfoutput>