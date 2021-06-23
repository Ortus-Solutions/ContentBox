<cfoutput>
<!--- authorPreferencesForm --->
#html.startForm(
	name		= "authorPreferencesForm",
	action		= prc.xehAuthorPreferences,
	novalidate	= "novalidate",
	class		= "form-vertical"
)#
		#html.hiddenField( name="authorID", bind=prc.author )#

		<!---Editor of Choice --->
		#html.select(
			name			= "preference.editor",
			label			= "Favorite Editor",
			options 		= prc.editors,
			class			= "form-control input-sm",
			selectedValue 	= prc.author.getPreference( "editor", "" ),
			wrapper			= "div class=controls",
			labelClass		= "control-label",
			groupWrapper	= "div class=form-group"
		)#

		<!---Markup of Choice --->
		#html.select(
			name			= "preference.markup",
			label			= "Favorite Markup",
			options 		= prc.markups,
			class			= "form-control input-sm",
			selectedValue 	= prc.author.getPreference( "markup", "" ),
			wrapper			= "div class=controls",
			labelClass		= "control-label",
			groupWrapper	= "div class=form-group"
		)#

		<!---Social Preferences --->
		#html.textfield(
			name			= "preference.twitter",
			label			= "Twitter Profile",
			class			= "form-control",
			value 			= prc.author.getPreference( "twitter", "" ),
			wrapper			= "div class=controls",
			labelClass		= "control-label",
			groupWrapper	= "div class=form-group"
		)#

		#html.textfield(
			name			= "preference.facebook",
			label			= "Facebook Profile",
			class			= "form-control",
			value			= prc.author.getPreference( "facebook","" ),
			wrapper			= "div class=controls",
			labelClass		= "control-label",
			groupWrapper	= "div class=form-group"
		)#

		#html.textfield(
			name			= "preference.linkedin",
			label			= "Linkedin Profile:",
			class			= "form-control",
			value			= prc.author.getPreference( "linkedin", "" ),
			wrapper			= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group"
		)#

		#html.textfield(
			name			= "preference.website",
			label			= "Website:",
			class			= "form-control",
			value			= prc.author.getPreference( "website", "" ),
			wrapper			= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group"
		)#

		<!--- Nav Bar Collapse --->
		<div class="form-group">
			#html.label(
				class   = "control-label",
				field   = "preference.sidemenuCollapse",
				content = "Collapsed Left Navbar:"
			)#

			<div class="controls">
				#html.checkbox(
					name    = "preference.sidemenuCollapse_toggle",
					data	= { toggle: 'toggle', match: 'preference\.sidemenuCollapse' },
					checked = prc.author.getPreference( "sidemenuCollapse", false )
				)#
				#html.hiddenField(
					name	= "preference.sidemenuCollapse",
					value 	= prc.author.getPreference( "sidemenuCollapse", "no" )
				)#
			</div>
		</div>

		<!--- Right Sidebar --->
		<div class="form-group">
			#html.label(
				class   = "control-label",
				field   = "preference.sidebarState",
				content = "Show Content Sidebar:"
			)#

			<div class="controls">
				#html.checkbox(
					name    = "preference.sidebarState_toggle",
					data	= { toggle: 'toggle', match: 'preference\.sidebarState' },
					checked = prc.author.getPreference( "sidebarState", true )
				)#
				#html.hiddenField(
					name	= "preference.sidebarState",
					value 	= prc.author.getPreference( "sidebarState", "yes" )
				)#
			</div>
		</div>

		<!--- Admin Event --->
		#announce( "cbadmin_UserPreferencePanel" )#

		<!--- Action Bar --->
		<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oCurrentAuthor.getAuthorID()>
			<div class="text-center mb10">
				<input type="submit" value="Save Preferences" class="btn btn-primary btn-lg">
			</div>
		</cfif>
	#html.endFieldSet()#
#html.endForm()#

<!--- authorRawPreferencesForm --->
#html.startForm(
	name 		= "authorRawPreferencesForm",
	action 		= prc.xehAuthorRawPreferences,
	novalidate 	= "novalidate",
	class 		= "form-vertical"
)#
	#html.startFieldset( legend="Raw Preferences (<a href='javascript:toggleRawPreferences()'>Show/Hide</a>)" )#
	#html.hiddenField( name="authorID", bind=prc.author )#

	<div id="rawPreferences" style="display:none">

		<!--- Raw Preferences --->
		#html.textarea(
			name		="preferences",
			label		="The raw user preferences are stored in JSON notation,which you can modify below:",
			bind		=prc.author,
			rows		="5",
			required	="required",
			class		="form-control",
			wrapper		="div class=controls",
			labelClass 	="control-label",
			groupWrapper="div class=form-group"
		)#

		<!--- Action Bar --->
		<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oCurrentAuthor.getAuthorID()>
			<div>
				<input type="submit" value="Save" class="btn btn-danger">
			</div>
		</cfif>

	</div>
	#html.endFieldSet()#
#html.endForm()#
</cfoutput>
