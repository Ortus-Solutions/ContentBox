<cfoutput>
<div class="row-fluid" id="main-content">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-lock icon-large"></i>
			Permissions
		</div>
		
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- PermissionForm --->
			#html.startForm(name="permissionForm",action=prc.xehPermissionRemove)#
			#html.hiddenField(name="permissionID",value="")#
			
			<!--- Content Bar --->
			<div class="well well-small">
				<!--- Command Bar --->
				<div class="pull-right">
					<a href="##" onclick="return createPermission();" class="btn btn-danger">Create Permission</a>
				</div>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="permissionFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="permissionFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- permissions --->
			<table name="permissions" id="permissions" class="tablesorter table table-hover table-striped" width="98%">
				<thead>
					<tr>
						<th>Permission</th>
						<th>Description</th>		
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop array="#prc.permissions#" index="permission">
					<tr>
						<td><a href="javascript:edit('#permission.getPermissionID()#','#jsstringFormat(permission.getPermission())#','#jsstringFormat(permission.getDescription())#')" 
							   title="Edit #permission.getPermission()#">#permission.getPermission()#</a></td>
						<td>#permission.getDescription()#</td>
						<td class="center">
							<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
							<!--- Edit Command --->
							<a href="javascript:edit('#permission.getPermissionID()#','#jsstringFormat( permission.getPermission() )#','#jsstringFormat( permission.getDescription() )#')" 
							   title="Edit #permission.getPermission()#"><i class="icon-edit icon-large"></i></a>
							<!--- Delete Command --->
							<a title="Delete Permission" href="javascript:remove('#permission.getPermissionID()#')" class="confirmIt" data-title="Delete Permission?"><i id="delete_#permission.getPermissionID()#" class="icon-remove-sign icon-large"></i></a>
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
<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
<!--- Permissions Editor --->
<div id="permissionEditorContainer" class="modal hide fade">
	<div id="modalContent">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Permission Editor</h3>
    </div>
	<!--- Create/Edit form --->
	<div class="modal-body">
		#html.startForm(action=prc.xehPermissionSave,name="permissionEditor",novalidate="novalidate")#
			#html.hiddenField(name="permissionID",value="")#
			#html.textField(name="permission",label="Permission:",required="required",maxlength="255",size="30",class="input-block-level",title="The unique permission name")#
			#html.textArea(name="description",label="Description:",cols="20",rows="3",class="input-block-level",required="required",title="A short permission description")#
		#html.endForm()#
	</div>
	<!--- Footer --->
	<div class="modal-footer">
		#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##permissionEditorContainer') )")#
		#html.submitButton(name="btnSave",value="Save",class="btn btn-danger")#
	</div>
	</div>
</div>
</cfif>
</cfoutput>