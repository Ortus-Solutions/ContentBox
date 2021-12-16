<cfoutput>
	<cfscript>
		// writeDump( var=[
		// 	prc.oContent.getPublishedDate()
		// ], top = 5 );
		// abort;
	</cfscript>
<!--- Publishing Panel Component --->
<div
	id="publishingPanel"
	x-data="{
		isPublished : #prc.oContent.getIsPublished() ? true : false#,
		publishingPanelOpen : false,
		togglePublishingPanel(){
			this.publishingPanelOpen = !this.publishingPanelOpen
		}
	}"
>
	<!--- Publishing Bar --->
	<div
		id="publishingBar"
		class="well well-sm"
		x-show="publishingPanelOpen"
		x-cloak
		x-transition.scale.origin.top
	>

		<h4>
			<i class="fa fa-calendar"></i> Publishing Details
		</h4>

		<!--- publish date --->
		<div>

			#html.label(
				class       = "control-label",
				field       = "publishedDate",
				content     = "Publish Date (<a href='javascript:publishNow()'>Now</a>)"
			)#

			<div class="controls row">
				<div class="col-md-6">
					<div class="input-group">

						#html.inputField(
							size    = "9",
							name    = "publishedDate",
							value   = prc.oContent.getDisplayPublishedDate( dateFormat : "yyyy-mm-dd", showTime : false ),
							class   = "form-control datepicker"
						)#

						<span class="input-group-addon">
							<span class="fa fa-calendar"></span>
						</span>
					</div>
				</div>

				<div class="col-md-6">
					<div
						class="input-group clockpicker"
						data-placement="left"
						data-align="top"
						data-autoclose="true"
					>
						<input
							type="text"
							class="form-control inline"
							value="#prc.oContent.getPublishedDateTime()#"
							name="publishedTime"
						>
						<span class="input-group-addon">
							<span class="fas fa-history"></span>
						</span>
					</div>
				</div>
			</div>
		</div>

		<!--- expire date --->
		<div>

			#html.label(
				class   = "control-label",
				field   = "expireDate",
				content = "Expiration Date"
			)#

			<div class="controls row">
				<div class="col-md-6">
					<div class="input-group">

						#html.inputField(
							size    = "9",
							name    = "expireDate",
							value   = prc.oContent.getDisplayExpireDate( dateFormat : "yyyy-mm-dd", showTime : false ),
							class   = "form-control datepicker"
						)#

						<span class="input-group-addon">
							<span class="fa fa-calendar"></span>
						</span>
					</div>
				</div>

				<div class="col-md-6">
					<div
						class="input-group clockpicker"
						data-placement="left"
						data-align="top"
						data-autoclose="true">
						<input
							type="text"
							class="form-control inline"
							value="#prc.oContent.getExpireDateTime()#"
							name="expireTime">
						<span class="input-group-addon">
							<span class="fas fa-history"></span>
						</span>
					</div>
				</div>
			</div>
		</div>

		<!--- Changelog --->
		<div class="form-group">
			<label for="changelog" class="control-label">Commit Changelog:</label>
			<div class="controls">
				#html.textField(
					name   : "changelog",
					class  : "form-control",
					title  : "A quick description of what this commit is all about."
				)#
			</div>
		</div>

		<div class="text-center">
			<button
				type="button"
				class="btn btn-danger"
				@click="togglePublishingPanel"
			>
				Cancel
			</button>

			<button
				type="button"
				id="publishButton"
				class="btn btn-success"
				onclick="quickPublish()"
			>
				Go!
			</button>
		</div>

	</div>

	<!--- Action Bar --->
	<div
		class="actionBar"
		id="actionBar"
		x-show="!publishingPanelOpen"
		x-cloak
		x-transition
	>
		<div class="btn-group">
			<!--- QUICK SAVE --->
			<button
				type="button"
				class="btn"
				:class="isPublished ? 'btn-default' : 'btn-info'"
				onclick="quickSave()"
				title="Save as draft and continue editing"
			>
				Save As Draft
			</button>
			<!--- QUICK SAVE OPTIONS --->
			<button
				type="button"
				class="btn dropdown-toggle"
				:class="isPublished ? 'btn-default' : 'btn-info'"
				data-toggle="dropdown"
				aria-haspopup="true"
				aria-expanded="false"
				title="Save Options"
			>
				<span class="caret"></span>
				<span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul class="dropdown-menu">
				<li>
					<a href="javascript:quickPublish( true )">Save and Close</a>
				</li>
			</ul>
		</div>

		<button
			class="btn btn-success"
			type="button"
			title="Open Publishing Details"
			@click="togglePublishingPanel"
		>
			Publish
		</button>
	</div>

	<!--- Loader --->
	<div class="loaders" id="uploadBarLoader">
		<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
		<div id="uploadBarLoaderStatus" class="center text-red">Saving...</div>
	</div>
</div>
</cfoutput>
