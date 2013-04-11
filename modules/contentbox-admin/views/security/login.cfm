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
			
			<p></p>
			
			<div class="control-group">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-user"></i></span>
					#html.textfield(name="username", required="required", class="span4", value=prc.rememberMe, placeholder="Username", autocomplete="off")#
				</div>
				
				<div class="input-prepend">
					<span class="add-on"><i class="icon-key"></i></span>
					#html.passwordField(name="password", required="required", class="span4", placeholder="Password", autocomplete="off")#
				</div>	
				
				<br/>
				<label class="checkbox inline">
					#html.checkBox(name="rememberMe",value=true,checked=( len( prc.rememberMe ) ))#
					Remember Me
				</label>		
			</div>
			
			<div id="loginButtonbar">
				#html.submitButton(value="&nbsp;&nbsp;Log In&nbsp;&nbsp;", class="btn btn-danger btn-large")#
			</div>
			
			<br/>
			<i class="icon-question-sign"></i>
			<a href="#event.buildLink( prc.xehLostPassword )#">Lost your password?</a> 
			
		#html.endForm()#
		</div>
	
	</div>
</div>
</cfoutput>