<cfoutput>
<!--- Entries Count --->
<input
	type="hidden"
	name="contentCount"
	id="contentCount"
	value="#prc.contentCount#">

<!--- entries --->
<table
	name="entries"
	id="entries"
	class="table table-striped-removed table-hover "
	cellspacing="0"
	width="100%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="15">
				<input type="checkbox" onClick="checkAll( this.checked, 'contentID' )"/>
			</th>
			<th>
				Name
			</th>
			<th width="40" class="text-center">
				Status
			</th>
			<th width="40" class="text-center">
				Search
			</th>
			<th width="40" class="text-center hidden-sm hidden-xs">
				Hits
			</th>
			<th width="40" class="text-center hidden-sm hidden-xs">
				Comments
			</th>
			<th width="50" class="text-center {sorter:false}">
				Actions
			</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.content#" index="entry">
		<tr data-contentID="#entry.getContentID()#"
			<cfif entry.isExpired()>
				class="danger"
			<cfelseif entry.isPublishedInFuture()>
				class="success"
			<cfelseif !entry.isContentPublished()>
				class="warning"
			<cfelseif entry.hasActiveContent() eq false>
				class="danger" title="No active content versions found, please publish one."
			</cfif>
		>
			<!--- check box --->
			<td class="text-center">
				<input type="checkbox" name="contentID" id="contentID" value="#entry.getContentID()#" />
			</td>

			<td>

				<!--- Title --->
				<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_EDITOR,ENTRIES_ADMIN" )>
					<a
						href="#event.buildLink( prc.xehEntriesEditor )#/contentID/#entry.getContentID()#"
						title="Edit"
						class="size18"
					>
						#entry.getTitle()#
					</a>
				<cfelse>
					<span class="size18">#entry.getTitle()#</span>
				</cfif>

				<!--- password protect --->
				<cfif entry.isPasswordProtected()>
					<i class="fas fa-key text-orange" title="Password Protected Content"></i>
				</cfif>

				<!--- Content Info --->
				#renderView(
					view : "_components/content/TableCreationInfo",
					args : { content : entry },
					prepostExempt : true
				)#
			</td>

			<!--- Status --->
			<td class="text-center">
				#renderView(
					view : "_components/content/TableStatus",
					args : { content : entry },
					prepostExempt : true
				)#
			</td>

			<!--- Show in Search --->
			<td class="text-center">
				#renderView(
					view : "_components/content/TableSearchStatus",
					args : { content : entry },
					prepostExempt : true
				)#
			</td>

			<!--- hits --->
			<td class="text-center hidden-sm hidden-xs">
				<span class="badge badge-info">#entry.getNumberOfHits()#</span>
			</td>

			<!--- Comments --->
			<td class="text-center hidden-sm hidden-xs">
				<span class="badge badge-info">#entry.getNumberOfComments()#</span>
			</td>

			<!--- Actions --->
			<td class="text-center">
				<!--- Entry Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Entry Actions">
						<i class="fas fa-ellipsis-v fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_EDITOR,ENTRIES_ADMIN" )>
						<!--- Clone Command --->
						<li>
							<a
								href="javascript:contentListHelper.openCloneDialog(
									'#encodeForJavascript( entry.getContentID() )#',
									'#encodeForJavascript( entry.getTitle() )#'
								)"
							>
								<i class="far fa-clone fa-lg"></i> Clone
							</a>
						</li>
						<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN" )>
						<!--- Delete Command --->
						<li>
							<a
								href="javascript:contentListHelper.remove( '#entry.getContentID()#' )"
								class="confirmIt"
								data-title="<i class='far fa-trash-alt'></i> Delete Entry?">
								<i id="delete_#entry.getContentID()#" class="far fa-trash-alt fa-lg" ></i> Delete
							</a>
						</li>
						</cfif>
						<!--- Edit Command --->
						<li>
							<a href="#event.buildLink( prc.xehEntryEditor )#/contentID/#entry.getContentID()#">
								<i class="fas fa-pen fa-lg"></i> Edit
							</a>
						</li>
						</cfif>
						<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,TOOLS_EXPORT" )>
						<!--- Export --->
						<li>
							<a
								href="#event.buildLink( prc.xehEntryExport )#/contentID/#entry.getContentID()#.json"
								target="_blank">
								<i class="fas fa-file-export fa-lg"></i> Export
							</a>
						</li>
						</cfif>
						<!--- History Command --->
						<li>
							<a href="#event.buildLink( prc.xehContentHistory )#/contentID/#entry.getContentID()#">
								<i class="fas fa-history fa-lg"></i> History
							</a>
						</li>
						<!-- Reset hits -->
						<li>
							<a href="javascript:contentListHelper.resetHits( '#entry.getContentID()#' )">
								<i class="fas fa-recycle fa-lg"></i> Reset Hits
							</a>
						</li>
						<!--- View in Site --->
						<li>
							<a
								href="#prc.CBHelper.linkEntry( entry )#"
								target="_blank">
								<i class="far fa-eye fa-lg"></i> Open In Site
							</a>
						</li>
			    	</ul>
			    </div>

			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.showAll>
	#prc.oPaging.renderit(
		foundRows = prc.contentCount,
		link      = prc.pagingLink,
		asList    = true
	)#
<cfelse>
	<span class="label label-info">Total Records: #prc.contentCount#</span>
</cfif>

</cfoutput>
