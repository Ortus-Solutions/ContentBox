<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	// Setup content view: from workbench/resources/contentList.js
	contentListHelper.init( {
		adminEntryPoint : '#event.buildLink( prc.cbAdminEntryPoint )#',
		tableContainer	: $( "##contentTableContainer" ),
		tableURL		: '#event.buildLink( prc.xehEntryTable )#',
		searchField 	: $( "##searchContent" ),
		searchName		: 'searchContent',
		contentForm 	: $( "##entryForm" ),
		bulkStatusURL 	: '#event.buildlink( prc.xehEntryBulkStatus )#',
		importDialog 	: $( "##importDialog" ),
		cloneDialog		: $( "##cloneDialog" ),
		parentID 		: ''
	} );
} );
</script>
</cfoutput>