<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
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
	$( "##eventFilter" ).keyup(function(){
		$.uiTableFilter( $( "##eventsList" ), this.value );
	} );
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
	$( "##settingSearch" ).keyup(function(){
		var $this = $(this);
		var clearIt = ( $this.val().length > 0 ? false : true );
		// ajax search
		settingsLoad( $this.val() );
	} );
	// Load settings
	settingsLoad( $( "##settingSearch" ).val() );
} );
function importSettings(){
	// local id's
	var $importForm = $( "##importForm" );
	// open modal for cloning options
	openModal( $importDialog, 500, 300 );
	// form validator and data
	$importForm.validate( { 
		submitHandler: function(form){
           	$importForm.find( "##importButtonBar" ).slideUp();
			$importForm.find( "##importBarLoader" ).slideDown();
			form.submit();
        }
	} );
	// close button
	$importForm.find( "##closeButton" ).click(function(e){
		closeModal( $importDialog ); return false;
	} );
	// clone button
	$importForm.find( "##importButton" ).click(function(e){
		$importForm.submit();
	} );
}
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
function edit(settingID,name,value){
	openModal( $( "##settingEditorContainer" ), 500, 300 );
	$settingEditor.find( "##settingID" ).val( settingID );
	$settingEditor.find( "##name" ).val( name );
	$settingEditor.find( "##value" ).val( value );
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
	$settingEditor.find( "##btnSave" ).val( "Save" );
	openModal( $( "##settingEditorContainer" ), 500, 300 );
	return false;
}
</script>
</cfoutput>