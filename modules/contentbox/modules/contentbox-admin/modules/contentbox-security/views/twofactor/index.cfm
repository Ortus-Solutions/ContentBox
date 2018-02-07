<cfoutput>
<div class="container-fluid">
    <div class="col-md-4" id="login-wrapper">

        <div class="panel panel-primary animated fadeInDown">

            <div class="panel-heading">
                <h3 class="panel-title">
                   <i class="fa fa-mobile fa-lg"></i> Two-Factor Authentication
                </h3>
            </div>

            <div class="panel-body">
	        	<!--- Render Messagebox --->
				#getModel( "messagebox@cbMessagebox" ).renderit()#

                #html.startForm(
                	action		= prc.xehValidate,
                	ssl 		= event.isSSL(),
                	name		= "twofactorForm",
                	novalidate	= "novalidate",
                	class		= "form-horizontal"
                )#

					<!--- Event --->
					#announceInterception( "cbadmin_beforeTwoFactorForm" )#

					<!--- Challenge Text --->
					<p>#prc.provider.getVerificationHelp()#</p>

	                <div class="form-group">
	                    <div class="col-md-12 controls">
	                        #html.textfield(
	                        	name			= "twofactorcode",
	                        	required		= "required",
	                        	class			= "form-control",
	                        	autocomplete	= "off"
	                        )#
	                        <i class="fa fa-lock"></i>
	                    </div>
	                </div>

                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="trustDevice" id="trustDevice" value="true"> #cb.r( "twofactor.trust@security" )#
                            <cfif prc.cbSettings.cb_security_2factorAuth_trusted_days gt 0>
                            (#prc.cbSettings.cb_security_2factorAuth_trusted_days# #cb.r( "common.days@security" )#)
                            </cfif>
                        </label>
                    </div>

					<p>&nbsp;</p>

	                <div class="form-group">
	                   <div class="col-md-12 text-center">
	                   		<button type="submit" class="btn btn-primary btn-block">
	                   			#cb.r( "common.validate@security" )#
	                   		</button>
	                    </div>
	                </div>

	                <a href="#event.buildLink( prc.xehResend )#">
               			<i class="fa fa-repeat"></i> #cb.r( "twofactor.resendcode@security" )#
               		</a>

	                <!--- Event --->
					#announceInterception( "cbadmin_afterTwoFactorForm" )#

                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>