<cfoutput>
<!--- Load Content List Viewer UI --->
#renderView( view="_tags/contentListViewer", prePostExempt=true )#
<!--- page JS --->
<script>
$(document).ready(function() {
	// Setup content view
	setupContentView( { 
		tableContainer	: $( "##pagesTableContainer" ), 
		tableURL		: '#event.buildLink( prc.xehPageTable )#',
		searchField 	: $( "##pageSearch" ),
		searchName		: 'searchPages',
		contentForm 	: $( "##pageForm" ),
		bulkStatusURL 	: '#event.buildlink(linkTo=prc.xehPageBulkStatus)#',
		importDialog 	: $( "##importDialog" ),
		cloneDialog		: $( "##cloneDialog" )
	} );
	
	// load content on startup, using default parents if passed.
	contentLoad( { parent: '#rc.parent#' } );
	
} );
</script>
</cfoutput>