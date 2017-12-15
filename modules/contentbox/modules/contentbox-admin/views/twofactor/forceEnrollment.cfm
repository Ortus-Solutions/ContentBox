<cfoutput>
<div class="container-fluid">
    <div class="col-md-8" id="login-wrapper">
        <div class="panel panel-primary animated fadeInDown">
            <div class="panel-heading">
                <h3 class="panel-title">
                   <i class="fa fa-key"></i> Enroll in Two Factor Authentication
                </h3>
            </div>
            <div class="panel-body">
	        	<!--- Render Messagebox. --->
				#getModel( "messagebox@cbMessagebox" ).renderit()#

                <!--- AuthorForm --->
                #html.startForm(
                    name 		= "twofactorForm",
                    action 		= prc.author.getIs2FactorAuth() ? prc.xehUnenrollTwoFactor : prc.xehEnrollTwoFactor,
                    novalidate 	= "novalidate",
                    class 		= "form-vertical"
                )#
                    #html.hiddenField( name="authorID", bind=prc.author )#

                    <fieldset>
                        <!--- Global Force --->
                        <cfif prc.cbSettings.cb_security_2factorAuth_force>
                            <div class="alert alert-warning">
                                <i class="fa fa-exclamation-triangle fa-lg"></i>
                                Global Two Factor Authentication is currently being enforced. Please make sure that you have setup
                                your device using the two factor provider shown below.
                            </div>
                        <!--- Else User can choose to activate it --->
                        <cfelse>
                            <div class="form-group">
                                #html.label(
                                    class   = "control-label",
                                    field   = "is2FactorAuth",
                                    content = "Status:"
                                )#

                                #prc.author.getIs2FactorAuth() ? "Enrolled" : "Not Enrolled"#
                            </div>
                        </cfif>

                        <!--- Provider Name --->
                        <div class="form-group">
                            <label>Provider: </label>
                            <span class="label label-info">#prc.twoFactorProvider.getDisplayName()#</span><br/>
                        </div>

                        <!--- Provider Setup Help --->
                        <div class="form-group">
                            <label>Provider Instructions: </label><br>
                            #prc.twoFactorProvider.getAuthorSetupHelp( prc.author )#
                        </div>

                        <!--- Provider Setup Help --->
                        <cfif len( prc.twoFactorProvider.getAuthorSetupForm( prc.author ) )>
                            <label>Required Provider Information: </label><br>
                            <div class="panel panel-default">
                                <div class="panel-body">
                                    #prc.twoFactorProvider.getAuthorSetupForm( prc.author )#
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
                        #announceInterception( "cbadmin_onAuthorTwoFactorOptions" )#

                    </fieldset>

                    <!---
                        Action Bar
                        Saving only if you have permissions, else it is view only.
                    --->
                    <cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oCurrentAuthor.getAuthorID()>
                    <div class="form-actions">
                        <div class="form-group">
                            <cfif prc.author.getIs2FactorAuth()>
                                #html.button(
                                    type = "submit",
                                    value = "Un-enroll",
                                    class = "btn btn-danger"
                                )#
                            <cfelse>
                                #html.button(
                                    type = "submit",
                                    value = "Enroll",
                                    class = "btn btn-primary"
                                )#
                            </cfif>
                        </div>
                    </div>
                    </cfif>

                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>
