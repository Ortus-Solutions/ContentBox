﻿<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1">
			<i class="fa fa-globe fa-lg"></i> Sites (#arrayLen( prc.sites )#)
		</h1>
	</div>
</div>

<div class="row">
	<div class="col-md-12">
		#cbMessageBox().renderit()#
		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>
	</div>
</div>

<div class="row">
	<div class="col-md-12">
		#html.startForm(
			name 	: "siteForm",
			action 	: prc.xehSiteRemove,
			class 	: "form-vertical"
		)#
			#html.hiddenField( name : "siteID", value : "" )#

			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">

						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name        = "siteFilter",
									class       = "form-control rounded quicksearch",
									placeholder = "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6 col-xs-8">
							<cfif prc.oCurrentAuthor.hasPermission( "SITES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
							<div class="text-right">
								<!---Global --->
								<div class="btn-group">
									<button class="btn dropdown-toggle btn-default" data-toggle="dropdown">
										Bulk Actions <span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<cfif prc.oCurrentAuthor.hasPermission( "SITES_ADMIN,TOOLS_IMPORT" )>
											<li>
												<a href="javascript:importContent()">
													<i class="fa fa-file-import fa-lg"></i> Import
												</a>
											</li>
										</cfif>
										<cfif prc.oCurrentAuthor.hasPermission( "SITES_ADMIN,TOOLS_EXPORT" )>
											<li>
												<a
													href="#event.buildLink( prc.xehExportAll )#.json"
													target="_blank"
												>
													<i class="fa fa-file-export fa-lg"></i>
													Export All
												</a>
											</li>
										</cfif>
									</ul>
								</div>
								<button
									class="btn btn-primary"
									onclick="return to( '#event.buildLink( prc.xehSiteEditor )#' )"
								>
									Create Site
								</button>
							</div>
							</cfif>
						</div>
					</div>
				</div>

				<div class="panel-body">

					<!--- Info Bar --->
					<div class="alert alert-warning">
						<i class="fa fa-warning fa-lg"></i>
						If you delete a site, all of the content will be deleted as well. Be very very careful!
					</div>

					<!--- sites --->
					<table name="sites" id="sites" class="table table-striped-removed table-hover " >
						<thead>
							<tr>
								<th>Site</th>
								<th>Base URL</th>
								<th width="100">Theme</th>
								<th width="185" class="text-center {sorter:false}">Features</th>
								<th width="50" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>

						<tbody>
							<cfloop array="#prc.sites#" index="site">
							<tr
								<!--- DISABLED MARKER --->
								<cfif !site.getIsActive()>
									class="danger"
									title="Site is disabled!"
								</cfif>
							>
								<td>
									<a
										href="#event.buildLink( '#prc.xehSiteEditor#/siteID/#site.getsiteID()#' )#"
										class="size18"
									>
										<cfif site.getSlug() eq 'default'>
											<i class="fa fa-star text-orange" title="Default Site"></i>
										</cfif>
										#site.getName()#
									</a>
									<div class="mt5 mb5">
										#site.getDescription()#
									</div>
									<div class="mt5 mb5 label label-success" title="Site Unique Slug">
										#site.getSlug()#
									</div>
								</td>
								<td>
									#site.getDomain()#
								</td>
								<td>
									#site.getActiveTheme()#
								</td>
								<td>
									<!--- Blog Enabled --->
									<span 
										class="mr5 #site.getIsBlogEnabled() ? 'text-green' : 'text-gray'#" 
										title="Blog"
									>
										#cbAdminComponent( "ui/Icon", { name : "ChatBubbleBottomCenterText" } )#
									</span>
									<!--- SiteMap Enabled --->
									<span 
										class="mr5 #site.getIsSitemapEnabled() ? 'text-green' : 'text-gray'#" 
										title="Sitemap"
									>
										#cbAdminComponent( "ui/Icon", { name : "SiteMap" } )#
									</span>
									<!--- PoweredBy --->
									<span 
										class="mr5 #site.getPoweredByHeader() ? 'text-green' : 'text-gray'#" 
										title="Powered By Header"
									>
										#cbAdminComponent( "ui/Icon", { name : "TowerBroadcast" } )#
									</span>
									<!--- AdminBar --->
									<span 
										class="mr5 #site.getAdminBar() ? 'text-green' : 'text-gray'#" 
										title="Admin Bar"
									>
										#cbAdminComponent( "ui/Icon", { name : "Window" } )#
									</span>
									<!--- SSL --->
									<span 
										class="mr5 #site.getIsSSL() ? 'text-green' : 'text-gray'#" 
										title="Admin Bar"
									>
										#cbAdminComponent( "ui/Icon", { name : "LockClosed" } )#
									</span>
								</td>
								<td class="text-center">
									<!--- Actions --->
									<div class="btn-group">
										<button class="btn btn-sm btn-icon btn-more dropdown-toggle" data-toggle="dropdown" title="Site Actions">
											#cbAdminComponent( "ui/Icon", { name : "EllipsisVertical" } )#
											<span class="visually-hidden">Site Actions</span>
										</button>
										<ul class="dropdown-menu text-left pull-right">

											<!--- Delete Command --->
											<cfif site.getSlug() neq "default">
												<li>
													<a
														href="javascript:remove( '#site.getsiteID()#' )"
														class="confirmIt"
														data-title="Delete Site?"
													>
														<span id="delete_#site.getsiteID()#">
															#cbAdminComponent( "ui/Icon", { name : "Trash" } )#
														</span> 
														Delete
													</a>
												</li>
											</cfif>

											<!--- Edit Command --->
											<li>
												<a href="#event.buildLink( '#prc.xehSiteEditor#/siteID/#site.getsiteID()#' )#">
													#cbAdminComponent( "ui/Icon", { name : "PencilSquare" } )# Edit
												</a>
											</li>

											<!--- Export --->
											<cfif prc.oCurrentAuthor.hasPermission( "TOOLS_EXPORT" )>
												<li>
													<a
														href="#event.buildLink( prc.xehExport )#/siteID/#site.getsiteID()#.json"
														target="_blank"
													>
														#cbAdminComponent( "ui/Icon", { name : "ArrowRightOnRectangle" } )# Export
													</a>
												</li>
											</cfif>

											<!--- Open site --->
											<li>
												<a href="#site.getSiteRoot()#" target="_blank">
													#cbAdminComponent( "ui/Icon", { name : "WindowArrow" } )# Open site
												</a>
											</li>

										</ul>
									</div>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
			</div>
		#html.endForm()#
	</div>
</div>

<!--- Sites Import --->
<cfif prc.oCurrentAuthor.hasPermission( "TOOLS_IMPORT" )>
	#view(
		view = "_tags/dialog/import",
		args = {
			title       : "Import Sites",
			contentArea : "sites",
			action      : prc.xehImportAll,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> sites file to import."
		},
		prePostExempt = true
	)#
</cfif>
</cfoutput>
