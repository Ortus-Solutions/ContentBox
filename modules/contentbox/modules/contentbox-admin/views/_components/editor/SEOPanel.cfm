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

	<div class="form-group" x-data="relocationsCrud()">
		<label style="width:100%">
			Redirects to this #prc.oContent.getContentType()#
			<a @click="createRelocation()" class="btn btn-xs btn-success pull-right" data-toggle="tooltip" title="Create new redirect to this page"><i class="fa fa-plus"></i></a>
		</label>
		<template x-if="!isLoading">
			<table class="table table-hover table-striped" border="0">
				<thead>
					<tr>
						<th>Slug</th>
						<th>Date Added</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<tr x-show="showForm">
						<td colspan="3" class="form-group">
							<label>Create New Redirect</label>
							<input type="text" placeholder="enter a relative URL ( e.g. path/to/my/page )" class="form-control" x-model="formData.slug" />
							<button type="button" @click="saveRelocation()" class="btn btn-success btn-sm pull-right" style="margin-top:10px"><i :class="!isSaving ? 'fa fa-save' : 'fa fa-spin fa-spinner'"></i> Save</button>
						</td>
					</tr>
					<template x-for="(item,index) in relocations">
						<tr :key="item.relocationID">
							<td><code x-text="'/' + item.slug"></code></td>
							<td x-text="new Date( item.createdDate ).toLocaleDateString()"></td>
							<td><a @click="deleteRelocation( item.relocationID )" data-toggle="tooltip" title="Delete this redirect"><i :class="!item.isProcessing ? 'fa fa-trash text-muted' : 'fa fa-spin fa-spinner text-muted'"></i></a></td>
						</tr>
					</template>
					<template x-if="!relocations.length">
						<tr>
							<td colspan="3" class="text-center text-muted">No Redirects are Currently Configured for this #prc.oContent.getContentType()#</td>
						</tr>
					</template>
				</tbody>
			</table>
		</template>
	</div>
</div>
</cfoutput>