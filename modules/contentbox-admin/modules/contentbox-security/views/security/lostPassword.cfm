<cfoutput>
<div>
    <div class="col-md-4" id="login-wrapper">
        <div class="panel panel-primary animated flipInY">
            <div class="panel-heading">
                <h3 class="panel-title">     
                   <i class="fa fa-key"></i> #cb.r( "lostpassword@security" )#
                </h3>      
            </div>
            <div class="panel-body">
            	<!--- Render Messagebox. --->
				#getModel( "messagebox@cbMessagebox" ).renderit()#

				<p>#cb.r( "lostpassword.instructions@security" )#</p>

                #html.startForm(
                	action=prc.xehDoLostPassword, 
                	name="lostPasswordForm", 
                	novalidate="novalidate", 
                	class="form-horizontal"
                )#
                    <div class="form-group">
                        <div class="col-md-12 controls">
                            #html.textfield(
                            	name="email", 
                            	required="required", 
                            	class="form-control", 
                            	placeholder=cb.r( "common.email@security" ), 
                            	autocomplete="off"
                            )#
                            <i class="fa fa-lock"></i>
                        </div>
                    </div>
                    <div class="form-group">
                       <div class="col-md-12 text-center">
                       		#html.button(
                       			type="submit", 
                       			value="#cb.r( "resetpassword@security" )#", 
                       			class="btn btn-primary"
                       		)#
                        </div>
                    </div>
                    <div class="form-group">
                       <div class="col-md-12">
                       		<a href="#event.buildLink( prc.xehLogin )#" class="">
                       			#cb.r( "backtologin@security" )#
                       		</a> 
                        </div>
                    </div>
                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>
