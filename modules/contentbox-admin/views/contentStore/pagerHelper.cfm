<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$contentPager = $( "##content_pager" );
	$contentPagerLoader = $( "##contentPagerLoader" );
} );
function pagerLink(page){
	$( "##contentPagerLoader" ).fadeIn( "fast" );
	$('##pagerContent')
		.load('#event.buildLink(prc.xehPager)#/pager_authorID/#prc.pager_authorID#/page/' + page + '/pager_parentID/#prc.pagePager_parentID#', function() {
			$( "##contentPagerLoader" ).fadeOut();
			hideAllTooltips();
			activateTooltips();
	} );
}
</script>
</cfoutput>