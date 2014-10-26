<cfoutput>
<div id="pagerEntries">
<!--- Loader --->
<div class="loaders floatRight" id="entryPagerLoader">
	<i class="fa fa-spinner fa-spin icon-large"></i>
</div>

<!--- entries --->
<table name="entries_pager" id="entries_pager" class="table table-hover table-condensed table-striped table-bordered" width="100%">
	<thead>
		<tr class="info">
			<th>Title</th>
			<th width="40" class="text-center"><i class="fa fa-globe icon-large" title="Published Status"></i></th>
			<th width="40" class="text-center"><i class="fa fa-signal icon-large" title="Hits"></i></th>
			<th width="40" class="text-center"><i class="fa fa-comments icon-large" title="Comments"></i></th>
			<th width="50" class="text-center">Actions</th>
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
				<i class="fa fa-user" title="last edit by"></i> <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a> on #entry.getActiveContent().getDisplayCreatedDate()#
				</small>
			</td>
			<td class="text-center">
				<cfif entry.isExpired()>
					<i class="fa fa-clock-o icon-large textRed" title="Entry has expired!"></i>
					<span class="hidden">expired</span>
				<cfelseif entry.isPublishedInFuture()>
					<i class="fa fa-fighter-jet icon-large textBlue" title="Entry Publishes in the future!"></i>
					<span class="hidden">published in future</span>
				<cfelseif entry.isContentPublished()>
					<i class="fa fa-check icon-large textGreen" title="Entry Published!"></i>
					<span class="hidden">published in future</span>
				<cfelse>
					<i class="fa fa-times icon-large textRed" title="Entry Draft!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="text-center"><span class="badge badge-info">#entry.getHits()#</span></td>
			<td class="text-center"><span class="badge badge-info">#entry.getNumberOfComments()#</span></td>
			<td class="text-center">
				<!--- Entry Actions --->
				<div class="btn-group btn-group-xs">
			    	<a class="btn btn-xs btn-primary dropdown-toggle" data-toggle="dropdown" href="##" title="Entry Actions">
						<i class="fa fa-cogs icon-large"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") OR prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#"><i class="fa fa-edit icon-large"></i> Edit</a></li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#"><i class="fa fa-clock-o icon-large"></i> History</a></li>
						<!--- View in Site --->
						<li><a href="#prc.CBHelper.linkEntry(entry)#" target="_blank"><i class="fa fa-eye icon-large"></i> Open In Site</a></li>
			    	</ul>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif prc.pager_pagination>
	#prc.pager_pagingPlugin.renderit(foundRows=prc.pager_entriesCount, link=prc.pager_pagingLink, asList=true)#
</cfif>
</div>
</cfoutput>