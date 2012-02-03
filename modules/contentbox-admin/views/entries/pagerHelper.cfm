<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$entriesPager = $("##entries_pager");
	$entriesPager.find("tr:even").addClass("even");
	// quick look
	$entriesPager.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if( $(this).attr('data-contentID') != null ){
				e.preventDefault();
				openRemoteModal('#event.buildLink(prc.xehEntryQuickLook)#/contentID/' + $(this).attr('data-contentID'));
			}
	    }
	});
});
function pagerLink(page){
	$("##entryPagerLoader").fadeIn("fast");
	$('##pagerEntries')
		.load('#event.buildLink(prc.xehPager)#/pager_authorID/#prc.pager_authorID#/page/' + page, function() {
			$("##entryPagerLoader").fadeOut();
			hideAllTooltips();
			activateTooltips();
	});
}
</script>
</cfoutput>