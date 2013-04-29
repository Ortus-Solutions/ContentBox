<cfoutput>
<div class="row" id="main-login">
	
	<div class="well" id="loginBox">
	
		<h2><i class="icon-key icon-"></i> Lost Password</h2>
		
		<div class="body">
			
			<!--- Render Messagebox. --->
			#getPlugin("MessageBox").renderit()#
			
			<div id="loginContent">
			<!--- Instructions --->
			<p>Enter your email address below in order to reset your password with a temporary password.</p>
			
			#html.startForm(action=prc.xehDoLostPassword,name="lostPasswordForm",novalidate="novalidate",class="form-vertical")#
				
				<div class="control-group">
					<div class="controls">
					    <div class="input-prepend">
							<span class="add-on"><i class="icon-envelope"></i></span>
							#html.textfield(name="email", required="required", class="input-large", placeholder="Email Address", autocomplete="off")#
						</div>
					</div>
				</div>
				
				<div id="loginButtonbar">
					#html.button(type="submit", value="<i class='icon-refresh'></i> Reset Password&nbsp;&nbsp;", class="btn btn-danger btn-large")#
				</div>
				
				<br/>
				<a href="#event.buildLink( prc.xehLogin )#" class="btn btn-mini"><i class="icon-reply"></i> Back to Login</a> 
				
			#html.endForm()#
			</div>
		
		</div>
	</div>
</div>
</cfoutput>