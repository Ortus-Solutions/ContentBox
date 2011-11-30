<cfoutput>
#html.startForm(action="cbinstaller/install",name="installerForm")#

<div class="box clear">
	<div class="header">
		<img src="#prc.assetRoot#/includes/images/help.png" alt="help" width="30" height="30" />Install Wizard
	</div>
	<div class="body_vertical_nav clearfix">
		<!--- Tabs --->
		<ul class="vertical_nav">
			<li class="active"><a href="##introduction">Introduction</a></li>
			<li><a href="##installer">Installer</a></li>
		</ul>
		<!--- Tab Content --->
		<div class="main_column">
			<div class="panes_vertical">
				
				<!--- Panel 1 --->
				<div>
					<h1>Welcome To ContentBox!</h1>
					<p>
						We have detected that your ContentBox is not setup yet, so let's get you up and running in no time.
						You have already done the first step which is created the datasource in which ContentBox will run under as you are
						now seeing this message.
						What you might not know is that we already created the entire database structure for you, we know just need
						a little information from you to get ContentBox ready for prime time.
					</p>
					<p>
						On the left hand side you will see the <strong>Installer</strong> tab that you will need to click in order
						to fill out our install wizard and get ContentBox ready.  So what are you waiting for? Let's get started!
					</p>
					
					<a href="##installer">
						<input name="start" type="button" class="button2" id="start" value="Start Installer" onclick="return false;">
					</a>
				</div>
				<!--- end panel 1 --->
				
				<!--- Panel 2 : User Setup--->
				<div>
					<h1>ContentBox Installer</h1>
					
					#html.startFieldset(legend="Administrator")#
					<p>
						Fill out the following information to setup your ContentBox administrator.
					</p>
					<!--- Fields --->
					#html.textField(name="firstName",label="First Name:",required="required",size="50",class="textfield")#
					#html.textField(name="lastName",label="Last Name:",required="required",size="50",class="textfield")#
					#html.inputField(name="email",type="email",label="Email:",required="required",size="50",class="textfield")#
					#html.textField(name="username",label="Username:",required="required",size="50",class="textfield")#
					#html.textField(name="password",label="Password:",required="required",size="50",class="textfield")#
					#html.textField(name="password_confirm",label="Confirm Password:",required="required",size="50",class="textfield")#
					#html.endFieldSet()#
					
					
					
					<!--- Action Bar --->
					<div class="actionBar">
						<input type="submit" value="Start Installation!" class="buttonred">
					</div>
					
				</div> 
				<!--- end panel 2 --->
			</div>
			<!--- end panes vertical --->
		</div>
		<!--- end main column --->
	</div>
	<!--- end body content --->
</div>
<!--- end content box --->

#html.endForm()#
<script language="javascript">
$(document).ready(function() {
	// form validators
	$("##installerForm").validator({grouped:true});
	$.tools.validator.fn("[name=password_confirm]", "Passwords need to match", function(el, value) {
		return (value==$("[name=password]").val()) ? true : false;
	});
});
</script>
</cfoutput>