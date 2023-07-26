<cfoutput>

<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-users fa-lg"></i> Permission Groups (#arrayLen( prc.aGroups )#)
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
            name	= "groupForm",
            action	= prc.xehGroupRemove,
            class	= "form-vertical"
        )#

        	#html.hiddenField( name="permissionGroupID", value="" )#

        	<div class="panel panel-default">
				<div class="panel-heading">

					<div class="row">

						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name		= "groupFilter",
									class		= "form-control rounded quicksearch",
									placeholder	= "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6 col-xs-8">
							<div class="text-right">
								<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<!---Global --->
									<div class="btn-group">
								    	<button class="btn dropdown-toggle btn-default" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
								    		<li><a href="javascript:importContent()">#cbAdminComponent( "ui/Icon", { name : "ArrowLeftOnRectangle" } )# Import</a></li>
											</cfif>
											<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink( prc.xehExportAll )#.json" target="_blank">
														#cbAdminComponent( "ui/Icon", { name : "ArrowRightOnRectangle" } )# Export All
													</a>
												</li>
												<li>
													<a href="javascript:exportSelected( '#event.buildLink( prc.xehExportAll )#' )">
														#cbAdminComponent( "ui/Icon", { name : "ArrowRightOnRectangle" } )# Export Selected
													</a>
												</li>
											</cfif>
								    	</ul>
								    </div>
									<button
										class="btn btn-primary"
										onclick="return to('#event.buildLink( prc.xehGroupEditor )#')"
									>
										Create Group
									</button>
								</cfif>
							</div>
						</div>

					</div>
				</div>

				<div class="panel-body">

					<!--- Info Bar --->
					<div class="alert alert-warning">
						<i class="fa fa-exclamation-circle fa-lg"></i>
						Once you delete a permission group all assigned permissions and authors will be unassigned.
					</div>

					<!--- groups --->
					<table name="groups" id="groups" class="table table-striped-removed table-hover">

						<thead>
							<tr>
								<th id="checkboxHolder" class="{sorter:false} text-center" width="15">
									<input type="checkbox" onClick="checkAll( this.checked, 'permissionGroupID' )"/>
								</th>
								<th>Group</th>
								<th width="95" class="text-center">Permissions</th>
								<th width="95" class="text-center">Authors</th>
								<th width="50" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>

						<tbody>
							<cfloop array="#prc.aGroups#" index="group">
							<tr>
								<!--- check box --->
								<td class="text-center">
									<input
										type="checkbox"
										name="permissionGroupID"
										id="permissionGroupID"
										value="#group.getPermissionGroupID()#" />
								</td>
								<td>
									<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN" )>
									<a
										href="#event.buildLink( prc.xehGroupEditor & "/permissionGroupID/#group.getPermissionGroupId()#")#"
										title="Edit #group.getName()#"
										>
										#group.getName()#
									</a>
									<cfelse>
										#group.getName()#
									</cfif>

									<div class="mt5 text-muted">
										#group.getDescription()#
									</div>
								</td>

								<td class="text-center">
									<span class="badge badge-info">#group.getNumberOfPermissions()#</span>
								</td>

								<td class="text-center">
									<span class="badge badge-info">#group.getNumberOfAuthors()#</span>
								</td>

								<td class="text-center">
									<!--- Actions --->
									<div class="btn-group">
								    	<button class="btn btn-sm btn-icon btn-more dropdown-toggle" data-toggle="dropdown" title="Group Actions">
											#cbAdminComponent( "ui/Icon", { name : "EllipsisVertical" } )#
											<span class="visually-hidden">Group Actions</span>
										</button>
								    	<ul class="dropdown-menu text-left pull-right">
											<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>

												<!--- Delete Command --->
												<li>
													<a 	href="javascript:remove( '#group.getPermissionGroupID()#' )"
														class="confirmIt"
														data-title="<i class='fa fa-trash'></i> Delete Group?"
													>
														<i class="fa fa-trash fa-lg" id="delete_#group.getPermissionGroupID()#"></i> Delete
													</a>
												</li>

												<!--- Edit Command --->
												<li>
													<a
														href="#event.buildLink( prc.xehGroupEditor & "/permissionGroupID/#group.getPermissionGroupId()#")#"
											   		>
													   #cbAdminComponent( "ui/Icon", { name : "PencilSquare" } )# Edit
											   		</a>
											   	</li>

												<!--- Export --->
												<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>
													<li>
														<a 	href="#event.buildLink( prc.xehExport )#/permissionGroupID/#group.getPermissionGroupID()#.json"
															target="_blank"
														>
															<i class="fa fa-file-export fa-lg"></i> Export
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

<!--- Import Dialog --->
<cfif prc.oCurrentAuthor.hasPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
	#view(
		view = "_tags/dialog/import",
		args = {
			title       : "Import Permission Groups",
			contentArea : "groups",
			action      : prc.xehImportAll,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> permission group's file to import."
		},
		prePostExempt = true
	)#
</cfif>
</cfoutput>
