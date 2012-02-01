<cfoutput>
<div id="pagerEntries">
<!--- Loader --->
<div class="loaders floatRight" id="entryPagerLoader">
	<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
</div>
<!--- Paging --->
<cfif prc.pager_pagination>
	#prc.pager_pagingPlugin.renderit(prc.pager_entriesCount,prc.pager_pagingLink)#
</cfif>

<!--- entries --->
<table name="entries_pager" id="entries_pager" class="tablelisting" width="100%">
	<thead>
		<tr>
			<th>Title</th>	
			<th>Categories</th>
			<th width="125">Dates</th>
			<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/publish.png" alt="publish" title="Entry Published"/></th>
			<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/glasses.png" alt="views" title="Number of Views"/></th>
			<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/comments.png" alt="comments" title="Number of Comments"/></th>
			<th width="50" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#prc.pager_entries#" index="entry">
		<tr data-contentID="#entry.getContentID()#">
			<td>
				<a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#" title="Edit #entry.getTitle()#">#entry.getTitle()#</a><br/>
				by <a href="mailto:#entry.getAuthor().getEmail()#">#entry.getAuthorName()#</a>				
			</td>
			<td>#entry.getCategoriesList()#</td>
			<td>
				<strong title="Published Date">P:</strong> #entry.getDisplayPublishedDate()#<br/>
				<strong title="Created Date">C:</strong> #entry.getDisplayCreatedDate()#
			</td>
			<td class="center">
				<cfif entry.getIsPublished()>
					<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Entry Published!" />
					<span class="hidden">published</span>
				<cfelse>
					<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="draft" title="Entry Draft!" />
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">#entry.getHits()#</td>
			<td class="center">#entry.getNumberOfComments()#</td>
			<td class="center">
				<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
				<!--- Edit Command --->
				<a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#" title="Edit #entry.getTitle()#"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" /></a>
				&nbsp;
				</cfif>
				<!--- View Command --->
				<a href="#prc.CBHelper.linkEntry(entry)#" title="View Entry In Site" target="_blank"><img src="#prc.cbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
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
</div>
</cfoutput>