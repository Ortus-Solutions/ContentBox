<cfoutput>
#html.startForm( name="loginSettingsForm", action=prc.xehSaveSettings )#
<fieldset>
	<legend><i class="fa fa-mobile fa-lg"></i> Two Factor Authentication</legend>

	<!--- Global Two Factor Auth --->
	<div class="form-group">
        #html.label(
        	class   = "control-label",
        	field   = "cb_security_2factorAuth_force",
        	content = "Force 2 Factor Authentication"
        )#
        <div class="controls">
            <small>Require all users to setup Two-factor authentication.</small><br/><br />
            #html.checkbox(
				name    = "cb_security_2factorAuth_force_toggle",
				data	= { toggle: 'toggle', match: 'cb_security_2factorAuth_force' },
				checked	= prc.cbSettings.cb_security_2factorAuth_force
			)#

			#html.hiddenField(
				name	= "cb_security_2factorAuth_force",
				value	= prc.cbSettings.cb_security_2factorAuth_force
			)#
        </div>
    </div>

	<!--- Trusted Device Length --->
	<div class="form-group">
		<label class="control-label" for="cb_security_2factorAuth_trusted_days">
			Trusted Device Timespan:
			<span class="badge badge-info" id="cb_security_2factorAuth_trusted_days_label">#prc.cbSettings.cb_security_2factorAuth_trusted_days#</span>
		</label>
		<div class="controls">
			<small>The number of days to trust a device if the two-factor authentication is valid. This is done via an encrypted browser tracking cookie. Once the cookie expires, two-factor authentication will need to be revalidated. Set to <code>0</code> if not used.</small>

			<div>
				<strong class="m10">0</strong>
				<input 	type="text"
						class="form-control slider"
						id="cb_security_2factorAuth_trusted_days"
						name="cb_security_2factorAuth_trusted_days"
						data-slider-value="#prc.cbSettings.cb_security_2factorAuth_trusted_days#"
						data-provide="slider"
						data-slider-min="0"
						data-slider-max="30"
						data-slider-step="1"
						data-slider-tooltip="hide"
				>
				<strong class="m10">30</strong>
			</div>
		</div>
	</div>

    <!--- Default Provider --->
	<div class="form-group">
		<label class="control-label" for="cb_security_2factorAuth_provider">Default Two Factor Provider:</label>
		<div class="controls">
			<small>Choose the default two factor provider that will be used for authentication by all ContentBox users. Please note that each provider could have different setup options. Ultimately, refer to the provider documentation.</small><br/>
            <small class="text-danger"><strong>Note:</strong> Changing the default two factor provider will unenroll all currently enrolled users!</small><br />
			#html.select(
                name            = "cb_security_2factorAuth_provider",
				options         = prc.twoFactorProviders,
				column          = "name",
				nameColumn      = "displayName",
				class           = "form-control input-sm",
				selectedValue   = prc.cbSettings.cb_security_2factorAuth_provider
            )#
            <br />
		</div>
	</div>

	<!--- Event for Two Factor Modules to Add their settings here --->
	#announce( "cbadmin_onTwoFactorSettingsPanel" )#

</fieldset>

<fieldset>
    <legend><i class="fas fa-user-shield fa-lg"></i>  Login Options</legend>

	<!--- Signout URL --->
    <div class="form-group">
        #html.label(
            class   = "control-label",
            field   = "cb_security_login_signout_url",
            content = "After Sign Out URL:"
        )#
        <div class="controls">
            <small>By default a logout takes you to the login screen, you can choose your own sign out URL below.</small><br/>
            #html.URLField(
                name  		= "cb_security_login_signout_url",
                value 		= prc.cbSettings.cb_security_login_signout_url,
                class 		= "form-control",
                title 		= "The URL to relocate a user after logout",
                placeholder = "http://"
            )#
        </div>
    </div>

    <!--- Sign In Text  --->
	<div class="form-group">
		#html.label(
			class       = "control-label",
			field       = "cb_security_login_signin_text",
			content     = "Sign In Text: "
		)#
		<div class="controls">
			<small>Custom text to show in the login screen, HTML/Markdown enabled.</small><br/>
			#html.textarea(
				name  	= "cb_security_login_signin_text",
				value 	= prc.cbSettings.cb_security_login_signin_text,
				class 	= "form-control mde",
				rows  	= "5"
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
