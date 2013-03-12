<cfoutput>
<!--- authorPreferencesForm --->
#html.startForm(name="authorPreferencesForm",action=prc.xehAuthorPreferences,novalidate="novalidate")#
	#html.startFieldset(legend="User Preferences")#
	#html.hiddenField(name="authorID",bind=prc.author)#
	
	<!---Editor of Choice --->
	<label for="preference.editor">Favorite Editor:</label>
	#html.select(name="preference.editor", options=prc.editors, class="width98", selectedValue=prc.oAuthor.getPreference("editor", ""))#
	<!---Markup of Choice --->
	<label for="preference.editor">Favorite Markup:</label>
	#html.select(name="preference.markup", options=prc.markups, class="width98", selectedValue=prc.oAuthor.getPreference("markup", ""))#
	
	<!---Social Preferences --->
	<label for="preference.twitter">Twitter Profile:</label>
	#html.textfield(name="preference.twitter", class="textfield width98", value=prc.oAuthor.getPreference("twitter", ""))#
	<label for="preference.facebook">Facebook Profile:</label>
	#html.textfield(name="preference.facebook", class="textfield width98", value=prc.oAuthor.getPreference("facebook", ""))#
	<label for="preference.google">Google+ Profile:</label>
	#html.textfield(name="preference.google", class="textfield width98", value=prc.oAuthor.getPreference("google", ""))#
	
	<!--- Admin Event --->
	#announceInterception("cbadmin_UserPreferencePanel")#
	
	<!--- Action Bar --->
	<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
	<div class="actionBar">
		<input type="submit" value="Save Preferences" class="buttonred">
	</div>
	</cfif>
	#html.endFieldSet()#
#html.endForm()#

<!--- authorRawPreferencesForm --->
#html.startForm(name="authorRawPreferencesForm",action=prc.xehAuthorRawPreferences,novalidate="novalidate")#
	#html.startFieldset(legend="Raw Preferences (<a href='javascript:toggleRawPreferences()'>Show/Hide</a>)")#
	#html.hiddenField(name="authorID",bind=prc.author)#
	
	<div id="rawPreferences" style="display:none">
		<!--- Raw Preferences --->
		<label for="preferences">The raw user preferences are stored in JSON notation, which you can modify below:</label>
		#html.textarea(name="preferences",bind=prc.author,rows="5",required="required")#

		<!--- Action Bar --->
		<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
		<div class="actionBar">
			<input type="submit" value="Save" class="buttonred">
		</div>
		</cfif>
	</div>
	#html.endFieldSet()#
#html.endForm()#	
</cfoutput>