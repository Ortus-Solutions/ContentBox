<cfoutput>
<div id="pagerPages">
	<!--- Loader --->
	<div class="loaders floatRight" id="pagePagerLoader">
		<i class="fa fa-spinner fa-spin fa-lg"></i>
	</div>

	<!--- entries --->
	<table name="pages_pager" id="pages_pager" class="table table-hover table-condensed table-striped" width="100%">
		<thead>
			<tr>
				<th>Page</th>
				<th width="40" class="text-center"><i class="fa fa-globe fa-lg" title="Published"></i></th>
				<th width="40" class="text-center"><i class="fa fa-signal fa-lg" title="Hits"></i></th>
				<th width="50" class="text-center">Actions</th>
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
					<small><i class="fa fa-user" title="last edit by"></i> <a href="mailto:#page.getAuthorEmail()#">#page.getAuthorName()#</a> on #page.getActiveContent().getDisplayCreatedDate()#</small>
				</td>
				<td class="text-center">
					<cfif page.isExpired()>
						<i class="fa fa-clock-o fa-lg textRed" title="Page has expired on ( (#page.getDisplayExpireDate()#))"></i>
						<span class="hidden">expired</span>
					<cfelseif page.isPublishedInFuture()>
						<i class="fa fa-fighter-jet fa-lg textBlue" title="Page Publishes in the future (#page.getDisplayPublishedDate()#)"></i>
						<span class="hidden">published in future</span>
					<cfelseif page.isContentPublished()>
						<i class="fa fa-check fa-lg textGreen" title="Page Published"></i>
						<span class="hidden">published in future</span>
					<cfelse>
						<i class="fa fa-times fa-lg textRed" title="Page Draft"></i>
						<span class="hidden">draft</span>
					</cfif>
				</td>
				<td class="text-center"><span class="badge badge-info">#page.getNumberOfHits()#</span></td>
				<td class="text-center">
					<!--- Page Actions --->
					<div class="btn-group btn-xs">
				    	<a class="btn btn-xs btn-primary dropdown-toggle" data-toggle="dropdown" href="##" title="Page Actions">
							<i class="fa fa-cogs fa-lg"></i>
						</a>
				    	<ul class="dropdown-menu text-left pull-right">
				    		<cfif prc.oAuthor.checkPermission( "PAGES_EDITOR" ) OR prc.oAuthor.checkPermission( "PAGES_ADMIN" )>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#"><i class="fa fa-edit fa-lg"></i> Edit</a></li>
							<!--- Create Child --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#"><i class="fa fa-sitemap fa-lg"></i> Create Child</a></li>
							</cfif>
							<!--- History Command --->
							<li><a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#"><i class="fa fa-clock-o fa-lg"></i> History</a></li>
							<!--- View in Site --->
							<li><a href="#prc.CBHelper.linkPage(page)#" target="_blank"><i class="fa fa-eye fa-lg"></i> View Page</a></li>
				    	</ul>
				    </div>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>
	
	<!--- Paging --->
	<cfif prc.pagePager_pagination>
		#prc.pagepager_oPaging.renderit(foundRows=prc.pager_pagesCount, link=prc.pagePager_pagingLink, asList=true)#
	</cfif>

</div>
</cfoutput>