<cfoutput>
<!--- Location Bar --->
<cfif structKeyExists( rc, "parent" ) AND len( rc.parent )>
	<div class="breadcrumb">
		<a href="javascript:contentListHelper.contentDrilldown()" title="Go Home!">
			<i class="fa fa-home fa-lg"></i>
		</a>
		#getInstance( "PageBreadcrumbVisitor@cbadmin" ).visit( prc.oParent )#
	</div>
</cfif>

<!--- Hidden Elements --->
#html.hiddenField( name="parent", value=event.getValue( "parent", "" ) )#
#html.hiddenField( name="contenCount", value=prc.contentCount )#

<!--- content --->
<table
	name="content"
	id="content"
	class="table table-striped-removed table-hover "
	cellspacing="0"
	width="100%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="15">
				<input type="checkbox" onClick="checkAll(this.checked,'contentID')"/>
			</th>
			<th>
				Name
			</th>
			<th width="40" class="text-center">
				Status
			</th>
			<th width="100" class="text-center {sorter:false}">
				Actions
			</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.content#" index="content">
		<tr
			<!--- We convert the - in the id to _ since the order plugin doesn't like dashes--->
			id="contentID-#content.getContentID().replace( "-", "_", "all" )#"
			data-contentID="#content.getContentID()#"

			<!--- double click drill down --->
			<cfif content.getNumberOfChildren()>
				ondblclick="contentListHelper.contentDrilldown( '#content.getContentID()#' )"
			</cfif>

			<!---Status bits --->
			<cfif content.isExpired()>
				class="danger"
			<cfelseif content.isPublishedInFuture()>
				class="success"
			<cfelseif !content.isContentPublished()>
				class="warning"
			<cfelseif content.hasActiveContent() eq false>
				class="danger" title="No active content versions found, please publish one."
			</cfif>
		>
			<!--- check box --->
			<td class="text-center">
				<input type="checkbox" name="contentID" id="contentID" value="#content.getContentID()#" />
			</td>
			<td>
				<!--- Children Dig Deeper --->
				<cfif content.getNumberOfChildren()>
					<a
						href="javascript:contentListHelper.contentDrilldown( '#content.getContentID()#' )"
						class="cursor-pointer text-muted"
						title="View Children (#content.getNumberOfChildren()#)"
					>
						<i class="fa fa-plus-square"></i>
					</a>
				<cfelse>
					<i class="fa fa-dot-circle-thin"></i>
				</cfif>

				<!--- Title --->
				<cfif prc.oCurrentAuthor.hasPermission( "CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN" )>
					<a
						href="#event.buildLink( prc.xehContentStoreEditor )#/contentID/#content.getContentID()#"
						title="Edit content"
					>
						<span class="size18">#content.getTitle()#</span>
					</a>
				<cfelse>
					<span class="size18">#content.getTitle()#</span>
				</cfif>

				<!--- Content Info --->
				#view(
					view : "_components/content/TableCreationInfo",
					args : { content : content, showDescription : true },
					prepostExempt : true
				)#

			</td>

			<td class="text-center">
				#view(
					view : "_components/content/TableStatus",
					args : { content : content },
					prepostExempt : true
				)#
			</td>

			<td class="text-center">
				<!--- Drag Handle --->
				<a 	href="##"
					onclick="return false;"
					class="dragHandle btn btn-icon btn-sm float-left"
					title="Click and drag to change retrieval order"
				>
					#cbAdminComponent( "ui/Icon", { name : "ChevronUpDown" } )#
				</a>

				<!--- content Actions --->
				<div class="btn-group btn-group-sm">
			    	<button class="btn btn-icon btn-more dropdown-toggle" data-toggle="dropdown" title="Content Actions">
						#cbAdminComponent( "ui/Icon", { name : "EllipsisVertical" } )#
						<span class="visually-hidden">Content Actions</span>
					</button>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oCurrentAuthor.hasPermission( "CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN" )>
							<!--- Clone Command --->
							<li>
								<a
									href="javascript:contentListHelper.openCloneDialog(
										'#encodeForJavaScript( content.getContentID() )#',
										'#encodeForJavaScript( content.getTitle() )#'
									)"
								>
									#cbAdminComponent( "ui/Icon", { name : "Square2Stack" } )# Clone
								</a>
							</li>
							<!--- Create Child --->
							<li>
								<a href="#event.buildLink( prc.xehContentEditor )#/parentID/#content.getContentID()#">
									<i class="fa fa-sitemap fa-lg"></i> Create Child
								</a>
							</li>
							<cfif prc.oCurrentAuthor.hasPermission( "CONTENTSTORE_ADMIN" )>
								<!--- Delete Command --->
								<li>
									<a href="javascript:contentListHelper.remove( '#content.getContentID()#' )" class="confirmIt" data-title="Delete Content?">
										<span id="delete_#content.getContentID()#">
											#cbAdminComponent( "ui/Icon", { name : "Trash" } )#
										</span> 
										Delete
									</a>
								</li>
							</cfif>
							<!--- Edit Command --->
							<li>
								<a href="#event.buildLink( prc.xehContentEditor )#/contentID/#content.getContentID()#">
									#cbAdminComponent( "ui/Icon", { name : "PencilSquare" } )# Edit
								</a>
							</li>
						</cfif>
						<cfif prc.oCurrentAuthor.hasPermission( "CONTENTSTORE_ADMIN,TOOLS_EXPORT" )>
						<!--- Export --->
							<li>
								<a href="#event.buildLink( prc.xehContentExport )#/contentID/#content.getContentID()#.json" target="_blank">
									#cbAdminComponent( "ui/Icon", { name : "ArrowRightOnRectangle" } )# Export
								</a>
							</li>
						</cfif>
						<!--- History Command --->
						<li>
							<a href="#event.buildLink( prc.xehContentHistory )#/contentID/#content.getContentID()#">
								<i class="fa fa-history fa-lg"></i> History
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
