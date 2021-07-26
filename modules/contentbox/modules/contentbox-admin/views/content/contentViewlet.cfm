<cfoutput>
<!--- latest edits --->
<table
	name="contentTable-#args.viewletID#"
	id="contentTable-#args.viewletID#"
	class="table table-hover  table-striped-removed"
	width="100%"
>
	<thead>
		<tr>
			<th>Title</th>

			<th width="175">Date</th>

			<cfif args.showPublishedStatus>
			<th width="50" class="text-center">
				Status
			</th>
			</cfif>

			<cfif args.showHits>
			<th width="40" class="text-center">
				Hits
			</th>
			</cfif>

			<th width="100" class="text-center">Actions</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#args.aContent#" index="thisContent">
		<tr id="contentID-#thisContent.getContentID()#" data-contentID="#thisContent.getContentID()#"
			<cfif args.colorCodings>
				<cfif thisContent.isExpired()>
					class="danger"
				<cfelseif thisContent.isPublishedInFuture()>
					class="success"
				<cfelseif !thisContent.isContentPublished()>
					class="warning"
				</cfif>
			</cfif>
		>
			<!--- ***************************************************************************** --->
			<!--- 								CONTENT NAME + TYPE								--->
			<!--- ***************************************************************************** --->
			<td>
				<!--- Editor --->
	    		<cfif thisContent.getContentType() eq "page">
					<!--- Edit --->
					<a href="#event.buildLink( prc.xehPagesEditor )#/contentID/#thisContent.getContentID()#" title="Edit Page">
						#thisContent.getTitle()#
					</a>
					<!--- Label --->
					<div class="mt5">
						<span class="label label-success">#thisContent.getContentType()#</span>
					</div>
				<cfelseif thisContent.getContentType() eq "contentStore">
					<!--- Edit --->
					<a href="#event.buildLink( prc.xehContentStoreEditor )#/contentID/#thisContent.getContentID()#" title="Edit ContentStore">
						#thisContent.getTitle()#
					</a>
					<!--- Label --->
					<div class="mt5">
						<span class="label label-default">#thisContent.getContentType()#</span>
					</div>
				<cfelse>
					<!--- Edit --->
					<a href="#event.buildLink( prc.xehEntriesEditor )#/contentID/#thisContent.getContentID()#" title="Edit Entry">
						#thisContent.getTitle()#
					</a>
					<!--- Label --->
					<div class="mt5">
						<span class="label label-info">#thisContent.getContentType()#</span>
					</div>
				</cfif>
			</td>

			<!--- ***************************************************************************** --->
			<!--- 								AUTHOR + CREATE DATE							--->
			<!--- ***************************************************************************** --->
			<td>
				<cfif args.showAuthor>
					#getInstance( "Avatar@contentbox" ).renderAvatar(
						email 	= thisContent.getAuthorEmail(),
						size 	= "20" ,
						class 	= "gravatar img-circle"
					)#
					<a href="mailto:#thisContent.getAuthorEmail()#">#thisContent.getAuthorName()#</a>
					<br>
				</cfif>
				#thisContent.getActiveContent().getDisplayCreatedDate()#
			</td>

			<!--- ***************************************************************************** --->
			<!--- 								PUBLISHED STATUS								--->
			<!--- ***************************************************************************** --->
			<cfif args.showPublishedStatus>
				<td class="text-center">
					#renderView(
						view : "_components/content/TableStatus",
						args : { content : thisContent },
						prepostExempt : true
					)#
				</td>
			</cfif>

			<!--- ***************************************************************************** --->
			<!--- 								HITS 											--->
			<!--- ***************************************************************************** --->
			<cfif args.showHits>
				<td class="text-center">
					<span class="badge badge-info">#thisContent.getNumberOfHits()#</span>
				</td>
			</cfif>

			<!--- ***************************************************************************** --->
			<!--- 								ACTIONS											--->
			<!--- ***************************************************************************** --->
			<td class="text-center">
				<!--- Page Actions --->
				<div class="btn-group btn-group-sm">
					<a
						class="btn btn-default btn-more dropdown-toggle"
						data-toggle="dropdown"
						href="##"
						title="Page Actions"
					>
						<i class="fas fa-ellipsis-v fa-lg"></i>
					</a>

					<ul class="dropdown-menu text-left pull-right">

						<!--- View in Site --->
						<cfif listFindNoCase( "page,entry", thisContent.getContentType() )>
							<li>
								<a 	class=""
									href="#prc.CBHelper.linkContent( thisContent )#"
									target="_blank"
								>
									<i class="far fa-eye fa-lg"></i> View
								</a>
							</li>
						</cfif>

						<!--- Edit --->
						<li>
							<cfset targetEditor = prc.xehEntriesEditor>
							<cfif thisContent.getContentType() eq "page">
								<cfset targetEditor = prc.xehPagesEditor>
							<cfelseif thisContent.getContentType() eq "contentStore">
								<cfset targetEditor = prc.xehContentStoreEditor>
							</cfif>
							<a
								href="#event.buildLink( targetEditor )#/contentID/#thisContent.getContentID()#"
							>
								<i class="fas fa-pen fa-lg"></i> Edit
							</a>
						</li>
					</ul>
				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- No Records --->
<cfif !arrayLen( args.aContent )>
	<div class="alert alert-info">
		No Records Found
	</div>
</cfif>
</cfoutput>
