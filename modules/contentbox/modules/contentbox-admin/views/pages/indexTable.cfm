<cfoutput>
<!--- Location Bar --->
<cfif structKeyExists( rc, "parent" ) AND len( rc.parent )>
	<div class="breadcrumb">
		<a href="javascript:contentDrilldown()" title="Go Home!">
			<i class="fa fa-home fa-lg"></i>
		</a>
	  	#getInstance( "PageBreadcrumbVisitor@cbadmin" ).visit( prc.page )#
	</div>
</cfif>

<!--- Hidden Elements --->
#html.hiddenField( name="parent", value=event.getValue( "parent","" ) )#
#html.hiddenField( name="pagesCount", value=prc.pagesCount )#

<!--- pages --->
<table id="pages" name="pages" class="table table-striped-removed table-hover " cellspacing="0" width="100%">
    <thead>
        <tr></tr>
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
        <cfloop array="#prc.pages#" index="page">
			<tr id="contentID-#page.getContentID()#" data-contentID="#page.getContentID()#"
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
				<cfif page.getNumberOfChildren()>ondblclick="contentDrilldown( '#page.getContentID()#' )"</cfif>
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
							href="javascript:contentDrilldown( '#page.getContentID()#' )"
							class="cursor-pointer text-muted"
							title="View Child Pages (#page.getNumberOfChildren()#)"
						>
							<i class="fa fa-plus-square"></i>
						</a>
					<cfelse>
						<i class="far fa-dot-circle-thin"></i>
					</cfif>

					<!--- Title --->
					<cfif prc.oCurrentAuthor.checkPermission( "PAGES_EDITOR,PAGES_ADMIN" )>
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
						<i class="fas fa-key text-orange" title="Password Protected Content"></i>
					</cfif>

					<!--- ssl protected --->
					<cfif page.getSSLOnly()>
						<i class="fas fa-shield-alt text-orange" title="SSL Enabled"></i>
					</cfif>

					<!--- Search Label --->
					<cfif len( rc.searchPages ) or prc.isFiltering>
						<div class="mt5" title="Root Path">
							<div class="label label-success">#page.getSlug()#</div>
						</div>
					</cfif>

					<!--- Content Info --->
					#renderView(
						view : "_components/content/TableCreationInfo",
						args : { content : page },
						prepostExempt : true
					)#
				</td>

				<td class="text-center">
					#renderView(
						view : "_components/content/TableStatus",
						args : { content : page },
						prepostExempt : true
					)#
				</td>

				<td class="text-center">
					<cfif page.getShowInMenu()>
						<i class="far fa-dot-circle fa-lg text-green"></i>
						<span class="hidden">yes</span>
					<cfelse>
						<i class="far fa-dot-circle fa-lg text-gray"></i>
						<span class="hidden">no</span>
					</cfif>
				</td>

				<td class="text-center">
					#renderView(
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
						class="dragHandle btn btn-default btn-sm"
						title="Click and drag to change menu order"
						style="padding:5px 15px"
					>
						<i class="fas fa-sort fa-lg"></i>
					</a>

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
							<cfif prc.oCurrentAuthor.checkPermission( "PAGES_EDITOR,PAGES_ADMIN" )>
								<!--- Clone Command --->
								<li class="mb5">
									<a
										href="javascript:openCloneDialog(
											'#page.getContentID()#',
											'#URLEncodedFormat( page.getTitle() )#'
										)"
									>
										<i class="far fa-clone fa fa-lg"></i> Clone
									</a>
								</li>

								<!--- Create Child --->
								<li class="mb5">
									<a
										href="#event.buildLink( prc.xehPageEditor )#/parentID/#page.getContentID()#"
									>
										<i class="fas fa-sitemap fa-lg"></i> Create Child
									</a>
								</li>

								<!--- Delete Command --->
								<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" )>
									<li class="mb5">
										<a
											href="javascript:remove( '#page.getContentID()#' )"
											class="confirmIt"
											data-title="<i class='far fa-trash-alt'></i> Delete Page?"
											data-message="This will delete the page and all of its sub-pages, are you sure?"
										>
											<i
												id="delete_#page.getContentID()#"
												class="far fa-trash-alt fa-lg"></i> Delete
										</a>
									</li>
								</cfif>

								<!--- Edit Command --->
								<li class="mb5">
									<a
										href="#event.buildLink( prc.xehPageEditor )#/contentID/#page.getContentID()#"
									>
										<i class="fas fa-pen fa-lg"></i> Edit
									</a>
								</li>
							</cfif>

							<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_EXPORT" )>
								<!--- Export --->
								<li class="mb5">
									<a
										href="#event.buildLink( prc.xehPageExport )#/contentID/#page.getContentID()#.json"
										target="_blank"
									>
										<i class="fas fa-file-export fa-lg"></i> Export as JSON
									</a>
								</li>
								<li class="mb5">
									<a
										href="#event.buildLink( prc.xehPageExport )#/contentID/#page.getContentID()#.xml"
										target="_blank"
									>
										<i class="fas fa-file-export fa-lg"></i> Export as XML
									</a>
								</li>
							</cfif>


							<!--- History Command --->
							<li class="mb5">
								<a
									href="#event.buildLink( prc.xehPageHistory )#/contentID/#page.getContentID()#"
								>
									<i class="fas fa-history fa-lg"></i> History
								</a>
							</li>

							<!--- Reset hits --->
							<li class="mb5">
								<a
									href="javascript:resetHits( '#page.getContentID()#' )"
								>
									<i class="fas fa-recycle fa-lg"></i> Reset Hits
								</a>
							</li>

							<!--- View in Site --->
							<li class="mb5">
								<a
									href="#prc.cbHelper.linkPage( page )#"
									target="_blank"
								>
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
</cfoutput>