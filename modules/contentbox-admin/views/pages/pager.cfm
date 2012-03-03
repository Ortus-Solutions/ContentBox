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
				<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/sort.png" alt="menu" title="Show in Menu"/></th>
				<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/parent_color_small.png" alt="order" title="Child Pages"/></th>
				<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/publish.png" alt="publish" title="Published"/></th>
				<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/glasses.png" alt="views" title="Number of Views"/></th>
				<th width="100" class="center">Actions</th>
			</tr>
		</thead>

		<tbody>
			<cfset i = 0>
			<cfloop array="#prc.pager_pages#" index="page">
			<cfset i++>
			<tr id="contentID-#page.getContentID()#" data-contentID="#page.getContentID()#"
				<cfif page.isExpired()>
					class="expired"
				<cfelseif page.isPublishedInFuture()>
					class="futurePublished"
				<cfelseif !page.isContentPublished()>
					class="selected"
				</cfif>>
				<td>
					<!--- Title --->
					<a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#" title="Edit Page">#page.getTitle()#</a><br>
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
					<cfif page.getShowInMenu()>
						<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Shows in menu!" />
					<cfelse>
						<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="draft" title="Not in menu!" />
					</cfif>
				</td>
				<td class="center">
					#page.getNumberOfChildren()#
				</td>
				<td class="center">
					<cfif page.isExpired()>
						<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="expired" title="Page has expired!" />
						<span class="hidden">expired</span>
					<cfelseif page.isPublishedInFuture()>
						<img src="#prc.cbRoot#/includes/images/information.png" alt="published" title="Page Publishes in the future!" />
						<span class="hidden">published in future</span>
					<cfelseif page.isContentPublished()>
						<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Page Published!" />
						<span class="hidden">published in future</span>
					<cfelse>
						<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="draft" title="Page Draft!" />
						<span class="hidden">draft</span>
					</cfif>
				</td>
				<td class="center">#page.getHits()#</td>
				<td class="center">
					<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
					<!--- Edit Command --->
					<a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#" title="Edit #page.getTitle()#"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" border="0"/></a>
					&nbsp;
					<!--- History Command --->
					<a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#" title="Version History"><img src="#prc.cbroot#/includes/images/old-versions.png" alt="versions" border="0"/></a>
					&nbsp;
					<!--- Create Child --->
					<a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#" title="Create Child Page"><img src="#prc.cbroot#/includes/images/parent.png" alt="edit" border="0"/></a>
					&nbsp;
					</cfif>
					<!--- View in Site --->
					<a href="#prc.CBHelper.linkPage(page)#" title="View Page In Site" target="_blank"><img src="#prc.cbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>

</div>
</cfoutput>