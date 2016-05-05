<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-group fa-lg"></i> Roles
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
            name="roleForm", 
            action=prc.xehRoleRemove, 
            class="form-vertical"
        )#
        	#html.hiddenField(name="roleID",value="" )#
        	<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">
						<div class="col-md-6">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name="roleFilter",
									class="form-control",
									placeholder="Quick Search"
								)#
							</div>
						</div>
						<div class="col-md-6">
							<div class="pull-right">
								<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
								<div class="pull-right">
									<!---Global --->
									<div class="btn-group btn-group-sm">
								    	<a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##">
											Bulk Actions <span class="caret"></span>
										</a>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT" )>
								    		<li><a href="javascript:importContent()"><i class="fa fa-upload"></i> Import</a></li>
											</cfif>
											<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>
												<li><a href="#event.buildLink (linkto=prc.xehExportAll )#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON</a></li>
												<li><a href="#event.buildLink( linkto=prc.xehExportAll )#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML</a></li>
											</cfif>
								    	</ul>
								    </div>
									<button onclick="return createRole();" class="btn btn-sm btn-primary">Create Role</button>
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
						You cannot delete roles that have authors attached to them.  You will need to un-attach those authors from the role first.
					</div>
					<!--- roles --->
					<table name="roles" id="roles" class="table table-striped table-hover table-condensed" width="98%">
						<thead>
							<tr>
								<th>Role</th>
								<th>Description</th>		
								<th width="95" class="text-center">Permissions</th>
								<th width="95" class="text-center">Authors</th>
								<th width="100" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>				
						<tbody>
							<cfloop array="#prc.roles#" index="role">
							<tr>
								<td>
									<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN" )>
									<a href="javascript:edit('#role.getRoleID()#',
									   					 '#HTMLEditFormat( jsstringFormat( role.getRole() ) )#',
									   					 '#HTMLEditFormat( jsstringFormat( role.getDescription() ) )#')" 
									   title="Edit #role.getRole()#">#role.getRole()#</a>
									<cfelse>
										#role.getRole()#
									</cfif>
								</td>
								<td>#role.getDescription()#</td>
								<td class="text-center"><span class="badge badge-info">#role.getNumberOfPermissions()#</span></td>
								<td class="text-center"><span class="badge badge-info">#role.getNumberOfAuthors()#</span></td>
								<td class="text-center">
									<!--- Actions --->

									<!--- permissions --->
									<a class="btn btn-sm btn-primary" href="javascript:openRemoteModal('#event.buildLink(prc.xehRolePermissions)#', {roleID: '#role.getRoleID()#'} );" title="Manage Permissions"><i class="fa fa-lock fa-lg"></i></a>
									<!--- Actions --->	
									<div class="btn-group">
								    	<a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
											<i class="fa fa-cogs fa-lg"></i>
										</a>
								    	<ul class="dropdown-menu text-left pull-right">
											<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>
												<!--- Delete Command --->
												<cfif role.getNumberOfAuthors() eq 0>
												<li><a href="javascript:remove('#role.getRoleID()#')" class="confirmIt" data-title="<i class='fa fa-trash-o'></i> Delete Role?"><i class="fa fa-trash-o fa-lg" id="delete_#role.getRoleID()#"></i> Delete</a></li>
												</cfif>
												<!--- Edit Command --->
												<li><a href="javascript:edit('#role.getRoleID()#',
											   					 '#HTMLEditFormat( jsstringFormat( role.getRole() ) )#',
											   					 '#HTMLEditFormat( jsstringFormat( role.getDescription() ) )#')"><i class="fa fa-edit fa-lg"></i> Edit</a></li>
											
												<!--- Export --->
												<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN,TOOLS_EXPORT" )>
													<li><a href="#event.buildLink(linkto=prc.xehExport)#/roleID/#role.getRoleID()#.json" target="_blank"><i class="fa fa-download"></i> Export as JSON</a></li>
													<li><a href="#event.buildLink(linkto=prc.xehExport)#/roleID/#role.getRoleID()#.xml" target="_blank"><i class="fa fa-download"></i> Export as XML</a></li>
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
<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN" )>
	<!--- Role Editor --->
	<div id="roleEditorContainer" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document" >
			<div class="modal-content">
		
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4><i class="fa fa-group"></i> Role Editor</h4>
			    </div>
				<!--- Create/Edit form --->
				#html.startForm(
					action=prc.xehRoleSave,
					name="roleEditor",
					novalidate="novalidate",
					class="form-vertical"
				)#
				<div class="modal-body">
					#html.hiddenField(name="roleID",value="" )#
					#html.textField(
						name="role",
						label="Role:",
						required="required",
						maxlength="255",
						size="30",
						class="form-control",
						title="A unique role name",
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
						title="A short role description",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#
				</div>
				<!--- Footer --->
				<div class="modal-footer">
					#html.resetButton(
						name="btnReset",
						value="Cancel",
						class="btn", 
						onclick="closeModal( $('##roleEditorContainer') )"
					)#
					#html.submitButton(
						name="btnSave",
						value="Save",
						class="btn btn-danger"
					)#
				</div>
				#html.endForm()#
				</div>
			</div>
		</div>
	</div>
</cfif>
<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
	<cfscript>
		dialogArgs = {
			title = "Import Roles",
			contentArea = "roles",
			action = prc.xehImportAll,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> roles file to import."
		};
	</cfscript>
	#renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfif>
</cfoutput>