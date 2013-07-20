<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// global ids
	$pageForm 				= $("##pageForm");
	$cloneDialog 			= $("##cloneDialog");
	$importDialog 			= $("##importDialog");
	$pagesTableContainer 	= $("##pagesTableContainer");
	$pageSearch				= $("##pageSearch");
	
	// load pages on startup
	pagesLoad( { parent: '#rc.parent#' } );
	
	// keyup quick search binding
	$pageSearch.keyup(function(){
		var $this = $(this);
		var clearIt = ( $this.val().length > 0 ? false : true );
		// ajax search
		pagesLoad( { search: $this.val() } );
	});
});
function getParentPage(){
	return $("##parent").val();
}
function pagesLoad(criteria){
	// default check
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
	$pagesTableContainer.css( 'opacity', .60 );
	// load content
	$pagesTableContainer.load( '#event.buildLink( prc.xehPageTable )#', 
		{ searchPages: criteria.search, 
		  page: criteria.page, 
		  parent: criteria.parent,
		  fAuthors : criteria.fAuthors,
		  fCategories : criteria.fCategories,
		  fStatus : criteria.fStatus,
		  showAll : criteria.showAll }, 
		function(){
			$pagesTableContainer.css( 'opacity', 1 );
			$(this).fadeIn( 'fast' );
	});
}
function pagesShowAll(){
	resetFilter();
	pagesLoad ({ showAll: true } );
}
function resetFilter(){
	$("##filterBox").removeClass("selected");
	pagesLoad();
	$("##fAuthors").val( '' );
	$("##fCategories").val( '' );
	$("##fStatus").val( '' );
}
function pagesFilter(){
	if ($("##fAuthors").val() != "all" ||
		$("##fCategories").val() != "all" ||
		$("##fStatus").val() != "any") {
		$("##filterBox").addClass("selected");
	}
	else{
		$("##filterBox").removeClass("selected");
	}
	pagesLoad( {
		fAuthors : $("##fAuthors").val(),
		fCategories : $("##fCategories").val(),
		fStatus : $("##fStatus").val()
	} );
}
function pagesDrilldown(parent){
	resetFilter();
	if( parent == undefined ){ parent = ""; }
	$pageSearch.val( '' );
	pagesLoad( { parent: parent } );
}
function pagesPaginate(page){
	// paginate with kept searches and filters.
	pagesLoad( {
		search: $pageSearch.val(),
		page: page,
		parent: getParentPage(),
		fAuthors : $("##fAuthors").val(),
		fCategories : $("##fCategories").val(),
		fStatus : $("##fStatus").val()
	} );
}
function getInfoPanelContent(contentID){
	return $("##infoPanel_" + contentID).html();
}
<cfif prc.oAuthor.checkPermission("PAGES_ADMIN,TOOLS_IMPORT")>
function remove(contentID){
	if( contentID != null ){
		$("##delete_"+ contentID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);		
	}
	$pageForm.submit();
}
function bulkRemove(){
	$pageForm.submit();
}
function bulkChangeStatus(status, contentID){
	$pageForm.attr("action","#event.buildlink(linkTo=prc.xehPageBulkStatus)#");
	$pageForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$("##status_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);	
	}
	$pageForm.submit();
}
function importContent(){
	// local id's
	var $importForm = $("##importForm");
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
</cfif>
<cfif prc.oAuthor.checkPermission("PAGES_EDITOR,PAGES_ADMIN")>
function openCloneDialog(contentID, title){
	// local id's
	var $cloneForm = $("##cloneForm");
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
</cfif>
</script>
</cfoutput>