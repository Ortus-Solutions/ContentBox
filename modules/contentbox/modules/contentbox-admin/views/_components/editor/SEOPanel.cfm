<cfoutput>
<div>
	<div class="form-group">
		#html.textfield(
			name      = "htmlTitle",
			label     = "Title: (Leave blank to use the page name)",
			bind      = prc.oContent,
			class     = "form-control",
			maxlength = "255"
		)#
	</div>

	<div class="form-group">
		<label for="htmlKeywords">
			Keywords: (<span id='html_keywords_count'>0</span>/160 characters left)
		</label>
		#html.textArea(
			name        = "htmlKeywords",
			bind        = prc.oContent,
			class       = "form-control",
			maxlength   = "160",
			rows        = "5"
		)#
	</div>

	<div class="form-group">
		<label for="htmlKeywords">
			Description: (<span id='html_description_count'>0</span>/160 characters left)
		</label>
		#html.textArea(
			name        = "htmlDescription",
			bind        = prc.oContent,
			class       = "form-control",
			maxlength   = "160",
			rows        = "5"
		)#
	</div>
</div>
</cfoutput>