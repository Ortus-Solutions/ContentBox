<cfoutput>
<div id="pagerEntries">
<!--- Loader --->
<div class="loaders floatRight" id="entryPagerLoader">
	<i class="icon-spinner icon-spin icon-large"></i>
</div>
<!--- Paging --->
<cfif prc.pager_pagination>
	#prc.pager_pagingPlugin.renderit(prc.pager_entriesCount,prc.pager_pagingLink)#
</cfif>

<!--- entries --->
<table name="entries_pager" id="entries_pager" class="table table-hover table-condensed table-striped table-bordered" width="100%">
	<thead>
		<tr>
			<th>Title</th>
			<th>Categories</th>
			<th width="40" class="center"><i class="icon-globe icon-large" title="Published Status"></i></th>
			<th width="40" class="center"><i class="icon-signal icon-large" title="Hits"></i></th>
			<th width="40" class="center"><i class="icon-comments icon-large" title="Comments"></i></th>
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
				by <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a> on #entry.getActiveContent().getDisplayCreatedDate()#
			</td>
			<td>#entry.getCategoriesList()#</td>
			<td class="center">
				<cfif entry.isExpired()>
					<i class="icon-time icon-large textRed" title="Entry has expired!"></i>
					<span class="hidden">expired</span>
				<cfelseif entry.isPublishedInFuture()>
					<i class="icon-fighter-jet icon-large textBlue" title="Entry Publishes in the future!"></i>
					<span class="hidden">published in future</span>
				<cfelseif entry.isContentPublished()>
					<i class="icon-ok icon-large textGreen" title="Entry Published!"></i>
					<span class="hidden">published in future</span>
				<cfelse>
					<i class="icon-remove icon-large textRed" title="Entry Published!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">#entry.getHits()#</td>
			<td class="center">#entry.getNumberOfComments()#</td>
			<td class="center">
				<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
				<!--- Edit Command --->
				<a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#" title="Edit #entry.getTitle()#"><i class="icon-edit icon-large"></i></a>
				&nbsp;
				</cfif>
				<!--- History Command --->
				<a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#" title="Version History"><i class="icon-time icon-large"></i></a>
				&nbsp;
				<!--- View Command --->
				<a href="#prc.CBHelper.linkEntry(entry)#" title="View Entry In Site" target="_blank"><i class="icon-eye-open icon-large"></i></a>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</div>
</cfoutput>