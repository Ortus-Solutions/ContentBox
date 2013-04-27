<cfoutput>
<!--- authorPreferencesForm --->
#html.startForm(name="authorPreferencesForm",action=prc.xehAuthorPreferences,novalidate="novalidate",class="well form-vertical")#
	#html.startFieldset(legend="User Preferences")#
	#html.hiddenField(name="authorID",bind=prc.author)#
	
	<!---Editor of Choice --->
	#html.select(name="preference.editor", label="Favorite Editor", options=prc.editors, class="width98", selectedValue=prc.oAuthor.getPreference("editor", ""),wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	<!---Markup of Choice --->
	#html.select(name="preference.markup", label="Favorite Markup", options=prc.markups, class="width98", selectedValue=prc.oAuthor.getPreference("markup", ""),wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	
	<!---Social Preferences --->
	#html.textfield(name="preference.twitter", label="Twitter Profile", class="textfield width98", value=prc.oAuthor.getPreference("twitter", ""),wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	#html.textfield(name="preference.facebook", label="Facebook Profile", class="textfield width98", value=prc.oAuthor.getPreference("facebook", ""),wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	#html.textfield(name="preference.google", label="Google+ Profile", class="textfield width98", value=prc.oAuthor.getPreference("google", ""),wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	
	<!--- Admin Event --->
	#announceInterception("cbadmin_UserPreferencePanel")#
	
	<!--- Action Bar --->
	<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
	<div class="form-actions">
		<input type="submit" value="Save Preferences" class="btn btn-danger">
	</div>
	</cfif>
	#html.endFieldSet()#
#html.endForm()#

<!--- authorRawPreferencesForm --->
#html.startForm(name="authorRawPreferencesForm",action=prc.xehAuthorRawPreferences,novalidate="novalidate",class="well form-vertical")#
	#html.startFieldset(legend="Raw Preferences (<a href='javascript:toggleRawPreferences()'>Show/Hide</a>)")#
	#html.hiddenField(name="authorID",bind=prc.author)#
	
	<div id="rawPreferences" style="display:none">
		<!--- Raw Preferences --->
		#html.textarea(name="preferences",label="The raw user preferences are stored in JSON notation, which you can modify below:",bind=prc.author,rows="5",required="required",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#

		<!--- Action Bar --->
		<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
		<div class="form-actions">
			<input type="submit" value="Save" class="btn btn-danger">
		</div>
		</cfif>
	</div>
	#html.endFieldSet()#
#html.endForm()#	
</cfoutput>