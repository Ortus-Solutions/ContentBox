<cfoutput>
<!--- Mail Server Settings --->
#html.startFieldset( legend = "Notification Settings" )#

	<!--- Site Email --->
	<div class="form-group">
		#html.label(
            class   = "control-label",
            field   = "siteEmail",
            content = "*#cb.r( "tab.site.admin@installer" )#"
		)#
		<div class="controls">
			<div class="mb10">
				<small>#cb.r( "tab.site.admin.title@installer" )#</small>
			</div>
			#html.emailField(
				name              = "siteEmail",
				class             = "form-control",
				size              = "100",
				required          = "required"
			)#
		</div>
	</div>

	<!--- Outgoing Email --->
	<div class="form-group">
		#html.label(
            class   = "control-label",
            field   = "siteOutgoingEmail",
            content = "*#cb.r( "tab.site.outgoing@installer" )#"
		)#
		<div class="controls">
			<div class="mb10">
				<small>#cb.r( "tab.site.outgoing.title@installer" )#</small>
			</div>
			#html.emailField(
				name              = "siteOutgoingEmail",
				class             = "form-control",
				size              = "100",
				required          = "required"
			)#
		</div>
	</div>

#html.endFieldSet()#


<!--- Mail Server Settings --->
#html.startFieldset( legend = "Email Server Settings" )#

    <div class="mt10 mb20">
		#cb.r( "tab.email.instructions@installer" )#
	</div>

    <!--- Mail Server --->
    <div class="form-group">
        #html.label(
            class   = "control-label",
            field   = "cb_site_mail_server",
            content = cb.r( "tab.email.server.label@installer" )
        )#
        <div class="controls">
            <div class="mb10">
				<small>#cb.r( "tab.email.server.help@installer" )#</small>
			</div>

            #html.textField(
                name  = "cb_site_mail_server",
                class = "form-control",
                title = cb.r( "tab.email.server.title@installer" )
            )#
        </div>
	</div>

    <!--- Mail Username --->
    <div class="form-group">
        #html.label(
            class   = "control-label",
            field   = "cb_site_mail_username",
            content = cb.r( "tab.email.username.label@installer" )
        )#
        <div class="controls">
            <div class="mb10">
				<small>#cb.r( "tab.email.username.help@installer" )#</small>
			</div>

            #html.textField(
                name  = "cb_site_mail_username",
                class = "form-control",
                title = cb.r( "tab.email.username.title@installer" )
            )#
        </div>
	</div>

    <!--- Mail Password --->
    <div class="form-group">
        #html.label(
            class   = "control-label",
            field   = "cb_site_mail_password",
            content = cb.r( "tab.email.password.label@installer" )
        )#
        <div class="controls">
            <div class="mb10">
				<small>#cb.r( "tab.email.password.help@installer" )#</small>
			</div>

            #html.passwordField(
                name  = "cb_site_mail_password",
                class = "form-control",
                title = cb.r( "tab.email.password.title@installer" )
            )#
        </div>
	</div>

    <!--- SMTP Port --->
    <div class="form-group">
        #html.label(
            class   = "control-label",
            field   = "cb_site_mail_smtp",
            content = cb.r( "tab.email.port@installer" )
        )#
        <div class="controls">
            <div class="mb10">
				<small>#cb.r( "tab.email.port.help@installer" )#</small>
			</div>

            #html.inputfield(
                type  = "numeric",
                value = "25",
                name  = "cb_site_mail_smtp",
                class = "form-control",
                size  = "5",
                title = cb.r( "tab.email.port.title@installer" )
            )#
        </div>
    </div>

    <!--- TLS --->
    <div class="form-group">
        #html.label(
            class   = "control-label",
            field   = "cb_site_mail_tls",
            content = cb.r( "tab.email.tls@installer" )
        )#
        <div class="controls">
            <div class="mb10">
				<small>#cb.r( "tab.email.tls.help@installer" )#</small>
			</div>

            #html.checkbox(
				name    = "cb_site_mail_tls_toggle",
				data	= { toggle: 'toggle', match: 'cb_site_mail_tls' }
			)#

			#html.hiddenField(
				name	= "cb_site_mail_tls",
                value   = false
			)#
        </div>
	</div>

    <!--- SSL --->
    <div class="form-group">
        #html.label(
            class   = "control-label",
            field   = "cb_site_mail_ssl",
            content = cb.r( "tab.email.ssl@installer" )
        )#
        <div class="controls">
            <div class="mb10">
				<small>#cb.r( "tab.email.ssl.help@installer" )#</small>
			</div>

            #html.checkbox(
				name    = "cb_site_mail_ssl_toggle",
				data	= { toggle: 'toggle', match: 'cb_site_mail_ssl' }
			)#

			#html.hiddenField(
				name	= "cb_site_mail_ssl",
                value   = false
			)#
        </div>
    </div>
#html.endFieldSet()#

<!---Toolbar --->
<div class="form-actions">
    <a href="javascript:prevStep()" class="btn btn-primary">
        <i class="fa fa-chevron-left"></i> #cb.r( "tab.previous@installer" )#
    </a>
    <a href="javascript:nextStep()" class="btn btn-primary">
        #cb.r( "tab.next@installer" )# <i class="fa fa-chevron-right"></i>
    </a>
</div>
</cfoutput>