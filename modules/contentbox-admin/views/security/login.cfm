<cfoutput>
<div class="box clear" id="loginBox">
	
	<div class="header">
		<img src="#prc.cbroot#/includes/images/key_icon.png" alt="help" />Login
	</div>
	
	<div class="body clearfix">
		
		<!--- Render Messagebox. --->
		#getPlugin("MessageBox").renderit()#
		
		<div id="loginContent">
		#html.startForm(action=rc.xehDoLogin,name="loginForm",novalidate="novalidate")#
			#html.hiddenField(name="_securedURL",value=event.getValue('_securedURL',''))#
			#html.textfield(name="username",label="Username: ",size="40",required="required",class="textfield",value=prc.rememberMe)#
			#html.passwordField(name="password",label="Password: ",size="40",required="required",class="textfield")#
			
			<div id="loginButtonbar">
			#html.checkBox(name="rememberMe",value=true,checked=(len(prc.rememberMe)))# 
			#html.label(field="rememberMe",content="Remember Me &nbsp;",class="inline")#
			#html.submitButton(value="&nbsp;&nbsp;Log In&nbsp;&nbsp;",class="buttonred")#
			</div>
			
			<br/>
			<img src="#prc.cbRoot#/includes/images/lock.png" alt="lostPassword" />
			<a href="#event.buildLink(rc.xehLostPassword)#">Lost your password?</a> 
			
		#html.endForm()#
		</div>
	
	</div>
</div>
</cfoutput>