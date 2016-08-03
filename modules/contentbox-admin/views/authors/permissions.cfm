<!--- Container ID: remoteModelContent --->
<cfoutput>
<div>
	
	<!--- Show/Remove Form--->
	#html.startForm(name="permissionRolesForm",class="form-vertical" )#
	#html.startFieldset(legend="Active User Role Permissions" )#
		<cfif !prc.author.getRole().hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently inherited permissions from the user's role: <strong>#prc.author.getRole().getRole()#</strong>.
		</cfif>			
		
		<cfloop array="#prc.author.getRole().getPermissions()#" index="perm">
		<div>
			<!--- Assigned --->
			<i class="fa fa-check fa-lg textGreen"></i>
			<!--- Name --->
			&nbsp; 
			<strong>#perm.getPermission()#</strong>
		</div>
		</cfloop>		
		
	#html.endFieldSet()#
	#html.endForm()#

	<p>&nbsp;</p>
	
	<!--- Add Permission Form--->
	<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
	#html.startForm(name="permissionForm",class="form-vertical" )#
		#html.startFieldset(legend="Assign A-la-Carte Permissions" )#
			#html.hiddenField(name="authorID",bind=prc.author)#
			
			<!--- Loader --->
			<div class="loaders floatRight" id="permissionLoader">
				<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i><br/>
				<div class="text-center"><small>Please Wait...</small></div>
			</div>
			
			<!--- Permissions --->
			<p>You can also add a-la-carte permissions to the user by adding from the selection below:</p>
			<div class="form-group">
				<div class="input-group">
					<!---Permission list --->
					<select name="permissionID" id="permissionID" class="form-control input-sm">
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
					<span class="input-group-btn">
						<cfif arrayLen( prc.permissions ) GT 0 AND !noPerms>
							<button type="button" class="btn btn-sm btn-danger" onclick="addPermission();return false;">Add Permission</button>
						<cfelse>
							<button type="button" class="btn btn-sm btn-danger" onclick="alert('No Permissions Found, Cannot Add!'); return false" disabled>Add Permission</button>
			            </cfif>
		        	</span>
				</div>
			</div>
		#html.endFieldSet()#
	#html.endForm()#
	</cfif>

	<p>&nbsp;</p>
	
	<!--- Show/Remove Form--->
	#html.startForm( name="alacartePermissions", class="form-vertical" )#
	#html.startFieldset( legend="Active A-la-carte Permissions" )#
		<cfif !prc.author.hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently assigned a-la-carte permissions. You can optionally remove permissions by clicking on the remove button (<i class="fa fa-times fa-lg textRed"></i>).</p>
		</cfif>			
		
		<cfloop array="#prc.author.getPermissions()#" index="perm">
		<div>
			<!--- Assigned --->
			<i class="fa fa-check fa-lg textGreen"></i>
			<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
				<!--- Remove --->
				<a href="javascript:removePermission('#perm.getPermissionID()#')" onclick="return confirm('Are you sure?')" title="Remove Permission"><i class="fa fa-times fa-lg textRed"></i></a>
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