<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$("tr:even").addClass("even");
	// quick look
	$("##comments_pager").find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
			if( $(this).attr('data-commentID') != null ){
	    		openRemoteModal('#event.buildLink(prc.xehCommentPagerQuickLook)#', {commentID: $(this).attr('data-commentID')});
				e.preventDefault();
			}
	    }
	});
});
<cfif prc.oAuthor.checkPermission("COMMENTS_ADMIN")>
function commentPagerChangeStatus(status,recordID){
	// update icon
	$('##status_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// ajax status change
	$.post("#event.buildlink(linkTo=prc.xehCommentPagerStatus)#",{commentStatus:status,commentID:recordID},function(data){
		hideAllTooltips();
		commentPagerLink(#rc.page#);
	});
}
function commentPagerRemove(recordID){
	if( !confirm("Really permanently delete comment?") ){ return; }
	$('##delete_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// ajax remove change
	$.post("#event.buildlink(linkTo=prc.xehCommentPagerRemove)#",{commentID:recordID},function(data){
		hideAllTooltips();
		commentPagerLink(#rc.page#);
	});	
}
</cfif>
function commentPagerLink(page){
	$("##commentsPagerLoader").fadeIn("fast");
	$('##pagerComments')
		.load('#event.buildLink(prc.xehCommentPager)#',
			{commentPager_contentID:'#prc.commentPager_contentID#',commentPager_contentID:'#prc.commentPager_contentID#', page:page, commentPager_pagination: '#prc.commentPager_pagination#'},function() {
			hideAllTooltips();
			$("##commentsPagerLoader").fadeOut();
			activateTooltips();
	});
}
</script>
</cfoutput>