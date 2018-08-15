<cfoutput>

<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-group fa-lg"></i> Permission Groups
        </h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">

        #getModel( "messagebox@cbMessagebox" ).renderit()#

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

						<div class="col-md-6">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name		= "groupFilter",
									class		= "form-control",
									placeholder	= "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6">
							<div class="pull-right">
								<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
								<div class="pull-right">
									<!---Global --->
									<div class="btn-group btn-group-sm">
								    	<a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##">
											Bulk Actions <span class="caret"></span>
										</a>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
								    		<li><a href="javascript:importContent()"><i class="fa fa-upload"></i> Import</a></li>
											</cfif>
											<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink (linkto = prc.xehExportAll )#.json" target="_blank">
														<i class="fa fa-download"></i> Export All as JSON
													</a>
												</li>
												<li>
													<a href="#event.buildLink( linkto = prc.xehExportAll )#.xml" target="_blank">
														<i class="fa fa-download"></i> Export All as XML
													</a>
												</li>
											</cfif>
								    	</ul>
								    </div>
									<button onclick="return createGroup();" class="btn btn-sm btn-primary">Create Group</button>
								</div>
								</cfif>
							</div>
						</div>

					</div>
				</div>

				<div class="panel-body">

					<!--- Info Bar --->
					<div class="alert alert-warning">
						<i class="fa fa-warning fa-lg"></i>
						Once you delete a permission group all assigned permissions and authors will be unassigned.
					</div>

					<!--- groups --->
					<table name="groups" id="groups" class="table table-striped table-hover table-condensed" width="98%">

						<thead>
							<tr>
								<th>Group</th>
								<th>Description</th>
								<th width="95" class="text-center">Permissions</th>
								<th width="95" class="text-center">Authors</th>
								<th width="100" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>

						<tbody>
							<cfloop array="#prc.aGroups#" index="group">
							<tr>

								<td>
									<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
									<a href="javascript:edit(
										'#group.getPermissionGroupID()#',
									   	'#HTMLEditFormat( jsstringFormat( group.getName() ) )#',
									   	'#HTMLEditFormat( jsstringFormat( group.getDescription() ) )#')"
									   title="Edit #group.getName()#">#group.getName()#</a>
									<cfelse>
										#group.getName()#
									</cfif>
								</td>

								<td>#group.getDescription()#</td>

								<td class="text-center">
									<span class="badge badge-info">#group.getNumberOfPermissions()#</span>
								</td>

								<td class="text-center">
									<span class="badge badge-info">#group.getNumberOfAuthors()#</span>
								</td>

								<td class="text-center">
									<!--- permissions --->
									<a 	class="btn btn-sm btn-primary"
										href="javascript:openRemoteModal(
											'#event.buildLink( prc.xehGroupPermissions )#',
											{ permissionGroupID: '#group.getPermissionGroupID()#'}
										);"
										title="Manage Permissions">
										<i class="fa fa-lock fa-lg"></i>
									</a>

									<!--- Actions --->
									<div class="btn-group">
								    	<a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##" title="Group Actions">
											<i class="fa fa-cogs fa-lg"></i>
										</a>
								    	<ul class="dropdown-menu text-left pull-right">
											<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>

												<!--- Delete Command --->
												<li>
													<a 	href="javascript:remove( '#group.getPermissionGroupID()#' )"
														class="confirmIt"
														data-title="<i class='fa fa-trash-o'></i> Delete Group?"
													>
														<i class="fa fa-trash-o fa-lg" id="delete_#group.getPermissionGroupID()#"></i> Delete
													</a>
												</li>

												<!--- Edit Command --->
												<li>
													<a href="javascript:edit(
														'#group.getPermissionGroupID()#',
											   			'#HTMLEditFormat( jsstringFormat( group.getName() ) )#',
											   			'#HTMLEditFormat( jsstringFormat( group.getDescription() ) )#')"
											   		>
											   			<i class="fa fa-edit fa-lg"></i> Edit
											   		</a>
											   	</li>

												<!--- Export --->
												<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>
													<li>
														<a 	href="#event.buildLink( prc.xehExport )#/permissionGroupID/#group.getPermissionGroupID()#.json"
															target="_blank"
														>
															<i class="fa fa-download"></i> Export as JSON
														</a>
													</li>
													<li>
														<a 	href="#event.buildLink( prc.xehExport )#/permissionGroupID/#group.getPermissionGroupID()#.xml"
															target="_blank"
														>
															<i class="fa fa-download"></i> Export as XML
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

<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
	<!--- Permission Group Editor --->
	<div id="groupEditorContainer" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document" >
			<div class="modal-content">

				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4><i class="fa fa-group"></i> Group Editor</h4>
			    </div>

				<!--- Create/Edit form --->
				#html.startForm(
					action		= prc.xehGroupSave,
					name		= "groupEditor",
					novalidate	= "novalidate",
					class		= "form-vertical"
				)#

				<div class="modal-body">
					#html.hiddenField( name="permissionGroupID", value="" )#

					#html.textField(
						name			= "name",
						label			= "Permission Group:",
						required		= "required",
						maxlength		= "255",
						size			= "30",
						class			= "form-control",
						title			= "A unique group name",
						wrapper			= "div class=controls",
						labelClass 		= "control-label",
						groupWrapper 	= "div class=form-group"
					)#

					#html.textArea(
						name			= "description",
						label			= "Description:",
						cols			= "20",
						rows			= "3",
						class			= "form-control",
						title			= "A short group description",
						wrapper			= "div class=controls",
						labelClass	 	= "control-label",
						groupWrapper 	= "div class=form-group"
					)#
				</div>
				<!--- Footer --->
				<div class="modal-footer">
					#html.resetButton(
						name	= "btnReset",
						value	= "Cancel",
						class	= "btn btn-default",
						onclick	= "closeModal( $('##groupEditorContainer') )"
					)#

					#html.submitButton(
						name	= "btnSave",
						value	= "Save",
						class	= "btn btn-danger"
					)#
				</div>
				#html.endForm()#
				</div>
			</div>
		</div>
	</div>
</cfif>

<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view = "_tags/dialog/import",
		args = {
			title       = "Import Permission Groups",
			contentArea = "groups",
			action      = prc.xehImportAll,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> permission group's file to import."
		}
	)#
</cfif>
</cfoutput>