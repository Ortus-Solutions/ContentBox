<!--- Container ID: remoteModelContent --->
<cfoutput>
<div>
	
	<!--- Show/Remove Form--->
	#html.startForm(name="permissionRolesForm")#
	#html.startFieldset(legend="Active User Role Permissions")#
		<cfif !prc.author.getRole().hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently inherited permissions from the user's role: <strong>#prc.author.getRole().getRole()#</strong>.
		</cfif>			
		
		<cfloop array="#prc.author.getRole().getPermissions()#" index="perm">
		<div>
			<!--- Assigned --->
			<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="Assigned" title="#perm.getPermission()# Assigned"/>
			<!--- Name --->
			&nbsp; 
			<strong>#perm.getPermission()#</strong>
		</div>
		</cfloop>		
		
	#html.endFieldSet()#
	#html.endForm()#
	
	<!--- Add Permission Form--->
	<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
	#html.startForm(name="permissionForm")#
	#html.startFieldset(legend="Assign A-la-Carte Permissions")#
		#html.hiddenField(name="authorID",bind=prc.author)#
		
		<!--- Loader --->
		<div class="loaders floatRight" id="permissionLoader">
			<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/><br/>
			<div class="center"><small>Please Wait...</small></div>
		</div>
		
		<!--- Permissions --->
		<p>You can also add a-la-carte permissions to the user by adding from the selection below:</p>
		#html.select(name="permissionID",options=prc.permissions,column="permissionID",nameColumn="permission")#
		
		<!--- Button --->
		<cfif arrayLen(prc.permissions) GT 0>
			<button class="buttonred" onclick="addPermission();return false;">Add Permission</button>
		<cfelse>
			<button class="buttonred" onclick="alert('No Permissions Found, Cannot Add!'); return false">Add Permission</button>
		</cfif>
		
	#html.endFieldSet()#
	#html.endForm()#
	</cfif>
	
	<!--- Show/Remove Form--->
	#html.startForm(name="alacartePermissions")#
	#html.startFieldset(legend="Active A-la-carte Permissions")#
		<cfif !prc.author.hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently assigned a-la-carte permissions. You can optionally remove permissions by clicking on the remove button (<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="Assigned" title="Remove"/>).</p>
		</cfif>			
		
		<cfloop array="#prc.author.getPermissions()#" index="perm">
		<div>
			<!--- Assigned --->
			<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="Assigned" title="#perm.getPermission()# Assigned"/>
			<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
			<!--- Remove --->
			<a href="javascript:removePermission('#perm.getPermissionID()#')" onclick="return confirm('Are you sure?')" title="Remove Permission"><img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="Assigned" border="0"/></a>
			</cfif>
			<!--- Name --->
			&nbsp; 
			<strong>#perm.getPermission()#</strong>
		</div>
		</cfloop>
		
	#html.endFieldSet()#
	#html.endForm()#
	
</div>
</cfoutput>