<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// Setup view
	setupView( { 
		tableContainer	: $("##authorTableContainer"), 
		tableURL		: '#event.buildLink( prc.xehAuthorTable )#',
		searchField 	: $("##userSearch"),
		searchName		: 'searchAuthors',
		contentForm 	: $("##authorForm"),
		importDialog 	: $("##importDialog"),
		cloneDialog		: $("##cloneDialog"),
		filterBox		: $("##filterBox")
	});

	// load content on startup
	contentLoad( {} );
});
// Setup the view with the settings object
function setupView( settings ){
	// setup model properties
	$tableContainer = settings.tableContainer;
	$tableURL		= settings.tableURL;
	$searchField 	= settings.searchField;
	$searchName		= settings.searchName;
	$contentForm	= settings.contentForm;
	$importDialog	= settings.importDialog;
	$cloneDialog	= settings.cloneDialog;
	$filterBox		= settings.filterBox;
	
	// quick search binding
	$searchField.keyup(function(){
		var $this = $(this);
		var clearIt = ( $this.val().length > 0 ? false : true );
		// ajax search
		contentLoad( { search: $this.val() } );
	});
}
// show all content
function contentShowAll(){
	resetFilter();
	contentLoad ({ showAll: true } );
}
// Content filters
function contentFilter(){
	if( $("##fStatus").val() != "any" ||
		$("##fRole").val() != "any" 
	){
		$filterBox.addClass( "selected" );
	} else {
		$filterBox.removeClass( "selected" );
	}
	// load content filtered
	contentLoad( {
		fStatus : $( "##fStatus" ).val(),
		fRole : $( "##fRole" ).val()
	} );
}
// reset filters
function resetFilter( reload ){
	// reload check
	if( reload ){ contentLoad(); }
	// reload filters
	$( $filterBox ).removeClass( "selected" );
	$( "##fStatus" ).val( '' );
	$( "##fRole" ).val( '' );
}
// content paginate
function contentPaginate(page){
	// paginate with kept searches and filters.
	contentLoad( {
		search: $searchField.val(),
		page: page
	} );
}
// Content load
function contentLoad( criteria ){
	// default checks
	if( criteria == undefined ){ criteria = {}; }
	// default criteria matches
	if( !( "search" in criteria ) ){ criteria.search = ""; }
	if( !( "page" in criteria ) ){ criteria.page = 1; }
	if( !( "showAll" in criteria ) ){ criteria.showAll = false; }
	if( !( "fStatus" in criteria ) ){ criteria.fStatus = "any"; }
	if( !( "fRole" in criteria ) ){ criteria.fRole = "any"; }
	// loading effect
	$tableContainer.css( 'opacity', .60 );
	var args = {  
		page: criteria.page, 
		showAll : criteria.showAll ,
		fStatus : criteria.fStatus,
		fRole : criteria.fRole
	};
	// Add dynamic search key name
	args[ $searchName ] = criteria.search;
	// load content
	$tableContainer.load( $tableURL, args, function(){
			$tableContainer.css( 'opacity', 1 );
			$( this ).fadeIn( 'fast' );
	});
}
<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_IMPORT")>
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
function removeAuthor(authorID){
	$("##delete_"+ authorID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
	$("##authorID").val( authorID );
	$("##authorForm").submit();
}
</cfif>
</script>
</cfoutput>