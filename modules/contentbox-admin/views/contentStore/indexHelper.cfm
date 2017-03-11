<cfoutput>
<!--- Load Content List Viewer UI --->
#renderView( view="_tags/contentListViewer", prePostExempt=true )#
<!--- page JS --->
<script>
$(document).ready(function() {
	// Setup content view
	setupContentView( { 
		tableContainer	: $( "##contentTableContainer" ), 
		tableURL		: '#event.buildLink( prc.xehContentTable )#',
		searchField 	: $( "##contentSearch" ),
		searchName		: 'searchContent',
		contentForm 	: $( "##contentForm" ),
		bulkStatusURL 	: '#event.buildlink( prc.xehContentBulkStatus )#',
		importDialog 	: $( "##importDialog" ),
		cloneDialog		: $( "##cloneDialog" )
	} );
	
	// load content on startup, using default parents if passed.
	contentLoad( { parent: '#rc.parent#' } );
	
} );
</script>
</cfoutput>