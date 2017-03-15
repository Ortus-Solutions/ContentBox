<!--- Container ID: remoteModelContent --->
<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		    <h4><i class="fa fa-lock"></i> Permissions Manager for '#prc.role.getRole()#'</h4>
		</div>
		<div class="modal-body">
			<!--- Add Permission Form--->
			#html.startForm( name="permissionForm" )#
				#html.startFieldset( legend="Available Permissions" )#
					<!--- Loader --->
					<div class="loaders floatRight" id="permissionLoader">
						<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i><br/>
						<div class="text-center"><small>Please Wait...</small></div>
					</div>
					
					<!--- Permissions --->
					<p>Choose a permission to add:</p>
					<div class="btn-group">
						<div class="form-group">
							<div class="controls">
								<!---Permission list --->
								<select name="permissionID" id="permissionID" class="form-control input-sm">
									<cfset noPerms = true>
									<cfloop array="#prc.permissions#" index="thisPerm">
										<cfif !prc.role.hasPermission( thisPerm )>
											<cfset noperms = false>
											<option value="#thisPerm.getPermissionID()#">#thisPerm.getPermission()#</option>
										</cfif>
									</cfloop>
									<cfif noPerms>
										<option value="null">Role has all permissions</option>
									</cfif>
								</select>
							</div>
						</div>
						<!--- Button --->
						<button class="btn btn-danger btn-small" onclick="addPermission();return false;" <cfif noPerms>disabled="disabled"</cfif>>Add Permission</button>
					</div>
					
				#html.endFieldSet()#
			#html.endForm()#
			
			
			<!--- Show/Remove Form--->
			#html.startForm( name="permissionRemoveForm" )#
				#html.startFieldset( legend="Active Role Permissions" )#
					<cfif !prc.role.hasPermission()>
						<small>No permissions assigned!</small>
					<cfelse>
						<p>Below are the currently assigned permissions. You can optionally remove permissions by clicking on the remove button (<i class="fa fa-minus-circle fa-lg textRed"></i>).</p>
					</cfif>			
				
					
					<cfloop array="#prc.role.getPermissions()#" index="perm">
					<div>
						<!--- Remove --->
						<a href="javascript:removePermission('#perm.getPermissionID()#')" onclick="return confirm('Are you sure?')" title="Remove Permission"><i class="fa fa-times fa-lg textRed"></i></a>
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
	</div>
</div>
</cfoutput>