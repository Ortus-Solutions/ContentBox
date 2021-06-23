<cfoutput>
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
							<cfif prc.oCurrentAuthor.checkPermission( "SITES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
							<div class="text-right">
								<!---Global --->
								<div class="btn-group">
									<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
										Bulk Actions <span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<cfif prc.oCurrentAuthor.checkPermission( "SITES_ADMIN,TOOLS_IMPORT" )>
											<li>
												<a href="javascript:importContent()">
													<i class="fas fa-file-import fa-lg"></i> Import
												</a>
											</li>
										</cfif>
										<cfif prc.oCurrentAuthor.checkPermission( "SITES_ADMIN,TOOLS_EXPORT" )>
											<li>
												<a
													href="#event.buildLink( prc.xehExportAll )#.json"
													target="_blank"
												>
													<i class="fas fa-file-export fa-lg"></i>
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
									<i
										class="fas fa-blog fa-lg mr5 #site.getIsBlogEnabled() ? 'text-green' : 'text-gray'#"
										title="Blog"></i>

									<!--- SiteMap Enabled --->
									<i
										class="fas fa-sitemap fa-lg mr5 #site.getIsSitemapEnabled() ? 'text-green' : 'text-gray'#"
										title="Sitemap"></i>

									<!--- PoweredBy --->
									<i
										class="fas fa-broadcast-tower fa-lg mr5 #site.getPoweredByHeader() ? 'text-green' : 'text-gray'#"
										title="Powered By Header"></i>

									<!--- AdminBar --->
									<i
										class="fas fa-laptop-house fa-lg mr5 #site.getAdminBar() ? 'text-green' : 'text-gray'#"
										title="Admin Bar"></i>

									<!--- SSL --->
									<i
										class="fas fa-lock fa-lg mr5 #site.getIsSSL() ? 'text-green' : 'text-gray'#"
										title="SSL"></i>

								</td>
								<td class="text-center">
									<!--- Actions --->
									<div class="btn-group">
										<a class="btn btn-sm btn-info btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Site Actions">
											<i class="fas fa-ellipsis-v fa-lg"></i>
										</a>
										<ul class="dropdown-menu text-left pull-right">

											<!--- Delete Command --->
											<cfif site.getSlug() neq "default">
												<li>
													<a
														href="javascript:remove( '#site.getsiteID()#' )"
														class="confirmIt"
														data-title="<i class='far fa-trash-alt'></i> Delete Site?"
													>
														<i class="far fa-trash-alt fa-lg" id="delete_#site.getsiteID()#"></i> Delete
													</a>
												</li>
											</cfif>

											<!--- Edit Command --->
											<li>
												<a href="#event.buildLink( '#prc.xehSiteEditor#/siteID/#site.getsiteID()#' )#">
													<i class="fas fa-pen fa-lg"></i> Edit
												</a>
											</li>

											<!--- Export --->
											<cfif prc.oCurrentAuthor.checkPermission( "TOOLS_EXPORT" )>
												<li>
													<a
														href="#event.buildLink( prc.xehExport )#/siteID/#site.getsiteID()#.json"
														target="_blank"
													>
														<i class="fas fa-file-export fa-lg"></i> Export
													</a>
												</li>
											</cfif>

											<!--- Open site --->
											<li>
												<a href="#site.getSiteRoot()#" target="_blank">
													<i class="fas fa-external-link-alt fa-lg"></i>Open site
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
<cfif prc.oCurrentAuthor.checkPermission( "TOOLS_IMPORT" )>
	#renderView(
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