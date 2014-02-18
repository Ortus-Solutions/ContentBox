<cfoutput>
<div class="row" id="main-login">
	
	<div class="well" id="loginBox">
	
		<h2><i class="icon-key icon-"></i> #cb.r( "lostpassword@security" )#</h2>
		
		<div class="body">
			
			<!--- Render Messagebox. --->
			#getPlugin("MessageBox").renderit()#
			
			<div id="loginContent">
			<!--- Instructions --->
			<p>#cb.r( "lostpassword.instructions@security" )#</p>
			
			#html.startForm(action=prc.xehDoLostPassword,name="lostPasswordForm",novalidate="novalidate",class="form-vertical")#
				
				<div class="control-group">
					<div class="controls">
					    <div class="input-prepend">
							<span class="add-on"><i class="icon-envelope"></i></span>
							#html.textfield(name="email", required="required", class="input-large", placeholder=cb.r( "common.email@security" ), autocomplete="off")#
						</div>
					</div>
				</div>
				
				<div id="loginButtonbar">
					#html.button(type="submit", value="<i class='icon-refresh'></i> #cb.r( "resetpassword@security" )#&nbsp;&nbsp;", class="btn btn-danger btn-large")#
				</div>
				
				<br/>
				<a href="#event.buildLink( prc.xehLogin )#" class="btn btn-mini"><i class="icon-reply"></i> #cb.r( "backtologin@security" )#</a> 
				
			#html.endForm()#
			</div>
		
		</div>
	</div>
</div>
</cfoutput>