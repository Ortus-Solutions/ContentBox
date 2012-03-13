<cfoutput>
#html.startForm(name="settingsForm",action=prc.xehSaveSettings)#
#html.anchor(name="top")#
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<cfif prc.oAuthor.checkPermission("SYSTEM_SAVE_CONFIGURATION")>
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<div class="actionBar">
				#html.submitButton(value="Save Settings",class="buttonred",title="Save the ContentBox settings")#
			</div>
		</div>
		</cfif>
	</div>
</div>
<!--End sidebar-->
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/ContentBox-Circle_32.png" alt="settings" />
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
				<li><a href="##cache_options"><img src="#prc.cbRoot#/includes/images/database_black.png" alt="modifiers"/> Content Caching</a></li>
				<li><a href="##mediamanager"><img src="#prc.cbRoot#/includes/images/media.png" alt="modifiers"/> Media Manager</a></li>
				<li><a href="##gravatars"><img src="#prc.cbRoot#/includes/images/gravatar.png" alt="modifiers"/> Gravatars</a></li>
				<li><a href="##notifications"><img src="#prc.cbRoot#/includes/images/email.png" alt="modifiers"/> Notifications</a></li>
				<li><a href="##search_options"><img src="#prc.cbRoot#/includes/images/search_black.png" alt="modifiers"/> Search Options</a></li>
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
								<cfloop array="#prc.pages#" index="thisPage" >
								<option value="#thispage.getSlug()#" <cfif prc.cbSettings.cb_site_homepage eq thisPage.getSlug()>selected="selected"</cfif>>#thisPage.getTitle()#</option>
								</cfloop>
							</select>

							<!--- Disable Blog --->
							#html.label(field="cb_site_disable_blog",content="Disable Blog:")#
							<small>You can disable the Blog in this entire ContentBox. This does not delete data, it just disables blog features. Also
								   remember to change the <strong>Home Page</strong> above to a real page and not the blog.</small><br/>
							#html.radioButton(name="cb_site_disable_blog",checked=prc.cbSettings.cb_site_disable_blog,value=true)# Yes
							#html.radioButton(name="cb_site_disable_blog",checked=not prc.cbSettings.cb_site_disable_blog,value=false)# No


						</fieldset>
						<!--- Site Maintenance --->
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/logout.png" alt="modifiers"/> <strong>Site Maintenance</strong></legend>
						 	<p>You can put your entire site in maintenance mode if you are doing upgrades or anything funky!</p>
							<!--- Site maintenance --->
							#html.label(field="cb_site_maintenance",content="Site Maintenance:")#
							#html.radioButton(name="cb_site_maintenance",checked=prc.cbSettings.cb_site_maintenance,value=true)# Yes
							#html.radioButton(name="cb_site_maintenance",checked=not prc.cbSettings.cb_site_maintenance,value=false)# No
							<!--- Maintenance Message --->
							#html.label(field="cb_site_maintenance_message",content="Offline Message: ")#
							<small>The message to show users once the site is in maintenance mode, HTML is ok.</small><br/>
							#html.textarea(name="cb_site_maintenance_message",value=prc.cbSettings.cb_site_maintenance_message,rows="3",title="Make it meaningful?")#
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
					<!--- Content Caching Options --->
					<div>
						<fieldset>
							<legend><img src="#prc.cbRoot#/includes/images/database_black.png" alt="modifiers"/>  Content Caching</legend>

							<!--- Content Caching --->
							#html.label(field="cb_content_caching",content="Activate Page rendered content caching:")#
							<small>Page content will be cached once it has been rendered</small><br/>
							#html.radioButton(name="cb_content_caching",checked=prc.cbSettings.cb_content_caching,value=true)# Yes
							#html.radioButton(name="cb_content_caching",checked=not prc.cbSettings.cb_content_caching,value=false)# No

							<!--- Entry Caching --->
							#html.label(field="cb_entry_caching",content="Activate Blog Entry rendered content caching:")#
							<small>Blog entry content will be cached once it has been rendered</small><br/>
							#html.radioButton(name="cb_entry_caching",checked=prc.cbSettings.cb_entry_caching,value=true)# Yes
							#html.radioButton(name="cb_entry_caching",checked=not prc.cbSettings.cb_entry_caching,value=false)# No

							<!--- Custom HTML Caching --->
							#html.label(field="cb_customHTML_caching",content="Activate Custom HTML rendered content caching:")#
							<small>Custom HTML content will be cached once it has been rendered</small><br/>
							#html.radioButton(name="cb_customHTML_caching",checked=prc.cbSettings.cb_customHTML_caching,value=true)# Yes
							#html.radioButton(name="cb_customHTML_caching",checked=not prc.cbSettings.cb_customHTML_caching,value=false)# No

							<!--- Content Cache Name --->
							<label for="cb_content_cacheName">Content Cache Provider:</label>
							<small>Choose the CacheBox provider to cache rendered content (blog,page,customHTML) into.</small><br/>
							#html.select(name="cb_content_cacheName",options=prc.cacheNames,selectedValue=prc.cbSettings.cb_content_cacheName)#

							<!--- Content Cache Timeouts --->
							<label for="cb_content_cachingTimeout">Content Cache Timeouts:</label>
							<small>The number of minutes a rendered content (blog,page,customHTML) is cached for.</small><br/>
							<select name="cb_content_cachingTimeout" id="cb_content_cachingTimeout">
								<cfloop from="5" to="100" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_content_cachingTimeout>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>

							<!--- Content Last Access Timeouts --->
							<label for="cb_rss_cachingTimeoutIdle">Content Cache Idle Timeouts:</label>
							<small>The number of idle minutes allowed for cached rendered content (blog,page,customHTML) to live if not used. Usually this is less than the timeout you selected above</small><br/>
							<select name="cb_content_cachingTimeoutIdle" id="cb_content_cachingTimeoutIdle">
								<cfloop from="5" to="100" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_content_cachingTimeoutIdle>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>

						</fieldset>
					</div>
					<!--- Media Manager --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/media.png" alt="modifiers"/> <strong>Media Manager</strong></legend>
							<p>From here you can control the media manager settings.</p>

							<!--- Location --->
							#html.label(field="",content="Directory Root: ")#
							<small>The absolute path in your server that will be the root of your media manager. Make sure it is web accessible please.</small></br>
							#html.textField(name="cb_media_directoryRoot",required="required",value=prc.cbSettings.cb_media_directoryRoot,class="textfield width98",title="The directory root of all your media files, make sure it is web accessible please")#

							<!--- Create Folders --->
							#html.label(field="cb_media_createFolders",content="Allow Creation of Folders:")#
							#html.radioButton(name="cb_media_createFolders",checked=prc.cbSettings.cb_media_createFolders,value=true)# Yes
							#html.radioButton(name="cb_media_createFolders",checked=not prc.cbSettings.cb_media_createFolders,value=false)# No

							<!--- Delete --->
							#html.label(field="cb_media_allowDelete",content="Allow Deletes:")#
							#html.radioButton(name="cb_media_allowDelete",checked=prc.cbSettings.cb_media_allowDelete,value=true)# Yes
							#html.radioButton(name="cb_media_allowDelete",checked=not prc.cbSettings.cb_media_allowDelete,value=false)# No

							<!--- Downloads --->
							#html.label(field="cb_media_allowDownloads",content="Allow Downloads:")#
							#html.radioButton(name="cb_media_allowDownloads",checked=prc.cbSettings.cb_media_allowDownloads,value=true)# Yes
							#html.radioButton(name="cb_media_allowDownloads",checked=not prc.cbSettings.cb_media_allowDownloads,value=false)# No

							<!--- Uploads --->
							#html.label(field="cb_media_allowUploads",content="Allow Uploads:")#
							#html.radioButton(name="cb_media_allowUploads",checked=prc.cbSettings.cb_media_allowUploads,value=true)# Yes
							#html.radioButton(name="cb_media_allowUploads",checked=not prc.cbSettings.cb_media_allowUploads,value=false)# No

							<!--- Mime Types --->
							#html.label(field="cb_media_acceptMimeTypes",content="Accept Mime Types")#
							<small>The allowed mime types the <em>CFFile Upload</em> will allow (<a href="http://help.adobe.com/en_US/ColdFusion/9.0/CFMLRef/WSc3ff6d0ea77859461172e0811cbec22c24-738f.html" target="_blank">See Reference</a>).</small></br>
							#html.textField(name="cb_media_acceptMimeTypes",value=prc.cbSettings.cb_media_acceptMimeTypes,class="textfield width98",title="The accepted mime types of the CFFile upload action. Blank means all files are accepted.")#

							<!--- Quick View --->
							#html.inputField(type="numeric",name="cb_media_quickViewWidth",label="Quick View Image Width: (pixels)",value=prc.cbSettings.cb_media_quickViewWidth,class="textfield width98",title="The width in pixels of the quick view dialog")#

						</fieldset>
						<!--- Uplodify --->
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/upload.png" alt="modifiers"/> <strong>Uploadify Integration</strong></legend>
							<p>From here you control the <a href="http://www.uploadify.com/" target="_blank">Uploadify</a> integration settings.</p>

							<!--- descrip[tion] --->
							#html.textField(name="cb_media_uplodify_fileDesc",label="File Description Dialog:",required="required",value=prc.cbSettings.cb_media_uplodify_fileDesc,class="textfield width98",title="The text used in the selection dialog window")#
							<!--- file extensions --->
							#html.textField(name="cb_media_uplodify_fileExt",label="File Extensions To Show:",required="required",value=prc.cbSettings.cb_media_uplodify_fileExt,class="textfield width98",title="The extensions to show in the selection dialog window")#
							<!--- multi --->
							#html.label(field="cb_media_uploadify_allowMulti",content="Allow Multiple Uploads:")#
							#html.radioButton(name="cb_media_uploadify_allowMulti",checked=prc.cbSettings.cb_media_uploadify_allowMulti,value=true)# Yes
							#html.radioButton(name="cb_media_uploadify_allowMulti",checked=not prc.cbSettings.cb_media_uploadify_allowMulti,value=false)# No
							<!--- size limit --->
							#html.textField(name="cb_media_uploadify_sizeLimit",label="Size Limit in bytes (0=no limit):",required="required",value=prc.cbSettings.cb_media_uploadify_sizeLimit,class="textfield width98",title="The size limit of the uploads. 0 Means no limit")#
							<!--- Custom JSON Options --->

							#html.label(field="cb_media_uploadify_customOptions",content="Custom JSON Options: ")#
							<small>The following must be valid JSON name value pairs of custom <a href="http://www.uploadify.com/documentation/" target="_blank">uploadify settings</a>.</small><br/>
							#html.textarea(name="cb_media_uploadify_customOptions",value=prc.cbSettings.cb_media_uploadify_customOptions,rows="2",title="Please remember this must be a valid JSON name value pairs")#
						</fieldset>
					</div>
					<!--- Gravatars --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/gravatar.png" alt="modifiers"/> <strong>Gravatars</strong></legend>
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
							#html.label(field="cb_site_email",content="Administrator Email:")#
							<small>The email that receives all notifications</small><br/>
							#html.textField(name="cb_site_email",value=prc.cbSettings.cb_site_email,class="textfield width98",required="required",title="The email that receives all notifications")#
							<!--- Outgoing Email --->
							#html.label(field="cb_site_outgoingEmail",content="Outgoing Email:")#
							<small>The email address that sends all emails out of ContentBox.</small><br/>
							#html.textField(name="cb_site_outgoingEmail",required="required",value=prc.cbSettings.cb_site_outgoingEmail,class="textfield width98",title="The email that sends all email notifications out")#
							<!--- Notification on User Create --->
							#html.label(field="cb_notify_author",content="Send a notification when a user has been created or removed:")#
							#html.radioButton(name="cb_notify_author",checked=prc.cbSettings.cb_notify_author,value=true)# Yes
							#html.radioButton(name="cb_notify_author",checked=not prc.cbSettings.cb_notify_author,value=false)# No

							<!--- Notification on Entry Create --->
							#html.label(field="cb_notify_entry",content="Send a notification when a blog entry has been created or removed:")#
							#html.radioButton(name="cb_notify_entry",checked=prc.cbSettings.cb_notify_entry,value=true)# Yes
							#html.radioButton(name="cb_notify_entry",checked=not prc.cbSettings.cb_notify_entry,value=false)# No

							<!--- Notification on Page Create --->
							#html.label(field="cb_notify_page",content="Send a notification when a page has been created or removed:")#
							#html.radioButton(name="cb_notify_page",checked=prc.cbSettings.cb_notify_page,value=true)# Yes
							#html.radioButton(name="cb_notify_page",checked=not prc.cbSettings.cb_notify_page,value=false)# No
						</fieldset>
						<!--- Mail Server Settings --->
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/email.png" alt="modifiers"/> <strong>Mail Server</strong></legend>
							<p>By default ContentBox will use the mail settings in your application server.  You can override those settings by completing
							   the settings below</p>
							<!--- Mail Server --->
							#html.label(field="cb_site_mail_server",content="Mail Server:")#
							<small>Optional mail server to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
							#html.textField(name="cb_site_mail_server",value=prc.cbSettings.cb_site_mail_server,class="textfield width98",title="The complete mail server URL to use.")#
							<!--- Mail Username --->
							#html.label(field="cb_site_mail_username",content="Mail Server Username:")#
							<small>Optional mail server username or it defaults to the settings in the ColdFusion Administrator</small><br/>
							#html.textField(name="cb_site_mail_username",value=prc.cbSettings.cb_site_mail_username,class="textfield width98",title="The optional mail server username to use.")#
							<!--- Mail Password --->
							#html.label(field="cb_site_mail_password",content="Mail Server Password:")#
							<small>Optional mail server password to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
							#html.passwordField(name="cb_site_mail_password",value=prc.cbSettings.cb_site_mail_password,class="textfield width98",title="The optional mail server password to use.")#
							<!--- SMTP Port --->
							#html.label(field="cb_site_mail_smtp",content="Mail SMTP Port:")#
							<small>The SMTP mail port to use, defaults to port 25.</small><br/>
							#html.inputfield(type="numeric",name="cb_site_mail_smtp",value=prc.cbSettings.cb_site_mail_smtp,class="textfield",size="5",title="The mail SMPT port to use.")#
							<!--- TLS --->
							#html.label(field="cb_site_mail_tls",content="Use TLS:")#
							<small>Whether to use TLS when sending mail or not.</small><br/>
							#html.radioButton(name="cb_site_mail_tls",checked=prc.cbSettings.cb_site_mail_tls,value=true)# Yes
							#html.radioButton(name="cb_site_mail_tls",checked=not prc.cbSettings.cb_site_mail_tls,value=false)# No
							<!--- SSL --->
							#html.label(field="cb_site_mail_ssl",content="Use SSL:")#
							<small>Whether to use SSL when sending mail or not.</small><br/>
							#html.radioButton(name="cb_site_mail_ssl",checked=prc.cbSettings.cb_site_mail_ssl,value=true)# Yes
							#html.radioButton(name="cb_site_mail_ssl",checked=not prc.cbSettings.cb_site_mail_ssl,value=false)# No
						</fieldset>


					</div>
					<!--- Search Options --->
					<div>
						<fieldset>
							<legend><img src="#prc.cbRoot#/includes/images/search_black.png" alt="modifiers"/>  Search Options</legend>

							<!--- Max Search Results --->
							<label for="cb_search_maxResults">Max Search Results:</label>
							<small>The number of search results to show before paging kicks in.</small><br/>
							<select name="cb_search_maxResults" id="cb_search_maxResults">
								<cfloop from="5" to="50" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_search_maxResults>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>

							<!--- Search Adapter --->
							#html.label(field="cb_search_adapter",content="Search Adapter: ")#
							<small>The ContentBox search engine adapter class (instantiation path) to use. You can create your own search engine adapters as
							long as they implement <em>contentbox.model.search.ISearchAdapter</em>. You can choose from our core adapters or
							enter your own CFC instantiation path below.</small><br/>

							<ul>
								<li><a href="javascript:chooseAdapter('contentbox.model.search.DBSearch')">ORM Database Search (contentbox.model.search.DBSearch)</a></li>
							</ul>

							#html.textField(name="cb_search_adapter",size="60",class="textfield",value=prc.cbSettings.cb_search_adapter,required="required",title="Please remember this must be a valid ColdFusion instantiation path")#

						</fieldset>
					</div>
					<!--- RSS Options --->
					<div>
						<fieldset>
							<legend><img src="#prc.cbRoot#/includes/images/feed.png" alt="modifiers"/>  RSS Options</legend>

							<!--- Max RSS Entries --->
							<label for="cb_rss_maxEntries">Max RSS Content Items:</label>
							<small>The number of recent content items to show on the syndication feeds.</small><br/>
							<select name="cb_rss_maxEntries" id="cb_rss_maxEntries">
								<cfloop from="5" to="50" step="5" index="i">
									<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_maxEntries>selected="selected"</cfif>>#i#</option>
								</cfloop>
							</select>

							<!--- Max RSS Comments --->
							<label for="cb_rss_maxComments">Max RSS Content Comments:</label>
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
</cfoutput>