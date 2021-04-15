<cfoutput>
<div>
    <div class="col-md-4" id="login-wrapper">
        <div class="panel panel-primary animated flipInY">

            <div class="panel-heading">
                <h3 class="panel-title p5">
                   <i class="fa fa-key"></i> #cb.r( "lostpassword@security" )#
                </h3>
            </div>

            <div class="panel-body">
            	<!--- Render Messagebox. --->
  				#cbMessageBox().renderit()#

  				<p>#cb.r( "lostpassword.instructions@security" )#</p>

                #html.startForm(
                	action     = prc.xehDoLostPassword,
                	name       = "lostPasswordForm",
                	novalidate = "novalidate",
                	class      = "form-horizontal"
                )#
                    #html.hiddenField( name="_csrftoken", value=csrfToken() )#

                    <div class="form-group">
                        <div class="col-md-12 controls">
                            #html.textfield(
                            	name         = "email",
                            	required     = "required",
                            	class        = "form-control",
                            	placeholder  = cb.r( "common.email@security" ),
                            	autocomplete = "off"
                            )#
                            <i class="fas fa-envelope"></i>
                        </div>
                    </div>

                    <div class="form-group">
                       <div class="col-md-12 text-center">
                       		#html.button(
                       			type  = "submit",
                       			value = "#cb.r( "resetpassword@security" )#",
                       			class = "btn btn-primary btn-lg"
                       		)#
                        </div>
                    </div>
                 #html.endForm()#

                #announce( "cbadmin_afterLostPasswordForm" )#

                <a href="#event.buildLink( prc.xehLogin )#" class="">
               		<i class="fas fa-chevron-left"></i> #cb.r( "backtologin@security" )#
               	</a>

                #announce( "cbadmin_afterBackToLogin" )#

            </div>
        </div>
    </div>
</div>
</cfoutput>
