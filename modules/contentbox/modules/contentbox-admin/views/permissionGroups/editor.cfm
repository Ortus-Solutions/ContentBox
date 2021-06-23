<cfoutput>
	<div class="row">
		<div class="col-md-12" id="main-content-slot">

			<div class="panel panel-default">

				<!--- Heading --->
				<div class="panel-heading">
					<!--- Top Actions --->
					<div class="float-right mt10">
						<!--- Back button --->
						<a
							class="btn btn-sm btn-default"
							href="#event.buildLink( prc.xehPermissionGroups )#"
							title="Back to listing"
						>
							<i class="fas fa-chevron-left"></i> Cancel
						</a>
					</div>

					<!--- Panel Title --->
					<div class="size16 p10">
						<i class="fas fa-users"></i>
						<cfif prc.oGroup.isLoaded()>
							Update
						<cfelse>
							Create
						</cfif>
						Permission Group
					</div>
				</div>

				<!--- Panel Body --->
				<div class="panel-body">

					<!--- Messageboxes --->
					#cbMessageBox().renderit()#

					<!--- groupForm --->
					#html.startForm(
						name 		= "groupForm",
						action 		= prc.xehGroupSave,
						novalidate 	= "novalidate",
						class 		= "form-vertical"
					)#

						<!--- Group Info --->
						#html.hiddenField( name="permissionGroupId", bind=prc.oGroup )#

						#html.textField(
							name    		= "name",
							bind    		= prc.oGroup,
							label   		= "*Group Name:",
							required		= "required",
							size    		= "255",
							class   		= "form-control",
							title 			= "The human readable name",
							wrapper 		= "div class=controls",
							labelClass 		= "control-label",
							groupWrapper 	= "div class=form-group"
						)#

						#html.textarea(
							name            = "description",
							label           = "Description:",
							bind    		= prc.oGroup,
							rows            = "3",
							class           = "form-control mde",
							title           = "A nice description of your group",
							wrapper         = "div class=controls",
							labelClass      = "control-label",
							groupWrapper    = "div class=form-group"
						)#



						<!--- Permissions --->
						#html.startFieldset( legend="Permissions" )#

						<!--- Filter --->
						<div class="form-group">
							<div class="input-group input-group-sm">
								<input
									type="text"
									class="form-control"
									placeholder="Quick Filter"
									aria-describedby="sizing-addon3"
									name="permissionFilter"
									id="permissionFilter"
								>
								<span
									class="input-group-addon cursor-pointer"
									id="sizing-addon3"
									title="Clear Search"
									onclick="clearFilter()"
								>
									<i class="far fa-times-circle fa-lg"></i>
								</span>
							</div>
						</div>

						<!--- Permissions --->
						<cfloop array="#prc.aPermissions#" index="thisPerm">
							<div class="form-group col-md-3 col-sm-4 col-xs-12 text-center thisPermission">
								#html.label(
									class   = "control-label",
									field 	= "permissions_#thisPerm.getPermissionId()#",
									content = thisPerm.getPermission(),
									title 	= thisPerm.getDescription()
								)#

								<div class="controls">
									#html.checkbox(
										name    = "permissions_#thisPerm.getPermissionId()#_toggle",
										data	= { toggle: 'toggle', match: 'permissions_#thisPerm.getPermissionId()#' },
										checked	= prc.oGroup.hasPermission( thisPerm )
									)#
									#html.hiddenField(
										id 		= "permissions_" & thisPerm.getPermissionId()
									)#
								</div>
							</div>
						</cfloop>

						#html.endFieldset()#


						<!--- Action Bar --->
						<div class="form-actions">
							<input type="submit" value="Save" class="btn btn-success btn-lg">
						</div>

					#html.endForm()#
				</div>
			 </div>
		</div>
	</div>
	</cfoutput>
