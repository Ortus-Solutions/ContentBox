<cfoutput>
<div class="row">
    <div class="col-md-12" id="main-content-slot">

    	<div class="panel panel-default">

            <div class="panel-heading">

                <h3 class="panel-title">
                	<i class="fa fa-user"></i>
					Create New Author
                </h3>

                <div class="actions">

                    <!--- Back To Inbox --->
                    #announceInterception( "cbadmin_onNewAuthorActions" )#

					<!--- Back button --->
					<p class="text-center">
						<button class="btn btn-sm btn-default" onclick="return to('#event.buildLink( prc.xehAuthors )#')">
							<i class="fa fa-reply"></i> Cancel
						</button>
					</p>
                </div>
            </div>

            <div class="panel-body">

            	<!--- Messageboxes --->
            	#getModel( "messagebox@cbMessagebox" ).renderIt()#

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

                    #html.startFieldset( legend="Profile" )#

    					<!--- Biography --->
    					#html.textarea(
    						name   			= "biography",
    						label  			= "Biography or Notes About The User:",
    						bind   			= prc.author,
    						rows   			= "10",
    						class  			= "form-control",
    						wrapper			= "div class=controls",
    						labelClass  	= "control-label",
    						groupWrapper	= "div class=form-group"
    					)#

                        <!---Editor of Choice --->
                		#html.select(
                			name			= "preference.editor",
                			label			= "Default Editor:",
                			options 		= prc.editors,
                			class			= "form-control input-sm",
                			selectedValue 	= prc.author.getPreference( "editor", "" ),
                			wrapper			= "div class=controls",
                			labelClass		= "control-label",
                			groupWrapper	= "div class=form-group"
                		)#

                		<!---Markup of Choice --->
                		#html.select(
                			name			= "preference.markup",
                			label			= "Default Markup:",
                			options 		= prc.markups,
                			class			= "form-control input-sm",
                			selectedValue 	= prc.author.getPreference( "markup", "" ),
                			wrapper			= "div class=controls",
                			labelClass		= "control-label",
                			groupWrapper	= "div class=form-group"
                		)#

                		<!---Social Preferences --->
                		#html.textfield(
                			name			= "preference.twitter",
                			label			= "Twitter Profile:",
                			class			= "form-control",
                			value 			= prc.author.getPreference( "twitter", "" ),
                			wrapper			= "div class=controls",
                			labelClass		= "control-label",
                			groupWrapper	= "div class=form-group"
                		)#

                		#html.textfield(
                			name			= "preference.facebook",
                			label			= "Facebook Profile:",
                			class			= "form-control",
                			value			= prc.author.getPreference( "facebook","" ),
                			wrapper			= "div class=controls",
                			labelClass		= "control-label",
                			groupWrapper	= "div class=form-group"
                		)#

                		#html.textfield(
                			name			= "preference.linkedin",
                			label			= "Linkedin Profile:",
                			class			= "form-control",
                			value			= prc.author.getPreference( "linkedin", "" ),
                			wrapper			= "div class=controls",
                			labelClass 		= "control-label",
                			groupWrapper 	= "div class=form-group"
                		)#

                        #html.textfield(
                			name			= "preference.website",
                			label			= "Website:",
                			class			= "form-control",
                			value			= prc.author.getPreference( "website", "" ),
                			wrapper			= "div class=controls",
                			labelClass 		= "control-label",
                			groupWrapper 	= "div class=form-group"
                		)#

					#html.endFieldSet()#

					<!--- Action Bar --->
					<div class="form-actions">
						<input type="submit" value="Create User" class="btn btn-danger">
					</div>

				#html.endForm()#

				<!--- cbadmin Event --->
				#announceInterception( "cbadmin_onNewAuthorForm" )#
            </div>
 		</div>
    </div>
</div>
</cfoutput>
