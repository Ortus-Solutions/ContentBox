<cfoutput>
<div class="box clear" id="loginBox">
	
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
			
			<div class="control-group">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-envelope"></i></span>
					#html.textfield(name="email", required="required", class="span4", placeholder="Email Address", autocomplete="off")#
				</div>
			</div>
			
			<div id="loginButtonbar">
				#html.href(href=event.buildLink( prc.xehLogin ), text="&nbsp;&nbsp;Back To Login&nbsp;&nbsp;", class="btn")#
				#html.button(type="submit", value="&nbsp;&nbsp;Reset Password&nbsp;&nbsp;", class="btn btn-danger")#
			</div>
			
		#html.endForm()#
		</div>
	
	</div>
</div>
</cfoutput>