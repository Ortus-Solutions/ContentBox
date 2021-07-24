<cfoutput>
<div id="pagerContent">
<!--- Loader --->
<div class="loaders float-right" id="contentPagerLoader">
	<i class="fa fa-spinner fa-spin fa-lg"></i>
</div>

<!--- content --->
<table name="content_pager" id="content_pager" class="table table-hover  table-striped-removed" width="100%">
	<thead>
		<tr>
			<th>Title</th>
			<th width="40" class="text-center"><i class="fa fa-globe fa-lg" title="Published Status"></i></th>
			<th width="50" class="text-center">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.pager_content#" index="content">
		<tr data-contentID="#content.getContentID()#"
			<cfif content.isExpired()>
				class="error"
			<cfelseif content.isPublishedInFuture()>
				class="success"
			<cfelseif !content.isContentPublished()>
				class="warning"
			</cfif>>
			<td>
				<a href="#event.buildLink(prc.xehContentEditor)#/contentID/#content.getContentID()#" title="Edit #content.getTitle()#">#content.getTitle()#</a><br/>
				<small>
				<i class="fa fa-user" title="last edit by"></i> <a href="mailto:#content.getAuthorEmail()#">#content.getAuthorName()#</a> on <span data-timestamp="#content.getActiveContent().getMemento().createdDate#">#content.getActiveContent().getDisplayCreatedDate()#<span>
				</small>
			</td>
			<td class="text-center">
				<cfif content.isExpired()>
					<i class="fas fa-history fa-lg text-red" title="Content has expired!"></i>
					<span class="hidden">expired</span>
				<cfelseif content.isPublishedInFuture()>
					<i class="fa fa-space-shuttle fa-lg text-blue" title="Content Publishes in the future!"></i>
					<span class="hidden">published in future</span>
				<cfelseif content.isContentPublished()>
					<i class="far fa-dot-circle fa-lg text-green" title="Content Published!"></i>
					<span class="hidden">published in future</span>
				<cfelse>
					<i class="far fa-check-circle fa-lg text-red" title="Content Draft!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="text-center">
				<!--- content Actions --->
				<div class="btn-group btn-group-xs">
			    	<a class="btn btn-xs btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Content Actions">
						<i class="fas fa-ellipsis-v fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSOTE_EDITOR,CONTENTSTORE_ADMIN" )>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehContentEditor)#/contentID/#content.getContentID()#"><i class="fas fa-pen fa-lg"></i> Edit</a></li>
						<!--- Create Child --->
						<li><a href="#event.buildLink(prc.xehContentEditor)#/parentID/#content.getContentID()#"><i class="fas fa-sitemap fa-lg"></i> Create Child</a></li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehContentHistory)#/contentID/#content.getContentID()#"><i class="fas fa-history fa-lg"></i> History</a></li>
			    	</ul>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif prc.pager_pagination>
	#prc.pager_oPaging.renderit(foundRows=prc.pager_contentCount, link=prc.pager_pagingLink, asList=true)#
</cfif>
</div>
</cfoutput>