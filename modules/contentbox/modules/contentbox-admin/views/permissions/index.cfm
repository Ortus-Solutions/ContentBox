<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-lock fa-lg"></i>
			Permissions
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
            name="permissionForm", 
            action=prc.xehPermissionRemove, 
            class="form-vertical"
        )#
        	#html.hiddenField(name="permissionID",value="" )#
        	<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">
						<div class="col-md-6">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name="permissionFilter",
									class="form-control",
									placeholder="Quick Search"
								)#
							</div>
						</div>
						<div class="col-md-6">
							<div class="pull-right">
								<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group btn-group-sm">
								    	<a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##">
											Bulk Actions <span class="caret"></span>
										</a>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
								    		<li><a href="javascript:importContent()"><i class="fa fa-upload"></i> Import</a></li>
											</cfif>
											<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_EXPORT" )>
												<li><a href="#event.buildLink (linkto=prc.xehExportAll )#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON</a></li>
												<li><a href="#event.buildLink( linkto=prc.xehExportAll )#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML</a></li>
											</cfif>
								    	</ul>
								    </div>
									<button onclick="return createPermission();" class="btn btn-sm btn-primary">Create Permission</button>
								</cfif>
							</div>
						</div>
					</div>
				</div>
				<div class="panel-body">
					<!--- permissions --->
					<table name="permissions" id="permissions" class="table table-striped table-hover table-condensed" width="100%">
						<thead>
							<tr>
								<th>Permission</th>
								<th>Description</th>
								<th class="text-center">Roles Assigned</th>		
								<th width="100" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>				
						<tbody>
							<cfloop array="#prc.permissions#" index="permission">
							<tr>
								<td>
									<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<a href="javascript:edit('#permission.getPermissionID()#',
									   						 '#HTMLEditFormat( jsstringFormat(permission.getPermission()) )#',
									   						 '#HTMLEditFormat( jsstringFormat(permission.getDescription()) )#')" 
									   title="Edit #permission.getPermission()#">#permission.getPermission()#</a>
									<cfelse>
										#permission.getPermission()#
									</cfif>
								</td>
								<td>#permission.getDescription()#</td>
								<td class="text-center">
									<span class="badge badge-info">#permission.getNumberOfRoles()#</span>
								</td>
								<td class="text-center">
									<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
										<!--- Edit Command --->
										<a class="btn btn-sm btn-primary" href="javascript:edit('#permission.getPermissionID()#',
										   						 '#HTMLEditFormat( jsstringFormat(permission.getPermission()) )#',
										   						 '#HTMLEditFormat( jsstringFormat(permission.getDescription()) )#');" 
										   title="Edit #permission.getPermission()#">
										   	<i class="fa fa-edit fa-lg"></i>
										</a>
										<!--- Delete Command --->
										<a class="btn btn-sm btn-danger confirmIt" title="Delete Permission" href="javascript:remove('#permission.getPermissionID()#');" data-title="Delete Permission?">
											<i id="delete_#permission.getPermissionID()#" class="fa fa-trash-o fa-lg"></i>
										</a>
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
<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
	<!--- Permissions Editor --->
	<div id="permissionEditorContainer" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog">
		    <div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4><i class="fa fa-lock"></i> Permission Editor</h4>
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
						name="btnReset",
						value="Cancel",
						class="btn", 
						onclick="closeModal( $('##permissionEditorContainer') )"
					)#
					#html.submitButton( name="btnSave",value="Save",class="btn btn-danger" )#
				</div>
				#html.endForm()#
			</div>
		</div>
	</div>
</cfif>
<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
	<cfscript>
		dialogArgs = {
			title = "Import Permissions",
			contentArea = "permissions",
			action = prc.xehImportAll,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> permissions file to import."
		};
	</cfscript>
	#renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfif>
</cfoutput>
