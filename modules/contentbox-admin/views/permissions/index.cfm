<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
		<div class="header">
			<img src="#prc.cbroot#/includes/images/entry.png" alt="info" width="24" height="24" />Editor
		</div>
		<div class="body">
			<!--- Create/Edit form --->
			#html.startForm(action=prc.xehPermissionSave,name="permissionEditor",novalidate="novalidate")#
				#html.hiddenField(name="permissionID",value="")#
				#html.textField(name="permission",label="Permission:",required="required",maxlength="255",size="30",class="textfield",title="The unique permission name")#
				#html.textArea(name="description",label="Description:",cols="20",rows="3",class="textarea",required="required",title="A short permission description")#
				<div class="actionBar">
					#html.resetButton(name="btnReset",value="Reset Form",class="button")#
					#html.submitButton(value="Save Permission",class="buttonred")#
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
			<img src="#prc.cbroot#/includes/images/permissions.png" alt="permissions" width="30" height="30" />
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
			<div class="contentBar">
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="permissionFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="permissionFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- permissions --->
			<table name="permissions" id="categoryFilter" class="tablesorter" width="98%">
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
							   title="Edit #permission.getPermission()#"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" border="0" /></a>
							<!--- Delete Command --->
							<a title="Delete Permission" href="javascript:remove('#permission.getPermissionID()#')" class="confirmIt" data-title="Delete Permission?"><img id="delete_#permission.getPermissionID()#" src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
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