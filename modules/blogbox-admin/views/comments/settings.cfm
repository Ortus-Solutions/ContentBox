<cfoutput>
#html.startForm(name="commentSettingsForm",action=rc.xehSaveSettings)#		
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<div class="actionBar">
				<button class="button" onclick="return to('#event.buildLink(rc.xehComments)#')" title="Go to the comments inbox"> Comments Inbox</button>
				#html.submitButton(value="Save Settings",class="buttonred",title="Save the comment settings")#
			</div>
		</div>
	</div>	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.bbroot#/includes/images/comments_32.png" alt="sofa" width="30" height="30" />
			Comment Settings
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<p>From here you can control how the BlogBox commenting system operates.</p>
		
		<fieldset>
		<legend><img src="#prc.bbRoot#/includes/images/settings_black.png" alt="modifiers"/> <strong>Comment Options</strong></legend>
		 	<!--- Activate Comments  --->
			#html.label(field="bb_comments_enabled",content="Enable Site Wide Comments:")#
			#html.radioButton(name="bb_comments_enabled",checked=prc.bbSettings.bb_comments_enabled,value=true)# Yes 	
			#html.radioButton(name="bb_comments_enabled",checked=not prc.bbSettings.bb_comments_enabled,value=false)# No 	
			   
			<!--- URL Translations --->
			#html.label(field="bb_comments_urltranslations",content="Translate URL's to links:")#
			#html.radioButton(name="bb_comments_urltranslations",checked=prc.bbSettings.bb_comments_urltranslations,value=true)# Yes 	
			#html.radioButton(name="bb_comments_urltranslations",checked=not prc.bbSettings.bb_comments_urltranslations,value=false)# No 	
			
			<!--- Whois URL --->
			#html.textField(name="bb_comments_whoisURL",label="Whois URL",value=prc.bbSettings.bb_comments_whoisURL,class="textfield",size="60")#
			<strong>={AuthorIP}</strong>	
		</fieldset>
		
		<fieldset>
		<legend><img src="#prc.bbRoot#/includes/images/lock.png" alt="modifiers"/> <strong>Before A Comment Appears</strong></legend>
		 	<!--- Enable Moderation --->
			#html.label(field="bb_comments_moderation",content="An administrator must moderate the comment:")#
			#html.radioButton(name="bb_comments_moderation",checked=prc.bbSettings.bb_comments_moderation,value=true)# Yes 	
			#html.radioButton(name="bb_comments_moderation",checked=not prc.bbSettings.bb_comments_moderation,value=false)# No 	
			
			<!--- Comment Previous History --->
			#html.label(field="bb_comments_moderation_whitelist",content="Comment author must have a previously approved comment:")#
			#html.radioButton(name="bb_comments_moderation_whitelist",checked=prc.bbSettings.bb_comments_moderation_whitelist,value=true)# Yes 	
			#html.radioButton(name="bb_comments_moderation_whitelist",checked=not prc.bbSettings.bb_comments_moderation_whitelist,value=false)# No 	
			
			<!--- Moderated Keywords --->
			#html.label(field="bb_comments_moderation_blacklist",content="Moderated keywords (Affects content, Author IP, or Author Email):")#
			<small>If a comment's content, author ip or email address matches any of these keywords, the comment is automatically moderated.</small>
			#html.textarea(name="bb_comments_moderation_blacklist",value=prc.bbSettings.bb_comments_moderation_blacklist,rows="8",title="One per line please")#		
			
			<!--- Blocked Keywords --->
			#html.label(field="bb_comments_moderation_blockedlist",content="Blocked keywords (Affects content, Author IP, or Author Email):")#
			<small>If a comment's content, author ip or email address matches any of these keywords, the comment is automatically rejected with no notifications.</small>
			#html.textarea(name="bb_comments_moderation_blockedlist",value=prc.bbSettings.bb_comments_moderation_blockedlist,rows="8",title="One per line please")#		
			
		</fieldset>
		
		<fieldset>
		<legend><img src="#prc.bbRoot#/includes/images/gravatar.png" alt="modifiers"/> <strong>Comment Author Gravatars</strong></legend>
			<p>An avatar is an image that follows you from site to site appearing beside your name when you comment on avatar enabled sites.(<a href="http://www.gravatar.com/" target="_blank">http://www.gravatar.com/</a>)</p>
			
			<!--- Gravatars  --->
			#html.label(field="bb_gravatar_display",content="Show User Avatar:")#
			#html.radioButton(name="bb_gravatar_display",checked=prc.bbSettings.bb_comments_urltranslations,value=true)# Yes 	
			#html.radioButton(name="bb_gravatar_display",checked=not prc.bbSettings.bb_comments_urltranslations,value=false)# No 	
			
			<!--- Avatar Rating --->
			<label for="bb_gravatar_rating">Maximum Avatar Rating:</label>
			<select name="wiki_gravatar_rating" id="wiki_gravatar_rating">
				<option value="G"  <cfif prc.bbSettings.bb_gravatar_rating eq "G">selected="selected"</cfif>>G - Suitable for all audiences</option>
				<option value="PG" <cfif prc.bbSettings.bb_gravatar_rating eq "PG">selected="selected"</cfif>>PG - Possibly offensive, usually for audiences 13 and above</option>
				<option value="R"  <cfif prc.bbSettings.bb_gravatar_rating eq "R">selected="selected"</cfif>>R - Intended for adult audiences above 17</option>
				<option value="X"  <cfif prc.bbSettings.bb_gravatar_rating eq "X">selected="selected"</cfif>>X - Even more mature than above</option>
			</select>
		</fieldset>
		
		<fieldset>
		<legend><img src="#prc.bbRoot#/includes/images/email.png" alt="modifiers"/> <strong>Notifications</strong></legend>
			<p>
				By default all notifications are sent to the system email: <a href="mailto:#prc.bbSettings.bb_site_email#">#prc.bbSettings.bb_site_email#</a>, 
			but you can add more emails, ohh goody!
			</p>
			<!--- Email Notifications --->
			#html.textarea(name="bb_comments_notifyemails",label="Notification Emails",value=prc.bbSettings.bb_comments_notifyemails,rows="3",title="Comma or semi-colon delimited list")#		
			
			<!--- Notification on Comment --->
			#html.label(field="bb_comments_notify",content="Send a notification that a comment has been made:")#
			#html.radioButton(name="bb_comments_notify",checked=prc.bbSettings.bb_comments_notify,value=true)# Yes 	
			#html.radioButton(name="bb_comments_notify",checked=not prc.bbSettings.bb_comments_notify,value=false)# No 	
			
			<!--- Notification on Moderation --->
			#html.label(field="bb_comments_moderation_notify",content="Send a notification when a comment needs moderation:")#
			#html.radioButton(name="bb_comments_moderation_notify",checked=prc.bbSettings.bb_comments_moderation_notify,value=true)# Yes 	
			#html.radioButton(name="bb_comments_moderation_notify",checked=not prc.bbSettings.bb_comments_moderation_notify,value=false)# No 	
		
		</fieldset>

		</div>
	</div>
</div>		
#html.endForm()#

<script type="text/javascript">
$(document).ready(function() {
	// form validators
	$("##commentSettingsForm").validator({grouped:true});
});
</script>
</cfoutput>