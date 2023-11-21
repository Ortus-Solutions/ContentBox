<cfoutput>
<div>
	<div class="form-group">
		#html.textfield(
			name      = "HTMLTitle",
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
			name        = "HTMLKeywords",
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
			name        = "HTMLDescription",
			bind        = prc.oContent,
			class       = "form-control",
			maxlength   = "160",
			rows        = "5"
		)#
	</div>

	<!--- Relocations --->
	<cfif prc.oContent.isLoaded()>
		<div
			class="form-group"
			x-data="relocationsCrud()"
			id="relocationsCrud"
		>
			<legend style="width:100%">
				#prc.oContent.getContentType()# Redirects
				<a
					@click="createRelocation()"
					class="btn btn-xs btn-success pull-right"
					data-toggle="tooltip"
					title="Create new redirect to this page"
				>
					<i class="fa fa-plus"></i>
				</a>
			</legend>

			<!--- Global Alert --->
			#cbAdminComponent( "ui/Alert", { messageModel : "globalAlert" } )#

			<template x-if="!isLoading">
				<table class="table table-hover table-striped" border="0">
					<thead>
						<tr>
							<th>Slug</th>
							<th>Date Added</th>
							<th width="50">Actions</th>
						</tr>
					</thead>
					<tbody>
						<!--- new form --->
						<tr x-show="showForm">
							<td colspan="3" class="form-group">

								<label for="slug">Create New Redirect</label>

								<input
									name="Slug"
									type="text"
									placeholder="enter a relative URL ( e.g. path/to/my/page )"
									class="form-control"
									x-model="formData.slug" />

								<div class="flex justify-end items-center mt10">
									<button
										type="button"
										class="btn btn-default btn-sm mr5"
										@click="cancelRelocation()"
										:disabled="isSaving"
									>
										Cancel
									</button>

									<button
										type="button"
										@click="saveRelocation()"
										class="btn btn-success btn-sm"
										:disabled="isSaving"
									>
											<i :class="!isSaving ? 'fa fa-save' : 'fa fa-spin fa-spinner'"></i>
											Save
									</button>
								</div>
							</td>
						</tr>

						<!--- Show Relocations --->
						<template x-for="( item, index  ) in relocations">
							<tr :key="item.relocationID">
								<td>
									<code x-text="'/' + item.slug"></code>
								</td>
								<td x-text="toLocaleDateTime( item.createdDate )"></td>
								<td>
									<button
										type="button"
										@click="deleteRelocation( item.relocationID )"
										data-toggle="tooltip"
										title="Delete this redirect"
										class="btn btn-xs btn-icon"
									>
										<i :class="!item.isProcessing ? 'fa fa-trash text-muted' : 'fa fa-spin fa-spinner text-muted'"></i>
									</button>
								</td>
							</tr>
						</template>

						<!--- No Relocations --->
						<template x-if="!relocations.length">
							<tr>
								<td colspan="3" class="text-center text-muted">No Redirects are Currently Configured for this #prc.oContent.getContentType()#</td>
							</tr>
						</template>
					</tbody>
				</table>
			</template>
		</div>
	</cfif>
</div>
</cfoutput>
