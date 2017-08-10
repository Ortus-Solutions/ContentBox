<cfoutput>
<!--- Load Content List Viewer UI --->
#renderView( view="_tags/contentListViewer", prePostExempt=true )#
<!--- page JS --->
<script>
$(document).ready(function() {
	// Create history Listener
	History.Adapter.bind( window, 'statechange', function(){
		//console.log( "called history: " + data.parent );
		contentLoad( { parent: History.getState().data.parent } );
	} );
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