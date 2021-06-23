<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fas fa-key fa-lg"></i>
			Permissions (#arrayLen( prc.permissions )#)
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
            name	= "permissionForm",
            action	= prc.xehPermissionRemove,
            class	= "form-vertical"
        )#

        	#html.hiddenField( name="permissionID", value="" )#

        	<div class="panel panel-default">

				<div class="panel-heading">
					<div class="row">

						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name		= "permissionFilter",
									class		= "form-control rounded quicksearch",
									placeholder	= "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6 col-xs-8">
							<div class="text-right">
								<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group">
								    	<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
								    			<li>
													<a href="javascript:importContent()">
														<i class="fas fa-file-import fa-lg"></i> Import
													</a>
												</li>
											</cfif>
											<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink( prc.xehExportAll )#.json" target="_blank">
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
										onclick="return createPermission();"
										class="btn btn-primary">
										Create Permission
									</button>
								</cfif>
							</div>
						</div>
					</div>
				</div>

				<div class="panel-body">
					<!--- permissions --->
					<table name="permissions" id="permissions" class="table table-striped-removed table-hover " width="100%">
						<thead>
							<tr>
								<th id="checkboxHolder" class="{sorter:false} text-center" width="15">
									<input type="checkbox" onClick="checkAll( this.checked, 'permissionID' )"/>
								</th>
								<th>Permission</th>
								<th class="text-center">Roles Assigned</th>
								<th class="text-center">Groups Assigned</th>
								<th width="100" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#prc.permissions#" index="permission">
							<tr>
								<!--- check box --->
								<td class="text-center">
									<input
										type="checkbox"
										name="permissionID"
										id="permissionID"
										value="#permission.getpermissionID()#" />
								</td>
								<td>
									<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<a href="javascript:edit(
										'#permission.getPermissionID()#',
										'#HTMLEditFormat( jsstringFormat(permission.getPermission()) )#',
										'#HTMLEditFormat( jsstringFormat(permission.getDescription()) )#'
										)"
									   title="Edit #permission.getPermission()#">#permission.getPermission()#</a>
									<cfelse>
										#permission.getPermission()#
									</cfif>

									<div class="mt5 text-muted">
										#permission.getDescription()#
									</div>
								</td>

								<td class="text-center">
									<span class="badge badge-info">#permission.getNumberOfRoles()#</span>
								</td>

								<td class="text-center">
									<span class="badge badge-info">#permission.getNumberOfGroups()#</span>
								</td>

								<td class="text-center">
									<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
										<div class="btn-group">
											<a
												class="btn btn-sm btn-default btn-more dropdown-toggle"
												data-toggle="dropdown"
												href="##"
												title="Actions">
												<i class="fas fa-ellipsis-v fa-lg"></i>
											</a>
									    	<ul class="dropdown-menu text-left pull-right">
									    		<!--- Edit Command --->
												<li>
													<a
														class=""
														href="javascript:edit(
															'#permission.getPermissionID()#',
															'#HTMLEditFormat( jsstringFormat(permission.getPermission()) )#',
															'#HTMLEditFormat( jsstringFormat(permission.getDescription()) )#'
															)"
														title="Edit #permission.getPermission()#">
														<i class="fas fa-pen fa-lg"></i> Edit
													</a>
												</li>
												<cfif prc.oCurrentAuthor.checkPermission( "TOOLS_EXPORT" )>
													<li>
														<a
															href="#event.buildLink( prc.xehExport )#/permissionID/#permission.getPermissionID()#.json"
															target="_blank">
															<i class="fas fa-file-export fa-lg"></i> Export
														</a>
													</li>
												</cfif>
												<!--- Delete Command --->
												<li>
													<a
														class="confirmIt"
														title="Delete Permission"
														href="javascript:remove( '#permission.getPermissionID()#' );"
														data-title="Delete Permission?">
														<i id="delete_#permission.getPermissionID()#" class="far fa-trash-alt fa-lg"></i> Delete
													</a>
												</li>
									    	</ul>
										</div>
									</cfif>
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
	<!--- Permissions Editor --->
	<div id="permissionEditorContainer" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog">
		    <div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4><i class="fas fa-key"></i> Permission Editor</h4>
				</div>
				<!--- Create/Edit form --->
				#html.startForm(
					action=prc.xehPermissionSave,
					name="permissionEditor",
					novalidate="novalidate",
					class="form-vertical"
				)#
				<div class="modal-body">
					#html.hiddenField(name="permissionID",value="" )#
					#html.textField(
						name="permission",
						label="Permission:",
						required="required",
						maxlength="255",
						size="30",
						class="form-control",
						title="The unique permission name",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#
					#html.textArea(
						name="description",
						label="Description:",
						cols="20",
						rows="3",
						class="form-control",
						required="required",
						title="A short permission description",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#
				</div>
				<!--- Footer --->
				<div class="modal-footer">
					#html.resetButton(
						name     = "btnReset",
						value    = "Cancel",
						class    = "btn btn-default",
						onclick  = "closeModal( $('##permissionEditorContainer') )"
					)#
					#html.submitButton( name="btnSave",value="Save",class="btn btn-primary" )#
				</div>
				#html.endForm()#
			</div>
		</div>
	</div>
</cfif>
<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view 		= "_tags/dialog/import",
		args 		= {
			title       : "Import Permissions",
			contentArea : "permissions",
			action      : prc.xehImportAll,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> permissions file to import."
		},
		prePostExempt = true
	)#
</cfif>
</cfoutput>
