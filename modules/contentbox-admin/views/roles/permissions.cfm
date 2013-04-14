<!--- Container ID: remoteModelContent --->
<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Permissions Manager for '#prc.role.getRole()#'</h3>
</div>
<div class="modal-body">
	<!--- Add Permission Form--->
	#html.startForm(name="permissionForm")#
	#html.startFieldset(legend="Available Permissions")#
		
		<!--- Loader --->
		<div class="loaders floatRight" id="permissionLoader">
			<i class="icon-spinner icon-spin icon-large icon-2x"></i><br/>
			<div class="center"><small>Please Wait...</small></div>
		</div>
		
		<!--- Permissions --->
		<p>Choose a permission to add:</p>
		<div class="btn-group">
			#html.select(name="permissionID",options=prc.permissions,column="permissionID",nameColumn="permission")#
			<!--- Button --->
			<button class="btn btn-danger btn-small" onclick="addPermission();return false;">Add Permission</button>
		</div>
		
	#html.endFieldSet()#
	#html.endForm()#
	
	
	<!--- Show/Remove Form--->
	#html.startForm(name="permissionRemoveForm")#
	#html.startFieldset(legend="Active Role Permissions")#
		<cfif !prc.role.hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently assigned permissions. You can optionally remove permissions by clicking on the remove button (<i class="icon-remove icon-large textRed"></i>).</p>
		</cfif>			
	
		
		<cfloop array="#prc.role.getPermissions()#" index="perm">
		<div>
			<!--- Remove --->
			<a href="javascript:removePermission('#perm.getPermissionID()#')" onclick="return confirm('Are you sure?')" title="Remove Permission"><i class="icon-remove icon-large textRed"></i></a>
			<!--- Name --->
			&nbsp; 
			<strong>#perm.getPermission()#</strong>
		</div>
		</cfloop>
		
		
	#html.endFieldSet()#
	#html.endForm()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>