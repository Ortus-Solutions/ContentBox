<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
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

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Info Box --->
		<div class="small_box">
			<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
			<div class="header">
				<i class="icon-edit"></i> Editor
			</div>
			<div class="body">
				<!--- Create/Edit form --->
				#html.startForm(action=prc.xehPermissionSave,name="permissionEditor",novalidate="novalidate")#
					#html.hiddenField(name="permissionID",value="")#
					#html.textField(name="permission",label="Permission:",required="required",maxlength="255",size="30",class="input-block-level",title="The unique permission name")#
					#html.textArea(name="description",label="Description:",cols="20",rows="3",class="input-block-level",required="required",title="A short permission description")#
					#html.resetButton(name="btnReset",value="Reset Form",class="btn")#
					#html.submitButton(value="Save Permission",class="btn btn-danger")#
				#html.endForm()#
			</div>
			</cfif>
		</div>	
	</div>
</div>
</cfoutput>