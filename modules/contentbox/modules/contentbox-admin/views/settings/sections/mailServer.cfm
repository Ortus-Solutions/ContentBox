<cfoutput>
#html.startForm( name="mailSettingsForm", action=prc.xehSaveSettings )#
<!--- Mail Server Settings --->
<fieldset>
    <legend><i class="far fa-envelope-open fa-lg"></i> <strong>Mail Server</strong></legend>
    <p>By default ContentBox will use the mail settings in your application server.  You can override those settings by completing
       the settings below</p>
    <!--- Mail Server --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_mail_server",
            content="Mail Server:"
        )#
        <div class="controls">
            <small>Optional mail server to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
            #html.textField(
                name="cb_site_mail_server",
                value=prc.cbSettings.cb_site_mail_server,
                class="form-control",
                title="The complete mail server URL to use."
            )#
        </div>
    </div>
    <!--- Mail Username --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_mail_username",
            content="Mail Server Username:"
        )#
        <div class="controls">
            <small>Optional mail server username or it defaults to the settings in the ColdFusion Administrator</small><br/>
            #html.textField(
                name="cb_site_mail_username",
                value=prc.cbSettings.cb_site_mail_username,
                class="form-control",
                title="The optional mail server username to use."
            )#
        </div>
    </div>
    <!--- Mail Password --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_mail_password",
            content="Mail Server Password:"
        )#
        <div class="controls">
            <small>Optional mail server password to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
            #html.passwordField(
                name="cb_site_mail_password",
                value=prc.cbSettings.cb_site_mail_password,
                class="form-control",
                title="The optional mail server password to use."
            )#
        </div>
    </div>
    <!--- SMTP Port --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_mail_smtp",
            content="Mail SMTP Port:"
        )#
        <div class="controls">
            <small>The SMTP mail port to use,
 defaults to port 25.</small><br/>
            #html.inputfield(
                type="numeric",
                name="cb_site_mail_smtp",
                value=prc.cbSettings.cb_site_mail_smtp,
                class="form-control",
                size="5",
                title="The mail SMPT port to use."
            )#
        </div>
    </div>
    <!--- TLS --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_mail_tls",
            content="Use TLS:"
        )#
        <div class="controls">
            <small>Whether to use TLS when sending mail or not.</small><br /><br />
            #html.checkbox(
				name    = "cb_site_mail_tls_toggle",
				data	= { toggle: 'toggle', match: 'cb_site_mail_tls' },
				checked	= prc.cbSettings.cb_site_mail_tls
			)#
			#html.hiddenField(
				name	= "cb_site_mail_tls",
				value	= prc.cbSettings.cb_site_mail_tls
			)#
        </div>
    </div>
    <!--- SSL --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_mail_ssl",
            content="Use SSL:"
        )#
        <div class="controls">
            <small>Whether to use SSL when sending mail or not.</small><br /><br />
            #html.checkbox(
				name    = "cb_site_mail_ssl_toggle",
				data	= { toggle: 'toggle', match: 'cb_site_mail_ssl' },
				checked	= prc.cbSettings.cb_site_mail_ssl
			)#
			#html.hiddenField(
				name	= "cb_site_mail_ssl",
				value	= prc.cbSettings.cb_site_mail_ssl
			)#
        </div>
    </div>
    <!--- Test Connection --->
    <hr/>
    <div id="emailTestDiv"></div>
    <button id="emailTestButton" class="btn btn-primary" title="Send a test email with these settings" onclick="return emailTest()">
        <i class="fa fa-spinner fa-lg" id="iTest"></i> Test Connection
    </button>
</fieldset>
<!--- Button Bar --->
<div class="form-actions mt20">
	#html.submitButton( value="Save Settings", class="btn btn-danger" )#
</div>

#html.endForm()#
</cfoutput>