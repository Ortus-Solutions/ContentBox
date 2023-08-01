<cfoutput>
#html.startForm( name="editorSettingsForm", action=prc.xehSaveSettings )#
<fieldset>
	<legend><i class="fas fa-pen fa-lg"></i> Editor Options</legend>

		<!--- Default Editor --->
		<div class="form-group">
			<label class="control-label" for="cb_editors_default">Default Editor:</label>
			<div class="controls">
				<small>Choose the default editor that all users will use for pages, blogs, custom HTML, etc.</small><br/>
				#html.select(
					name            = "cb_editors_default",
					options         = prc.editors,
					column          = "name",
					nameColumn      = "displayName",
					class           = "form-control input-sm",
					selectedValue   = prc.cbSettings.cb_editors_default
				)#
			</div>
		</div>

		<!--- Default Markup --->
		<div class="form-group">
			<label class="control-label" for="cb_editors_markup">Default Markup:</label>
			<div class="controls">
				<small>Choose the default markup to use for content.</small><br/>
				#html.select(
					name            = "cb_editors_markup",
					options         = prc.markups,
					class           = "form-control input-sm",
					selectedValue   = prc.cbSettings.cb_editors_markup
				)#
			</div>
		</div>

		<!--- CKEditor  --->
		<div class="form-group">
			#html.label(
				class       = "control-label",
				field       = "cb_editors_ckeditor_toolbar",
				content     = "CKEditor Standard Toolbar: "
			)#
			<div class="controls">
				<small>The CKEditor toolbar elements. You can find a list of valid configuration items in <a href="http://docs.ckeditor.com/##!/guide/dev_configuration" target="_blank">CKEditor's documentation</a>.
				<strong>Please make a backup before editing, just in case.</strong></small><br/>
				#html.textarea(
					name  	= "cb_editors_ckeditor_toolbar",
					value 	= prc.cbSettings.cb_editors_ckeditor_toolbar,
					class 	= "form-control",
					rows  	= "18"
				)#
			</div>
		</div>

		<!--- CKEditor Excerpt --->
		<div class="form-group">
			#html.label(
				class	= "control-label",
				field	= "cb_editors_ckeditor_excerpt_toolbar",
				content	= "CKEditor Excerpt Toolbar: "
			)#
			<div class="controls">
				<small>The CKEditor excerpt toolbar elements. You can find a list of valid configuration items in <a href="http://docs.ckeditor.com/##!/guide/dev_configuration" target="_blank">CKEditor's documentation</a>.
				<strong>Please make a backup before editing, just in case.</strong></small><br/>
				#html.textarea(
					name	= "cb_editors_ckeditor_excerpt_toolbar",
					value	= prc.cbSettings.cb_editors_ckeditor_excerpt_toolbar,
					class	= "form-control",
					rows	= "10"
				)#
			</div>
		</div>

		<!--- CKEditor Extra Plugins --->
		<div class="form-group">
			#html.label(
				class	= "control-label",
				field	= "cb_editors_ckeditor_extraplugins",
				content	= "CKEditor Extra Plugins: "
			)#
			<div class="controls">
				<small>The CKEditor extra plugins to load. You can find a list of valid configuration items in <a href="http://docs.ckeditor.com/##!/guide/dev_configuration" target="_blank">CKEditor's documentation</a>.
				<strong>Please make a backup before editing, just in case.</strong></small><br/>
				#html.textarea(
					name 	= "cb_editors_ckeditor_extraplugins",
					value 	= prc.cbSettings.cb_editors_ckeditor_extraplugins,
					class 	= "form-control",
					rows 	= "3"
				)#
			</div>
		</div>

</fieldset>
<!--- Button Bar --->
<div class="form-actions mt20">
	#html.submitButton( value="Save Settings", class="btn btn-danger" )#
</div>

#html.endForm()#
</cfoutput>