<cfoutput>
<!--- Mail Server Settings --->
#html.startFieldset(legend=cb.r( "tab.email@installer" ) )#
    #cb.r( "tab.email.instructions@installer" )#
    
    <!--- Mail Server --->
    <div class="form-group">
        #html.label( 
            class="control-label",
            field="cb_site_mail_server",
            content=cb.r( "tab.email.server.label@installer" ) 
        )#
        <div class="controls">
            <small>#cb.r( "tab.email.server.help@installer" )#</small><br/>
            #html.textField( 
                name="cb_site_mail_server",
                class="form-control",
                title=cb.r( "tab.email.server.title@installer" ) 
            )#
        </div>
    </div>
    <!--- Mail Username --->
    <div class="form-group">
        #html.label( 
            class="control-label",
            field="cb_site_mail_username",
            content=cb.r( "tab.email.username.label@installer" ) 
        )#
        <div class="controls">
            <small>#cb.r( "tab.email.username.help@installer" )#</small><br/>
            #html.textField( 
                name="cb_site_mail_username",
                class="form-control",
                title=cb.r( "tab.email.username.title@installer" )
            )#
        </div>
    </div>
    <!--- Mail Password --->
    <div class="form-group">
        #html.label( 
            class="control-label",
            field="cb_site_mail_password",
            content=cb.r( "tab.email.password.label@installer" ) 
        )#
        <div class="controls">
            <small>#cb.r( "tab.email.password.help@installer" )#</small><br/>
            #html.passwordField( 
                name="cb_site_mail_password",
                class="form-control",
                title=cb.r( "tab.email.password.title@installer" ) 
            )#
        </div>
    </div>
    <!--- SMTP Port --->
    <div class="form-group">
        #html.label( 
            class="control-label",
            field="cb_site_mail_smtp",
            content=cb.r( "tab.email.port@installer" ) 
        )#
        <div class="controls">
            <small>#cb.r( "tab.email.port.help@installer" )#</small><br/>
            #html.inputfield( 
                type="numeric",
                value="25",
                name="cb_site_mail_smtp",
                class="form-control",
                size="5",
                title=cb.r( "tab.email.port.title@installer" ) 
            )#
        </div>
    </div>
    
    
    <!--- TLS --->
    <div class="form-group">
        #html.label( 
            class="control-label", 
            field="cb_site_mail_tls", 
            content=cb.r( "tab.email.tls@installer" ) 
        )#
        <div class="controls">
            <small>#cb.r( "tab.email.tls.help@installer" )#</small><br/>
            #html.radioButton( 
                name="cb_site_mail_tls",
                value=true 
            )# #cb.r( "common.yes@installer" )#  
            #html.radioButton( 
                name="cb_site_mail_tls",
                checked="true",
                value=false 
            )# #cb.r( "common.no@installer" )# 
        </div>
    </div>
    <!--- SSL --->
    <div class="form-group">
        #html.label( 
            class="control-label",
            field="cb_site_mail_ssl",
            content=cb.r( "tab.email.ssl@installer" ) 
        )#
        <div class="controls">
            <small>#cb.r( "tab.email.ssl.help@installer" )#</small><br/>
            #html.radioButton( 
                name="cb_site_mail_ssl",
                value=true 
            )# #cb.r( "common.yes@installer" )#  
            #html.radioButton( 
                name="cb_site_mail_ssl",
                checked=true,
                value=false 
            )# #cb.r( "common.no@installer" )# 
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