<cfoutput>
<div id="pagerEntries">
<!--- Paging --->
#rc.pager_pagingPlugin.renderit(rc.pager_entriesCount,rc.pager_pagingLink)#
		
<!--- entries --->
<table name="entries_pager" id="entries_pager" class="tablelisting" width="98%">
	<thead>
		<tr>
			<th>Title</th>	
			<th>Categories</th>
			<th width="125" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#rc.pager_entries#" index="entry">
		<tr>
			<td><a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#entry.getentryID()#" title="Edit #entry.getTitle()#">#entry.getTitle()#</a></td>
			<td>#entry.getCategoriesList()#</td>
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
function pagerLink(page){
	$('##pagerEntries').fadeOut().load('#event.buildLink(rc.xehPager)#/pager_authorID/#rc.pager_authorID#/page/' + page, function() {
		$(this).fadeIn();
		activateTooltips();
	});
}
</script>
</div>
</cfoutput>