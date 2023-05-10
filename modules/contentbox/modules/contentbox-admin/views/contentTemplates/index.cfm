<cfoutput>
	<!--- Setup alpine component --->
	<div x-data="templatesCrud()">

		<!--- TITLE --->
		<div class="row">
			<div class="col-md-12">
				<h1 class="h1">
					<i class="fa fa-tags"></i> Content Templates (<span x-text="pagination.totalRecords"></span>)
				</h1>
			</div>
		</div>

		<!--- MESSAGES --->
		<div class="row">
			<div class="col-md-12">
				<!--- MessageBox --->
				#cbMessageBox().renderit()#
				<!--- Global Alert --->
				#cbAdminComponent( "ui/Alert", { messageModel : "globalAlert" } )#
				<!---Import Log --->
				<cfif flash.exists( "importLog" )>
					<div class="consoleLog">#flash.get( "importLog" )#</div>
				</cfif>
			</div>
		</div>

		<!--- DATA TABLES --->
		<div class="row">
			<div class="col-md-12">
				<div class="panel panel-default">

					<!--- Search + Filter Bar + Actions Bar --->
					<div class="panel-heading">
						<div class="row">

							<div class="col-md-6 col-xs-4 flex flex-row">
								<!--- Search Filter --->
								<div class="form-group m0 mr5">
									<div class="input-group">
										<input
											name="templateSearch"
											class="form-control quicksearch"
											placeholder="Quick Search"
											x-model="searchQuery"
											@input.debounce="searchTemplates()"
										>
										<div class="input-group-addon">
											<button type="button" class="btn-link" title="Reset Search Options" @click="resetSearchOptions"><i class="fa fa-undo"></i></button>
										</div>

									</div>
								</div>
							</div>

							<div class="col-md-6 col-xs-8">
								<div class="text-right">
									<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
										<div class="btn-group">
											<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
												Bulk Actions <span class="caret"></span>
											</button>
											<ul class="dropdown-menu">
												<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN" )>
												<li>
													<a
														@click="deleteSelected()"
														class="cursor-pointer"
													>
														<i class="far fa-trash-alt fa-lg"></i> Delete Selected
													</a>
												</li>
												</cfif>

												<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN,TOOLS_IMPORT" )>
												<li>
													<a
														@click="importContent()"
														class="cursor-pointer"
													>
														<i class="fa fa-file-import fa-lg"></i> Import
													</a>
												</li>
												</cfif>

												<!--- Export All + Selected --->
												<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN,TOOLS_EXPORT" )>
													<li>
														<a href="#event.buildLink ( prc.xehExportAll )#.json" target="_blank">
															<i class="fa fa-file-export fa-lg"></i> Export All
														</a>
													</li>
													<li>
														<a
															@click="exportSelected()"
															class="cursor-pointer"
														>
															<i class="fa fa-file-export fa-lg"></i> Export Selected
														</a>
													</li>
												</cfif>
											</ul>
										</div>
									</cfif>

									<!--- Create Template --->
									<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN" )>
										<button
											type="button"
											@click.prevent="editTemplate()"
											class="btn btn-primary"
										>
											Create Template
										</button>
									</cfif>
								</div>
							</div>
						</div>
					</div>

					<!--- Panel Content --->
					<div class="panel-body">
						<!--- Loader --->
						<template x-if="isLoading">
							<div class="text-center m20" x-show="isLoading">
								<i class="fa fa-spinner fa-spin fa-lg"></i><br/>
							</div>
						</template>

						<template x-if="!isLoading">
							<!--- Table --->
							<table x-show="!isEditorOpen" id="templates" class="table table-striped-removed table-hover " cellspacing="0" width="100%" x-show="!isLoading" x-cloak>
								<thead>
									<tr>
										<th
											class="text-center"
											width="15"
										>
											<input
												name="selectAll"
												type="checkbox"
												@click="selectAll( $el.checked )"
											/>
										</th>
										<th>Template <a @click="sortBy( 'name' )" :class="[ searchOptions.sortOrder.indexOf( 'name' ) > -1 ? 'text-info' : 'text-muted' ]"><i class="arrow fa fa-sm fa-caret-down"></i></a></th>
										<th>Content Type <a @click="sortBy( 'contentType' )" :class="[ searchOptions.sortOrder.indexOf( 'contentType' ) > -1 ? 'text-info' : 'text-muted' ]"><i class="arrow fa fa-sm fa-caret-down"></i></a></th>
										<th>Description</th>
										<th width="75" class="text-center">Assigned Count <a @click="sortBy( 'assignedContentItems' )" :class="[ searchOptions.sortOrder.indexOf( 'assignedContentItems' ) > -1 ? 'text-info' : 'text-muted' ]"><i class="arrow fa fa-sm fa-caret-down"></i></a></th>
										<th>Creator <a @click="sortBy( 'creator.lastName' )" :class="[ searchOptions.sortOrder.indexOf( 'creator.lastName' ) > -1 ? 'text-info' : 'text-muted' ]"><i class="arrow fa fa-sm fa-caret-down"></i></a></th>
										<th>Last Modified <a @click="sortBy( 'modifiedDate', 'DESC' )" :class="[ searchOptions.sortOrder.indexOf( 'modifiedDate' ) > -1 ? 'text-info' : 'text-muted' ]"><i class="arrow fa fa-sm fa-caret-down"></i></a></th>
										<th>Global <a @click="sortBy( 'isGlobal DESC, contentType ASC' )" :class="[ searchOptions.sortOrder.indexOf( 'isGlobal' ) > -1 ? 'text-info' : 'text-muted' ]"><i class="arrow fa fa-sm fa-caret-down"></i></a></th>
										<th></th>
									</tr>
								</thead>
								<tbody>

									<template x-for="(template, index) in templates" :key="template.templateID">

										<tr>
											<td class="text-center">
												<input
													type="checkbox"
													name="templateID"
													id="templateID"
													:value="template.templateID"
													x-model="selectedTemplates"
												/>
											</td>

											<td>
												<a
													@click="editTemplate( template )"
													class="cursor-pointer"
													title="Edit"
													x-text="template.name"
												>
												</a>
											</td>

											<td x-tooltip="the content type of this template" x-text="template.contentType"></td>

											<td x-text="template.description"></td>

											<td x-text="template.assignedContentItems" class="text-center"></td>

											<td x-text="template.creator.fullName"></td>

											<td x-text="new Date( template.modifiedDate ).toLocaleDateString()"></td>
											<td>
												<a
													@click="toggleGlobal( template )"
													:class="template.isGlobal ? 'text-primary' : 'text-muted'"
													x-tooltip="template.isGlobal ? 'This template is assigned as a a global template. Global templates are applied to all new items with the specified content type. Click to unset.' : `Click to set this template as the global template for the content type ${template.contentType}`"
												>
													<i class="fa fa-globe fa-2x"></i>
												</a>
											</td>
											<!--- Actions --->
											<td class="text-center">
												<div class="btn-group">
													<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN" )>

													<div class="btn-group btn-group-sm">
														<a
															class="btn btn-default btn-more dropdown-toggle"
															data-toggle="dropdown"
															href="##">
															<i class="fa fa-ellipsis-v fa-lg"></i>
														</a>
														<ul class="dropdown-menu text-left pull-right">
															<!--- Edit --->
															<li>
																<a
																	@click="editTemplate( template )"
																	class="cursor-pointer"
																	title="Edit"
																>
																	<i class="fa fa-edit fa-sm"></i> Edit
																</a>
															</li>
															<!--- Duplicate --->
															<li>
																<a
																	@click="duplicateTemplate( template )"
																	title="Duplicate"
																>
																	<i class="fa fa-clone fa-sm"></i> Duplicate
																</a>
															</li>

															<!--- Delete Command --->
															<li>
																<a
																	@click="deleteTemplate( `${template.templateID}`, index )"
																	data-title="Delete Template?"
																	data-message="Delete the template and all of its associations"
																>
																	<i class="fa fa-trash fa-sm"></i> Delete
																</a>
															</li>
														</ul>
													</div>
													</cfif>
												</div>
											</td>
										</tr>
									</template>

								</tbody>
								<tbody x-show="!isLoading && !templates.length" x-cloak>
									<tr>
										<td colspan="8">
											<p class="alert alert-info text-center text-muted">
												There are no existing templates for this site.
											</p>
										</td>
									</tr>
								</tbody>
							</table>
						</template>
						<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN" )>
							<template x-if="isEditorOpen">
								<form x-cloak method="post" @submit.prevent="saveTemplate()">
									<div>
											<button
												class="close"
												aria-label="Close"
												@click.prevent="closeEditor"><i class="fa fa-close"></i></button>
											<h3 x-show="!templateForm.templateID">Create Template</h3>
											<h3 x-show="templateForm.templateID">Editing : <span x-text="templateForm.name"></span></h3>

										<div class="template-fields">

											<!--- Messages --->
											<div
												class="alert alert-danger"
												x-show="errorMessages.length"
												x-html="errorMessages"
											></div>

											<!--- Id --->
											<input
												type="hidden"
												id="templateID"
												name="templateID"
												x-model="templateForm.templateID">

											<fieldset class="col-sm-12">
												<legend>Configuration</legend>
												<div class="form-group col-sm-8">
													<label field="template">Content Type</label>
													<select class="form-control" x-model="templateForm.contentType">
														<template x-for="(option) in availableTypes">
															<option :value="option" :selected="templateForm.contentType == option" x-text="option"></option>
														</template>
													</select>
												</div>
												<template x-if="templateForm.isGlobal || !hasGlobalTemplateForType( templateForm.contentType )">
													<div class="form-group col-sm-4">
														<label>Is Global Template</label>
														<toggle>
															<div style="margin-top:5px">
																<label class="flex items-center cursor-pointer">
																	<!-- toggle -->
																	<div class="relative">
																		<!--- Input --->
																		<input
																			id="isGlobal"
																			name="isGlobal"
																			class="hidden"
																			type="checkbox"
																			:checked="!!templateForm.isGlobal"
																			@click="templateForm.isGlobal = !templateForm.isGlobal"
																		/>
																		<!-- path -->
																		<div class="toggle-path bg-gray-200 w-16 h-9 rounded-full shadow-inner"></div>
																		<!-- circle -->
																		<div class="toggle-circle absolute w-7 h-7 bg-white rounded-full shadow inset-y-0 left-0"></div>
																	</div>
																</label>
																<span class="text-warning" x-show="templateForm.isGlobal" x-cloak><small><em>Warning:</em> Any content items which are not assigned a template will automatically have this template applied.</small></span>
															</div>
														</toggle>
													</div>
												</template>

												<!--- Template --->
												<div class="form-group col-sm-12">
													<label field="template">Template:</label>
													<div class="controls">
														#html.textField(
															name		 	= "name",
															maxlength	 	= "200",
															required 		= "true",
															size		 	= "30",
															placeholder	 	= "Enter a name for this template",
															class		 	= "form-control",
															x 				= {
																model : "templateForm.name"
															}
														)#
													</div>
												</div>

												<!--- Slug --->
												<div class="form-group col-sm-12">
													<label field="template">Description:</label>
													<div class="controls">
														#html.textArea(
															name		 	= "description",
															maxlength	 	= "200",
															size		 	= "30",
															placeholder	 	= "enter an optional description for this template",
															class		 	= "form-control",
															x 				= {
																model : "templateForm.description"
															}
														)#
													</div>
												</div>

											</fieldset>

											<fieldset class="col-sm-12">
												<legend>Template Fields</legend>
												<div class="form-group">
													<label class="text-muted"><small>Select the fields you wish to define in this template.</small></label>
													<ul class="list-inline">
														<template x-for="(templateField, index) in availableFields()" :key="templateField.key">
															<li class="col-lg-3 col-md-4 col-sm-6 col-xs-12">
																<toggle>
																	<div>
																		<label class="flex items-center cursor-pointer">
																			<!-- toggle -->
																			<div class="relative">
																				<!--- Input --->
																				<input
																					:id="'toggle_'+templateField.key"
																					:name="templateField.key"
																					class="hidden"
																					type="checkbox"
																					@click="addFieldToTemplate"
																					:checked="isSelectedField( templateField.key )"
																				/>
																				<!-- path -->
																				<div class="toggle-path bg-gray-200 w-16 h-9 rounded-full shadow-inner"></div>
																				<!-- circle -->
																				<div class="toggle-circle absolute w-7 h-7 bg-white rounded-full shadow inset-y-0 left-0"></div>
																			</div>
																			<div class="ml20 mb10" x-text="templateField.label"></div>
																		</label>
																	</div>
																</toggle>
															</li>
														</template>
													</ul>
													<div class="clearfix"></div>
												</div>
											</fieldset>
											<template x-for="[ fieldKey, definition ] in Object.entries( selectedDefinitions() )" :key="'editor_' + fieldKey">
												<div class="form-group col-sm-12">
													<template x-if="definition.type == 'string'">
														<fieldset>
															<legend x-text="definition.label"></legend>
															<div class="col-xs-12">
																<input class="form-control" :name="'input_value_'+fieldKey" type="text" x-model="templateForm.definition[ fieldKey ].value"/>
															</div>
														</fieldset>
													</template>
													<template x-if="definition.type == 'text'">
														<fieldset>
															<legend x-text="definition.label"></legend>
															<div class="col-xs-12">
																<textarea class="form-control" :name="'input_value_'+fieldKey" x-model="templateForm.definition[ fieldKey ].value"></textarea>
															</div>
														</fieldset>
													</template>
													<template x-if="definition.type == 'markdown'">
														<fieldset>
															<legend x-text="definition.label"></legend>
															<div class="col-xs-12">
																<textarea class="form-control" :name="'input_value_'+fieldKey" x-model="templateForm.definition[ fieldKey ].value"></textarea>
															</div>
														</fieldset>
													</template>
													<template x-if="definition.type == 'integer'">
														<fieldset>
															<legend x-text="definition.label"></legend>
															<div class="col-xs-12">
																<input class="form-control" :name="'input_value_'+fieldKey" type="number" min="0" pattern="[0-9]" x-model="templateForm.definition[ fieldKey ].value"/>
															</div>
														</fieldset>
													</template>
													<template x-if="definition.type == 'file'">
														<fieldset>
															<legend x-text="definition.label"></legend>
															<div class="col-xs-12">
																<input type="file" :name="'input_value_'+fieldKey" x-model="!templateForm.definition[ fieldKey ].value"/>
															</div>
														</fieldset>
													</template>
													<template x-if="definition.type == 'boolean'">
														<fieldset>
															<toggle>
																<div>
																	<label class="flex items-center cursor-pointer">
																		<div class="pr5" x-text="definition.label"></div>
																		<!-- toggle -->
																		<div class="relative">
																			<!--- Input --->
																			<input
																				:id="'toggle_definition_'+fieldKey"
																				:name="'input_value_'+fieldKey"
																				class="hidden"
																				type="checkbox"
																				:checked="!!templateForm.definition[ fieldKey ].value"
																				@click="templateForm.definition[ fieldKey ].value = !templateForm.definition[ fieldKey ].value"
																			/>
																			<!-- path -->
																			<div class="toggle-path bg-gray-200 w-16 h-9 rounded-full shadow-inner"></div>
																			<!-- circle -->
																			<div class="toggle-circle absolute w-7 h-7 bg-white rounded-full shadow inset-y-0 left-0"></div>
																		</div>
																	</label>
																</div>
															</toggle>
														</fieldset>
													</template>
													<template x-if="definition.type == 'select'">
														<fieldset>
															<legend x-text="definition.label"></legend>
															<div class="col-xs-12">
																<select class="form-control" x-model="templateForm.definition[ fieldKey ].value" :multiple="fieldKey == 'categories' ? true : null">
																	<template x-for="(option) in fieldOptions( fieldKey )">
																		<option :value="option.id" :selected="templateForm.definition[ fieldKey ].value && templateForm.definition[ fieldKey ].value.indexOf( option.id ) > -1" x-text="option.label"></option>
																	</template>
																</select>
															</div>
														</fieldset>
													</template>
													<template x-if="definition.type == 'typeahead'">
														<fieldset>
															<legend x-text="definition.label"></legend>
															<div class="input-group col-xs-12">
																<div class="input-group-prepend">
																	<input type="text" :name="fieldKey" @input="typeaheadOptionSearch" placeholder="Enter text to search">
																</div>
																<select class="form-control" x-model="templateForm.definition[ fieldKey ].value">
																	<template x-for="( option ) in fieldOptions( fieldKey )">
																		<option value="option.id" x-text="option.label"></option>
																	</template>
																</select>
															</div>
														</fieldset>
													</template>
													<template x-if="definition.type == 'array'">
														<fieldset>
															<legend>
																<span x-text="definition.label"></span>
																<button type="button" class="btn btn-success text-bold pull-right" @click="appendSchemaItem( fieldKey )"><i class="fa fa-plus"></i></button>
															</legend>
															<template x-if="fieldKey == 'customFields'">
																<ul class="list-unstyled">
																	<template x-for="(field, index) in templateForm.definition[ fieldKey ].value">
																		<li>
																			<div class="col-xs-5">
																				<label x-text="definition.schema[ 'name' ].label"></label>
																				<input class="form-control" :name="'cf_name_'+index" type="text" x-model="templateForm.definition[ fieldKey ].value[ index].name"/>
																			</div>
																			<div class="col-xs-6">
																				<label x-text="definition.schema[ 'defaultValue' ].label"></label>
																				<input class="form-control" :name="'cf_defaultValue_'+index" type="text" x-model="templateForm.definition[ fieldKey ].value[ index].defaultValue"/>
																			</div>
																			<div class="col-xs-1 pt5">
																				<button type="button" class="mt20 btn btn-danger text-bold" @click="removeSchemaItem( fieldKey, index )"><i class="fa fa-trash"></i></button>
																			</div>
																		</li>
																	</template>
																</ul>
															</template>
															<template x-if="fieldKey !== 'customFields'">
																<div>
																	New array item
																</div>
															</template>
														</fieldset>
													</template>
												</div>
											</template>
											<fieldset class="col-sm-12">
												<div class="form-group text-right">
													<button
														class="btn btn-default"
														@click.prevent="closeEditor"
														:disabled="isSubmitting"
													>
														<i class="fa fa-undo"></i>
														Cancel
													</button>

													<button
														type="submit"
														class="btn btn-primary"
														:disabled="isSubmitting"
													>
														<i x-show="!isSubmitting" class="fa fa-save"></i>
														<i x-show="isSubmitting" class="fa fa-spin fa-spinner"></i>
														Save Template
													</button>
												</div>
											</fieldset>
										</div>
									</div>
								</form>
							</template>
						</cfif>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!---only show if user has rights to templates admin and tool import--->
	<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN,TOOLS_IMPORT" )>
		#renderView(
			view 	= "_tags/dialog/import",
			args 	= {
				title 		= "Import Templates",
				contentArea = "template",
				action 		= prc.xehImportAll,
				contentInfo = "Choose the ContentBox <strong>JSON</strong> file to import."
			},
			prePostExempt = true
		)#
	</cfif>
	</cfoutput>