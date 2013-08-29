<cfoutput>
<div id="pagerContent">
<!--- Loader --->
<div class="loaders floatRight" id="contentPagerLoader">
	<i class="icon-spinner icon-spin icon-large"></i>
</div>

<!--- content --->
<table name="content_pager" id="content_pager" class="tablesorter table table-hover table-condensed table-striped" width="100%">
	<thead>
		<tr>
			<th>Title</th>
			<th width="40" class="center"><i class="icon-globe icon-large" title="Published Status"></i></th>
			<th width="50" class="center">Actions</th>
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
				<i class="icon-user" title="last edit by"></i> <a href="mailto:#content.getAuthorEmail()#">#content.getAuthorName()#</a> on #content.getActiveContent().getDisplayCreatedDate()#
				</small>
			</td>
			<td class="center">
				<cfif content.isExpired()>
					<i class="icon-time icon-large textRed" title="Content has expired!"></i>
					<span class="hidden">expired</span>
				<cfelseif content.isPublishedInFuture()>
					<i class="icon-fighter-jet icon-large textBlue" title="Content Publishes in the future!"></i>
					<span class="hidden">published in future</span>
				<cfelseif content.isContentPublished()>
					<i class="icon-ok icon-large textGreen" title="Content Published!"></i>
					<span class="hidden">published in future</span>
				<cfelse>
					<i class="icon-remove icon-large textRed" title="Content Draft!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">
				<!--- content Actions --->
				<div class="btn-group">
			    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Content Actions">
						<i class="icon-cogs icon-large"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oAuthor.checkPermission("CONTENTSOTE_EDITOR,CONTENTSTORE_ADMIN")>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehContentEditor)#/contentID/#content.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehContentHistory)#/contentID/#content.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
			    	</ul>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif prc.pager_pagination>
	#prc.pager_pagingPlugin.renderit(prc.pager_contentCount, prc.pager_pagingLink)#
</cfif>
</div>
</cfoutput>