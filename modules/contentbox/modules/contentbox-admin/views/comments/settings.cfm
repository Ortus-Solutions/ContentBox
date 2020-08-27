<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="far fa-comments"></i> Site Comment Settings</h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        #getInstance( "messagebox@cbMessagebox" ).renderit()#
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        #html.startForm(
            name   = "commentSettingsForm",
            action = rc.xehSaveSettings,
            class  = "form-vertical"
        )#

			#html.anchor( name="top" )#

            <div class="panel panel-default">
                <div class="panel-body">

					<p>
						From here you can control how the ContentBox commenting system operates on the currently active site:
						<code>#prc.oCurrentSite.getName()#</code>
					</p>

					<!--- Vertical Nav --->
                    <div class="tab-wrapper tab-left tab-primary">
                        <!--- Documentation Navigation Bar --->
                        <ul class="nav nav-tabs">
							<li class="active">
								<a href="##general_options" data-toggle="tab">
									<i class="fas fa-sliders-h fa-lg"></i> <span class="hidden-xs">Settings</span>
								</a>
							</li>
							<li>
								<a href="##notifications" data-toggle="tab">
									<i class="far fa-envelope-open fa-lg"></i> <span class="hidden-xs">Notifications</span>
								</a>
							</li>
                            <!--- cbadmin Event --->
                            #announce( "cbadmin_onCommentSettingsNav" )#
                        </ul>

                        <!--- Tab Content --->
                        <div class="tab-content">

                            <!--- comment options --->
                            <div class="tab-pane active" id="general_options">
                                <fieldset>
                                        <!--- Activate Comments  --->
                                        <div class="form-group">
                                            #html.label(
                                                field="cb_comments_enabled",
                                                content="Enable Site Wide Comments:",
                                                class="control-label"
                                            )#
                                            <div class="controls">
                                            	#html.checkbox(
													name    = "cb_comments_enabled_toggle",
													data	= { toggle: 'toggle', match: 'cb_comments_enabled' },
													checked	= prc.cbSiteSettings.cb_comments_enabled
												)#
												#html.hiddenField(
													name	= "cb_comments_enabled",
													value	= prc.cbSiteSettings.cb_comments_enabled
												)#
                                            </div>
                                        </div>

                                        <!--- URL Translations --->
                                        <div class="form-group">
                                            #html.label(
                                                field="cb_comments_urltranslations",
                                                content="Translate URL's to links:",
                                                class="control-label"
                                            )#
                                            <div class="controls">
                                            	#html.checkbox(
													name    = "cb_comments_urltranslations_toggle",
													data	= { toggle: 'toggle', match: 'cb_comments_urltranslations' },
													checked	= prc.cbSiteSettings.cb_comments_urltranslations
												)#
												#html.hiddenField(
													name	= "cb_comments_urltranslations",
													value	= prc.cbSiteSettings.cb_comments_urltranslations
												)#
                                            </div>
                                        </div>
                                </fieldset>
                            </div>

                            <!--- Notifications --->
                            <div class="tab-pane" id="notifications">
                                <fieldset>
                                    <legend><i class="far fa-envelope-open fa-lg"></i> Notifications</legend>
                                    <p>
										By default all comment notifications are sent to the global system email(s).
										However, you can add per-site notification emails below:

									</p>

                                    <!--- Email Notifications --->
									<div class="form-group">
                                        #html.label(
											field 	= "cb_comments_notify",
											content = "Notification Emails:",
											class 	= "control-label"
										)#
                                        <div class="controls">
                                        	#html.textarea(
												name="cb_comments_notifyemails",
												value=prc.cbSiteSettings.cb_comments_notifyemails,
												rows="3",
												class="form-control",
												title="Comma delimited list",
												wrapper="div class=controls"
											)#
                                        </div>
									</div>

                                    <!--- Notification on Comment --->
                                    <div class="form-group">
                                        #html.label(
											field 	= "cb_comments_notify",
											content = "Send a notification that a comment has been made:",
											class 	= "control-label"
										)#
                                        <div class="controls">
                                        	#html.checkbox(
												name    = "cb_comments_notify_toggle",
												data	= { toggle: 'toggle', match: 'cb_comments_notify' },
												checked	= prc.cbSiteSettings.cb_comments_notify
											)#
											#html.hiddenField(
												name	= "cb_comments_notify",
												value	= prc.cbSiteSettings.cb_comments_notify
											)#
                                        </div>
                                    </div>

                                    <!--- Notification on Moderation --->
                                    <div class="form-group">
                                        #html.label(
                                            field 	= "cb_comments_moderation_notify",
											content = "Send a notification when a comment needs moderation:",
											class 	= "control-label"
                                        )#
                                        <div class="controls">
                                        	#html.checkbox(
												name    = "cb_comments_moderation_notify_toggle",
												data	= { toggle: 'toggle', match: 'cb_comments_moderation_notify' },
												checked	= prc.cbSiteSettings.cb_comments_moderation_notify
											)#
											#html.hiddenField(
												name	= "cb_comments_moderation_notify",
												value	= prc.cbSiteSettings.cb_comments_moderation_notify
											)#
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                            <!--- cbadmin Event --->
                            #announce( "cbadmin_onCommentSettingsContent" )#
                            <!--- End Tab Content --->
                            <div class="form-actions">
                                #html.button(type="submit", value="Save Settings", class="btn btn-danger" )#
                            </div>

                        </div>
                        <!--- End Tab Content --->
                    </div>
                    <!---End Veritcal Nav--->
                </div>
            </div>
        #html.endForm()#
    </div>
</div>
</cfoutput>