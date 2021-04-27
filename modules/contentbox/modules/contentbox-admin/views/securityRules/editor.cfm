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
						href="#event.buildLink( prc.xehSecurityRules )#"
						title="Back to listing"
					>
						<i class="fas fa-chevron-left"></i> Cancel
					</a>
				</div>

				<!--- Panel Title --->
				<div class="size16 p10">
					<i class="fas fa-passport"></i>
					<cfif prc.rule.isLoaded()>
						Update
					<cfelse>
						Create
					</cfif>
					Security Rule
				</div>
			</div>

			<div class="panel-body">

				<!--- Messageboxes --->
				#cbMessageBox().renderit()#

				<!--- Form --->
                #html.startForm(
                    name       = "ruleEditForm",
                    action     = prc.xehRuleSave,
                    novalidate = "novalidate",
                    class      = "form-vertical"
                )#
                    <!--- ruleID --->
                    #html.hiddenField( name="ruleID", bind=prc.rule )#

					<!--- Usage --->
					<div class="alert alert-danger">
						<i class="fa fa-exclamation-triangle fa-lg"></i>
						Please remember that the secure and white lists are lists of
						<a href="https://www.regular-expressions.info/reference.html" target="_blank">regular expressions</a> that will match against an incoming
						event pattern string or a routed URL string.  So remember the event pattern syntax: <em>[moduleName:][package.]handler[.action]</em> if you will
						be using event type matching. If you are using URL matching then do NOT start your patterns with <strong>'/'</strong> as it is pre-pended for you.
					</div>

					<div class="form-group">
						#html.label(
							field   = "match",
							content = "Match Type:",
							class   = "control-label"
						)#
						<div class="controls">

							<div class="mb5">
								<code>URL</code> matches the incoming routed URL <code>Event</code> matches the incoming event
							</div>

							#html.radioButton(
								name  = "match",
								value = 'url',
								bind  = prc.rule
							)# URL

							#html.radioButton(
								name  = "match",
								value = 'event',
								bind  = prc.rule
							)# Event
						</div>
					</div>

					#html.textField(
						name="secureList",
						label="*Secure List:",
						bind=prc.rule,
						required="required",
						maxlength="255",
						class="form-control",
						size="100",
						title="The list of regular expressions that if matched it will trigger security for this rule.",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#

					#html.textField(
						name="whiteList",
						label="White List:",
						bind=prc.rule,
						maxlength="255",
						class="form-control",
						size="100",
						title="The list of regular expressions that if matched it will allow them through for this rule.",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#

					#html.textField(
						name="order",
						label="Firing Order Index:",
						bind=prc.rule,
						size="5",
						class="form-control",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#

					#html.startFieldset( legend="Authorizations" )#

						<div class="form-group">
							<label for="permissions">
								Permissions:
								<cfif len( prc.rule.getPermissions() )>
									<span class="badge badge-info">#prc.rule.getPermissions()#</span>
								</cfif>
							</label>

							<div class="mb5 text-muted">
								The list of security permissions needed to access the secured content of this rule.
							</div>

							<select
								name="permissions"
								id="permissions"
								multiple
								class="form-control"
								size="20"
							>
								<cfloop array=#prc.aPermissions# index="thisPerm">
									<option
										value="#thisPerm.getPermission()#"
										<cfif findNoCase( thisPerm.getPermission(), prc.rule.getPermissions() )>selected="selected"</cfif>
									>
										#thisPerm.getPermission()#
									</option>
								</cfloop>
							</select>
						</div>

						<div class="form-group">
							<label for="roles">
								Roles:
								<cfif len( prc.rule.getRoles() )>
									<span class="badge badge-info">#prc.rule.getRoles()#</span>
								</cfif>
							</label>

							<div class="mb5 text-muted">
								The list of security roles needed to access the secured content of this rule.
							</div>

							<select
								name="roles"
								id="roles"
								multiple
								class="form-control"
							>
								<cfloop array=#prc.aRoles# index="thisRole">
									<option value="#thisRole.getRole()#">#thisRole.getRole()#</option>
								</cfloop>
							</select>
						</div>
                    #html.endFieldset()#

                    #html.startFieldset( legend="Relocation Data" )#
                        <div class="form-group">
                            #html.label(
                                field   = "useSSL",
                                content = "Redirect using SSL:",
                                class   = "control-label"
                            )#
                            <div class="controls">
                                #html.radioButton(
                                    name  = "useSSL",
                                    value = true,
                                    bind  = prc.rule
                                )# Yes
                                #html.radioButton(
                                    name  = "useSSL",
                                    value = false,
                                    bind  = prc.rule
                                )# No
                            </div>
                        </div>

                        #html.textField(
                            name       		= "redirect",
                            label      		= "*Redirect Pattern:",
                            required   		= "required",
                            bind       		= prc.rule,
                            maxlength  		= "255",
                            class      		= "form-control",
                            size       		= "100",
                            title      		= "The URL pattern to redirect to if user does not have access to this rule.",
                            wrapper    		= "div class=controls",
                            labelClass 		= "control-label",
							groupWrapper    = "div class=form-group",
							placeholder     = "cbadmin/security/login"
                        )#

                        #html.select(
                            name			= "messageType",
                            label			= "Relocation Message Type:",
                            bind			= prc.rule,
							options			= "Info,Warn,Error,Fatal,Debug",
							selectedValue	= "Warn",
                            class			= "form-control input-lg",
                            title			= "The message type of the relocation",
                            wrapper			= "div class=controls",
                            labelClass 		= "control-label",
							groupWrapper 	= "div class=form-group"
                        )#

                        #html.textField(
                            name       		= "message",
                            label      		= "Relocation Message:",
                            bind       		= prc.rule,
                            maxlength  		= "255",
                            class      		= "form-control",
                            size       		= "100",
                            title      		= "The message to show the user upon relocation",
                            wrapper    		= "div class=controls",
                            labelClass 		= "control-label",
							groupWrapper 	= "div class=form-group",
							placeholder 	= "Sorry! You don't have the right authorizations"
						)#

                    #html.endFieldset()#

                    <!--- Action Bar --->
                    <div class="form-actions">
                        <button type="submit" class="btn btn-success">Save</button>
					</div>

                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>