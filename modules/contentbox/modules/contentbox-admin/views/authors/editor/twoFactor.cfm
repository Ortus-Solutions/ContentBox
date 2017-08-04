<cfoutput>
<div class="tab-pane" id="twofactor" style="min-height: 400px">
	<!--- AuthorForm --->
	#html.startForm(
		name 		= "twofactorForm",
		action 		= prc.xehSaveTwoFactor,
		novalidate 	= "novalidate",
		class 		= "form-vertical"
	)#
		#html.hiddenField( name="authorID", bind=prc.author )#
		
		<fieldset>
			<legend>Two-Factor Authentication</legend>
			
			<p>
				Increase your account's security by enabling Two-Factor Authentication (2FA).
			</p>

			<!--- Global Force --->
			<cfif prc.cbSettings.cb_security_2factorAuth_force>
			<div class="alert alert-warning">
				<i class="fa fa-exclamation-triangle fa-lg"></i>
				Global Two Factor Authentication is currently being enforced. Please make sure that you have setup 
				your device using the two factor provider shown below.
			</div>

			<!--- Else User can choose to activate it --->
			<cfelse>
				<div class="form-group">
					#html.label(
						class   = "control-label",
						field   = "is2FactorAuth",
						content = "Status:"
					)#

					<div class="controls">
						#html.checkbox(
							name    = "is2FactorAuth_toggle",
							data	= { toggle: 'toggle', match: 'is2FactorAuth' },
							checked = prc.author.getIs2FactorAuth()
						)#
						#html.hiddenField(
							name	= "is2FactorAuth",
							bind 	= prc.author
						)#
					</div>
				</div>
			</cfif>
			
			<!--- Provider Name --->
			<div class="form-group">
				<label>Provider: </label> 
				<span class="label label-info">#prc.twoFactorProvider.getDisplayName()#</span><br/>
			</div>
			
			<!--- Provider Setup Help --->
			<div class="form-group">
				<label>Provider Instructions: </label><br>
				#prc.twoFactorProvider.getAuthorSetupHelp()#
			</div>

			<!--- Provider Author Options --->
			<cfif len( prc.twoFactorProvider.getAuthorOptions() )>
			<div class="form-group">
				<label>Provider Options: </label><br>
				#prc.twoFactorProvider.getAuthorOptions()#
			</div>
			</cfif>
			
			<!--- Provider Listener so they can add even more options via events --->
			#announceInterception( "cbadmin_onAuthorTwoFactorOptions" )#

		</fieldset>

		<!--- 
			Action Bar 
			Saving only if you have permissions, else it is view only.
		--->
		<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oCurrentAuthor.getAuthorID()>
		<div class="form-actions">
			<input type="submit" value="Save Details" class="btn btn-danger">
		</div>
		</cfif>

	#html.endForm()#
</div>
</cfoutput>