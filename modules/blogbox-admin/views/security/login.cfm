<cfoutput>
<div class="box clear" id="loginBox">
	
	<div class="header">
		<img src="#prc.bbroot#/includes/images/key_icon.png" alt="help" />Login
	</div>
	
	<div class="body clearfix">
		
		<!--- Render Messagebox. --->
		#getPlugin("MessageBox").renderit()#
		
		<div id="loginContent">
		#html.startForm(action=rc.xehDoLogin,name="loginForm",novalidate="novalidate")#
			<input type="hidden" name="_securedURL" value="#event.getValue('_securedURL','')#">
			
			<label for="username">Username</label>
			<input type="text" name="username" id="username" size="40" required="required" class="textfield">
			
			<label for="password">Password</label>
			<input type="password" name="password" id="password" size="40" required="required" class="textfield">
			
			<br/><br/>
			<a href="#event.buildLink(rc.xehLostPassword)#">Lost your password?</a> 
			&nbsp;
			<input type="submit" value="&nbsp;&nbsp;Log In&nbsp;&nbsp;" class="buttonred">
		#html.endForm()#
		</div>
	
	</div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	//Get Focus
	$("##username").focus();
	// form validators
	$("##loginForm").validator({grouped:true});
});
</script>
</cfoutput>