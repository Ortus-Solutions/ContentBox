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
			<i class="icon-ok icon-large textGreen"></i>
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
			<i class="icon-spinner icon-spin icon-large icon-2x"></i><br/>
			<div class="center"><small>Please Wait...</small></div>
		</div>
		
		<!--- Permissions --->
		<p>You can also add a-la-carte permissions to the user by adding from the selection below:</p>
		
		<div class="input-append">
			<!---Permission list --->
			<select name="permissionID" id="permissionID">
				<cfset noPerms = true>
				<cfloop array="#prc.permissions#" index="thisPerm">
					<cfif !prc.author.hasPermission( thisPerm ) AND !prc.author.getRole().hasPermission( thisPerm )>
						<cfset noperms = false>
						<option value="#thisPerm.getPermissionID()#">#thisPerm.getPermission()#</option>
					</cfif>
				</cfloop>
				<cfif noPerms>
					<option value="null">Role has all permissions</option>
				</cfif>
			</select>
			<cfif arrayLen( prc.permissions ) GT 0 AND !noPerms>
				<button class="btn btn-danger" onclick="addPermission();return false;">Add Permission</button>
			<cfelse>
				<button class="btn btn-danger" onclick="alert('No Permissions Found, Cannot Add!'); return false" disabled>Add Permission</button>
			</cfif>
		</div>
		
	#html.endFieldSet()#
	#html.endForm()#
	</cfif>
	
	<!--- Show/Remove Form--->
	#html.startForm(name="alacartePermissions")#
	#html.startFieldset(legend="Active A-la-carte Permissions")#
		<cfif !prc.author.hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently assigned a-la-carte permissions. You can optionally remove permissions by clicking on the remove button (<i class="icon-remove icon-large textRed"></i>).</p>
		</cfif>			
		
		<cfloop array="#prc.author.getPermissions()#" index="perm">
		<div>
			<!--- Assigned --->
			<i class="icon-ok icon-large textGreen"></i>
			<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
			<!--- Remove --->
			<a href="javascript:removePermission('#perm.getPermissionID()#')" onclick="return confirm('Are you sure?')" title="Remove Permission"><i class="icon-remove icon-large textRed"></i></a>
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