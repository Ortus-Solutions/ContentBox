<cfoutput>
#html.startForm(action="cbinstaller/install",name="installerForm",novalidate="novalidate",class="form-vertical")#
<div class="row-fluid">
	<div class="box">
		<div class="header">
			<i class="icon-lightbulb icon-large"></i> #cb.r( "labels.wizard@installer" )#
		</div>
        <div class="body">
    		<!--- Vertical Nav --->
    		<div class="tabbable tabs-left">
    			<!--- Tabs --->
    			<ul class="nav nav-tabs">
    				<li class="active"><a href="##introduction" class="current" data-toggle="tab">Introduction</a></li>
    				<li><a href="##step1" data-toggle="tab">1: Administrator</a></li>
    				<li><a href="##step2" data-toggle="tab">2: Site Setup</a></li>
    				<li><a href="##step3" data-toggle="tab">3: Email Setup</a></li>
    				<li><a href="##step4" data-toggle="tab">4: URL Rewrites</a></li>
    			</ul>
    			<!--- Tab Content --->
    			<div class="tab-content">
    					
    				<!--- ****************************************************************************** --->
    				<!--- Intro Panel --->
    				<!--- ****************************************************************************** --->
    				<div class="hero-unit tab-pane active" id="introduction">
    					<h1>Welcome To ContentBox!</h1>
    					<p>
    						We have detected that your <strong>ContentBox</strong> is not setup yet, so let's get you up and running in no time.
    						You have already done the first step, which is created the datasource in which ContentBox will run under.
    						What you might not know, is that we already created the entire database structure for you, we now just need
    						a little information from you to get <strong>ContentBox</strong> ready for prime time.
    					</p>
    					<p>
    						So what are you waiting for? Let's get started!
    					</p>
    					
    					<a href="javascript:nextStep()" class="btn btn-primary btn-large"><i class="icon-ok"></i> Start Installer</a>
    				</div>
    				<!--- end panel 1 --->
    				
    				<!--- ****************************************************************************** --->
    				<!--- Step 1 : Admin Setup--->
    				<!--- ****************************************************************************** --->
    				<div class="tab-pane well" id="step1">
    					<!--- Admin Info --->
    					#html.startFieldset(legend="Administrator")#
    					<p>
    						Fill out the following information to setup your ContentBox administrator.
    					</p>
    					<!--- Fields --->
    					#html.textField(name="firstName",label="First Name:",required="required",size="100",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					#html.textField(name="lastName",label="Last Name:",required="required",size="100",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					#html.inputField(name="email",type="email",label="Email:",required="required",size="100",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					#html.textField(name="username",label="Username:",required="required",size="100",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					#html.passwordField(name="password",label="Password:",required="required",size="100",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					#html.passwordField(name="password_confirm",label="Confirm Password:",required="required",size="100",class="textfield passwordmatch",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					#html.endFieldSet()#
    					
    					<!---Toolbar --->
    					<div class="form-actions">
    						<a href="javascript:prevStep()" class="btn btn-primary"><i class="icon-chevron-left"></i> Previous Step</a>
    						<a href="javascript:nextStep()" class="btn btn-primary">Next Step <i class="icon-chevron-right"></i></a>
    					</div>
    				</div>
    				
    				<!--- ****************************************************************************** --->
    				<!--- Step 2 : Site Setup--->
    				<!--- ****************************************************************************** --->
    				<div class="tab-pane well" id="step2">	
    					<!--- Site Info --->
    					#html.startFieldset(legend="Site Information")#
    					<p>
    						Let's get some information about your site.
    					</p>
    					
    					<!--- Populate With Sample Data --->
						<div class="control-group">
						    #html.label(field="populatedata",content="Populate Site With Sample Data:",class="control-label")#
                            <div class="controls">
                                #html.radioButton(name="populatedata",checked=true,value=true,autocomplete=false)# Yes 	
    							#html.radioButton(name="populatedata",value=false,autocomplete=false)# No 	
                            </div>
						</div>
    					<!--- Site Name  --->
    					#html.textField(name="siteName",label="Site Name:",class="textfield",size="100",title="The global name of this ContentBox installation",required="required",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					<!--- Site Email --->
    					#html.inputField(name="siteEmail",type="email",label="Administrator Email:",class="textfield",size="100",title="The email that receives all notifications from ContentBox",required="required",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					<!--- Outgoing Email --->
    					#html.inputField(name="siteOutgoingEmail",type="email",label="Outgoing Email:",class="textfield",size="100",title="The email that sends all email notifications out of ContentBox",required="required",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					<!--- Tag Line --->
    					#html.textField(name="siteTagLine",label="Site Tag Line:",class="textfield",size="100",title="A cool tag line that can appear anywhere in your site",required="required",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					<!--- Description --->
    					#html.textarea(name="siteDescription",label="Site Description:",rows="3",title="Your site description, also used in the HTML description meta tag",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#		
    					<!--- Keywords --->
    					#html.textarea(name="siteKeywords",label="Site Keywords:",rows="3",title="A comma delimited list of keywords to be used in the HTML keywords meta tag",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#		
    					#html.endFieldSet()#
    					
    					<!---Toolbar --->
    					<div class="form-actions">
    						<a href="javascript:prevStep()" class="btn btn-primary"><i class="icon-chevron-left"></i> Previous Step</a>
    						<a href="javascript:nextStep()" class="btn btn-primary">Next Step <i class="icon-chevron-right"></i></a>
    					</div>
    				</div>
    				
    				<!--- ****************************************************************************** --->
    				<!--- Step 3 : Email Setup--->
    				<!--- ****************************************************************************** --->
    				<div class="tab-pane well" id="step3">	
    					<!--- Mail Server Settings --->
    					#html.startFieldset(legend="Email Setup")#
    						<p>By default ContentBox will use the mail settings in your application server.  You can override those settings by completing
    						   the settings below</p>
    						<!--- Mail Server --->
							<div class="control-group">
							    #html.label(class="control-label",field="cb_site_mail_server",content="Mail Server:")#
                                <div class="controls">
                                    <small>Optional mail server to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
    								#html.textField(name="cb_site_mail_server",class="textfield width98",title="The complete mail server URL to use.")#
                                </div>
							</div>
    						<!--- Mail Username --->
							<div class="control-group">
							    #html.label(class="control-label",field="cb_site_mail_username",content="Mail Server Username:")#
                                <div class="controls">
                                    <small>Optional mail server username or it defaults to the settings in the ColdFusion Administrator</small><br/>
    								#html.textField(name="cb_site_mail_username",class="textfield width98",title="The optional mail server username to use.")#
                                </div>
							</div>
    						<!--- Mail Password --->
							<div class="control-group">
							    #html.label(class="control-label",field="cb_site_mail_password",content="Mail Server Password:")#
                                <div class="controls">
                                    <small>Optional mail server password to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
    								#html.passwordField(name="cb_site_mail_password",class="textfield width98",title="The optional mail server password to use.")#
                                </div>
							</div>
    						<!--- SMTP Port --->
							<div class="control-group">
							    #html.label(class="control-label",field="cb_site_mail_smtp",content="Mail SMTP Port:")#
                                <div class="controls">
                                    <small>The SMTP mail port to use, defaults to port 25.</small><br/>
    								#html.inputfield(type="numeric",value="25",name="cb_site_mail_smtp",class="textfield",size="5",title="The mail SMPT port to use.")#
                                </div>
							</div>
    						
    						
    						<!--- TLS --->
							<div class="control-group">
							    #html.label(class="control-label",field="cb_site_mail_tls",content="Use TLS:")#
                                <div class="controls">
                                    <small>Whether to use TLS when sending mail or not.</small><br/>
    								#html.radioButton(name="cb_site_mail_tls",value=true)# Yes 	
    								#html.radioButton(name="cb_site_mail_tls",checked="true",value=false)# No 
                                </div>
							</div>
    						<!--- SSL --->
							<div class="control-group">
							    #html.label(class="control-label",field="cb_site_mail_ssl",content="Use SSL:")#
                                <div class="controls">
                                    <small>Whether to use SSL when sending mail or not.</small><br/>
    								#html.radioButton(name="cb_site_mail_ssl",value=true)# Yes 	
    								#html.radioButton(name="cb_site_mail_ssl",checked=true,value=false)# No 
                                </div>
							</div>
    					#html.endFieldSet()#
    					
    					<!---Toolbar --->
    					<div class="form-actions">
    						<a href="javascript:prevStep()" class="btn btn-primary"><i class="icon-chevron-left"></i> Previous Step</a>
    						<a href="javascript:nextStep()" class="btn btn-primary">Next Step <i class="icon-chevron-right"></i></a>
    					</div>
    				</div>
    					
    				<!--- ****************************************************************************** --->
    				<!--- Step 4 : Site URL Rewrites --->
    				<!--- ****************************************************************************** --->
    				<div class="tab-pane well" id="step4">	
    					<!--- URL Rewrites --->
    					#html.startFieldset(legend="Site URL Rewrites")#
    					<p>
    						ContentBox by default is configured to work with SES (Search Engine Safe) URLs.  However, in order to remove the 
    						<strong>index.cfm</strong> from your URL's you will need to configure a web server rewrite engine like
    						<a href="http://httpd.apache.org/docs/current/mod/mod_rewrite.html">Apache mod_rewrite</a>, 
    						<a href="http://www.tuckey.org/urlrewrite/">tuckey URL Rewrite filter</a> or 
    						<a href="http://www.iis.net/download/urlrewrite">IIS 7 rewrite module</a>.
    						We can configure <em>Apache mod_rewrite, IIS 7 and ContentBox Express</em> for you automatically by creating the appropriate files in 
    						the application web root.
    					</p>
    					
    					<div class="alert">
    						<p>
    							If you select full URL rewrites below, then we will modify your application's routing table to remove the 
    							<strong>index.cfm</strong> from the URLs (<em>config/routes.cfm</em>).  You can also select not to have full URL rewrites and your URLs
    							will contain an <strong>index.cfm</strong> in them. 
    						</p>
    						<strong>Full URL Rewrite:</strong>
    						<code>
    							http://myapp/about-us
    						</code>
    						<br/>
    						<strong>Default URL Rewrite</strong>
    						<code>
    							http://myapp/index.cfm/about-us
    						</code>
    					</div>
    					
    					<!--- Populate With Sample Data --->
						<div class="control-group">
							#html.label(class="control-label",field="fullrewrite",content="Enable Full URL Rewrites:")#    
                            <div class="controls">
                                <label>#html.radioButton(name="fullrewrite",value=true)# Yes</label>
            					#html.select(options="contentbox_express,mod_rewrite,iis7", name="rewrite_engine")#
            					<br/>
            					<label>
            						#html.radioButton(name="fullrewrite",checked=true,value=false)# No 	
            					</label>
                            </div>
						</div>
    					#html.endFieldSet()#
    					
    					<!--- Action Bar --->
    					<div class="form-actions">
    						<a href="javascript:prevStep()" class="btn btn-primary"><i class="icon-chevron-left"></i> Previous Step</a>
    						#html.button(type="submit", name="submit", value="<i class='icon-ok'></i> Start Installation!",class="btn btn-danger",title="Let's get this party started!")#
    					</div>
    					
    				</div>    					
    				<!---Error Bar --->
    				<div id="errorBar"></div>
    			</div>
    			<!--- End Tab Content --->
    		</div>
		<!--- End Vertical Nav --->
		</div>
        <!--- End Body --->
	</div>
	<!--- end content box --->
</div>
#html.endForm()#
</cfoutput>