<cfoutput>
<div class="row" id="main-login">
	<div class="box span12 offset4" id="loginBox">
	
		<div class="header">
			<i class="icon-key icon-"></i> Lost Password
		</div>
		
		<div class="body clearfix">
			
			<!--- Render Messagebox. --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- Instructions --->
			<p>Enter your email address below in order to reset your password.</p>
				
			<div id="loginContent">
			#html.startForm(action=prc.xehDoLostPassword,name="lostPasswordForm",novalidate="novalidate")#
				
				<div class="padding10">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-envelope"></i></span>
						#html.textfield(name="email", required="required", class="input-large", placeholder="Email Address", autocomplete="off")#
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