<cfoutput>
<div class="row">
    <div class="col-md-12" id="main-content-slot">

		<div class="panel panel-default">

			<div class="panel-heading">

				<!--- Top Actions --->
				<div class="float-right mt10">
					<!--- Back To Inbox --->
					#announce( "cbadmin_onNewAuthorActions" )#
					<!--- Back button --->
					<a
						class="btn btn-sm btn-default"
						href="#event.buildLink( prc.xehAuthors )#"
						title="Back to listing"
					>
						<i class="fas fa-chevron-left"></i> Cancel
					</a>
				</div>

				<!--- Title --->
				<div class="size16 p10">
					<i class="fas fa-user"></i>
					Create New Author
				</div>

            </div>

            <div class="panel-body">

				<!--- Messageboxes --->
				#cbMessageBox().renderit()#

				<!--- AuthorForm --->
				#html.startForm(
					name 		= "authorForm",
					action 		= prc.xehAuthorsave,
					novalidate 	= "novalidate",
					class 		= "form-vertical"
				)#
					#html.startFieldset( legend="Account Details" )#

						#html.hiddenField( name="authorID", bind=prc.author )#

						#html.textField(
							name    		= "firstName",
							bind    		= prc.author,
							label   		= "*First Name:",
							required		= "required",
							size    		= "50",
							class   		= "form-control",
							wrapper 		= "div class=controls",
							labelClass 		= "control-label",
							groupWrapper 	= "div class=form-group"
						)#

						#html.textField(
							name    		= "lastName",
							bind    		= prc.author,
							label   		= "*Last Name:",
							required		= "required",
							size    		= "50",
							class   		= "form-control",
							wrapper 		= "div class=controls",
							labelClass 		= "control-label",
							groupWrapper 	= "div class=form-group"
						)#

						#html.inputField(
							name    		= "email",
							type    		= "email",
							bind    		= prc.author,
							label   		= "*Email:",
							required		= "required",
							size    		= "50",
							class   		= "form-control",
							wrapper 		= "div class=controls",
							labelClass 		= "control-label",
							groupWrapper 	= "div class=form-group"
						)#

						#html.textField(
							name    		= "username",
							bind    		= prc.author,
							label   		= "*Username:",
							required		= "required",
							size    		= "50",
							class   		= "form-control username",
							wrapper 		= "div class=controls",
							labelClass		= "control-label",
							groupWrapper	= "div class=form-group"
						)#

                    #html.endFieldset()#


                    #html.startFieldset( legend="Password" )#
                        <div class="alert alert-info">
                            A randomly generated password will be created and a reset link will be generated and sent to the user.
                            User will be forced to set the password on first sign in.
                        </div>
                    #html.endFieldset()#

                    #html.startFieldset( legend="Access" )#

						<!--- Roles --->
						#html.select(
							label     		= "Access Role:",
							name      		= "role",
							options   		= prc.roles,
							column    		= "roleID",
							nameColumn		= "role",
							bind      		= prc.author.getRole(),
							style     		= "width:200px",
							class     		= "form-control input-sm",
							wrapper   		= "div class=controls",
							labelClass		= "control-label",
							groupWrapper 	= "div class=form-group"
						)#

                        <!--- Permission Groups --->
                        <div class="form-group">
                            <label class="control-label">Permission Groups:</label>
                            <cfloop array="#prc.aPermissionGroups#" index="thisGroup">
                                <div class="checkbox">
                                    <label>
                                        <input  type="checkbox"
                                                name="permissionGroups"
                                                id="permissionGroups"
                                                value="#thisGroup.getPermissionGroupID()#"
                                                <cfif prc.author.hasPermissionGroup( thisGroup )>
                                                checked="checked"
                                                </cfif>
                                        > #thisGroup.getName()#
                                    </label>
                                </div>
                            </cfloop>
                        </div>


                    #html.endFieldSet()#

					<!--- Action Bar --->
					<div class="form-actions">
						<input type="submit" value="Create User" class="btn btn-primary btn-lg">
					</div>

				#html.endForm()#

				<!--- cbadmin Event --->
				#announce( "cbadmin_onNewAuthorForm" )#
            </div>
		</div>
    </div>
</div>
</cfoutput>
