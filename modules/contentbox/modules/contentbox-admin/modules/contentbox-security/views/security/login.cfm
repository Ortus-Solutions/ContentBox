<cfoutput>
<div>
    <div class="col-md-4" id="login-wrapper">
		<div class="panel animated fadeInDown">

            <div class="panel-heading">
                <h3 class="text-center">
                   Login
                </h3>
			</div>

            <div class="panel-body">
	        	<!--- Render Messagebox. --->
				#cbMessageBox().renderit()#

                #html.startForm(
                	action		= prc.xehDoLogin,
                	ssl 		= event.isSSL(),
                	name		= "loginForm",
                	novalidate	= "novalidate",
                	class		= "form-horizontal"
                )#
					#html.hiddenField( name="_securedURL", value=rc._securedURL )#
					#html.hiddenField( name="_csrftoken", value=csrfToken() )#

					<!--- Sign In Text --->
					<cfif len( prc.signInText )>#prc.signInText#</cfif>

                	<!--- Event --->
					#announce( "cbadmin_beforeLoginForm" )#

	                <div class="form-group">
	                    <div class="col-md-12 controls">
	                        #html.textfield(
	                        	name			= "username",
	                        	required		= "required",
	                        	class			= "form-control",
	                        	value			= prc.rememberMe,
	                        	placeholder		= cb.r( "common.username@security" ),
	                        	autocomplete	= "off"
	                        )#
	                        <i class="fa fa-user" aria-hidden="true"></i>
	                    </div>
	                </div>
	                <div class="form-group">
	                   <div class="col-md-12 controls">
	                        #html.passwordField(
	                        	name			= "password",
	                        	required		= "required",
	                        	class			= "form-control",
	                        	placeholder		= cb.r( "common.password@security" ),
	                        	autocomplete	= "off"
	                        )#
	                        <i class="fa fa-key" aria-hidden="true"></i>
	                    </div>

	                </div>

					<div class="text-right text-sm">
						<a
							href="#event.buildLink( prc.xehLostPassword )#"
							class="help-block"
						>
							<i class="fa fa-question-circle"></i>
							#cb.r( "lostpassword@security" )#?
						</a>
					</div>

	                <div class="form-group">
	                	<div class="col-md-12 controls">
							<label class="checkbox">
								#cb.r( "rememberme@security" )#<br>
	                            #html.select(
	                                name 	= "rememberMe",
	                                class 	= "form-control input-sm",
	                                options = html.option( value="0", content=cb.r( "rememberme.session@security" ) ) &
	                                        html.option( value="1", content=cb.r( "rememberme.day@security" ) ) &
	                                        html.option( value="7", content=cb.r( "rememberme.week@security" ) ) &
	                                        html.option( value="30", content=cb.r( "rememberme.month@security" ) ) &
	                                        html.option( value="365", content=cb.r( "rememberme.year@security" ) )
	                            )#
							</label>
						</div>
					</div>

	                <div class="form-group">
	                   <div class="col-md-offset-3 col-md-6 text-center">
	                   		<button type="submit" class="btn btn-primary btn-lg btn-block">
	                   			#cb.r( "common.login@security" )#
	                   		</button>
	                    </div>
					</div>

	                <!--- Event --->
					#announce( "cbadmin_afterLoginForm" )#

                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>
