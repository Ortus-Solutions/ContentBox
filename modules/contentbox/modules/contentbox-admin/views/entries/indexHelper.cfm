<cfoutput>
<!--- Load Content List Viewer UI --->
#renderView(view="_tags/contentListViewer", prePostExempt=true)#
<!--- page JS --->
<script>
$(document).ready(function() {
	// Setup content view
	setupContentView( { 
		tableContainer	: $( "##entriesTableContainer" ), 
		tableURL		: '#event.buildLink( prc.xehEntryTable )#',
		searchField 	: $( "##entrySearch" ),
		searchName		: 'searchEntries',
		contentForm 	: $( "##entryForm" ),
		bulkStatusURL 	: '#event.buildlink(linkTo=prc.xehEntryBulkStatus)#',
		importDialog 	: $( "##importDialog" ),
		cloneDialog		: $( "##cloneDialog" )
	} );
	
	// load content on startup, using default parents if passed.
	contentLoad( {} );
	
} );
</script>
</cfoutput>