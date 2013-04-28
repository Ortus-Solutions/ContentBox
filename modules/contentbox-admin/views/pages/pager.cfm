<cfoutput>
<div id="pagerPages">
	<!--- Loader --->
	<div class="loaders floatRight" id="pagePagerLoader">
		<i class="icon-spinner icon-spin icon-large"></i>
	</div>

	<!--- entries --->
	<table name="pages_pager" id="pages_pager" class="table table-hover table-condensed table-striped table-bordered" width="100%">
		<thead>
			<tr>
				<th>Page</th>
				<th width="40" class="center"><i class="icon-globe icon-large" title="Published"></i></th>
				<th width="40" class="center"><i class="icon-signal icon-large" title="Hits"></i></th>
				<th width="100" class="center">Actions</th>
			</tr>
		</thead>

		<tbody>
			<cfset i = 0>
			<cfloop array="#prc.pager_pages#" index="page">
			<cfset i++>
			<tr id="contentID-#page.getContentID()#" data-contentID="#page.getContentID()#"
				<cfif page.isExpired()>
					class="error"
				<cfelseif page.isPublishedInFuture()>
					class="success"
				<cfelseif !page.isContentPublished()>
					class="warning"
				</cfif>>
				<td>
					<!--- Title --->
					<a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#">#page.getSlug()#</a><br>
					<i class="icon-user" title="last edit by"></i> <a href="mailto:#page.getAuthorEmail()#">#page.getAuthorName()#</a> on #page.getActiveContent().getDisplayCreatedDate()#
				</td>
				<td class="center">
					<cfif page.isExpired()>
						<i class="icon-time icon-large textRed" title="Page has expired on ( (#page.getDisplayExpireDate()#))"></i>
						<span class="hidden">expired</span>
					<cfelseif page.isPublishedInFuture()>
						<i class="icon-fighter-jet icon-large textBlue" title="Page Publishes in the future (#page.getDisplayPublishedDate()#)"></i>
						<span class="hidden">published in future</span>
					<cfelseif page.isContentPublished()>
						<i class="icon-ok icon-large textGreen" title="Page Published"></i>
						<span class="hidden">published in future</span>
					<cfelse>
						<i class="icon-remove icon-large textRed" title="Page Draft"></i>
						<span class="hidden">draft</span>
					</cfif>
				</td>
				<td class="center"><span class="badge badge-info">#page.getHits()#</span></td>
				<td class="center">
					<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
					<!--- Edit Command --->
					<a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#" title="Edit #page.getTitle()#"><i class="icon-edit icon-large"></i></a>
					&nbsp;
					<!--- History Command --->
					<a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#" title="Version History"><i class="icon-time icon-large"></i></a>
					&nbsp;
					<!--- Create Child --->
					<a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#" title="Create Child Page"><i class="icon-sitemap icon-large"></i></a>
					&nbsp;
					</cfif>
					<!--- View in Site --->
					<a href="#prc.CBHelper.linkPage(page)#" title="View Page In Site" target="_blank"><i class="icon-eye-open icon-large"></i></a>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>
	
	<!--- Paging --->
	<cfif prc.pagePager_pagination>
		#prc.pagePager_pagingPlugin.renderit(prc.pager_pagesCount,prc.pagePager_pagingLink)#
	</cfif>

</div>
</cfoutput>