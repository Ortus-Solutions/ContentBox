<cfoutput>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-lightbulb-o"></i> #cb.r( "labels.wizard@installer" )#</h3>
    </div>
    <div class="panel-body">
        #html.startForm( 
            action="cbinstaller/install", 
            name="installerForm", 
            novalidate="novalidate", 
            class="form-vertical" 
        )#
            <div class="tab-wrapper tab-left tab-primary">
                <!--- Tabs --->
                <ul class="nav nav-tabs">
                    <li class="active"><a href="##introduction" class="current" data-toggle="tab">#cb.r( "tab.intro@installer" )#</a></li>
                    <li><a href="##step1" data-toggle="tab">1: #cb.r( "tab.admin@installer" )#</a></li>
                    <li><a href="##step2" data-toggle="tab">2: #cb.r( "tab.site@installer" )#</a></li>
                    <li><a href="##step3" data-toggle="tab">3: #cb.r( "tab.email@installer" )#</a></li>
                    <li><a href="##step4" data-toggle="tab">4: #cb.r( "tab.rewrites@installer" )#</a></li>
                </ul>

                <div class="tab-content">
                    <!--- ****************************************************************************** --->
                    <!--- Intro Panel --->
                    <!--- ****************************************************************************** --->
                    <div class="jumbotron tab-pane active" id="introduction">
                        <h1>#cb.r( "tab.intro.title@installer" )#</h1>
                        #cb.r( "tab.intro.message@installer" )#
                        
                        <a href="javascript:nextStep()" class="btn btn-primary btn-large">
                            <i class="fa fa-check"></i> #cb.r( "tab.intro.start@installer" )#
                        </a>
                    </div>
                    <!--- end panel 1 --->
                    
                    <!--- ****************************************************************************** --->
                    <!--- Step 1 : Admin Setup--->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step1">
                        <!--- Admin Info --->
                        #html.startFieldset( legend=cb.r( "tab.admin@installer" ) )#
                        <p>
                            #cb.r( "tab.admin.instructions@installer" )#
                        </p>
                        <!--- Fields --->
                        #html.textField(
                            name="firstName",
                            label=cb.r( "tab.admin.lname@installer" ),
                            required="required",
                            size="100",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        #html.textField(
                            name="lastName",
                            label=cb.r( "tab.admin.fname@installer" ),
                            required="required",
                            size="100",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        #html.inputField(
                            name="email",
                            type="email",
                            label=cb.r( "tab.admin.email@installer" ),
                            required="required",
                            size="100",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        #html.textField(
                            name="username",
                            label=cb.r( "tab.admin.username@installer" ),
                            required="required",
                            size="100",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        #html.passwordField(
                            name="password",
                            label=cb.r( "tab.admin.password@installer" ),
                            required="required",
                            size="100",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        #html.passwordField(
                            name="password_confirm",
                            label=cb.r( "tab.admin.password_confirm@installer" ),
                            required="required",
                            size="100",
                            class="form-control passwordmatch",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        
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
                    </div>
                    
                    <!--- ****************************************************************************** --->
                    <!--- Step 2 : Site Setup--->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step2">  
                        <!--- Site Info --->
                        #html.startFieldset( legend=cb.r( "tab.site@installer" ) )#
                        #cb.r( "tab.site.instructions@installer" )#
                        
                        <!--- Populate With Sample Data --->
                        <div class="form-group">
                            #html.label( 
                                field="populatedata", 
                                content=cb.r( "tab.site.sampledata@installer" ), 
                                class="control-label" 
                            )#
                            <div class="controls">
                                #html.radioButton( 
                                    name="populatedata", 
                                    checked=true, 
                                    value=true,
                                    autocomplete=false 
                                )# #cb.r( "common.yes@installer" )#  

                                #html.radioButton( 
                                    name="populatedata", 
                                    value=false, 
                                    autocomplete=false 
                                )# #cb.r( "common.no@installer" )#  
                            </div>
                        </div>
                        <!--- Site Name  --->
                        #html.textField( 
                            name="siteName",
                            label=cb.r( "tab.site.sitename@installer" ),
                            class="form-control",
                            size="100",
                            title=cb.r( "tab.site.sitename.title@installer" ),
                            required="required",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        <!--- Site Email --->
                        #html.inputField( 
                            name="siteEmail",
                            type="email",
                            label=cb.r( "tab.site.admin@installer" ),
                            class="form-control",
                            size="100",
                            title=cb.r( "tab.site.admin.title@installer" ),
                            required="required",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        <!--- Outgoing Email --->
                        #html.inputField( 
                            name="siteOutgoingEmail",
                            type="email",
                            label=cb.r( "tab.site.outgoing@installer" ),
                            class="form-control",
                            size="100",
                            title=cb.r( "tab.site.outgoing.title@installer" ),
                            required="required",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        <!--- Tag Line --->
                        #html.textField( 
                            name="siteTagLine",
                            label=cb.r( "tab.site.tagline@installer" ),
                            class="form-control",
                            size="100",
                            title=cb.r( "tab.site.tagline.title@installer" ),
                            required="required",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        <!--- Description --->
                        #html.textarea( 
                            name="siteDescription",
                            label=cb.r( "tab.site.description@installer" ),
                            rows="3",
                            class="form-control",
                            title=cb.r( "tab.site.description.title@installer" ),
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#        
                        <!--- Keywords --->
                        #html.textarea( 
                            name="siteKeywords",
                            label=cb.r( "tab.site.keywords@installer" ),
                            rows="3",
                            class="form-control",
                            title=cb.r( "tab.site.keywords.title@installer" ),
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#     
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
                    </div>
                    
                    <!--- ****************************************************************************** --->
                    <!--- Step 3 : Email Setup--->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step3">  
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
                    </div>
                        
                    <!--- ****************************************************************************** --->
                    <!--- Step 4 : Site URL Rewrites --->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step4">  
                        <!--- URL Rewrites --->
                        #html.startFieldset( legend=cb.r( "tab.rewrites@installer" ) )#
                        <p>
                            #cb.r( "tab.rewrites.intro@installer" )#
                            <a href="http://httpd.apache.org/docs/current/mod/mod_rewrite.html">Apache mod_rewrite</a>,
 
                            <a href="http://www.tuckey.org/urlrewrite/">Tuckey URL Rewrite</a> #cb.r( "common.or@installer" )# 
                            <a href="http://www.iis.net/download/urlrewrite">IIS 7 Rewrite</a>.
                            #cb.r( "tab.rewrites.intro2@installer" )#
                        </p>
                        
                        <div class="alert">
                            #cb.r( "tab.rewrites.alert@installer" )#
                        </div>
                        
                        <!--- Rewrites --->
                        <div class="form-group">
                            #html.label( 
                                class="control-label",
                                field="fullrewrite",
                                content=cb.r( "tab.rewrites.enable@installer" ) 
                            )#    
                            <div class="controls">
                                <label>
                                    #html.radioButton( 
                                        name="fullrewrite",
                                        value=true 
                                    )# #cb.r( "common.yes@installer" )#</label>
                                #html.select( 
                                    options="contentbox_express,mod_rewrite,iis7",
                                    name="rewrite_engine",
                                    class="input-sm"
                                )#
                                <br/>
                                <label>
                                    #html.radioButton( 
                                        name="fullrewrite",
                                        checked=true,
                                        value=false 
                                    )# #cb.r( "common.no@installer" )#     
                                </label>
                            </div>
                        </div>
                        #html.endFieldSet()#
                        
                        <!--- Action Bar --->
                        <div class="form-actions">
                            <a href="javascript:prevStep()" class="btn btn-primary">
                                <i class="fa fa-chevron-left"></i> #cb.r( "tab.previous@installer" )#
                            </a>
                            #html.button( 
                                type="submit",
                                name="submit",
                                value="<i class='fa fa-check'></i> #cb.r( 'tab.start@installer' )#",
                                class="btn btn-danger",
                                title=cb.r( 'tab.start.title@installer' ) 
                            )#
                        </div>
                        
                    </div>                      
                    <!---Error Bar --->
                    <div id="errorBar"></div>
                </div>
                <!--- End Tab Content --->
            </div>
        #html.endForm()#
    </div>
</div>
</cfoutput>