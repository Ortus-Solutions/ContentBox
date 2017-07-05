<cfoutput>
<fieldset>
	<legend><i class="fa fa-lock fa-lg"></i> Password Options</legend>

	<!--- Min Password Length --->
	<div class="form-group">
		<label class="control-label" for="cb_security_min_password_length">
			Minimum Password Length:
			<span class="badge badge-info" id="min_password_length">#prc.cbSettings.cb_security_min_password_length#</span>
		</label>
		<div class="controls">
			<small>The minimum length for user passwords. ContentBox limits the minimum to 8 characters.</small>

			<div>
				<strong class="margin10">8</strong>
				<input 	type="text"
						class="form-control"
						id="cb_security_min_password_length"
						name="cb_security_min_password_length"
						data-slider-value="#prc.cbSettings.cb_security_min_password_length#"
						data-provide="slider"
						data-slider-min="8"
						data-slider-max="50"
						data-slider-step="1"
						data-slider-tooltip="hide"
				>
				<strong class="margin10">50</strong>
			</div>
		</div>
	</div>

</fieldset>

<fieldset>
	<legend><i class="fa fa-paw fa-lg"></i> Login Tracker</legend>

	<!--- Login Blocker --->
	<div class="form-group">
        #html.label( class="control-label", field="cb_security_login_blocker", content="Enable Login Tracker:" )#
        <div class="controls">
            <small>When enabled, all logins attempts will by tracked and blocking is enabled if too many attempts occur.</small><br/><br />
            #html.checkbox(
				name    = "cb_security_login_blocker_toggle",
				data	= { toggle: 'toggle', match: 'cb_security_login_blocker' },
				checked	= prc.cbSettings.cb_security_login_blocker
			)#

			#html.hiddenField(
				name	= "cb_security_login_blocker",
				value	= prc.cbSettings.cb_security_login_blocker
			)#
        </div>
    </div>

    <!--- Max Attempts --->
	<div class="form-group">
        <label class="control-label" for="cb_security_max_attempts">Max Invalid Attempts To Block:</label>
        <div class="controls">
            <small>The number of invalid login attempts before a user is blocked.</small><br/>
			<select name="cb_security_max_attempts" class="form-control" id="cb_security_max_attempts">
				<cfloop from="5" to="50" step="5" index="i">
					<option value="#i#" <cfif i eq prc.cbSettings.cb_security_max_attempts>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
        </div>
    </div>

    <!--- Block Time--->
	<div class="form-group">
        <label class="control-label" for="cb_security_blocktime">Minutes To Block:</label>
        <div class="controls">
            <small>The number of minutes a user will be blocked if max attempts is triggered.</small><br/>
			<select name="cb_security_blocktime" class="form-control" id="cb_security_blocktime">
				<cfloop from="5" to="60" step="5" index="i">
					<option value="#i#" <cfif i eq prc.cbSettings.cb_security_blocktime>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
        </div>
    </div>

    <!--- Max Auth Logs --->
	<div class="form-group">
        <label class="control-label" for="cb_security_max_auth_logs">Max Auth Logs:</label>
        <div class="controls">
            <small>The number of log entries to keep before rotating logs.</small><br/>
			<select name="cb_security_max_auth_logs" class="form-control" id="cb_security_max_auth_logs">
				<cfloop from="100" to="2000" step="100" index="i">
					<option value="#i#" <cfif i eq prc.cbSettings.cb_security_max_auth_logs>selected="selected"</cfif>>#i#</option>
				</cfloop>
				<option value="" <cfif prc.cbSettings.cb_security_max_auth_logs eq "">selected="selected"</cfif>>Unlimited</option>
			</select>
        </div>
    </div>

</fieldset>

