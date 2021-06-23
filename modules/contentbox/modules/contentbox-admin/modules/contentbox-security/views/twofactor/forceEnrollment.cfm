<cfoutput>
<div class="container-fluid">
    <div class="col-md-4" id="login-wrapper">
        <div class="panel panel-primary animated fadeInDown">

			<div class="panel-heading">
                <h3 class="panel-title p5">
                   <i class="fa fa-key"></i> Enroll in Two Factor Authentication
                </h3>
            </div>

			<div class="panel-body">
	        	<!--- Render Messagebox. --->
				#cbMessageBox().renderit()#

                <!--- AuthorForm --->
                #html.startForm(
                    name 		= "twofactorForm",
                    action 		= prc.xehEnroll,
                    novalidate 	= "novalidate",
                    class 		= "form-vertical"
                )#
					#html.hiddenField( name="authorID",      value=prc.oAuthor.getAuthorID() )#
					#html.hiddenField( name="relocationURL", value=rc.relocationURL )#
					#html.hiddenField( name="rememberMe",    value=rc.rememberMe )#

                    <fieldset>
                        <!--- Global Force --->
						<div class="alert alert-warning">
							<i class="fa fa-exclamation-triangle fa-lg"></i>
							Global Two Factor Authentication is currently being enforced. Please make sure that you have setup
							your device using the two factor provider shown below.
						</div>

                        <!--- Provider Name --->
                        <div class="form-group">
                            <label>Provider: </label>
                            <span class="label label-info">#prc.twoFactorProvider.getDisplayName()#</span><br/>
                        </div>

                        <!--- Provider Setup Help --->
                        <div class="form-group">
                            <label>Provider Instructions: </label><br>
                            #prc.twoFactorProvider.getAuthorSetupHelp( prc.oAuthor )#
                        </div>

                        <!--- Provider Setup Help --->
                        <cfif len( prc.twoFactorProvider.getAuthorSetupForm( prc.oAuthor ) )>
                            <label>Required Provider Information: </label><br>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    #prc.twoFactorProvider.getAuthorSetupForm( prc.oAuthor )#
                                </div>
                            </div>
						</cfif>

                        <!--- Provider Author Options --->
                        <cfif len( prc.twoFactorProvider.getAuthorOptions() )>
                            <div class="form-group">
                                <label>Provider Options: </label><br>
                                #prc.twoFactorProvider.getAuthorOptions()#
                            </div>
                        </cfif>

                        <!--- Provider Listener so they can add even more options via events --->
                        #announce( "cbadmin_onAuthorTwoFactorOptions" )#

                    </fieldset>

                    <div class="form-actions">
                        <div class="form-group">
							#html.button(
								type = "submit",
								value = "Enroll",
								class = "btn btn-primary"
							)#
                        </div>
                    </div>

                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>
