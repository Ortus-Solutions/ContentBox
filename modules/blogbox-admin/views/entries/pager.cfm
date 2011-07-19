<cfoutput>
<div id="pagerEntries">
<!--- Paging --->
<cfif rc.pager_pagination>
	#rc.pager_pagingPlugin.renderit(rc.pager_entriesCount,rc.pager_pagingLink)#
</cfif>

<!--- entries --->
<table name="entries_pager" id="entries_pager" class="tablelisting" width="100%">
	<thead>
		<tr>
			<th>Title</th>	
			<th>Categories</th>
			<th width="125">Dates</th>
			<th width="40" class="center">Online</th>
			<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/comments.png" alt="comments"/></th>
			<th width="50" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#rc.pager_entries#" index="entry">
		<tr data-entryID="#entry.getEntryID()#">
			<td>
				<a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#entry.getentryID()#" title="Edit #entry.getTitle()#">#entry.getTitle()#</a><br/>
				by <a href="mailto:#entry.getAuthor().getEmail()#">#entry.getAuthorName()#</a>				
			</td>
			<td>#entry.getCategoriesList()#</td>
			<td>
				<strong title="Published Date">P:</strong> #entry.getDisplayPublishedDate()#<br/>
				<strong title="Created Date">C:</strong> #entry.getDisplayCreatedDate()#
			</td>
			<td class="center">
				<cfif entry.getIsPublished()>
					<img src="#prc.bbRoot#/includes/images/button_ok.png" alt="published" title="Entry Published!" />
					<span class="hidden">published</span>
				<cfelse>
					<img src="#prc.bbRoot#/includes/images/button_cancel.png" alt="draft" title="Entry Draft!" />
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">#entry.getNumberOfComments()#</td>
			<td class="center">
				<!--- View Command --->
				<a href="##" title="View Entry"><img src="#prc.bbroot#/includes/images/eye.png" alt="view" /></a>
				<!--- Edit Command --->
				<a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#entry.getEntryID()#" title="Edit #entry.getTitle()#"><img src="#prc.bbroot#/includes/images/edit.png" alt="edit" /></a>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$("tr:even").addClass("even");
	// quick look
	$("##entries_pager").find("tr").mousedown(function(e) {
	    if (e.which === 3) {
	    	openRemoteModal('#event.buildLink(rc.xehEntryQuickLook)#/entryID/' + $(this).attr('data-entryID'));
			e.preventDefault();
	    }
	});
});
function pagerLink(page){
	$('##pagerEntries').fadeOut().load('#event.buildLink(rc.xehPager)#/pager_authorID/#rc.pager_authorID#/page/' + page, function() {
		$(this).fadeIn();
		activateTooltips();
	});
}
</script>
</div>
</cfoutput>