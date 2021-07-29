<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	// Setup content view: from workbench/resources/contentList.js
	contentListHelper.init( {
		adminEntryPoint : '#event.buildLink( prc.cbAdminEntryPoint )#',
		tableContainer	: $( "##contentTableContainer" ),
		tableURL		: '#event.buildLink( prc.xehContentTable )#',
		searchField 	: $( "##contentSearch" ),
		searchName		: 'searchContent',
		contentForm 	: $( "##contentForm" ),
		bulkStatusURL 	: '#event.buildlink( prc.xehContentBulkStatus )#',
		importDialog 	: $( "##importDialog" ),
		cloneDialog		: $( "##cloneDialog" ),
		parentID 		: '#encodeForJavaScript( rc.parent )#'
	} );
} );
</script>
</cfoutput>