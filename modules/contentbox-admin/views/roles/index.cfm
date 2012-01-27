<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
		<div class="header">
			<img src="#prc.cbroot#/includes/images/entry.png" alt="info" width="24" height="24" />Editor
		</div>
		<div class="body">
			<!--- Create/Edit form --->
			#html.startForm(action=prc.xehRoleSave,name="roleEditor",novalidate="novalidate")#
				#html.hiddenField(name="roleID",value="")#
				#html.textField(name="role",label="Role:",required="required",maxlength="255",size="30",class="textfield",title="A unique role name")#
				#html.textArea(name="description",label="Description:",cols="20",rows="3",class="textarea",title="A short role description")#
				<div class="actionBar">
					#html.resetButton(name="btnReset",value="Reset Form",class="button")#
					#html.submitButton(value="Save Role",class="buttonred")#
				</div>
			#html.endForm()#
		</div>
		</cfif>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/roles.png" alt="roles" width="30" height="30" />
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
			<div class="contentBar">
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="roleFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="roleFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- Info Bar --->
			<div class="infoBar">
				<img src="#prc.cbRoot#/includes/images/info.png" alt="info"/>
				You cannot delete roles that have authors attached to them.  You will need to un-attach those authors from the role first.
			</div>			
			
			<!--- roles --->
			<table name="roles" id="roles" class="tablesorter" width="98%">
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
						<td class="center">#role.getNumberOfPermissions()#</td>
						<td class="center">#role.getNumberOfAuthors()#</td>
						<td class="center">
							<!--- permissions --->
							<a href="javascript:openRemoteModal('#event.buildLink(prc.xehRolePermissions)#', {roleID: '#role.getRoleID()#'} );" 
							   title="Manage Permissions"><img src="#prc.cbroot#/includes/images/lock.png" alt="edit" border="0" /></a>
							&nbsp;
							
							<!--- ROLES_ADMIN --->
							<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
								<!--- Edit Command --->
								<a href="javascript:edit('#role.getRoleID()#','#jsstringFormat( role.getRole() )#','#jsstringFormat( role.getDescription() )#')" 
								   title="Edit Role"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" border="0" /></a>
								&nbsp;
								<!--- Delete Command --->
								<cfif role.getNumberOfAuthors() eq 0>
								<a title="Delete Role" href="javascript:remove('#role.getRoleID()#')" class="confirmIt" data-title="Delete Role?"><img id="delete_#role.getRoleID()#" src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
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
</cfoutput>