<cfoutput>
#html.startForm(name="commentSettingsForm",action=rc.xehSaveSettings,class="form-vertical")#		
#html.anchor(name="top")#
<div class="row-fluid">
	<div class="span12">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-comments icon-large"></i>
				Comment Settings
			</div>
			<!--- Body --->
			<div class="body">	
	
				<!--- Back To Inbox --->	
				#html.href(text="<i class='icon-reply'></i> Back To Inbox", class="btn pull-right", href=event.buildlink(prc.xehComments))#			
			
				<!--- messageBox --->
				#getPlugin("MessageBox").renderit()#
			
				<p>From here you can control how the ContentBox commenting system operates.</p>
			
				<!--- Vertical Nav --->
				<div class="tabbable tabs-left">
    				<!--- Documentation Navigation Bar --->
    				<ul class="nav nav-tabs">
    					<li class="active"><a href="##general_options" data-toggle="tab"><i class="icon-cog icon-large"></i> General Options</a></li>
    					<li><a href="##moderation" data-toggle="tab"><i class="icon-unlock icon-large"></i> Moderation</a></li>
    					<li><a href="##notifications" data-toggle="tab"><i class="icon-envelope-alt icon-large"></i> Notifications</a></li>
    					<!--- cbadmin Event --->
    					#announceInterception("cbadmin_onCommentSettingsNav")#
    				</ul>		
                    
    				<!--- Tab Content --->
    				<div class="tab-content">
    				    
    					<!--- comment options --->
    					<div class="tab-pane active" id="general_options">
    						<fieldset>
    						<legend><i class="icon-cog icon-large"></i> <strong>Comment Options</strong></legend>
    						 	<!--- Activate Comments  --->
								<div class="control-group">
    								#html.label(field="cb_comments_enabled",content="Enable Site Wide Comments:",class="control-label")#
    								<div class="controls">
    									#html.radioButton(name="cb_comments_enabled",checked=prc.cbSettings.cb_comments_enabled,value=true)# Yes 	
        								#html.radioButton(name="cb_comments_enabled",checked=not prc.cbSettings.cb_comments_enabled,value=false)# No   
    								</div>
								</div>
    							   
    							<!--- URL Translations --->
    							<div class="control-group">
    							    #html.label(field="cb_comments_urltranslations",content="Translate URL's to links:",class="control-label")#
    							    <div class="controls">
    							        #html.radioButton(name="cb_comments_urltranslations",checked=prc.cbSettings.cb_comments_urltranslations,value=true)# Yes 	
    									#html.radioButton(name="cb_comments_urltranslations",checked=not prc.cbSettings.cb_comments_urltranslations,value=false)# No 	
    							    </div>
    							</div>
                                
    							<!--- Captcha --->
    							<div class="control-group">
    							    #html.label(field="cb_comments_captcha",content="Use Security Captcha Image:",class="control-label")#
    							    <div class="controls">
    							        #html.radioButton(name="cb_comments_captcha",checked=prc.cbSettings.cb_comments_captcha,value=true)# Yes 	
    									#html.radioButton(name="cb_comments_captcha",checked=not prc.cbSettings.cb_comments_captcha,value=false)# No 
    							    </div>
    							</div>
    							   							
    							<!--- Whois URL --->
    							#html.textField(name="cb_comments_whoisURL",label="Whois URL",value=prc.cbSettings.cb_comments_whoisURL,class="textfield",size="60",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						</fieldset>
    					</div>
    					<!--- Comment Moderation --->
    					<div class="tab-pane" id="moderation">
    						<fieldset>
    						<legend><i class="icon-unlock icon-large"></i> <strong>Before A Comment Appears</strong></legend>
    						 	<!--- Enable Moderation --->
								<div class="control-group">
								    #html.label(field="cb_comments_moderation",content="An administrator must moderate the comment:")#
                                    <div class="controls">
								        <small>All comments will be moderated according to our moderation rules</small><br/>
            							#html.radioButton(name="cb_comments_moderation",checked=prc.cbSettings.cb_comments_moderation,value=true)# Yes 	
            							#html.radioButton(name="cb_comments_moderation",checked=not prc.cbSettings.cb_comments_moderation,value=false)# No 	
								    </div>
								</div>

    							<!--- Comment Previous History --->
								<div class="control-group">
								    #html.label(field="cb_comments_moderation_whitelist",content="Comment author must have a previously approved comment:")#
                                    <div class="controls">
								        <small>If an approved comment is found for the submitting email address, the comment is automatically approved and not moderated.</small><br/>
    									#html.radioButton(name="cb_comments_moderation_whitelist",checked=prc.cbSettings.cb_comments_moderation_whitelist,value=true)# Yes 	
    									#html.radioButton(name="cb_comments_moderation_whitelist",checked=not prc.cbSettings.cb_comments_moderation_whitelist,value=false)# No
								    </div>
								</div>	
    							
                                <!--- Auto-Delete Moderated Comments --->
                                <div class="control-group">
                                    #html.label(field="cb_comments_moderation_expiration",content="Number of days before auto-deleting moderated comments:")#
                                    <div class="controls">
                                        <small>If a comment has been moderated, it will be auto-deleted after the specified number of days (set to 0 to disable auto-deletion).</small><br/>
                                        #html.inputField(name="cb_comments_moderation_expiration",value=prc.cbSettings.cb_comments_moderation_expiration,type="number")#
                                    </div>
                                </div>  

    							<!--- Moderated Keywords --->
								<div class="control-group">
								    #html.label(field="cb_comments_moderation_blacklist",content="Moderated keywords (Affects content, Author IP, or Author Email):",class="control-label")#
								    <div class="controls">
								        <small>If a comment's content, author ip or email address matches any of these keywords, the comment is automatically moderated. Regular expressions are ok.</small>
    									#html.textarea(name="cb_comments_moderation_blacklist",value=prc.cbSettings.cb_comments_moderation_blacklist,rows="8",title="One per line please")#
								    </div>
								</div>
    							
    							<!--- Blocked Keywords --->
								<div class="control-group">
								    #html.label(field="cb_comments_moderation_blockedlist",content="Blocked keywords (Affects content, Author IP, or Author Email):")#
                                    <div class="controls">
								        <small>If a comment's content, author ip or email address matches any of these keywords, the comment is automatically rejected with no notifications. Regular expressions are ok.</small>
    									#html.textarea(name="cb_comments_moderation_blockedlist",value=prc.cbSettings.cb_comments_moderation_blockedlist,rows="8",title="One per line please")#		
								    </div>
								</div>	
    						</fieldset>
    					</div>
    					<!--- Notifications --->
    					<div class="tab-pane" id="notifications">
    						<fieldset>
    						<legend><i class="icon-envelope-alt icon-large"></i> <strong>Notifications</strong></legend>
    							<p>
    								By default all comment notifications are sent to the system email: <a href="mailto:#prc.cbSettings.cb_site_email#">#prc.cbSettings.cb_site_email#</a>, 
    							but you can add more emails separated by commas, ohh goody!
    							</p>
    							<!--- Email Notifications --->
    							#html.textarea(name="cb_comments_notifyemails",label="Notification Emails",value=prc.cbSettings.cb_comments_notifyemails,rows="3",title="Comma delimited list",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#		
    							
    							<!--- Notification on Comment --->
                                <div class="control-group">
								    #html.label(field="cb_comments_notify",content="Send a notification that a comment has been made:")#
                                    <div class="controls">
								        #html.radioButton(name="cb_comments_notify",checked=prc.cbSettings.cb_comments_notify,value=true)# Yes 	
    									#html.radioButton(name="cb_comments_notify",checked=not prc.cbSettings.cb_comments_notify,value=false)# No 	
								    </div>
								</div>
    							
    							<!--- Notification on Moderation --->
								<div class="control-group">
									#html.label(field="cb_comments_moderation_notify",content="Send a notification when a comment needs moderation:")#    
                                    <div class="controls">
								        #html.radioButton(name="cb_comments_moderation_notify",checked=prc.cbSettings.cb_comments_moderation_notify,value=true)# Yes 	
    									#html.radioButton(name="cb_comments_moderation_notify",checked=not prc.cbSettings.cb_comments_moderation_notify,value=false)# No 	
								    </div>
								</div>    							
    						</fieldset>						
    					</div>
						<!--- cbadmin Event --->
						#announceInterception("cbadmin_onCommentSettingsContent")#
						<!--- End Tab Content --->
        				<div class="form-actions">
        					#html.button(type="submit", value="Save Settings", class="btn btn-danger")#
        				</div>
						
					</div>
					<!--- End Tab Content --->
				</div>
                <!---End Veritcal Nav--->
			</div>
            <!---End Body--->
		</div>
	</div>		
</div>
#html.endForm()#
</cfoutput>