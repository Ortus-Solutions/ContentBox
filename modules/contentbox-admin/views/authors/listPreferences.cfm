<cfoutput>
<!--- authorPreferencesForm --->
#html.startForm( name="authorPreferencesForm", action=prc.xehAuthorPreferences, novalidate="novalidate", class="form-vertical" )#
	#html.startFieldset(legend="User Preferences" )#
		#html.hiddenField( name="authorID", bind=prc.author )#
		
		<!---Editor of Choice --->
		#html.select( 
			name="preference.editor", 
			label="Favorite Editor", 
			options=prc.editors, 
			class="form-control input-sm", 
			selectedValue=prc.author.getPreference( "editor", "" ),
			wrapper="div class=controls",
			labelClass="control-label",
			groupWrapper="div class=form-group" 
		)#
		
		<!---Markup of Choice --->
		#html.select( 
			name="preference.markup", 
			label="Favorite Markup", 
			options=prc.markups, 
			class="form-control input-sm", 
			selectedValue=prc.author.getPreference( "markup", "" ),
			wrapper="div class=controls",
			labelClass="control-label",
			groupWrapper="div class=form-group" 
		)#
		
		<!---Social Preferences --->
		#html.textfield( 
			name="preference.twitter",
			label="Twitter Profile",
			class="form-control",
			value=prc.author.getPreference( "twitter", "" ),
			wrapper="div class=controls",
			labelClass="control-label",
			groupWrapper="div class=form-group" 
		)#

		#html.textfield( 
			name="preference.facebook",
			label="Facebook Profile",
			class="form-control",
			value=prc.author.getPreference( "facebook","" ),
			wrapper="div class=controls",
			labelClass="control-label",
			groupWrapper="div class=form-group" 
		)#

		#html.textfield( 
			name="preference.google",
			label="Google+ Profile",
			class="form-control",
			value=prc.author.getPreference( "google", "" ),
			wrapper="div class=controls",
			labelClass="control-label",
			groupWrapper="div class=form-group" 
		)#
		
		<!--- Nav Bar Collapse --->
		#html.select( 
			name  			= "preference.sidemenuCollapse",
			label 			= "Collapsed Left Navbar",
			options 		= "yes,no",
			class 			= "form-control input-sm",
			selectedValue 	= prc.author.getPreference( "sidemenuCollapse", "no" ),
			wrapper 		= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group" 
		)#

		<!--- Right Sidebar --->
		#html.select( 
			name  			= "preference.sidebarState",
			label 			= "Show Content Sidebar",
			options 		= "yes,no",
			class 			= "form-control input-sm",
			selectedValue 	= prc.author.getPreference( "sidebarState", "yes" ),
			wrapper 		= "div class=controls",
			labelClass		= "control-label",
			groupWrapper 	= "div class=form-group" 
		)#
		
		<!--- Admin Event --->
		#announceInterception( "cbadmin_UserPreferencePanel" )#
		
		<!--- Action Bar --->
		<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
			<div>
				<input type="submit" value="Save Preferences" class="btn btn-danger">
			</div>
		</cfif>
	#html.endFieldSet()#
#html.endForm()#

<!--- authorRawPreferencesForm --->
#html.startForm( name="authorRawPreferencesForm", action=prc.xehAuthorRawPreferences, novalidate="novalidate", class="form-vertical" )#
	#html.startFieldset( legend="Raw Preferences (<a href='javascript:toggleRawPreferences()'>Show/Hide</a>)" )#
	#html.hiddenField( name="authorID", bind=prc.author )#
	
	<div id="rawPreferences" style="display:none">
		<!--- Raw Preferences --->
		#html.textarea( 
			name="preferences",
			label="The raw user preferences are stored in JSON notation,which you can modify below:",
			bind=prc.author,
			rows="5",
			required="required",
			class="form-control",
			wrapper="div class=controls",
			labelClass="control-label",
			groupWrapper="div class=form-group" 
		)#

		<!--- Action Bar --->
		<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
			<div>
				<input type="submit" value="Save" class="btn btn-danger">
			</div>
		</cfif>
	</div>
	#html.endFieldSet()#
#html.endForm()#	
</cfoutput>