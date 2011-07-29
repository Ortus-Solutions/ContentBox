<cfoutput>
#html.startForm(name="settingsForm",action=rc.xehSaveSettings)#		
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<div class="actionBar">
				#html.submitButton(value="Save Settings",class="buttonred",title="Save the BlogBox settings")#
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
			<img src="#prc.bbroot#/includes/images/coldbox_icon.png" alt="settings" />
			Configure BlogBox
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<p>From here you can manage all of the major BlogBox configuration options.</p>
		
		<fieldset>
		<legend><img src="#prc.bbRoot#/includes/images/settings_black.png" alt="modifiers"/> <strong>General Options</strong></legend>
		 	<!--- Site Name  --->
			#html.textField(name="bb_site_name",label="Site Name:",value=prc.bbSettings.bb_site_name,class="textfield width98",title="The global name of this BlogBox installation")#
			<!--- Tag Line --->
			#html.textField(name="bb_site_tagline",label="Site Tag Line:",value=prc.bbSettings.bb_site_tagline,class="textfield width98",title="A cool tag line that can appear anywhere in your site")#
			<!--- Description --->
			#html.textarea(name="bb_site_description",label="Site Description:",value=prc.bbSettings.bb_site_description,rows="3",title="Your site description, also used in the HTML description meta tag")#		
			<!--- Keywords --->
			#html.textarea(name="bb_site_keywords",label="Site Keywords:",value=prc.bbSettings.bb_site_keywords,rows="3",title="A comma delimited list of keywords to be used in the HTML keywords meta tag")#		
			
		</fieldset>
		
		<fieldset>
			<legend><img src="#prc.bbRoot#/includes/images/chart.png" alt="modifiers"/>  Dashboard Options</legend>
			<!--- Recent Entries --->
			<label for="bb_dashboard_recentEntries">Recent Entries Count</label>
			<select name="bb_dashboard_recentEntries" id="bb_dashboard_recentEntries">
				<cfloop from="5" to="50" step="5" index="i">
					<option value="#i#" <cfif i eq prc.bbSettings.bb_dashboard_recentEntries>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
			
			<!--- Recent Comments--->
			<label for="bb_dashboard_recentComments">Recent Comments Count</label>
			<select name="bb_dashboard_recentComments" id="bb_dashboard_recentComments">
				<cfloop from="5" to="50" step="5" index="i">
					<option value="#i#" <cfif i eq prc.bbSettings.bb_dashboard_recentComments>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
		</fieldset>
		
		<fieldset>
		<legend><img src="#prc.bbRoot#/includes/images/gravatar.png" alt="modifiers"/> <strong>User & Author Gravatars</strong></legend>
			<p>An avatar is an image that follows you from site to site appearing beside your name when you comment on avatar enabled sites.(<a href="http://www.gravatar.com/" target="_blank">http://www.gravatar.com/</a>)</p>
			
			<!--- Gravatars  --->
			#html.label(field="bb_gravatar_display",content="Show Avatars:")#
			#html.radioButton(name="bb_gravatar_display",checked=prc.bbSettings.bb_comments_urltranslations,value=true)# Yes 	
			#html.radioButton(name="bb_gravatar_display",checked=not prc.bbSettings.bb_comments_urltranslations,value=false)# No 	
			
			<!--- Avatar Rating --->
			<label for="bb_gravatar_rating">Maximum Avatar Rating:</label>
			<select name="bb_gravatar_rating" id="bb_gravatar_rating">
				<option value="G"  <cfif prc.bbSettings.bb_gravatar_rating eq "G">selected="selected"</cfif>>G - Suitable for all audiences</option>
				<option value="PG" <cfif prc.bbSettings.bb_gravatar_rating eq "PG">selected="selected"</cfif>>PG - Possibly offensive, usually for audiences 13 and above</option>
				<option value="R"  <cfif prc.bbSettings.bb_gravatar_rating eq "R">selected="selected"</cfif>>R - Intended for adult audiences above 17</option>
				<option value="X"  <cfif prc.bbSettings.bb_gravatar_rating eq "X">selected="selected"</cfif>>X - Even more mature than above</option>
			</select>
		</fieldset>
		
		
		
		<fieldset>
		<legend><img src="#prc.bbRoot#/includes/images/email.png" alt="modifiers"/> <strong>Notifications</strong></legend>
			<!--- Site Email --->
			#html.textField(name="bb_site_email",label="Administrator Email:",value=prc.bbSettings.bb_site_email,class="textfield width98",title="The email that receives all notifications")#
			<!--- Outgoing Email --->
			#html.textField(name="bb_site_outgoingEmail",label="Outgoing Email:",value=prc.bbSettings.bb_site_outgoingEmail,class="textfield width98",title="The email that sends all email notifications out")#
			
			<!--- Notification on Author Create --->
			#html.label(field="bb_notify_author",content="Send a notification when an author has been created or removed:")#
			#html.radioButton(name="bb_notify_author",checked=prc.bbSettings.bb_notify_author,value=true)# Yes 	
			#html.radioButton(name="bb_notify_author",checked=not prc.bbSettings.bb_notify_author,value=false)# No 	
			
			<!--- Notification on Entry Create --->
			#html.label(field="bb_notify_entry",content="Send a notification when a blog entry has been created or removed:")#
			#html.radioButton(name="bb_notify_entry",checked=prc.bbSettings.bb_notify_entry,value=true)# Yes 	
			#html.radioButton(name="bb_notify_entry",checked=not prc.bbSettings.bb_notify_entry,value=false)# No 	
		</fieldset>
		
		<fieldset>
			<legend><img src="#prc.bbRoot#/includes/images/library.png" alt="modifiers"/>  Paging Options</legend>
			
			<!--- Max Blog Post --->
			<label for="bb_paging_maxentries">Max Blog Entries:</label>
			<small>The number of entries to show on the blog before paging is done.</small><br/>
			<select name="bb_paging_maxentries" id="bb_paging_maxentries">
				<cfloop from="5" to="50" step="5" index="i">
					<option value="#i#" <cfif i eq prc.bbSettings.bb_paging_maxentries>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
			
			<!--- Max Blog Post --->
			<label for="bb_paging_maxRSSEntries">Max RSS Blog Entries:</label>
			<small>The number of recent entries to show on the syndication feeds.</small><br/>
			<select name="bb_paging_maxRSSEntries" id="bb_paging_maxRSSEntries">
				<cfloop from="5" to="50" step="5" index="i">
					<option value="#i#" <cfif i eq prc.bbSettings.bb_paging_maxRSSEntries>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
			
			<!--- Max Rows --->
			<label for="bb_paging_maxrows">Paging Max Rows</label>
			<small>The max rows to use in the administrator.</small><br/>
			<select name="bb_paging_maxrows" id="bb_paging_maxrows">
				<cfloop from="5" to="50" step="5" index="i">
					<option value="#i#" <cfif i eq prc.bbSettings.bb_paging_maxrows>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
			
			<!--- Max Band Gap --->
			<label for="bb_paging_bandgap">Paging Band Gap</label>
			<small>The paging bandgap to use in the administrator.</small><br/>
			<select name="bb_paging_bandgap" id="bb_paging_bandgap">
				<cfloop from="1" to="10" index="i">
					<option value="#i#" <cfif i eq prc.bbSettings.bb_paging_bandgap>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
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