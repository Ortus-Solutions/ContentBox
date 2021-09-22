<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$settingEditor 	= $( "##settingEditor" );
	$importDialog 	= $( "##importDialog" );

	// settings sorting
	$( "##settings" ).dataTable( {
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
	// Search filter
	$( "##eventFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##eventsList" ), this.value );
            },
            300
        )
	);

	// form validator
	$settingEditor.validate();

	// reset
	$('##btnReset').click(function() {
		$settingEditor.find( "##settingID" ).val( '' );
		$settingEditor.find( "##btnSave" ).val( "Save" );
		$settingEditor.find( "##btnReset" ).val( "Reset" );
	} );

	// settings quick search
	$( "##settingSearch" ).keyup(
		_.debounce(
            function(){
                var $this = $(this);
				var clearIt = ( $this.val().length > 0 ? false : true );
				// ajax search
				settingsLoad( $this.val() );
            },
            300
        )
	);

	// Load settings
	settingsLoad( $( "##settingSearch" ).val() );
} );
function flushSettingsCache(){
	$( "##specialActionsLoader" ).removeClass( "hidden" );
	$.ajax( {
		url : '#event.buildLink(prc.xehFlushCache)#',
		success : function(data){
			if (data.ERROR) {
				adminNotifier( "error", data.MESSAGES, 3000 );
			}
			else{
				adminNotifier( "info", data.MESSAGES );
			}
			$( "##specialActionsLoader" ).addClass( "hidden" );
		}
	} );

}
/**
 * Load settings according to filters
 */
function settingsLoad( search, viewAll, page ){
	$( '##settingsTableContainer' )
		.load(
			'#event.buildLink( prc.xehRawSettingsTable )#',
			{
				search 	: search || "",
				viewAll : viewAll || false,
				page 	: page || 1 ,
				siteId 	: $( "##siteFilter" ).val()
			},
			function(){
				$( this ).fadeIn();
				activateConfirmations();
			}
		);
}
function settingsPaginate( page ){
	$('##settingsTableContainer').fadeOut();
	settingsLoad( $( "##settingSearch" ).val() , false, page );
}
function viewAllSettings(){
	$( '##settingsTableContainer' ).fadeOut();
	settingsLoad( "", true );
}
function edit( settingID, name, value, isCore, siteID ){
	openModal( $( "##settingEditorContainer" ), 500, 300 );
	$settingEditor.find( "##settingID" ).val( settingID );
	$settingEditor.find( "##name" ).val( name );
	$settingEditor.find( "##value" ).val( value );
	if( isCore === true ){
		$settingEditor.find( "##isCore" ).attr( "checked", true );
	}
	$settingEditor.find( "##site" ).val( siteID );
	$settingEditor.find( "##btnSave" ).val( "Update" );
	$settingEditor.find( "##btnReset" ).val( "Cancel" );
}
function remove( settingID ){
	var $settingForm = $( "##settingForm" );
	$( "##delete_"+ settingID).removeClass( "icon-remove-sign" ).addClass( "fa fa-spinner fa-spin" );
	$settingForm.find( "##settingID" ).val( settingID );
	$settingForm.submit();
}
function createSetting(){
	$settingEditor.find( "##settingID" ).val( '' );
	$settingEditor.find( "##name" ).val( '' );
	$settingEditor.find( "##value" ).val( '' );
	$settingEditor.find( "##isCore" ).attr( "checked", false );
	$settingEditor.find( "##site" ).val( "" );
	$settingEditor.find( "##btnSave" ).val( "Save" );
	openModal( $( "##settingEditorContainer" ), 500, 350 );
	return false;
}
function submitSettingForm(){
	$( "##settingEditor" ).submit();
}
function exportSelected( exportEvent ){
	var selected = [];
	$( "##settingID:checked" ).each( function(){
		selected.push( $( this ).val() );
	} );
	if( selected.length ){
		checkAll( false, 'settingID' );
		window.open( exportEvent + "/settingID/" + selected );
	} else {
		alert( "Please select something to export!" );
	}
}
</script>
</cfoutput>