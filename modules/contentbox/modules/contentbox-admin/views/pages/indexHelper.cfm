<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	// Setup content view: from workbench/resources/contentList.js
	contentListHelper.init( {
		adminEntryPoint : '#event.buildLink( prc.cbAdminEntryPoint )#',
		tableContainer	: $( "##contentTableContainer" ),
		tableURL		: '#event.buildLink( prc.xehPageTable )#',
		searchField 	: $( "##searchContent" ),
		searchName		: 'searchContent',
		contentForm 	: $( "##pageForm" ),
		bulkStatusURL 	: '#event.buildlink( prc.xehPageBulkStatus )#',
		importDialog 	: $( "##importDialog" ),
		cloneDialog		: $( "##cloneDialog" ),
		parentID 		: '#encodeForJavaScript( rc.parent )#'
	} );
} );
</script>
</cfoutput>