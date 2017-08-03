<cfoutput>
<div class="tab-pane" id="password" style="min-height: 400px">
	#html.startForm(
		name       = "authorPasswordForm",
		action     = prc.xehAuthorChangePassword,
		novalidate = "novalidate",
		class      = "form-vertical"
	)#
		#html.startFieldset( legend="Change Password" )#
		#html.hiddenField( name="authorID", bind=prc.author )#

		<!--- Fields --->
		#html.passwordField(
			name    		= "password",
			label   		= "Password:",
			required		= "required",
			size    		= "50",
			class   		= "form-control pwcheck",
			wrapper 		= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group"
		)#

		#html.passwordField(
			name    		= "password_confirm",
			label   		= "Confirm Password:",
			required		= "required",
			size    		= "50",
			class   		= "form-control pwcheck",
			wrapper 		= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group"
		)#

		<!--- Show Rules --->
		<div id="passwordRules" class="well well-sm" data-min-length="#prc.cbSettings.cb_security_min_password_length#">
			<span class="badge" id="pw_rule_lower">abc</span>
			<span class="badge" id="pw_rule_upper">ABC</span>
			<span class="badge" id="pw_rule_digit">123</span>
			<span class="badge" id="pw_rule_special">!@$</span>
			<span class="badge" id="pw_rule_count">0</span>
			<p class="help-block">At least #prc.cbSettings.cb_security_min_password_length# characters including upper and lower case letters, numbers, and symbols.</p>
		</div>

		#html.endFieldSet()#

		<!--- Action Bar --->
		<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oCurrentAuthor.getAuthorID()>
		<div class="form-actions">
			<input type="submit" value="Change Password" class="btn btn-danger">
		</div>
		</cfif>
	#html.endForm()#
	</div>
</cfoutput>