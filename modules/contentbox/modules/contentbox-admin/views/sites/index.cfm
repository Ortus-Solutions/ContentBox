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
		#getInstance( "messagebox@cbMessagebox" ).renderit()#
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
			#html.hiddenField( name : "siteId", value : "" )#

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
									<a class="btn btn-info dropdown-toggle" data-toggle="dropdown" href="##">
										Bulk Actions <span class="caret"></span>
									</a>
									<ul class="dropdown-menu">
										<cfif prc.oCurrentAuthor.checkPermission( "SITES_ADMIN,TOOLS_IMPORT" )>
										<li><a href="javascript:importContent()"><i class="fas fa-file-import"></i> Import</a></li>
										</cfif>
										<cfif prc.oCurrentAuthor.checkPermission( "SITES_ADMIN,TOOLS_EXPORT" )>
											<li><a href="#event.buildLink( prc.xehExportAll )#.json" target="_blank"><i class="fas fa-file-export"></i> Export All as JSON</a></li>
											<li><a href="#event.buildLink( prc.xehExportAll )#.xml" target="_blank"><i class="fas fa-file-export"></i> Export All as XML</a></li>
										</cfif>
									</ul>
								</div>
								<a
									href="#event.buildLink( prc.xehSiteEditor )#"
									class="btn btn-primary"
									>
									Create Site
								</a>
							</div>
							</cfif>
						</div>
					</div>
				</div>

				<div class="panel-body">

					<!--- Info Bar --->
					<div class="alert alert-warning">
						<i class="fa fa-warning fa-lg"></i>
						You cannot delete sites that have content attached to them.
						You will need to deactivate the site unless all content is removed.
					</div>

					<!--- sites --->
					<table name="sites" id="sites" class="table table-striped-removed table-hover " width="98%">
						<thead>
							<tr>
								<th>Site</th>
								<th>Domain Match</th>
								<th>Theme</th>
								<th width="150" class="text-center {sorter:false}">Features</th>
								<th width="100" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>

						<tbody>
							<cfloop array="#prc.sites#" index="site">
							<tr>
								<td>
									<a
										href="#event.buildLink( '#prc.xehSiteEditor#/siteId/#site.getSiteId()#' )#"
									>
										<cfif site.getSlug() eq 'default'>
											<i class="fa fa-star textOrange" title="Default Site"></i>
										</cfif>
										#site.getName()#
									</a>
									<div>
										#site.getDescription()#
									</div>
								</td>
								<td>
									#site.getDomainRegex()#
								</td>
								<td>
									#site.getActiveTheme()#
								</td>
								<td>
									<!--- Blog Enabled --->
									<i
										class="fas fa-blog fa-lg mr5 #site.getIsBlogEnabled() ? 'textGreen' : 'textGray'#"
										title="Blog"></i>

									<!--- SiteMap Enabled --->
									<i
										class="fas fa-sitemap fa-lg mr5 #site.getIsSitemapEnabled() ? 'textGreen' : 'textGray'#"
										title="Sitemap"></i>

									<!--- PoweredBy --->
									<i
										class="fas fa-broadcast-tower fa-lg mr5 #site.getPoweredByHeader() ? 'textGreen' : 'textGray'#"
										title="Powered By Header"></i>

									<!--- AdminBar --->
									<i
										class="fas fa-laptop-house fa-lg mr5 #site.getAdminBar() ? 'textGreen' : 'textGray'#"
										title="Admin Bar"></i>

									<!--- SSL --->
									<i
										class="fas fa-lock fa-lg mr5 #site.getIsSSL() ? 'textGreen' : 'textGray'#"
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
											<cfif site.getNumberOfContent() eq 0>
												<li>
													<a
														href="javascript:remove( '#site.getSiteId()#' )"
														class="confirmIt"
														data-title="<i class='far fa-trash-alt'></i> Delete Site?"
													>
														<i class="far fa-trash-alt fa-lg" id="delete_#site.getSiteId()#"></i> Delete
													</a>
												</li>
											</cfif>

											<!--- Edit Command --->
											<li>
												<a href="#event.buildLink( '#prc.xehSiteEditor#/siteId/#site.getSiteId()#' )#">
													<i class="fas fa-pen fa-lg"></i> Edit
												</a>
											</li>

											<!--- Export --->
											<cfif prc.oCurrentAuthor.checkPermission( "TOOLS_EXPORT" )>
												<li>
													<a
														href="#event.buildLink( prc.xehExport )#/siteId/#site.getSiteId()#.json"
														target="_blank"
													>
														<i class="fas fa-file-export"></i> Export as JSON
													</a>
												</li>
												<li>
													<a
														href="#event.buildLink( prc.xehExport )#/siteId/#site.getSiteId()#.xml"
														target="_blank"
													>
														<i class="fas fa-file-export"></i> Export as XML
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
				</div>
			</div>
		#html.endForm()#
	</div>
</div>

<!--- Sites Import --->
<cfif prc.oCurrentAuthor.checkPermission( "TOOLS_IMPORT" )>
	#renderView(
		view : "_tags/dialog/import",
		args : {
			title       : "Import Sites",
			contentArea : "sites",
			action      : prc.xehImportAll,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> sites file to import."
		}
	)#
</cfif>
</cfoutput>