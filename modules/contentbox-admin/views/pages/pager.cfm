<cfoutput>
<div id="pagerPages">
<!--- Loader --->
<div class="loaders floatRight" id="pagePagerLoader">
	<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
</div>
<!--- Paging --->
<cfif prc.pagePager_pagination>
	#prc.pagePager_pagingPlugin.renderit(prc.pager_pagesCount,prc.pagePager_pagingLink)#
</cfif>

<!--- entries --->
<table name="pages_pager" id="pages_pager" class="tablelisting" width="100%">
	<thead>
		<tr>
			<th>Page</th>	
			<th width="60" class="center"><img src="#prc.cbRoot#/includes/images/sort.png" alt="sort" title="Page Order"/></th>
			<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/parent_color_small.png" alt="order" title="Child Pages"/></th>
			<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/publish.png" alt="publish" title="Published"/></th>
			<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/glasses.png" alt="views" title="Number of Views"/></th>
			<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/comments.png" alt="comments" title="Number of Comments"/></th>
			<th width="75" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfset i = 0>
		<cfloop array="#prc.pager_pages#" index="page">
		<cfset i++>
		<tr data-pageID="#page.getPageID()#">
			<td>
				<!--- Title --->
				<a href="#event.buildLink(prc.xehPageEditor)#/pageID/#page.getPageID()#" title="Edit Page">#page.getTitle()#</a><br>
				by #page.getAuthorName()#<br/>
				<!--- password protect --->
				<cfif page.isPasswordProtected()>
					<img src="#prc.cbRoot#/includes/images/lock.png" alt="locked" title="Page is password protected"/>
				<cfelse>
					<img src="#prc.cbRoot#/includes/images/lock_off.png" alt="locked" title="Page is public"/>
				</cfif>
				&nbsp;
				<!--- comments icon --->
				<cfif page.getallowComments()>
					<img src="#prc.cbRoot#/includes/images/comments.png" alt="locked" title="Commenting is Open!"/>
				<cfelse>
					<img src="#prc.cbRoot#/includes/images/comments_off.png" alt="locked" title="Commenting is Closed!"/>
				</cfif>			
			</td>
			<td class="center">
				#page.getOrder()#
				<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
				<!--- Order Up --->
				<cfif ( page.getOrder()-1 ) GTE 0 >
					<a href="javascript:changeOrder('#page.getPageID()#', #page.getOrder()-1#,'up')" title="Order Up"><img id="orderup_#page.getPageID()#" src="#prc.cbRoot#/includes/images/_up.gif" alt="order"/></a>
				</cfif>
				<!--- Increase Order Index--->
				<a href="javascript:changeOrder('#page.getPageID()#',#page.getOrder()+1#,'down')" title="Order Down"><img id="orderdown_#page.getPageID()#" src="#prc.cbRoot#/includes/images/_down.gif" alt="order"/></a>
				</cfif>
			</td>
			<td class="center">
				#page.getNumberOfChildren()#	
			</td>
			<td class="center">
				<cfif page.getIsPublished()>
					<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Page Published!" />
					<span class="hidden">published</span>
				<cfelse>
					<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="draft" title="Page Draft!" />
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">#page.getHits()#</td>
			<td class="center">#page.getNumberOfComments()#</td>
			<td class="center">
				<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
				<!--- Edit Command --->
				<a href="#event.buildLink(prc.xehPageEditor)#/pageID/#page.getPageID()#" title="Edit #page.getTitle()#"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" border="0"/></a>
				&nbsp;
				<!--- Create Child --->
				<a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getPageID()#" title="Create Child Page"><img src="#prc.cbroot#/includes/images/parent.png" alt="edit" border="0"/></a>
				&nbsp;
				</cfif>
				<!--- View in Site --->
				<a href="#prc.CBHelper.linkPage(page)#" title="View Page In Site" target="_blank"><img src="#prc.cbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$pagesPager = $("##pages_pager"); 
	$pagesPager.find("tr:even").addClass("even");
	// quick look
	$pagesPager.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if( $(this).attr('data-pageID') != null ){
				openRemoteModal('#event.buildLink(prc.xehPageQuickLook)#/pageID/' + $(this).attr('data-pageID'));
				e.preventDefault();
			}
	    }
	});
});
function pagerLink(page){
	$("##pagePagerLoader").fadeIn("fast");
	$('##pagerPages')
		.load('#event.buildLink(prc.xehPagePager)#?pagePager_pagination=#prc.pagePager_pagination#&pager_authorID=#prc.pagePager_authorID#&pager_parentID=#prc.pagePager_parentID#&page=' + page, function() {
			$("##pagePagerLoader").fadeOut();
			hideAllTooltips();
			activateTooltips();
	});
}
<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
function changeOrder(pageID,order,direction){
	// img change
	$('##order'+direction+'_'+pageID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// change order
	$.post('#event.buildLink(prc.xehPageOrder)#',{pageID:pageID,order:order},function(){ 
		hideAllTooltips();
		pagerLink(#rc.page#); 
	});
}
</cfif>
</script>
</div>
</cfoutput>