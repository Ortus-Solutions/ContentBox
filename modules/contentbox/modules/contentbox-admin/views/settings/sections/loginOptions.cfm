<cfoutput>

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

</fieldset>



<fieldset>
    <legend><i class="fa fa-cogs fa-lg"></i>  Login Options</legend>

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
</cfoutput>
