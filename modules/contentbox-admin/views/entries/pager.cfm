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
			<th width="75" class="center">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.pager_entries#" index="entry">
		<tr data-contentID="#entry.getContentID()#"
			<cfif entry.isExpired()>
				class="expired"
			<cfelseif entry.isPublishedInFuture()>
				class="futurePublished"
			<cfelseif !entry.isContentPublished()>
				class="selected"
			</cfif>>
			<td>
				<a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#" title="Edit #entry.getTitle()#">#entry.getTitle()#</a><br/>
				by <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a>
			</td>
			<td>#entry.getCategoriesList()#</td>
			<td>
				<strong title="Published Date">P:</strong> #entry.getDisplayPublishedDate()#<br/>
				<strong title="Created Date">C:</strong> #entry.getDisplayCreatedDate()#
			</td>
			<td class="center">
				<cfif entry.isExpired()>
					<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="expired" title="Entry has expired!" />
					<span class="hidden">expired</span>
				<cfelseif entry.isPublishedInFuture()>
					<img src="#prc.cbRoot#/includes/images/information.png" alt="published" title="Entry Publishes in the future!" />
					<span class="hidden">published in future</span>
				<cfelseif entry.isContentPublished()>
					<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Entry Published!" />
					<span class="hidden">published in future</span>
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
				<!--- History Command --->
				<a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#" title="Version History"><img src="#prc.cbroot#/includes/images/old-versions.png" alt="versions" border="0"/></a>
				&nbsp;
				<!--- View Command --->
				<a href="#prc.CBHelper.linkEntry(entry)#" title="View Entry In Site" target="_blank"><img src="#prc.cbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</div>
</cfoutput>