<fieldset>
	<legend><i class="fa fa-filter"></i> <strong>Rate Limiter</strong></legend>
	<!--- Rate Limiter --->
	<div class="form-group">
        #html.label( class="control-label", field="cb_security_rate_limiter", content="Enable Rate Limiter:" )#
        <div class="controls">
            <small>When enabled, it will keep track of requests and apply rate limiting according to count and duration settings according to client IP Address.</small><br/><br />
            #html.checkbox(
				name    = "cb_security_rate_limiter_toggle",
				data	= { toggle: 'toggle', match: 'cb_security_rate_limiter' },
				checked	= prc.cbSettings.cb_security_rate_limiter
			)#
			#html.hiddenField(
				name	= "cb_security_rate_limiter",
				value	= prc.cbSettings.cb_security_rate_limiter
			)#
        </div>
    </div>

    <!--- Rate Limiter logging --->
    <div class="form-group">
        #html.label( class="control-label", field="cb_security_rate_limiter_logging", content="Enable Rate Limiter Logging:" )#
        <div class="controls">
            <small>When enabled, and if an IP is rate limited then ContentBox will log the blocked event using the system logs.</small><br/><br />
            #html.checkbox(
                name    = "cb_security_rate_limiter_logging_toggle",
                data    = { toggle: 'toggle', match: 'cb_security_rate_limiter_logging' },
                checked = prc.cbSettings.cb_security_rate_limiter_logging
            )#
            #html.hiddenField(
                name    = "cb_security_rate_limiter_logging",
                value   = prc.cbSettings.cb_security_rate_limiter_logging
            )#
        </div>
    </div>

    <!--- Bot Limiter --->
	<div class="form-group">
        #html.label( class="control-label", field="cb_security_rate_limiter_bots_only", content="Enable For Automated Requests Only:" )#
        <div class="controls">
            <small>When enabled, it will apply rate limiting only for cookie-less requests. If disabled, it will limit ALL requests, including "legit" user requests. Usually, automated scripts and DOS attacks have no cookies enabled.</small><br/><br />
            #html.checkbox(
				name    = "cb_security_rate_limiter_bots_only_toggle",
				data	= { toggle: 'toggle', match: 'cb_security_rate_limiter_bots_only' },
				checked	= prc.cbSettings.cb_security_rate_limiter_bots_only
			)#
			#html.hiddenField(
				name	= "cb_security_rate_limiter_bots_only",
				value	= prc.cbSettings.cb_security_rate_limiter_bots_only
			)#
        </div>
    </div>

    <!--- Limiter Count --->
    <div class="form-group">
        <label class="control-label" for="cb_security_rate_limiter_count">Limiter Count:</label>
        <div class="controls">
            <small>Throttle requests made more than this count in the duration specified.</small><br/>
			<select name="cb_security_rate_limiter_count" class="form-control" id="cb_security_rate_limiter_count">
				<cfloop from="1" to="25" step="1" index="i">
					<option value="#i#" <cfif i eq prc.cbSettings.cb_security_rate_limiter_count>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
        </div>
	</div>

	<!--- Limiter Duration --->
    <div class="form-group">
        <label class="control-label" for="cb_security_rate_limiter_duration">Limiter Duration (Seconds):</label>
        <div class="controls">
            <small>Throttle requests made more than the count above in the span of this setting in seconds.</small><br/>
			<select name="cb_security_rate_limiter_duration" class="form-control" id="cb_security_rate_limiter_duration">
				<cfloop from="1" to="25" step="1" index="i">
					<option value="#i#" <cfif i eq prc.cbSettings.cb_security_rate_limiter_duration>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
        </div>
	</div>

    <!--- Limiter Message --->
    <div class="form-group">
        #html.label( field="cb_security_rate_limiter_message", class="control-label", content="Limiter Message:" )#
        <div class="controls">
            <small>The message displayed to users when the rate limit has been exceeded. A 503 status header is also sent in the response.The <code>{duration}</code> element will be replaced with the setting at runtime.</small>
            #html.textarea(
            	name 	= "cb_security_rate_limiter_message",
            	class 	= "form-control",
            	value 	= prc.cbSettings.cb_security_rate_limiter_message,
            	rows 	= "4"
            )#
        </div>
    </div>

    <div class="form-group">
        #html.label( field="cb_security_rate_limiter_redirectURL", class="control-label", content="Limiter Redirect URL:" )#
        <div class="controls">
            <small>If you fill out this URL, then instead of showing the above limiter message, we will redirect (302) the request to this URL.</small>
            #html.URLField(
                name    = "cb_security_rate_limiter_redirectURL",
                class   = "form-control",
                value   = prc.cbSettings.cb_security_rate_limiter_redirectURL
            )#
        </div>
    </div>

</fieldset>

<fieldset>
    <legend><i class="fa fa-lock fa-lg"></i>  Secure Sockets Layer (SSL) Encryption</legend>
	<!--- Admin SSL --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_admin_ssl",
            content="Admin Force SSL (Secure Sockets Layer):"
        )#
        <div class="controls">
            <small>You can enable SSL encryption for the administrator module.</small><br /><br />
            #html.checkbox(
				name    = "cb_admin_ssl_toggle",
				data	= { toggle: 'toggle', match: 'cb_admin_ssl' },
				checked	= prc.cbSettings.cb_admin_ssl
			)#
			#html.hiddenField(
				name	= "cb_admin_ssl",
				value	= prc.cbSettings.cb_admin_ssl
			)#
        </div>
    </div>

	<!--- Site SSL --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_ssl",
            content="Site Force SSL (Secure Sockets Layer):"
        )#
        <div class="controls">
            <small>You can enable SSL encryption for the entire site.</small><br /><br />
            #html.checkbox(
				name    = "cb_site_ssl_toggle",
				data	= { toggle: 'toggle', match: 'cb_site_ssl' },
				checked	= prc.cbSettings.cb_site_ssl
			)#
			#html.hiddenField(
				name	= "cb_site_ssl",
				value	= prc.cbSettings.cb_site_ssl
			)#
        </div>
    </div>
</fieldset>
</cfoutput>
