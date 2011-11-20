<cfoutput>
#html.startForm(name="settingsForm",action=prc.xehSaveSettings)#		
#html.anchor(name="top")#
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<div class="actionBar">
				#html.submitButton(value="Save Settings",class="buttonred",title="Save the ContentBox settings")#
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
			<img src="#prc.cbroot#/includes/images/coldbox_icon.png" alt="settings" />
			Configure ContentBox
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<p>From here you can manage all of the major ContentBox configuration options.</p>
		
		<!--- Vertical Nav --->
		<div class="body_vertical_nav clearfix">
			<!--- Documentation Navigation Bar --->
			<ul class="vertical_nav">
				<li class="active"><a href="##general_options"><img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> General Options</a></li>
				<li><a href="##dashboard_options"><img src="#prc.cbRoot#/includes/images/chart.png" alt="modifiers"/> Dashboard Options</a></li>
				<li><a href="##gravatars"><img src="#prc.cbRoot#/includes/images/gravatar.png" alt="modifiers"/> Gravatars</a></li>
				<li><a href="##notifications"><img src="#prc.cbRoot#/includes/images/email.png" alt="modifiers"/> Notifications</a></li>
				<li><a href="##rss_options"><img src="#prc.cbRoot#/includes/images/feed.png" alt="modifiers"/> RSS Options</a></li>
				<li><a href="##paging_options"><img src="#prc.cbRoot#/includes/images/library.png" alt="modifiers"/> Paging Options</a></li>
				<!--- cbadmin Event --->
				#announceInterception("cbadmin_onSettingsNav")#
			</ul>		
			<!--- Documentation Panes --->	
			<div class="main_column">
				<!-- Content area that wil show the form and stuff -->
				<div class="panes_vertical">
					<!--- General Options --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> <strong>General Options</strong></legend>
						 	<!--- Site Name  --->
							#html.textField(name="cb_site_name",label="Site Name:",value=prc.cbSettings.cb_site_name,class="textfield width98",title="The global name of this ContentBox installation")#
							<!--- Tag Line --->
							#html.textField(name="cb_site_tagline",label="Site Tag Line:",value=prc.cbSettings.cb_site_tagline,class="textfield width98",title="A cool tag line that can appear anywhere in your site")#
							<!--- Description --->
							#html.textarea(name="cb_site_description",label="Site Description:",value=prc.cbSettings.cb_site_description,rows="3",title="Your site description, also used in the HTML description meta tag")#		
							<!--- Keywords --->
							#html.textarea(name="cb_site_keywords",label="Site Keywords:",value=prc.cbSettings.cb_site_keywords,rows="3",title="A comma delimited list of keywords to be used in the HTML keywords meta tag")#		
							<!--- HomePage --->
							<label for="cb_site_homepage">Home Page Displays:</label>
							<small>Choose the latest blog entries or a static page.</small><br/>
							<select name="cb_site_homepage" id="cb_site_homepage" class="width98">
								<option value="cbBlog" <cfif prc.cbSettings.cb_site_homepage eq "cbBlog">selected="selected"</cfif>>Latest Blog Entries</option>
								#html.options(values=prc.pages,column="slug",nameColumn="title",selectedValue=prc.cbSettings.cb_site_homepage)#
							</select> 	
							
						</fieldset>
					</div>
					<!--- Dashboard Options --->
					<div>
						<fieldset>
							<legend><img src="#prc.cbRoot#/includes/images/chart.png" alt="modifiers"/>  Dashboard Options</legend>
							<!--- Recent Entries --->
							<label for="cb_dashboard_recentEntries">Recent Entries Count</label>
							<select name="cb_dashboard_recentEntries" id="cb_dashboard_recentEntries">
								<cfloop from="5" to="50" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentEntries>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>
							
							<!--- Recent Pages --->
							<label for="cb_dashboard_recentPages">Recent Pages Count</label>
							<select name="cb_dashboard_recentPages" id="cb_dashboard_recentPages">
								<cfloop from="5" to="50" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentPages>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>
							
							<!--- Recent Comments--->
							<label for="cb_dashboard_recentComments">Recent Comments Count</label>
							<select name="cb_dashboard_recentComments" id="cb_dashboard_recentComments">
								<cfloop from="5" to="50" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentComments>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>
						</fieldset>	
					</div>
					<!--- Gravatars --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/gravatar.png" alt="modifiers"/> <strong>User & Author Gravatars</strong></legend>
							<p>An avatar is an image that follows you from site to site appearing beside your name when you comment on avatar enabled sites.(<a href="http://www.gravatar.com/" target="_blank">http://www.gravatar.com/</a>)</p>
							
							<!--- Gravatars  --->
							#html.label(field="cb_gravatar_display",content="Show Avatars:")#
							#html.radioButton(name="cb_gravatar_display",checked=prc.cbSettings.cb_comments_urltranslations,value=true)# Yes 	
							#html.radioButton(name="cb_gravatar_display",checked=not prc.cbSettings.cb_comments_urltranslations,value=false)# No 	
							
							<!--- Avatar Rating --->
							<label for="cb_gravatar_rating">Maximum Avatar Rating:</label>
							<select name="cb_gravatar_rating" id="cb_gravatar_rating">
								<option value="G"  <cfif prc.cbSettings.cb_gravatar_rating eq "G">selected="selected"</cfif>>G - Suitable for all audiences</option>
								<option value="PG" <cfif prc.cbSettings.cb_gravatar_rating eq "PG">selected="selected"</cfif>>PG - Possibly offensive, usually for audiences 13 and above</option>
								<option value="R"  <cfif prc.cbSettings.cb_gravatar_rating eq "R">selected="selected"</cfif>>R - Intended for adult audiences above 17</option>
								<option value="X"  <cfif prc.cbSettings.cb_gravatar_rating eq "X">selected="selected"</cfif>>X - Even more mature than above</option>
							</select>
						</fieldset>
					</div>
					<!--- Notifications --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/email.png" alt="modifiers"/> <strong>Notifications</strong></legend>
							<!--- Site Email --->
							#html.textField(name="cb_site_email",label="Administrator Email:",value=prc.cbSettings.cb_site_email,class="textfield width98",title="The email that receives all notifications")#
							<!--- Outgoing Email --->
							#html.textField(name="cb_site_outgoingEmail",label="Outgoing Email:",value=prc.cbSettings.cb_site_outgoingEmail,class="textfield width98",title="The email that sends all email notifications out")#
							
							<!--- Notification on Author Create --->
							#html.label(field="cb_notify_author",content="Send a notification when an author has been created or removed:")#
							#html.radioButton(name="cb_notify_author",checked=prc.cbSettings.cb_notify_author,value=true)# Yes 	
							#html.radioButton(name="cb_notify_author",checked=not prc.cbSettings.cb_notify_author,value=false)# No 	
							
							<!--- Notification on Entry Create --->
							#html.label(field="cb_notify_entry",content="Send a notification when a blog entry has been created or removed:")#
							#html.radioButton(name="cb_notify_entry",checked=prc.cbSettings.cb_notify_entry,value=true)# Yes 	
							#html.radioButton(name="cb_notify_entry",checked=not prc.cbSettings.cb_notify_entry,value=false)# No 	
						</fieldset>
					</div>
					<!--- RSS Options --->
					<div>
						<fieldset>
							<legend><img src="#prc.cbRoot#/includes/images/feed.png" alt="modifiers"/>  RSS Options</legend>
									
							<!--- Max RSS Entries --->
							<label for="cb_rss_maxEntries">Max RSS Blog Entries:</label>
							<small>The number of recent entries to show on the syndication feeds.</small><br/>
							<select name="cb_rss_maxEntries" id="cb_rss_maxEntries">
								<cfloop from="5" to="50" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_maxEntries>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>
							
							<!--- Max RSS Comments --->
							<label for="cb_rss_maxComments">Max RSS Blog Comments:</label>
							<small>The number of recent comments to show on the syndication feeds.</small><br/>
							<select name="cb_rss_maxComments" id="cb_rss_maxComments">
								<cfloop from="5" to="50" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_maxComments>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>	
							
							<!--- RSS Caching --->
							#html.label(field="cb_rss_caching",content="Activate RSS feed caching:")#
							#html.radioButton(name="cb_rss_caching",checked=prc.cbSettings.cb_rss_caching,value=true)# Yes 	
							#html.radioButton(name="cb_rss_caching",checked=not prc.cbSettings.cb_rss_caching,value=false)# No 	
							
							<!--- RSS Cache Name --->
							<label for="cb_rss_cacheName">Feed Cache Provider:</label>
							<small>Choose the CacheBox provider to cache feeds into.</small><br/>
							#html.select(name="cb_rss_cacheName",options=prc.cacheNames,selectedValue=prc.cbSettings.cb_rss_cacheName)#
							
							<!--- Rss Cache Timeouts --->
							<label for="cb_rss_cachingTimeout">Feed Cache Timeouts:</label>
							<small>The number of minutes a feed XML is cached per permutation of feed type.</small><br/>
							<select name="cb_rss_cachingTimeout" id="cb_rss_cachingTimeout">
								<cfloop from="5" to="100" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_cachingTimeout>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>	
							
							<!--- Rss Cache Last Access Timeouts --->
							<label for="cb_rss_cachingTimeoutIdle">Feed Cache Idle Timeouts:</label>
							<small>The number of idle minutes allowed for cached RSS feeds to live. Usually this is less than the timeout you selected above</small><br/>
							<select name="cb_rss_cachingTimeoutIdle" id="cb_rss_cachingTimeoutIdle">
								<cfloop from="5" to="100" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_cachingTimeoutIdle>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>		
							
						</fieldset>
					</div>
					<!--- Paging Options --->
					<div>	
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/library.png" alt="modifiers"/>  Paging Options</legend>
						
						<!--- Max Blog Post --->
						<label for="cb_paging_maxentries">Max Home Page Blog Entries:</label>
						<small>The number of entries to show on the blog before paging is done.</small><br/>
						<select name="cb_paging_maxentries" id="cb_paging_maxentries">
							<cfloop from="5" to="50" step="5" index="i">
								<option value="#i#" <cfif i eq prc.cbSettings.cb_paging_maxentries>selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						
						<!--- Max Rows --->
						<label for="cb_paging_maxrows">Paging Max Rows</label>
						<small>The max rows to use in the administrator.</small><br/>
						<select name="cb_paging_maxrows" id="cb_paging_maxrows">
							<cfloop from="5" to="50" step="5" index="i">
								<option value="#i#" <cfif i eq prc.cbSettings.cb_paging_maxrows>selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						
						<!--- Max Band Gap --->
						<label for="cb_paging_bandgap">Paging Band Gap</label>
						<small>The paging bandgap to use in the administrator.</small><br/>
						<select name="cb_paging_bandgap" id="cb_paging_bandgap">
							<cfloop from="1" to="10" index="i">
								<option value="#i#" <cfif i eq prc.cbSettings.cb_paging_bandgap>selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
					</fieldset>
					</div>
					<!--- cbadmin Event --->
					#announceInterception("cbadmin_onSettingsContent")#
				</div>
				<!--- End panes_vertical --->
			</div>
			<!--- End main_column --->
		</div>
		<!--- End vertical nav --->
			
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