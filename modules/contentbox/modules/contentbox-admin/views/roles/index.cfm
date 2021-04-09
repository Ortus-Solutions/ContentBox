<cfoutput>

<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fas fa-user-shield fa-lg"></i> Roles (#arrayLen( prc.roles )#)
        </h1>
    </div>
</div>

<div class="row">
	<div class="col-md-12">

		<!--- MessageBox --->
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
            name   = "roleForm",
            action = prc.xehRoleRemove,
            class  = "form-vertical"
        )#
			#html.hiddenField( name="roleID", value="" )#

        	<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">

						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name        = "roleFilter",
									class       = "form-control rounded quicksearch",
									placeholder = "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6 col-xs-8">
							<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
								<div class="text-right">
									<!---Global --->
									<div class="btn-group">
										<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
										<ul class="dropdown-menu">
											<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT" )>
												<li>
													<a href="javascript:importContent()">
														<i class="fas fa-file-import fa-lg"></i> Import
													</a>
												</li>
											</cfif>
											<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink (to=prc.xehExportAll )#.json" target="_blank">
														<i class="fas fa-file-export fa-lg"></i> Export All as JSON
													</a>
												</li>
												<li>
													<a href="#event.buildLink( to=prc.xehExportAll )#.xml" target="_blank">
														<i class="fas fa-file-export fa-lg"></i> Export All as XML
													</a>
												</li>
											</cfif>
										</ul>
									</div>
									<button
										class="btn btn-primary"
										onclick="return to('#event.buildLink( prc.xehRoleEditor )#')"
									>
										Create Role
									</button>
								</div>
							</cfif>
						</div>
					</div>
				</div>

				<div class="panel-body">

					<!--- Info Bar --->
					<div class="alert alert-warning">
						<i class="fas fa-exclamation-circle fa-lg"></i>
						You cannot delete roles that have authors attached to them.  You will need to un-attach those authors from the role first.
					</div>

					<!--- roles --->
					<table name="roles" id="roles" class="table table-striped-removed table-hover">
						<thead>
							<tr>
								<th>Role</th>
								<th width="95" class="text-center">Permissions</th>
								<th width="95" class="text-center">Authors</th>
								<th width="50" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>

						<tbody>
							<cfloop array="#prc.roles#" index="role">
							<tr>
								<td>
									<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN" )>
										<a
											href="#event.buildLink( prc.xehRoleEditor & "/roleId/#role.getId()#")#"
											title="Edit #role.getName()#"
											>
											#role.getName()#
										</a>
									<cfelse>
										#role.getRole()#
									</cfif>

									<div class="mt5 textMuted">
										#role.getDescription()#
									</div>
								</td>


								<td class="text-center">
									<span class="badge badge-info">#role.getNumberOfPermissions()#</span>
								</td>

								<td class="text-center">
									<span class="badge badge-info">#role.getNumberOfAuthors()#</span>
								</td>

								<td class="text-center">
									<!--- Actions --->
									<div class="btn-group">
								    	<a class="btn btn-sm btn-info btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
											<i class="fas fa-ellipsis-v fa-lg"></i>
										</a>
								    	<ul class="dropdown-menu text-left pull-right">
											<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>

												<!--- Delete Command --->
												<cfif role.getNumberOfAuthors() eq 0>
													<li>
														<a 	href="javascript:remove( '#role.getId()#' )"
															class="confirmIt"
															data-title="<i class='far fa-trash-alt'></i> Delete Role?"
														>
															<i class="far fa-trash-alt fa-lg" id="delete_#role.getId()#"></i> Delete
														</a>
													</li>
												</cfif>

												<!--- Edit Command --->
												<li>
													<a
														href="#event.buildLink( prc.xehRoleEditor & "/roleId/#role.getId()#")#"
											   		>
											   			<i class="fas fa-pen fa-lg"></i> Edit
											   		</a>
											   	</li>

												<!--- Export --->
												<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>
													<li>
														<a
															href="#event.buildLink( prc.xehExport )#/roleID/#role.getId()#.json"
															target="_blank"
														>
															<i class="fas fa-file-export fa-lg"></i> Export as JSON
														</a>
													</li>
													<li>
														<a
															href="#event.buildLink( prc.xehExport )#/roleID/#role.getId()#.xml"
															target="_blank"
														>
															<i class="fas fa-file-export fa-lg"></i> Export as XML
														</a>
													</li>
												</cfif>
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
<!--- Import --->
<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view			= "_tags/dialog/import",
		args			= {
			title       : "Import Roles",
			contentArea : "roles",
			action      : prc.xehImportAll,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> roles file to import."
		},
		prePostExempt 	= true
	)#
</cfif>
</cfoutput>