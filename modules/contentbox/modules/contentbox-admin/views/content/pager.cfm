﻿<cfoutput>
<div id="contentPager_#prc.contentPager_id#">
	<!--- Loader --->
	<div class="loaders float-right" id="contentPager_#prc.contentPager_id#_loader">
		<i class="fa fa-spinner fa-spin fa-lg"></i>
	</div>

	<!--- entries --->
	<table
		name="contentPager_#prc.contentPager_id#_table"
		id="contentPager_#prc.contentPager_id#_table"
		class="table table-hover table-striped-removed"
		width="100%">
		<thead>
			<tr>
				<th>
					Title
				</th>
				<th width="40" class="text-center">
					<i class="fa fa-globe fa-lg" title="Published"></i>
				</th>
				<th width="40" class="text-center">
					<i class="fa fa-signal fa-lg" title="Hits"></i>
				</th>
				<th width="50" class="text-center">
					Actions
				</th>
			</tr>
		</thead>

		<tbody>
			<cfloop array="#prc.contentPager_content#" index="thisContent">
			<tr
				data-contentID="#thisContent.getContentID()#"
				<cfif thisContent.isExpired()>
					class="error"
				<cfelseif thisContent.isPublishedInFuture()>
					class="success"
				<cfelseif !thisContent.isContentPublished()>
					class="warning"
				</cfif>
			>

				<!--- Title --->
				<td>
					<a href="#event.buildLink( prc.xehContentPagerEditor )#/contentID/#thisContent.getContentID()#">
						#thisContent.getTitle()#
					</a>
					<br>
					<small>
						<i class="fa fa-user" title="last edit by"></i>
						<a href="mailto:#thisContent.getAuthorEmail()#">
							#thisContent.getAuthorName()#
						</a> on #thisContent.getActiveContent().getDisplayCreatedDate()#
					</small>
				</td>

				<!--- Info Columns --->
				<td class="text-center">
					<cfif thisContent.isExpired()>
						<span class="text-red" title="Page has expired on ( (#thisContent.getDisplayExpireDate()#))">
							#cbAdminComponent( "ui/Icon", { name : "ClockWarning" } )#
						</span>
						<span class="hidden">expired</span>
					<cfelseif thisContent.isPublishedInFuture()>
							<span class="text-blue" title="Page Publishes in the future (#thisContent.getDisplayPublishedDate()#)">
								#cbAdminComponent( "ui/Icon", { name : "ClockArrowPath" } )#
							</span>
						<span class="hidden">published in future</span>
					<cfelseif thisContent.isContentPublished()>
						<span class="text-green" title="Page Published">
							#cbAdminComponent( "ui/Icon", { name : "SignalCircle" } )#
						</span>
						<span class="hidden">published</span>
					<cfelse>
						<span class="text-gray" title="Page Draft">
							#cbAdminComponent( "ui/Icon", { name : "ClockDashedHalf" } )#
						</span>
						<span class="hidden">draft</span>
					</cfif>
				</td>

				<!--- Hits --->
				<td class="text-center">
					<span class="badge badge-info">#thisContent.getNumberOfHits()#</span>
				</td>

				<!--- Actions --->
				<td class="text-center">
					<div class="btn-group btn-xs">
				    	<a
				    		class="btn btn-xs btn-default btn-more dropdown-toggle"
				    		data-toggle="dropdown"
				    		href="##"
				    		title="Page Actions">
							<i class="fa fa-ellipsis-v fa-lg"></i>
						</a>
				    	<ul class="dropdown-menu text-left pull-right">
				    		<cfif prc.oCurrentAuthor.hasPermission( "#prc.contentPager_securityPrefix#_EDITOR,#prc.contentPager_securityPrefix#_ADMIN" )>
								<!--- Edit Command --->
								<li>
									<a href="#event.buildLink( prc.xehContentPagerEditor )#/contentID/#thisContent.getContentID()#">
										#cbAdminComponent( "ui/Icon", { name : "PencilSquare" } )# Edit
									</a>
								</li>
							</cfif>
							<!--- History Command --->
							<li>
								<a href="#event.buildLink( prc.xehContentPagerHistory )#/contentID/#thisContent.getContentID()#">
									#cbAdminComponent( "ui/Icon", { name : "History" } )# History
								</a>
							</li>
							<!--- View in Site --->
							<cfif thisContent.getContentType() neq "contentStore">
								<li>
									<a href="#prc.CBHelper.linkContent( thisContent )#" target="_blank">
										#cbAdminComponent( "ui/Icon", { name : "Eye" } )# View In Site
									</a>
								</li>
							</cfif>
				    	</ul>
				    </div>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>

	<!--- Paging --->
	<cfif prc.contentPager_pagination>
		#prc.contentPager_oPaging.renderit(
			foundRows : prc.contentPager_contentCount,
			link      : prc.contentPager_pagingLink,
			asList    : true,
			page 	  : rc.contentPager_page
		)#
	</cfif>

</div>
</cfoutput>
