<cfoutput>
<!--- Render Commong editor functions --->
#renderView(view="_tags/contentLists", prePostExempt=true)#
<!--- page JS --->
<script type="text/javascript">
$(document).ready(function() {
	// Setup content view
	setupContentView( { 
		tableContainer	: $("##pagesTableContainer"), 
		tableURL		: '#event.buildLink( prc.xehPageTable )#',
		searchField 	: $("##pageSearch"),
		contentForm 	: $("##pageForm"),
		bulkStatusURL 	: '#event.buildlink(linkTo=prc.xehPageBulkStatus)#',
		importDialog 	: $("##importDialog"),
		cloneDialog		: $("##cloneDialog")
	});
	
	// load content on startup, using default parents if passed.
	contentLoad( { parent: '#rc.parent#' } );
	
});
</script>
</cfoutput>