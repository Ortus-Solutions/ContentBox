<cfoutput>
#html.startForm( name="siteSettingsForm", action=prc.xehSaveSettings )#
<fieldset>
	<legend><i class="fas fa-globe fa-lg"></i> All Site Options</legend>

		<!--- Caching of Settings --->
		<div class="form-group">
			<label class="control-label" for="cb_site_settings_cache">Settings Cache Provider:</label>
			<div class="controls">
				<p>Choose the CacheBox provider to cache global site settings into.</p>
				#html.select(
					name			= "cb_site_settings_cache",
					options			= prc.cacheNames,
					selectedValue	= prc.cbSettings.cb_site_settings_cache,
					class			= "form-control"
				)#
			</div>
		</div>

		<!---Blog EntryPoint --->
		<div class="form-group">
			#html.label(
				class   = "control-label",
				field   = "cb_site_blog_entrypoint",
				content = "Blog Entry Point:"
			)#
			<div class="controls">
				<p>
					Choose the entry point in the URL to trigger the blog engine. The usual defaul entry point pattern is
					<code>blog</code>. Do not use symbols or slashes (/ \). This will apply to all registered sites.
				</p>

				<div class="input-group">
					<span class="input-group-addon">https://mysite/</span>
					<input
						name="cb_site_blog_entrypoint"
						id="cb_site_blog_entrypoint"
						type="text"
						class="form-control"
						value="#prc.cbSettings.cb_site_blog_entrypoint#">
				</div>
			</div>
		</div>

	</fieldset>

	<!--- Site Maintenance --->
	<fieldset>
	<legend><i class="fas fa-hand-holding-medical fa-lg"></i> <strong>Maintenance</strong></legend>
		<p>You can put your sites in maintenance mode if you are doing upgrades or anything funky!</p>
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
				<p>The message to show users once the site is in maintenance mode, HTML/Markdown is ok.</p>
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

	<!--- Button Bar --->
	<div class="form-actions mt20">
		#html.submitButton( value="Save Settings", class="btn btn-danger" )#
	</div>

	#html.endForm()#
</cfoutput>