<cfoutput>
<div>
    <div class="col-md-4" id="login-wrapper">
        <div class="panel panel-primary animated flipInY">

            <div class="panel-heading">
                <h3 class="panel-title">
                   <i class="fa fa-key"></i> #cb.r( "resetpassword@security" )#
                </h3>
            </div>

            <div class="panel-body">
            	<!--- Render Messagebox. --->
				#getModel( "messagebox@cbMessagebox" ).renderit()#

  				<p>#cb.r( "resetpassword.instructions@security" )#</p>

				#html.startForm(
					action    	= prc.xehPasswordChange,
					name      	= "passwordResetForm",
					novalidate	= "novalidate",
					class     	= "form-horizontal"
				)#

					#html.hiddenField( name="token", value=encodeForHTMLAttribute( rc.token ) )#

					<div class="form-group">
						<div class="col-md-12 controls">
							#html.passwordField(
								name        	= "password",
								required    	= "required",
								class       	= "form-control pwcheck",
								autocomplete	= "off"
							)#
							<i class="fa fa-lock"></i>
						</div>
					</div>

					<!--- Show Rules --->
					<div id="passwordRules" class="well well-sm" data-min-length="#prc.cbSettings.cb_security_min_password_length#">
						<span class="badge" id="pw_rule_lower">abc</span>
						<span class="badge" id="pw_rule_upper">ABC</span>
						<span class="badge" id="pw_rule_digit">123</span>
						<span class="badge" id="pw_rule_special">!@$</span>
						<span class="badge" id="pw_rule_count">0</span>
						<p class="help-block">#cb.r( "common.passwordrules@security" )#</p>
					</div>

					<div class="form-group">

						<div class="col-md-12">
							<label for="password_confirmation">#cb.r( "resetpassword.confirm@security" )#</label>
						</div>

						<div class="col-md-12">
							#html.passwordField(
								name        	= "password_confirmation",
								required    	= "required",
								class       	= "form-control pwcheck",
								autocomplete	= "off"
							)#
							<i class="fa fa-lock"></i>
						</div>
					</div>

					<div class="form-group">
						<div class="col-md-12 text-center">
					 		#html.button(
					 			type  	= "submit",
					 			value 	= "#cb.r( "resetpassword@security" )#",
					 			class 	= "btn btn-primary"
					 		)#
						</div>
					</div>

					<a href="#event.buildLink( prc.xehLogin )#">
						<i class="fa fa-chevron-left"></i> #cb.r( "backtologin@security" )#
					</a>

				#html.endForm()#
              </div>
          </div>
      </div>
</div>
</cfoutput>
