﻿<cfoutput>
<div class="box clear" id="loginBox">
	
	<div class="header">
		<img src="#prc.cbroot#/includes/images/key_icon.png" alt="help" />Lost Password
	</div>
	
	<div class="body clearfix">
		
		<!--- Render Messagebox. --->
		#getPlugin("MessageBox").renderit()#
		
		<!--- Instructions --->
		<p>Enter your email address below in order to reset your password.</p>
			
		<div id="loginContent">
		#html.startForm(action=prc.xehDoLostPassword,name="lostPasswordForm",novalidate="novalidate")#
			#html.textfield(name="email",label="Email Address: ",size="40",required="required",class="textfield")#
			
			<div id="loginButtonbar">
			#html.href(href=event.buildLink( prc.xehLogin ), text=html.button(class="button",value="&nbsp;&nbsp;Back To Login&nbsp;&nbsp;"))#
			#html.submitButton(value="&nbsp;&nbsp;Reset Password&nbsp;&nbsp;",class="buttonred")#
			</div>
			
		#html.endForm()#
		</div>
	
	</div>
</div>
</cfoutput>