<cfoutput>
<div class="box clear" id="loginBox">
	
	<div class="header">
		<i class="icon-key icon-"></i> Login
	</div>
	
	<div class="body clearfix">
		
		<!--- Render Messagebox. --->
		#getPlugin("MessageBox").renderit()#
		
		<div id="loginContent">
		#html.startForm(action=prc.xehDoLogin,name="loginForm",novalidate="novalidate")#
			#html.hiddenField(name="_securedURL",value=rc._securedURL)#
			#html.textfield(name="username",label="Username: ",size="40",required="required",class="textfield",value=prc.rememberMe)#
			#html.passwordField(name="password",label="Password: ",size="40",required="required",class="textfield")#
			
			<div id="loginButtonbar">
			#html.checkBox(name="rememberMe",value=true,checked=( len( prc.rememberMe ) ))# 
			#html.label(field="rememberMe",content="Remember Me &nbsp;",class="inline")#
			#html.submitButton(value="&nbsp;&nbsp;Log In&nbsp;&nbsp;",class="btn btn-danger")#
			</div>
			
			<br/>
			<i class="icon-question-sign"></i>
			<a href="#event.buildLink( prc.xehLostPassword )#">Lost your password?</a> 
			
		#html.endForm()#
		</div>
	
	</div>
</div>
</cfoutput>