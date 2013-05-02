<cfoutput>
<div id="pagerEntries">
<!--- Loader --->
<div class="loaders floatRight" id="entryPagerLoader">
	<i class="icon-spinner icon-spin icon-large"></i>
</div>

<!--- entries --->
<table name="entries_pager" id="entries_pager" class="tablesorter table table-hover table-condensed table-striped" width="100%">
	<thead>
		<tr>
			<th>Title</th>
			<th width="40" class="center"><i class="icon-globe icon-large" title="Published Status"></i></th>
			<th width="40" class="center"><i class="icon-signal icon-large" title="Hits"></i></th>
			<th width="40" class="center"><i class="icon-comments icon-large" title="Comments"></i></th>
			<th width="50" class="center">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.pager_entries#" index="entry">
		<tr data-contentID="#entry.getContentID()#"
			<cfif entry.isExpired()>
				class="error"
			<cfelseif entry.isPublishedInFuture()>
				class="success"
			<cfelseif !entry.isContentPublished()>
				class="warning"
			</cfif>>
			<td>
				<a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#" title="Edit #entry.getTitle()#">#entry.getTitle()#</a><br/>
				<small>
				<i class="icon-user" title="last edit by"></i> <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a> on #entry.getActiveContent().getDisplayCreatedDate()#
				</small>
			</td>
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
			<td class="center"><span class="badge badge-info">#entry.getHits()#</span></td>
			<td class="center"><span class="badge badge-info">#entry.getNumberOfComments()#</span></td>
			<td class="center">
				<!--- Entry Actions --->
				<div class="btn-group">
			    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Entry Actions">
						<i class="icon-cogs icon-large"></i>
					</a>
			    	<ul class="dropdown-menu text-left">
			    		<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") OR prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
						<!--- View in Site --->
						<li><a href="#prc.CBHelper.linkEntry(entry)#" target="_blank"><i class="icon-eye-open icon-large"></i> Open In Site</a></li>
			    	</ul>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif prc.pager_pagination>
	#prc.pager_pagingPlugin.renderit(prc.pager_entriesCount,prc.pager_pagingLink)#
</cfif>
</div>
</cfoutput>