<cfoutput>
<fieldset>
	<legend><i class="fa fa-paw fa-lg"></i> Login Tracker</legend>
	
	<!--- Login Blocker --->
	<div class="form-group">
        #html.label(class="control-label",field="cb_security_login_blocker",content="Enable Login Tracker:" )#
        <div class="controls">
            <small>When enabled, all logins attempts will by tracked and blocking is enabled if too many attempts occur.</small><br/>
			#html.radioButton(name="cb_security_login_blocker",checked=prc.cbSettings.cb_security_login_blocker,value=true)# Yes
			#html.radioButton(name="cb_security_login_blocker",checked=not prc.cbSettings.cb_security_login_blocker,value=false)# No
        </div>
    </div>

    <!--- Max Attempts --->
	<div class="form-group">
        <label class="control-label" for="cb_security_max_attempts">Max Invalid Attempts To Block:</label>
        <div class="controls">
            <small>The number of invalid login attempts before a user is blocked.</small><br/>
			<select name="cb_security_max_attempts" id="cb_security_max_attempts">
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
			<select name="cb_security_blocktime" id="cb_security_blocktime">
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
			<select name="cb_security_max_auth_logs" id="cb_security_max_auth_logs">
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
            <small>When enabled, it will keep track of requests and apply rate limiting according to count and duration settings according to client IP Address.</small><br/>
			#html.radioButton( name="cb_security_rate_limiter", checked=prc.cbSettings.cb_security_rate_limiter, value=true )# Yes
			#html.radioButton( name="cb_security_rate_limiter", checked=not prc.cbSettings.cb_security_rate_limiter, value=false )# No
        </div>
    </div>

    <!--- Bot Limiter --->
	<div class="form-group">
        #html.label( class="control-label", field="cb_security_rate_limiter_bots_only", content="Enable For Automated Requests Only:" )#
        <div class="controls">
            <small>When enabled, it will apply rate limiting only for cookie-less requests. If disabled, it will limit ALL requests, including "legit" user requests. Usually, automated scripts and DOS attacks have no cookies enabled.</small><br/>
			#html.radioButton( name="cb_security_rate_limiter_bots_only", checked=prc.cbSettings.cb_security_rate_limiter_bots_only, value=true )# Yes
			#html.radioButton( name="cb_security_rate_limiter_bots_only", checked=not prc.cbSettings.cb_security_rate_limiter_bots_only, value=false )# No
        </div>
    </div>

    <!--- Limiter Count --->
    <div class="form-group">
        <label class="control-label" for="cb_security_rate_limiter_count">Limiter Count:</label>
        <div class="controls">
            <small>Throttle requests made more than this count in the duration specified.</small><br/>
			<select name="cb_security_rate_limiter_count" id="cb_security_rate_limiter_count">
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
			<select name="cb_security_rate_limiter_duration" id="cb_security_rate_limiter_duration">
				<cfloop from="1" to="25" step="1" index="i">
					<option value="#i#" <cfif i eq prc.cbSettings.cb_security_rate_limiter_duration>selected="selected"</cfif>>#i#</option>
				</cfloop>
			</select>
        </div>
	</div>

    <!--- Bot Regex Matching --->
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
            <small>You can enable SSL encryption for the administrator module.</small><br/>
            #html.radioButton(
                name="cb_admin_ssl",
                checked=prc.cbSettings.cb_admin_ssl,
                value=true
            )# Yes
            #html.radioButton(
                name="cb_admin_ssl",
                checked=not prc.cbSettings.cb_admin_ssl,
                value=false
            )# No
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
            <small>You can enable SSL encryption for the entire site.</small><br/>
            #html.radioButton(
                name="cb_site_ssl",
                checked=prc.cbSettings.cb_site_ssl,
                value=true
            )# Yes
            #html.radioButton(
                name="cb_site_ssl",
                checked=not prc.cbSettings.cb_site_ssl,
                value=false
            )# No
        </div>
    </div>  
</fieldset>
</cfoutput>
