<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// Setup view
	setupView( { 
		tableContainer	: $( "##authorTableContainer" ), 
		tableURL		: '#event.buildLink( prc.xehAuthorTable )#',
		searchField 	: $( "##userSearch" ),
		searchName		: 'searchAuthors',
		contentForm 	: $( "##authorForm" ),
		importDialog 	: $( "##importDialog" ),
		cloneDialog		: $( "##cloneDialog" ),
		filterBox		: $( "##filterBox" ),
		filters 		: [
			{ name : "fStatus", defaultValue : "any" },
			{ name : "fRole", defaultValue : "any" }
		]
	} );

	// load content on startup
	contentLoad( {} );
} );
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

	// setup filters
	$filters 		= settings.filters;
	
	// quick search binding
	$searchField.keyup(function(){
		var $this = $(this);
		var clearIt = ( $this.val().length > 0 ? false : true );
		// ajax search
		contentLoad( { search: $this.val() } );
	} );
}
// show all content
function contentShowAll(){
	resetFilter();
	contentLoad ( { showAll: true } );
}
// Content filters
function contentFilter(){
	// discover if we are filtering
	var filterArgs 	= {};
	var isFiltering = false;

	// check for active filters
	for( var thisFilter in $filters ){
		var thisValue = $( "##" + $filters[ thisFilter ].name ).val();
		if( thisValue != $filters[ thisFilter ].defaultValue ){
			isFiltering = true;
			break;
		}
	}
	// update filter box
	( isFiltering ? $filterBox.addClass( "selected" ) : $filterBox.removeClass( "selected" ) );
	// activate filtering
	contentLoad( {} );
}
// reset filters
function resetFilter( reload ){
	// reset filters to default values
	for( var thisFilter in $filters ){
		$( "##" + $filters[ thisFilter ].name ).val( $filters[ thisFilter ].defaultValue );
	}
	// reload check
	if( reload ){ contentLoad( {} ); }
	// reload filters
	$( $filterBox ).removeClass( "selected" );
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

	// loading effect
	$tableContainer.css( 'opacity', .60 );
	// setup ajax arguments
	var args = {  
		page: criteria.page, 
		showAll : criteria.showAll
	};
	// do we have filters, if so apply them to arguments
	for( var thisFilter in $filters ){
		args[ $filters[ thisFilter ].name ] = $( "##" + $filters[ thisFilter ].name ).val();
	}
	// Add dynamic search key name
	args[ $searchName ] = criteria.search;
	// load content
	$tableContainer.load( $tableURL, args, function(){
		$tableContainer.css( 'opacity', 1 );
		$( this ).fadeIn( 'fast' );
	} );
}
<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_IMPORT" )>
function importContent(){
	// local id's
	var $importForm = $( "##importForm" );
	// open modal for cloning options
	openModal( $importDialog, 500, 350 );
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
function removeAuthor(authorID){
	$( "##delete_"+ authorID).removeClass( "icon-remove-sign" ).addClass( "fa fa-spinner fa-spin" );
	$( "##authorID" ).val( authorID );
	$( "##authorForm" ).submit();
}
</cfif>
</script>
</cfoutput>