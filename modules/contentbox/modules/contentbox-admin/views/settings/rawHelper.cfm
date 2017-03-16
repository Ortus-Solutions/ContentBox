<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$settingEditor = $( "##settingEditor" );
	$importDialog = $( "##importDialog" );
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
	$( "##eventFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##eventsList" ), this.value );
            },
            300
        )
	);
	// singletons sorting + filter
	$( "##singletons" ).dataTable( {
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
	$( "##singletonsFilter" ).keyup(function(){
		$.uiTableFilter( $( "##singletons" ), this.value );
	} );
	// form validator
	$settingEditor.validate();
	// reset
	$('##btnReset').click(function() {
		$settingEditor.find( "##settingID" ).val( '' );
		$settingEditor.find( "##btnSave" ).val( "Save" );
		$settingEditor.find( "##btnReset" ).val( "Reset" );
	} );
	// keyup quick search
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
function settingsLoad(search, viewAll, page){
	if( search == undefined){ search = ""; }
	if( viewAll == undefined){ viewAll = false; }
	if( page == undefined){ page = 1; }
	
	$('##settingsTableContainer').load( '#event.buildLink( prc.xehRawSettingsTable )#', 
		{ search: search, viewAll: viewAll, page: page }, 
		function(){
			$(this).fadeIn();
			activateConfirmations();
	} );
}
function settingsPaginate(page){
	$('##settingsTableContainer').fadeOut();
	settingsLoad( $( "##settingSearch" ).val() , false, page );
}
function viewAllSettings(){
	$('##settingsTableContainer').fadeOut();
	settingsLoad( "", true );
}
function edit( settingID, name, value, isCore ){
	openModal( $( "##settingEditorContainer" ), 500, 300 );
	$settingEditor.find( "##settingID" ).val( settingID );
	$settingEditor.find( "##name" ).val( name );
	$settingEditor.find( "##value" ).val( value );
	if( isCore === true ){
		$settingEditor.find( "##isCore" ).attr( "checked", true );
	}
	$settingEditor.find( "##btnSave" ).val( "Update" );
	$settingEditor.find( "##btnReset" ).val( "Cancel" );
}
function remove(settingID){
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
	$settingEditor.find( "##btnSave" ).val( "Save" );
	openModal( $( "##settingEditorContainer" ), 500, 350 );
	return false;
}
function submitSettingForm(){
	$( "##settingEditor" ).submit();
}
</script>
</cfoutput>