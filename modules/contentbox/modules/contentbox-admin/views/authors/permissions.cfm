<!--- Container ID: remoteModelContent --->
<cfoutput>
<div>

	<!--- Show/Remove Roles Form--->
	#html.startForm( name="permissionRolesForm", class="form-vertical" )#
	#html.startFieldset( legend="Role Permissions" )#
		<cfif !prc.author.getRole().hasPermission()>
			<small>No permissions assigned!</small>
		<cfelse>
			<p>Below are the currently inherited permissions from the user's role: <span class="label label-info">#prc.author.getRole().getRole()#</span>.
		</cfif>

		<div class="well well-sm">
			<cfloop array="#prc.author.getRole().getPermissions()#" index="perm">
			<div>
				<!--- Assigned --->
				<i class="far fa-dot-circle fa-lg text-green"></i>
				<!--- Name --->
				&nbsp;
				<strong>#perm.getPermission()#</strong>
			</div>
			</cfloop>
		</div>

	#html.endFieldSet()#
	#html.endForm()#

	<!--- Add Permission Groups Form--->
	#html.startForm( name="groupsForm", class="form-vertical" )#
	#html.startFieldset( legend="Permission Groups" )#
	<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
			#html.hiddenField( name="authorID", bind=prc.author )#

			<!--- Loader --->
			<div class="loaders float-right text-center" id="groupsLoader">
				<i class="fas fa-circle-notch fa-spin fa-lg"></i><br/>
				<div class="text-center"><small>Please Wait...</small></div>
			</div>

			<!--- Permissions --->
			<p>You can assign permission groups to this user:</p>
			<div class="row">
					<div class="col-md-8 mb5">
						<!---Permission Groups List --->
						<select name="permissionGroupID" id="permissionGroupID" class="form-control input-sm">
							<cfset noGroups = true>

							<cfloop array="#prc.aPermissionGroups#" index="thisGroup">
								<cfif !prc.author.hasPermissionGroup( thisGroup )>
									<cfset noGroups = false>
									<option value="#thisGroup.getPermissionGroupID()#">#thisGroup.getName()#</option>
								</cfif>
							</cfloop>

							<cfif noGroups>
								<option value="null">User has all permission groups assigned</option>
							</cfif>
						</select>
					</div>

					<div class="col-md-4">
						<cfif arrayLen( prc.aPermissionGroups ) GT 0 AND !noGroups>
							<button
								type="button"
								class="btn btn-primary btn-block p11"
								onclick="addPermissionGroup();return false;"
							>
								Add Group
							</button>
						<cfelse>
							<button
								type="button"
								class="btn btn-primary btn-block p11"
								onclick="alert( 'No Permission Groups Found, Cannot Add!' ); return false"
								disabled
							>
								Add Group
							</button>
			            </cfif>
		        	</div>
			</div>
	</cfif>
	#html.endFieldSet()#
	#html.endForm()#

	<!--- Show/Remove Permissions Groups Form--->
	#html.startForm( name="alacartePermissionGroups", class="form-vertical" )#
		<cfif !prc.author.hasPermissionGroup()>
			<div class="alert alert-info">No permission groups assigned!</div>
		<cfelse>
			<p>Below are the currently assigned a-la-carte permission groups. You can optionally remove permission groups by clicking on the remove button (<i class="far fa-dot-circle fa-lg text-red"></i>).</p>
		</cfif>

		<cfloop array="#prc.author.getPermissionGroups()#" index="group">
			<div class="mt20">
				<!--- Remove --->
				<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
					<a 	href="javascript:removePermissionGroup( '#group.getPermissionGroupID()#' )"
						onclick="return confirm( 'Are you sure?' )"
						title="Remove Permission Group"
					>
						<i class="far fa-dot-circle fa-lg text-red"></i>
					</a>
				</cfif>

				<!--- Name --->
				<strong>#group.getName()#</strong>

				<!--- Permissions --->
				<div class="well well-sm m10 rounded">
					<cfloop array="#group.getPermissions()#" index="perm">
						<div>
							<!--- Assigned --->
							<i class="far fa-dot-circle fa-lg text-green"></i>
							<!--- Name --->
							<strong>#perm.getPermission()#</strong>
						</div>
					</cfloop>
				</div>
			</div>
		</cfloop>

	#html.endForm()#


	<p>&nbsp;</p>

	<!--- Add Permission Form--->
	#html.startForm( name="permissionForm", class="form-vertical" )#
	#html.startFieldset( legend="A-la-Carte Permissions" )#
	<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
			#html.hiddenField( name="authorID", bind=prc.author )#

			<!--- Loader --->
			<div class="loaders float-right text-center" id="permissionLoader">
				<i class="fas fa-circle-notch fa-spin fa-lg"></i><br/>
				<div class="text-center"><small>Please Wait...</small></div>
			</div>

			<!--- Permissions --->
			<p>You can also add a-la-carte permissions to the user by adding from the selection below:</p>
			<div class="row">

				<div class="col-md-8 mb5">
					<!---Permission list --->
					<select name="permissionID" id="permissionID" class="form-control input-sm">
						<cfset noPerms = true>

						<cfloop array="#prc.aPermissions#" index="thisPerm">
							<cfif !prc.author.checkPermission( thisPerm.getPermission() )>
								<cfset noperms = false>
								<option value="#thisPerm.getPermissionID()#">#thisPerm.getPermission()#</option>
							</cfif>
						</cfloop>

						<cfif noPerms>
							<option value="null">Role has all permissions</option>
						</cfif>
					</select>
				</div>

				<div class="col-md-4">
					<cfif arrayLen( prc.aPermissions ) GT 0 AND !noPerms>
						<button
							type="button"
							class="btn btn-primary btn-block p11"
							onclick="addPermission();return false;"
						>
							Add Permission
						</button>
					<cfelse>
						<button
							type="button"
							class="btn btn-primary btn-block p11"
							onclick="alert( 'No Permissions Found, Cannot Add!' ); return false"
							disabled
						>
							Add Permission
						</button>
					</cfif>
				</div>

			</div>
			</div>
	</cfif>
	#html.endFieldSet()#
	#html.endForm()#

	<!--- Show/Remove Form--->
	#html.startForm( name="alacartePermissions", class="form-vertical" )#
		<cfif !prc.author.hasPermission()>
			<div class="alert alert-info">No permissions assigned!</div>
		<cfelse>
			<p>Below are the currently assigned a-la-carte permissions. You can optionally remove permissions by clicking on the remove button (<i class="far fa-dot-circle fa-lg text-red"></i>).</p>
		</cfif>

		<cfloop array="#prc.author.getPermissions()#" index="perm">
		<div>
			<!--- Assigned --->
			<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
				<!--- Remove --->
				<a href="javascript:removePermission('#perm.getPermissionID()#')" onclick="return confirm('Are you sure?')" title="Remove Permission"><i class="far fa-dot-circle fa-lg text-red"></i></a>
			</cfif>
			<!--- Name --->
			<strong>#perm.getPermission()#</strong>
		</div>
		</cfloop>

	#html.endForm()#

</div>
</cfoutput>
