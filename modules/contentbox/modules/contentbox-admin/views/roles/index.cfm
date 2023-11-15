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
									class       = "form-control quicksearch",
									placeholder = "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6 col-xs-8">
							<cfif prc.oCurrentAuthor.hasPermission( "ROLES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
								<div class="text-right">
									<!---Global --->
									<div class="btn-group">
										<button class="btn dropdown-toggle btn-default" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
										<ul class="dropdown-menu">
											<cfif prc.oCurrentAuthor.hasPermission( "ROLES_ADMIN,TOOLS_IMPORT" )>
												<li>
													<a href="javascript:importContent()">
														<i class="fa fa-file-import fa-lg"></i> Import
													</a>
												</li>
											</cfif>
											<cfif prc.oCurrentAuthor.hasPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink ( prc.xehExportAll )#.json" target="_blank">
														<i class="fas fa-file-export fa-lg"></i> Export All
													</a>
												</li>
												<li>
													<a href="javascript:exportSelected( '#event.buildLink( prc.xehExportAll )#' )">
														<i class="fas fa-file-export fa-lg"></i> Export Selected
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
						<i class="fa fa-exclamation-circle fa-lg"></i>
						You cannot delete roles that have authors attached to them.  You will need to un-attach those authors from the role first.
					</div>

					<!--- roles --->
					<table name="roles" id="roles" class="table table-striped-removed table-hover">
						<thead>
							<tr>
								<th id="checkboxHolder" class="{sorter:false} text-center" width="15">
									<input name="checkAll" type="checkbox" onclick="checkAll( this.checked, 'roleID' )"/>
								</th>
								<th>Role</th>
								<th width="95" class="text-center">Permissions</th>
								<th width="95" class="text-center">Authors</th>
								<th width="50" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>

						<tbody>
							<cfloop array="#prc.roles#" index="role">
							<tr>
								<!--- check box --->
								<td class="text-center">
									<input
										type="checkbox"
										name="roleID"
										id="roleID"
										value="#role.getRoleID()#" />
								</td>
								<td>
									<cfif prc.oCurrentAuthor.hasPermission( "ROLES_ADMIN" )>
										<a
											href="#event.buildLink( prc.xehRoleEditor & "/roleId/#role.getRoleId()#")#"
											title="Edit #role.getName()#"
											>
											#role.getName()#
										</a>
									<cfelse>
										#role.getRole()#
									</cfif>

									<div class="mt5 text-muted">
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
								    	<button class="btn btn-sm btn-icon btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
											<i class="fa fa-ellipsis-v fa-lg" aria-hidden="true"></i>
											<span class="visually-hidden">Role Actions</span>
										</button>
								    	<ul class="dropdown-menu text-left pull-right">
											<cfif prc.oCurrentAuthor.hasPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>

												<!--- Delete Command --->
												<cfif role.getNumberOfAuthors() eq 0>
													<li>
														<a 	href="javascript:remove( '#role.getRoleId()#' )"
															class="confirmIt"
															data-title="<i class='fa fa-trash'></i> Delete Role?"
														>
															<i class="fa fa-trash fa-lg" id="delete_#role.getRoleId()#"></i> Delete
														</a>
													</li>
												</cfif>

												<!--- Edit Command --->
												<li>
													<a
														href="#event.buildLink( prc.xehRoleEditor & "/roleId/#role.getRoleId()#")#"
											   		>
											   			<i class="fas fa-pen fa-lg"></i> Edit
											   		</a>
											   	</li>

												<!--- Export --->
												<cfif prc.oCurrentAuthor.hasPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>
													<li>
														<a
															href="#event.buildLink( prc.xehExport )#/roleID/#role.getRoleID()#.json"
															target="_blank"
														>
															<i class="fas fa-file-export fa-lg"></i> Export
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
<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
	#view(
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
