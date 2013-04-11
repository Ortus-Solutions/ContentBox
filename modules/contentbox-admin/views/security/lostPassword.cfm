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
			#html.textfield(name="email",label="Email Address: ",size="40",required="required",class="span4")#
			
			<div id="loginButtonbar">
			#html.href(href=event.buildLink( prc.xehLogin ), text="&nbsp;&nbsp;Back To Login&nbsp;&nbsp;", class="btn")#
			#html.button(type="submit", value="&nbsp;&nbsp;Reset Password&nbsp;&nbsp;", class="btn btn-danger")#
			</div>
			
		#html.endForm()#
		</div>
	
	</div>
</div>
</cfoutput>