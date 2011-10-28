<cfoutput>
<div class="box clear" id="loginBox">
	
	<div class="header">
		<img src="#prc.cbroot#/includes/images/key_icon.png" alt="help" />Lost Password
	</div>
	
	<div class="body clearfix">
		
		<!--- Render Messagebox. --->
		#getPlugin("MessageBox").renderit()#
		
		<div id="loginContent">
		#html.startForm(action=rc.xehDoLostPassword,name="lostPasswordForm",novalidate="novalidate")#
			<input type="hidden" name="_securedURL" value="#event.getValue('_securedURL','')#">
			<br/>
			<p>Enter your email address below in order to reset your password.  A new password
			will be generated and sent to your email address.</p>
			
			<label for="email">Email</label>
			<input type="email" name="email" id="email" size="40" required="required" class="textfield">
			
			<br/><br/>
			<a href="#event.buildLink(prc.xehLogin)#">< Back to Login</a> 
			&nbsp;
			<input type="submit" value="&nbsp;&nbsp;Reset Password&nbsp;&nbsp;" class="buttonred">
		#html.endForm()#
		</div>
	
	</div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	//Get Focus
	$("##email").focus();
	// form validators
	$("##lostPasswordForm").validator({grouped:true});
});
</script>
</cfoutput>