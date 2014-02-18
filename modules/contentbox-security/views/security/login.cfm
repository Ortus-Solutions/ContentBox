<cfoutput>
<div class="row" id="main-login">

	<div class="well" id="loginBox">
		<!---Login Header --->
		<h2><i class="icon-key icon-"></i> #cb.r( "common.login@security" )#</h2>
		
		<!---Body --->
		<div class="body">
			
			<!--- Render Messagebox. --->
			#getPlugin("MessageBox").renderit()#
			
			<div id="loginContent">
			#html.startForm(action=prc.xehDoLogin, name="loginForm", novalidate="novalidate", class="form-vertical")#
				#html.hiddenField(name="_securedURL", value=rc._securedURL)#
				
				
				<div class="control-group">
					<div class="input-prepend controls">
						<div class="input-prepend">
							<span class="add-on"><i class="icon-user"></i></span>
							#html.textfield(name="username", required="required", class="input-large", value=prc.rememberMe, placeholder=cb.r( "common.username@security" ), autocomplete="off")#
						</div>
					</div>
				</div>

				<div class="control-group">
					<div class="controls">
						<div class="input-prepend">
							<span class="add-on"><i class="icon-key"></i></span>
							#html.passwordField(name="password", required="required", class="input-large", placeholder=cb.r( "common.username@security" ), autocomplete="off")#
						</div>
					</div>
				</div>
				
				<div class="control-group">
					<label class="checkbox inline">
						#html.checkBox(name="rememberMe", value=true, checked=( len( prc.rememberMe ) ))#
						#cb.r( "rememberme@security" )#
					</label>		
				</div>
				
				<div id="loginButtonbar">
					#html.button(type="submit", value="<i class='icon-signin'></i> #cb.r( "common.login@security" )#&nbsp;&nbsp;", class="btn btn-danger btn-large")#
				</div>
				
				<br/>
				<a href="#event.buildLink( prc.xehLostPassword )#" class="btn btn-mini"><i class="icon-question-sign"></i> #cb.r( "lostpassword@security" )#?</a> 
				
			#html.endForm()#
			</div>
		
		</div>
	</div>
</div>
</cfoutput>