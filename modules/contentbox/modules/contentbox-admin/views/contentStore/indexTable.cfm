<cfoutput>
<!--- Location Bar --->
<cfif structKeyExists( rc, "parent" ) AND len( rc.parent )>
	<div class="breadcrumb">
		<a href="javascript:contentListHelper.contentDrilldown()" title="Go Home!">
			<i class="fas fa-home fa-lg"></i>
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
					<i class="far fa-dot-circle-thin"></i>
				</cfif>

				<!--- Title --->
				<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN" )>
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
				#renderView(
					view : "_components/content/TableCreationInfo",
					args : { content : content, showDescription : true },
					prepostExempt : true
				)#

			</td>

			<td class="text-center">
				#renderView(
					view : "_components/content/TableStatus",
					args : { content : content },
					prepostExempt : true
				)#
			</td>

			<td class="text-center">
				<!--- Drag Handle --->
				<a 	href="##"
					onclick="return false;"
					class="dragHandle btn btn-default btn-sm"
					title="Click and drag to change retrieval order"
					style="padding:5px 15px"
				>
					<i class="fas fa-sort fa-lg"></i>
				</a>

				<!--- content Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Content Actions">
						<i class="fas fa-ellipsis-v fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN" )>
							<!--- Clone Command --->
							<li>
								<a
									href="javascript:contentListHelper.openCloneDialog(
										'#encodeForJavaScript( content.getContentID() )#',
										'#encodeForJavaScript( content.getTitle() )#'
									)"
								>
									<i class="far fa-clone fa-lg"></i> Clone
								</a>
							</li>
							<!--- Create Child --->
							<li>
								<a href="#event.buildLink( prc.xehContentEditor )#/parentID/#content.getContentID()#">
									<i class="fas fa-sitemap fa-lg"></i> Create Child
								</a>
							</li>
							<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN" )>
								<!--- Delete Command --->
								<li>
									<a href="javascript:contentListHelper.remove( '#content.getContentID()#' )" class="confirmIt" data-title="<i class='far fa-trash-alt fa-lg'></i> Delete Content?">
										<i id="delete_#content.getContentID()#" class="far fa-trash-alt fa-lg" ></i> Delete
									</a>
								</li>
							</cfif>
							<!--- Edit Command --->
							<li>
								<a href="#event.buildLink( prc.xehContentEditor )#/contentID/#content.getContentID()#">
									<i class="fas fa-pen fa-lg"></i> Edit
								</a>
							</li>
						</cfif>
						<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN,TOOLS_EXPORT" )>
						<!--- Export --->
							<li>
								<a href="#event.buildLink( prc.xehContentExport )#/contentID/#content.getContentID()#.json" target="_blank">
									<i class="fas fa-file-export fa-lg"></i> Export
								</a>
							</li>
						</cfif>
						<!--- History Command --->
						<li>
							<a href="#event.buildLink( prc.xehContentHistory )#/contentID/#content.getContentID()#">
								<i class="fas fa-history fa-lg"></i> History
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
