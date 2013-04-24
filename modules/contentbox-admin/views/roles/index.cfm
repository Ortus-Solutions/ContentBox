<cfoutput>
<div class="row-fluid" id="main-content">   
    <div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-group"></i>
			Roles
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- RoleForm --->
			#html.startForm(name="roleForm",action=prc.xehRoleRemove)#
			#html.hiddenField(name="roleID",value="")#
			
			<!--- Content Bar --->
			<div class="well well-small">
				<!--- Command Bar --->
				<div class="pull-right">
					<a href="##" onclick="return createRole();" class="btn btn-danger">Create Role</a>
				</div>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="roleFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="roleFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- Info Bar --->
			<div class="alert">
				<i class="icon-warning-sign icon-large"></i>
				You cannot delete roles that have authors attached to them.  You will need to un-attach those authors from the role first.
			</div>			
			
			<!--- roles --->
			<table name="roles" id="roles" class="tablesorter table table-hover table-striped" width="98%">
				<thead>
					<tr>
						<th>Role</th>
						<th>Description</th>		
						<th width="95" class="center">Permissions</th>
						<th width="95" class="center">Authors</th>
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop array="#prc.roles#" index="role">
					<tr>
						<td>
							<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
							<a href="javascript:edit('#role.getRoleID()#','#jsstringFormat( role.getRole() )#','#jsstringFormat( role.getDescription() )#')" 
							   title="Edit #role.getRole()#">#role.getRole()#</a>
							<cfelse>
								#role.getRole()#
							</cfif>
						</td>
						<td>#role.getDescription()#</td>
						<td class="center"><span class="badge badge-info">#role.getNumberOfPermissions()#</span></td>
						<td class="center"><span class="badge badge-info">#role.getNumberOfAuthors()#</span></td>
						<td class="center">
							<!--- permissions --->
							<a href="javascript:openRemoteModal('#event.buildLink(prc.xehRolePermissions)#', {roleID: '#role.getRoleID()#'} );" 
							   title="Manage Permissions"><i class="icon-lock icon-large"></i></a>
							&nbsp;
							
							<!--- ROLES_ADMIN --->
							<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
								<!--- Edit Command --->
								<a href="javascript:edit('#role.getRoleID()#','#jsstringFormat( role.getRole() )#','#jsstringFormat( role.getDescription() )#')" 
								   title="Edit Role"><i class="icon-edit icon-large"></i></a>
								&nbsp;
								<!--- Delete Command --->
								<cfif role.getNumberOfAuthors() eq 0>
								<a title="Delete Role" href="javascript:remove('#role.getRoleID()#')" class="confirmIt" data-title="Delete Role?"><i class="icon-remove-sign icon-large" id="delete_#role.getRoleID()#"></i></a>
								</cfif>
							</cfif>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			#html.endForm()#
		</div>	
	</div>
</div>
<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
<!--- Role Editor --->
<div id="roleEditorContainer" class="modal hide fade">
	<div id="modalContent">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Role Editor</h3>
    </div>
	<!--- Create/Edit form --->
	#html.startForm(action=prc.xehRoleSave,name="roleEditor",novalidate="novalidate")#
	<div class="modal-body">
		#html.hiddenField(name="roleID",value="")#
		#html.textField(name="role",label="Role:",required="required",maxlength="255",size="30",class="input-block-level",title="A unique role name")#
		#html.textArea(name="description",label="Description:",cols="20",rows="3",class="input-block-level",title="A short role description")#
	</div>
	<!--- Footer --->
	<div class="modal-footer">
		#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##roleEditorContainer') )")#
		#html.submitButton(name="btnSave",value="Save",class="btn btn-danger")#
	</div>
	#html.endForm()#
	</div>
</div>
</cfif>
</cfoutput>