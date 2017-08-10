<cfoutput>
<fieldset>
	<legend><i class="fa fa-cog fa-lg"></i> Site Options</legend>
		<!--- Site Name  --->
		#html.textField(
			name            = "cb_site_name",
			label           = "Site Name:",
			value           = prc.cbSettings.cb_site_name,
			class           = "form-control",
			title           = "The global name of this ContentBox installation",
			wrapper         = "div class=controls",
			labelClass      = "control-label",
			groupWrapper    = "div class=form-group"
		)#

		<!--- Tag Line --->
		#html.textField(
			name            = "cb_site_tagline",
			label           = "Site Tag Line:",
			value           = prc.cbSettings.cb_site_tagline,
			class           = "form-control",
			title           = "A cool tag line that can appear anywhere in your site",
			wrapper         = "div class=controls",
			labelClass      = "control-label",
			groupWrapper    = "div class=form-group"
		)#

		<!--- Description --->
		#html.textarea(
			name            = "cb_site_description",
			label           = "Site Description:",
			value           = prc.cbSettings.cb_site_description,
			rows            = "3",
			class           = "form-control mde",
			title           = "Your site description, also used in the HTML description meta tag",
			wrapper         = "div class=controls",
			labelClass      = "control-label",
			groupWrapper    = "div class=form-group"
		)#

		<!--- Keywords --->
		<div class="form-group">
			<label class="control-label" for="cb_site_keywords">Site Keywords:</label>
			<div class="controls">
				<small>Used in the meta tags of your site.</small><br/>
				#html.textarea(
					name  = "cb_site_keywords",
					value = prc.cbSettings.cb_site_keywords,
					rows  = "3",
					title = "A comma delimited list of keywords to be used in the HTML keywords meta tag",
					class = "form-control"
				)#
			</div>
		</div>

		<!--- HomePage --->
		<div class="form-group">
			<label class="control-label" for="cb_site_homepage">Home Page:</label>
			<div class="controls">
				<small>Choose the latest blog entries or a ContentBox page for the home page of your site.</small><br/>
				<select name="cb_site_homepage" id="cb_site_homepage" class="form-control input-sm">
					<option value="cbBlog" <cfif prc.cbSettings.cb_site_homepage eq "cbBlog">selected="selected"</cfif>>Latest Blog Entries</option>
					<cfloop array="#prc.pages#" index="thisPage" >
					<option value="#thispage.getSlug()#" <cfif prc.cbSettings.cb_site_homepage eq thisPage.getSlug()>selected="selected"</cfif>>#thisPage.getSlug()#</option>
					</cfloop>
				</select>
			</div>
		</div>  

		<!--- Powered by Header --->
		<div class="form-group">
			#html.label(
				class   = "control-label",
				field   = "cb_site_poweredby",
				content = "Send ContentBox Identity Header:"
			)#

			<div class="controls">
				<small>ContentBox will emit an indentiy header <code>x-powered-by:contentbox</code> if enabled.</small><br/><br/>
				#html.checkbox(
					name    = "cb_site_poweredby_toggle",
					data	= { toggle: 'toggle', match: 'cb_site_poweredby' },
					checked	= prc.cbSettings.cb_site_poweredby
				)#
				#html.hiddenField(
					name	= "cb_site_poweredby",
					value	= prc.cbSettings.cb_site_poweredby
				)#
			</div>
		</div>

		<!--- Sitemap --->
		<div class="form-group">
			#html.label(
				class   = "control-label",
				field   = "cb_site_sitemap",
				content = "Enable Sitemap Features:"
			)#
			
			<div class="controls">
				<small>If enabled, you will be able to access the site map via <code>/sitemap</code> and can even add format extensions, e.g: <code>sitemap.json, sitemap.xml, sitemap.txt</code></small><br/><br/>			
				#html.checkbox(
					name    = "cb_site_sitemap_toggle",
					data	= { toggle: 'toggle', match: 'cb_site_sitemap' },
					checked	= prc.cbSettings.cb_site_sitemap
				)#
				#html.hiddenField(
					name	= "cb_site_sitemap",
					value	= prc.cbSettings.cb_site_sitemap
				)#
			</div>
		</div>

		<!--- Site Admin Bar --->
		<div class="form-group">
			#html.label(
				class   = "control-label",
				field   = "cb_site_adminbar",
				content = "Enable Site Admin Bar:"
			)#

			<div class="controls">
				<small>If enabled, logged in and with the right permissions, you will see a ContentBox Floating Admin Bar in your site to help you edit and manage content from the UI.</small><br/><br/>
				#html.checkbox(
					name    = "cb_site_adminbar_toggle",
					data	= { toggle: 'toggle', match: 'cb_site_adminbar' },
					checked	= prc.cbSettings.cb_site_adminbar
				)#
				#html.hiddenField(
					name	= "cb_site_adminbar",
					value	= prc.cbSettings.cb_site_adminbar
				)#
			</div>
		</div>

		<!--- Caching of Settings --->
		<div class="form-group">
			<label class="control-label" for="cb_site_settings_cache">Settings Cache Provider:</label>
			<div class="controls">
				<small>Choose the CacheBox provider to cache global site settings into.</small><br/>
				#html.select(
					name			= "cb_site_settings_cache",
					options			= prc.cacheNames,
					selectedValue	= prc.cbSettings.cb_site_settings_cache,
					class			= "input-sm"
				)#
			</div>
		</div>

	</fieldset>

	<!---Blog Entries --->
	<fieldset>
	<legend><i class="fa fa-quote-left fa-lg"></i> <strong>Blog Options</strong></legend>
		<!--- Disable Blog --->
		<div class="form-group">
			#html.label(
				class="control-label",
				field="cb_site_disable_blog",
				content="Disable Blog:"
			)#
			<div class="controls">
				<small>You can disable the Blog in this entire ContentBox. This does not delete data, it just disables blog features. Also
				remember to change the <strong>Home Page</strong> above to a real page and not the blog.</small><br/><br/>
				#html.checkbox(
					name    = "cb_site_disable_blog_toggle",
					data	= { toggle: 'toggle', match: 'cb_site_disable_blog' },
					checked	= prc.cbSettings.cb_site_disable_blog
				)#
				#html.hiddenField(
					name	= "cb_site_disable_blog",
					value	= prc.cbSettings.cb_site_disable_blog
				)#
			</div>
		</div>  
		<!--- Entry Point --->
		<div class="form-group">
			#html.label(class="control-label",field="cb_site_blog_entrypoint",content="Blog Entry Point:" )#
			<div class="controls">
				<small>Choose the entry point in the URL to trigger the blog engine. The usual defaul entry point pattern is 
				<strong>blog</strong>. Do not use symbols or slashes (/ \)<br/></small>
				<code>#prc.cb.linkHome()#</code> 
				#html.textField(
					name="cb_site_blog_entrypoint", 
					value=prc.cbSettings.cb_site_blog_entrypoint, 
					class="form-control"
				)#
			</div>
		</div>  
	</fieldset>
	<!--- Site Maintenance --->
	<fieldset>
	<legend><i class="fa fa-ambulance fa-lg"></i> <strong>Site Maintenance</strong></legend>
		<p>You can put your entire site in maintenance mode if you are doing upgrades or anything funky!</p>
		<!--- Site maintenance --->
		<div class="form-group">
			#html.label(
				class 	= "control-label",
				field 	= "cb_site_maintenance",
				content = "Site Maintenance:"
			)#
			<div class="controls">
				#html.checkbox(
					name    = "cb_site_maintenance_toggle",
					data	= { toggle: 'toggle', match: 'cb_site_maintenance' },
					checked	= prc.cbSettings.cb_site_maintenance
				)#
				#html.hiddenField(
					name	= "cb_site_maintenance",
					value	= prc.cbSettings.cb_site_maintenance
				)#
			</div>
		</div>
		<!--- Maintenance Message --->
		<div class="form-group">
			#html.label(class="control-label",field="cb_site_maintenance_message",content="Offline Message: " )#
			<div class="controls">
				<small>The message to show users once the site is in maintenance mode, HTML/Markdown is ok.</small><br/>
				#html.textarea(
					name  = "cb_site_maintenance_message",
					value = prc.cbSettings.cb_site_maintenance_message,
					class = "form-control mde",
					rows  = "3",
					title = "Make it meaningful?"
				)#
			</div>
		</div>
	</fieldset>
</cfoutput>