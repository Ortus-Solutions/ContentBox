<cfoutput>
<!--- Editor Javascript --->
<script type="text/javascript">
// Setup the content view with the settings object
function setupContentView( settings ){
	// setup model properties
	$tableContainer = settings.tableContainer;
	$tableURL		= settings.tableURL;
	$searchField 	= settings.searchField;
	$searchName		= settings.searchName;
	$contentForm	= settings.contentForm;
	$bulkStatusURL  = settings.bulkStatusURL;
	$importDialog	= settings.importDialog;
	$cloneDialog	= settings.cloneDialog;
	
	// quick search binding
	$searchField.keyup(function(){
		var $this = $(this);
		var clearIt = ( $this.val().length > 0 ? false : true );
		// ajax search
		contentLoad( { search: $this.val() } );
	});
}
// Content filters
function contentFilter(){
	if ($("##fAuthors").val() != "all" ||
		$("##fCategories").val() != "all" ||
		$("##fStatus").val() != "any") {
		$("##filterBox").addClass("selected");
	}
	else{
		$("##filterBox").removeClass("selected");
	}
	contentLoad( {
		fAuthors : $("##fAuthors").val(),
		fCategories : $("##fCategories").val(),
		fStatus : $("##fStatus").val()
	} );
}
// reset filters
function resetFilter( reload ){
	// reload check
	if( reload ){
		contentLoad();
	}
	// reload filters
	$("##filterBox").removeClass("selected");
	$("##fAuthors").val( '' );
	$("##fCategories").val( '' );
	$("##fStatus").val( '' );
}
// Content drill down
function contentDrilldown(parent){
	resetFilter();
	if( parent == undefined ){ parent = ""; }
	$searchField.val( '' );
	contentLoad( { parent: parent } );
}
// show all content
function contentShowAll(){
	resetFilter();
	contentLoad ({ showAll: true } );
}
// Get parent content ID value
function getParentContentID(){
	return $("##parent").val();
}
// content paginate
function contentPaginate(page){
	// paginate with kept searches and filters.
	contentLoad( {
		search: $searchField.val(),
		page: page,
		parent: getParentContentID(),
		fAuthors : $("##fAuthors").val(),
		fCategories : $("##fCategories").val(),
		fStatus : $("##fStatus").val()
	} );
}
// Content load
function contentLoad(criteria){
	// default checks
	if( criteria == undefined ){ criteria = {}; }
	// default criteria matches
	if( !("search" in criteria) ){ criteria.search = ""; }
	if( !("page" in criteria) ){ criteria.page = 1; }
	if( !("parent" in criteria) ){ criteria.parent = ""; }
	if( !("fAuthors" in criteria) ){ criteria.fAuthors = "all"; }
	if( !("fCategories" in criteria) ){ criteria.fCategories = "all"; }
	if( !("fStatus" in criteria) ){ criteria.fStatus = "any"; }
	if( !("showAll" in criteria) ){ criteria.showAll = false; }
	// loading effect
	$tableContainer.css( 'opacity', .60 );
	var args = {  
		page: criteria.page, 
		parent: criteria.parent,
		fAuthors : criteria.fAuthors,
		fCategories : criteria.fCategories,
		fStatus : criteria.fStatus,
		showAll : criteria.showAll 
	};
	// Add dynamic search key name
	args[ $searchName ] = criteria.search;
	// load content
	$tableContainer.load( $tableURL, args, function(){
			$tableContainer.css( 'opacity', 1 );
			$(this).fadeIn( 'fast' );
	});
}
// Get info panel contents
function getInfoPanelContent(contentID){
	return $("##infoPanel_" + contentID).html();
}
// Activate info panels
function activateInfoPanels(){
	$(".popovers").popover({
		html : true,
		content : function(){
			return getInfoPanelContent( $(this).attr( "data-contentID" ) );
		},
		trigger : 'hover',
		placement : 'left',
		title : '<i class="icon-info-sign"></i> Quick Info',
		delay : { show: 200, hide: 500 }
	});
}
// Activate quick looks 
function activateQuickLook( $table, quickLookURL ){
	$table.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-contentID') != null) {
				openRemoteModal( quickLookURL + $(this).attr('data-contentID'));
				e.preventDefault();
			}
	    }
	});
}
// Remove content
function remove( contentID, id ){
	id = typeof id !== 'undefined' ? id : 'contentID';
	if( contentID != null ){
		$("##delete_"+ contentID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue( id, contentID );		
	}
	$contentForm.submit();
}
// Bulk Remove
function bulkRemove(){
	$contentForm.submit();
}
// Bulk change status
function bulkChangeStatus(status, contentID){
	// Setup the right form actions and status
	$contentForm.attr( "action", $bulkStatusURL );
	$contentForm.find("##contentStatus").val( status );
	// only submit if something selected
	if( contentID != null ){
		$("##status_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);	
	}
	$contentForm.submit();
}
// Import content dialogs
function importContent(){
	var $importForm = $importDialog.find("##importForm");
	// open modal for cloning options
	openModal( $importDialog, 500, 350 );
	// form validator and data
	$importForm.validate({ 
		submitHandler: function(form){
           	$importForm.find("##importButtonBar").slideUp();
			$importForm.find("##importBarLoader").slideDown();
			form.submit();
        }
	});
	// close button
	$importForm.find("##closeButton").click(function(e){
		closeModal( $importDialog ); return false;
	});
	// clone button
	$importForm.find("##importButton").click(function(e){
		$importForm.submit();
	});
}
// Clone Dialog
function openCloneDialog(contentID, title){
	// local id's
	var $cloneForm = $cloneDialog.find("##cloneForm");
	// open modal for cloning options
	openModal( $cloneDialog, 500, 300 );
	// form validator and data
	$cloneForm.validate({ 
		submitHandler: function(form){
           	$cloneForm.find("##cloneButtonBar").slideUp();
			$cloneForm.find("##clonerBarLoader").slideDown();
			form.submit();
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
</script>
</cfoutput>