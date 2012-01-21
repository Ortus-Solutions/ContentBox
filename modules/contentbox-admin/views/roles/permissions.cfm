<!--- Container ID: remoteModelContent --->
<cfoutput>
<h2>Permissions Manager for '#prc.role.getRole()#'</h2>
<div>
	<!--- Add Permission Form--->
	#html.startForm(name="permissionForm")#
	#html.startFieldset(legend="Available Permissions")#
		
		<!--- Loader --->
		<div class="loaders floatRight" id="permissionLoader">
			<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/><br/>
			<div class="center"><small>Please Wait...</small></div>
		</div>
		
		<!--- Permissions --->
		<p>Choose a permission to add:</p>
		#html.select(name="permissionID",options=prc.permissions,column="permissionID",nameColumn="permission")#
		
		<!--- Button --->
		<button class="buttonred" onclick="addPermission();return false;">Add Permission</button>
		
	#html.endFieldSet()#
	#html.endForm()#
	
	
	<!--- Show/Remove Form--->
	#html.startForm(name="permissionRemoveForm")#
	#html.startFieldset(legend="Active Role Permissions")#
		<cfif !prc.role.hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently assigned permissions. You can optionally remove permissions by clicking on the remove button (<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="Assigned" title="Remove"/>).</p>
		</cfif>			
	
		
		<cfloop array="#prc.role.getPermissions()#" index="perm">
		<div>
			<!--- Assigned --->
			<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="Assigned" title="#perm.getPermission()# Assigned"/>
			<!--- Remove --->
			<a href="javascript:removePermission('#perm.getPermissionID()#')" onclick="return confirm('Are you sure?')" title="Remove Permission"><img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="Assigned" border="0"/></a>
			<!--- Name --->
			&nbsp; 
			<strong>#perm.getPermission()#</strong>
		</div>
		</cfloop>
		
		
	#html.endFieldSet()#
	#html.endForm()#
	
	
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>