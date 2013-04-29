<cfoutput>
<div id="pagerPages">
	<!--- Loader --->
	<div class="loaders floatRight" id="pagePagerLoader">
		<i class="icon-spinner icon-spin icon-large"></i>
	</div>

	<!--- entries --->
	<table name="pages_pager" id="pages_pager" class="tablesorter table table-hover table-condensed table-striped" width="100%">
		<thead>
			<tr>
				<th>Page</th>
				<th width="40" class="center"><i class="icon-globe icon-large" title="Published"></i></th>
				<th width="40" class="center"><i class="icon-signal icon-large" title="Hits"></i></th>
				<th width="50" class="center">Actions</th>
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
					<!--- Page Actions --->
					<div class="btn-group">
				    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Page Actions">
							<i class="icon-cogs icon-large"></i>
						</a>
				    	<ul class="dropdown-menu text-left">
				    		<cfif prc.oAuthor.checkPermission("PAGES_EDITOR") OR prc.oAuthor.checkPermission("PAGES_ADMIN")>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
							<!--- Create Child --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#"><i class="icon-sitemap icon-large"></i> Create Child</a></li>
							</cfif>
							<!--- History Command --->
							<li><a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
							<!--- View in Site --->
							<li><a href="#prc.CBHelper.linkPage(page)#" target="_blank"><i class="icon-eye-open icon-large"></i> View Page</a></li>
				    	</ul>
				    </div>
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