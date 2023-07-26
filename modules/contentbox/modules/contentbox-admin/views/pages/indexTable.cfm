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
#html.hiddenField( name="parent", value=event.getValue( "parent","" ) )#
#html.hiddenField( name="pagesCount", value=prc.contentCount )#

<!--- pages --->
<table
	id="pages"
	name="pages"
	class="table table-striped-removed table-hover "
	cellspacing="0"
	width="100%"
>
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
				Menu
			</th>
			<th width="40" class="text-center">
				Search
			</th>
			<th width="40" class="text-center hidden-sm hidden-xs">
				Hits
			</th>
			<th width="100" class="text-center {sorter:false}">
				Actions
			</th>
        </tr>
    </thead>
    <tbody>
        <cfloop array="#prc.content#" index="page">
			<tr
				<!--- We convert the - in the id to _ since the order plugin doesn't like dashes--->
				id="contentID-#page.getContentID().replace( "-", "_", "all" )#"
				data-contentID="#page.getContentID()#"

				<!--- Classes according to content status --->
				<cfif page.isExpired()>
					class="danger"
				<cfelseif page.isPublishedInFuture()>
					class="success"
				<cfelseif !page.isContentPublished()>
					class="warning"
				<cfelseif page.hasActiveContent() eq false>
					class="danger" title="No active content versions found, please publish one."
				</cfif>

				<!--- double click drill down --->
				<cfif page.getNumberOfChildren()>
					ondblclick="contentListHelper.contentDrilldown( '#page.getContentID()#' )"
				</cfif>
			>
				<!--- check box --->
				<td class="text-center">
					<input type="checkbox" name="contentID" id="contentID" value="#page.getContentID()#" />
				</td>

				<td>
					<!--- Home page--->
					<cfif page.getSlug() eq prc.oCurrentSite.getHomepage()>
						<i class="fa fa-home text-muted" title="Current Homepage"></i>
					</cfif>


					<!--- Children Dig Deeper --->
					<cfif page.getNumberOfChildren()>
						<a
							href="javascript:contentListHelper.contentDrilldown( '#page.getContentID()#' )"
							class="cursor-pointer text-muted"
							title="View Child Pages (#page.getNumberOfChildren()#)"
						>
							<i class="fa fa-plus-square"></i>
						</a>
					<cfelse>
						<i class="fa fa-dot-circle-thin"></i>
					</cfif>

					<!--- Title --->
					<cfif prc.oCurrentAuthor.hasPermission( "PAGES_EDITOR,PAGES_ADMIN" )>
						<a
							href="#event.buildLink( prc.xehPageEditor )#/contentID/#page.getContentID()#"
							title="Edit #page.getTitle()#"
							class="size18"
						>
							#page.getTitle()#
						</a>
					<cfelse>
						<span class="size18">#page.getTitle()#</span>
					</cfif>

					<!--- password protected --->
					<cfif page.isPasswordProtected()>
						<i class="fa fa-key text-orange" title="Password Protected Content"></i>
					</cfif>

					<!--- Search Label --->
					<cfif len( rc.searchContent ) or prc.isFiltering>
						<div class="mt5" title="Root Path">
							<div class="label label-success">#page.getSlug()#</div>
						</div>
					</cfif>

					<!--- Content Info --->
					#view(
						view : "_components/content/TableCreationInfo",
						args : { content : page },
						prepostExempt : true
					)#
				</td>

				<td class="text-center">
					#view(
						view : "_components/content/TableStatus",
						args : { content : page },
						prepostExempt : true
					)#
				</td>

				<td class="text-center">
					<cfif page.getShowInMenu()>
						<i class="fa fa-dot-circle fa-lg text-green"></i>
						<span class="hidden">yes</span>
					<cfelse>
						<i class="fa fa-dot-circle fa-lg text-gray"></i>
						<span class="hidden">no</span>
					</cfif>
				</td>

				<td class="text-center">
					#view(
						view : "_components/content/TableSearchStatus",
						args : { content : page },
						prepostExempt : true
					)#
				</td>

				<td class="text-center hidden-sm hidden-xs">
					<span class="badge badge-info">#page.getNumberOfHits()#</span>
				</td>

				<td class="text-center">
					<!--- Drag Handle --->
					<a
						href="##"
						onclick="return false;"
						class="dragHandle btn btn-icon btn-sm"
						title="Click and drag to change menu order"
					>
						#cbAdminComponent( "ui/Icon", { name : "ChevronUpDown" } )#
					</a>

					<!--- Page Actions --->
					<div class="btn-group btn-group-sm">
						<button
							class="btn btn-icon btn-more dropdown-toggle"
							data-toggle="dropdown"
							title="Page Actions"
						>
							#cbAdminComponent( "ui/Icon", { name : "EllipsisVertical" } )#
							<span class="visually-hidden">Page Actions</span>
						</button>

						<ul class="dropdown-menu text-left pull-right">
							<cfif prc.oCurrentAuthor.hasPermission( "PAGES_EDITOR,PAGES_ADMIN" )>
								<!--- Clone Command --->
								<li class="mb5">
									<a
										href="javascript:contentListHelper.openCloneDialog(
											'#encodeForJavascript( page.getContentID() )#',
											'#encodeForJavascript( page.getTitle() )#'
										)"
									>
										<i class="fa fa-clone fa fa-lg"></i> Clone
									</a>
								</li>

								<!--- Create Child --->
								<li class="mb5">
									<a
										href="#event.buildLink( prc.xehPageEditor )#/parentID/#page.getContentID()#"
									>
										<i class="fa fa-sitemap fa-lg"></i> Create Child
									</a>
								</li>

								<!--- Delete Command --->
								<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN" )>
									<li class="mb5">
										<a
											href="javascript:contentListHelper.remove( '#page.getContentID()#' )"
											class="confirmIt"
											data-title="<i class='fa fa-trash'></i> Delete Page?"
											data-message="This will delete the page and all of its sub-pages, are you sure?"
										>
											<i
												id="delete_#page.getContentID()#"
												class="fa fa-trash fa-lg"></i> Delete
										</a>
									</li>
								</cfif>

								<!--- Edit Command --->
								<li class="mb5">
									<a
										href="#event.buildLink( prc.xehPageEditor )#/contentID/#page.getContentID()#"
									>
										#cbAdminComponent( "ui/Icon", { name : "PencilSquare" } )# Edit
									</a>
								</li>
							</cfif>

							<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN,TOOLS_EXPORT" )>
								<!--- Export --->
								<li class="mb5">
									<a
										href="#event.buildLink( prc.xehPageExport )#/contentID/#page.getContentID()#.json"
										target="_blank"
									>
										<i class="fa fa-file-export fa-lg"></i> Export
									</a>
								</li>
							</cfif>


							<!--- History Command --->
							<li class="mb5">
								<a
									href="#event.buildLink( prc.xehContentHistory )#/contentID/#page.getContentID()#"
								>
									<i class="fa fa-history fa-lg"></i> History
								</a>
							</li>

							<!--- Reset hits --->
							<li class="mb5">
								<a
									href="javascript:contentListHelper.resetHits( '#page.getContentID()#' )"
								>
									<i class="fa fa-recycle fa-lg"></i> Reset Hits
								</a>
							</li>

							<!--- View in Site --->
							<li class="mb5">
								<a
									href="#prc.cbHelper.linkPage( page )#"
									target="_blank"
								>
									<i class="fa fa-eye fa-lg"></i> Open In Site
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
