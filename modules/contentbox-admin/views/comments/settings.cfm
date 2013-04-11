<cfoutput>
#html.startForm(name="commentSettingsForm",action=rc.xehSaveSettings)#		
#html.anchor(name="top")#
<div class="main" id="main">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-comments icon-large"></i>
			Comment Settings
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<p>From here you can control how the ContentBox commenting system operates.</p>
		
		<!--- Vertical Nav --->
		<div class="body_vertical_nav clearfix">
			<!--- Documentation Navigation Bar --->
			<ul class="vertical_nav">
				<li class="active"><a href="##general_options"><i class="icon-cog icon-large"></i> General Options</a></li>
				<li><a href="##moderation"><i class="icon-unlock icon-large"></i> Moderation</a></li>
				<li><a href="##notifications"><i class="icon-envelope-alt icon-large"></i> Notifications</a></li>
				<!--- cbadmin Event --->
				#announceInterception("cbadmin_onCommentSettingsNav")#
			</ul>		
			<!--- Documentation Panes --->	
			<div class="main_column">
				<!-- Content area that wil show the form and stuff -->
				<div class="panes_vertical">
					<!--- comment options --->
					<div>
						<fieldset>
						<legend><i class="icon-cog icon-large"></i> <strong>Comment Options</strong></legend>
						 	<!--- Activate Comments  --->
							#html.label(field="cb_comments_enabled",content="Enable Site Wide Comments:")#
							#html.radioButton(name="cb_comments_enabled",checked=prc.cbSettings.cb_comments_enabled,value=true)# Yes 	
							#html.radioButton(name="cb_comments_enabled",checked=not prc.cbSettings.cb_comments_enabled,value=false)# No 	
							   
							<!--- URL Translations --->
							#html.label(field="cb_comments_urltranslations",content="Translate URL's to links:")#
							#html.radioButton(name="cb_comments_urltranslations",checked=prc.cbSettings.cb_comments_urltranslations,value=true)# Yes 	
							#html.radioButton(name="cb_comments_urltranslations",checked=not prc.cbSettings.cb_comments_urltranslations,value=false)# No 	
							
							<!--- Captcha --->
							#html.label(field="cb_comments_captcha",content="Use Security Captcha Image:")#
							#html.radioButton(name="cb_comments_captcha",checked=prc.cbSettings.cb_comments_captcha,value=true)# Yes 	
							#html.radioButton(name="cb_comments_captcha",checked=not prc.cbSettings.cb_comments_captcha,value=false)# No 	
							
							<!--- Whois URL --->
							#html.textField(name="cb_comments_whoisURL",label="Whois URL",value=prc.cbSettings.cb_comments_whoisURL,class="textfield",size="60")#
							<strong>={AuthorIP}</strong>	
						</fieldset>
					</div>
					<!--- Comment Moderation --->
					<div>
						<fieldset>
						<legend><i class="icon-unlock icon-large"></i> <strong>Before A Comment Appears</strong></legend>
						 	<!--- Enable Moderation --->
							#html.label(field="cb_comments_moderation",content="An administrator must moderate the comment:")#
							<small>All comments will be moderated according to our moderation rules</small><br/>
							#html.radioButton(name="cb_comments_moderation",checked=prc.cbSettings.cb_comments_moderation,value=true)# Yes 	
							#html.radioButton(name="cb_comments_moderation",checked=not prc.cbSettings.cb_comments_moderation,value=false)# No 	
							
							<!--- Comment Previous History --->
							#html.label(field="cb_comments_moderation_whitelist",content="Comment author must have a previously approved comment:")#
							<small>If an approved comment is found for the submitting email address, the comment is automatically approved and not moderated.</small><br/>
							#html.radioButton(name="cb_comments_moderation_whitelist",checked=prc.cbSettings.cb_comments_moderation_whitelist,value=true)# Yes 	
							#html.radioButton(name="cb_comments_moderation_whitelist",checked=not prc.cbSettings.cb_comments_moderation_whitelist,value=false)# No 	
							
							<!--- Moderated Keywords --->
							#html.label(field="cb_comments_moderation_blacklist",content="Moderated keywords (Affects content, Author IP, or Author Email):")#
							<small>If a comment's content, author ip or email address matches any of these keywords, the comment is automatically moderated. Regular expressions are ok.</small>
							#html.textarea(name="cb_comments_moderation_blacklist",value=prc.cbSettings.cb_comments_moderation_blacklist,rows="8",title="One per line please")#		
							
							<!--- Blocked Keywords --->
							#html.label(field="cb_comments_moderation_blockedlist",content="Blocked keywords (Affects content, Author IP, or Author Email):")#
							<small>If a comment's content, author ip or email address matches any of these keywords, the comment is automatically rejected with no notifications. Regular expressions are ok.</small>
							#html.textarea(name="cb_comments_moderation_blockedlist",value=prc.cbSettings.cb_comments_moderation_blockedlist,rows="8",title="One per line please")#		
						</fieldset>
					</div>
					<!--- Notifications --->
					<div>
						<fieldset>
						<legend><i class="icon-envelope-alt icon-large"></i> <strong>Notifications</strong></legend>
							<p>
								By default all comment notifications are sent to the system email: <a href="mailto:#prc.cbSettings.cb_site_email#">#prc.cbSettings.cb_site_email#</a>, 
							but you can add more emails separated by commas, ohh goody!
							</p>
							<!--- Email Notifications --->
							#html.textarea(name="cb_comments_notifyemails",label="Notification Emails",value=prc.cbSettings.cb_comments_notifyemails,rows="3",title="Comma delimited list")#		
							
							<!--- Notification on Comment --->
							#html.label(field="cb_comments_notify",content="Send a notification that a comment has been made:")#
							#html.radioButton(name="cb_comments_notify",checked=prc.cbSettings.cb_comments_notify,value=true)# Yes 	
							#html.radioButton(name="cb_comments_notify",checked=not prc.cbSettings.cb_comments_notify,value=false)# No 	
							
							<!--- Notification on Moderation --->
							#html.label(field="cb_comments_moderation_notify",content="Send a notification when a comment needs moderation:")#
							#html.radioButton(name="cb_comments_moderation_notify",checked=prc.cbSettings.cb_comments_moderation_notify,value=true)# Yes 	
							#html.radioButton(name="cb_comments_moderation_notify",checked=not prc.cbSettings.cb_comments_moderation_notify,value=false)# No 	
						</fieldset>						
					</div>
					<!--- cbadmin Event --->
					#announceInterception("cbadmin_onCommentSettingsContent")#
				</div>
				<!--- end panes_vertical --->
				<div class="actionBar pull-right">
					#html.submitButton(value="Save Settings",class="btn btn-danger",title="Save the comment settings")#
				</div>
			</div>
			<!--- end main_column --->
		</div>
		<!--- end vertical nav --->
		
		
		</div>
	</div>
</div>		
#html.endForm()#
</cfoutput>