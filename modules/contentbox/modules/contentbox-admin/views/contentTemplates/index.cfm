<cfoutput>
	<!--- Setup alpine component --->
	<div x-data="categoriesCrud()">

		<!--- TITLE --->
		<div class="row">
			<div class="col-md-12">
				<h1 class="h1">
					<i class="fas fa-tags"></i> Content Templates (<span x-text="pagination.totalRecords"></span>)
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
									<input
										name="templateSearch"
										class="form-control rounded quicksearch"
										placeholder="Quick Search"
										x-model="searchQuery"
										@input.debounce="searchTemplates()"
									>
								</div>
							</div>

							<div class="col-md-6 col-xs-8">
								<div class="text-right">
									<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
										<div class="btn-group">
											<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
												Bulk Actions <span class="caret"></span>
											</button>
											<ul class="dropdown-menu">
												<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" )>
												<li>
													<a
														@click="deleteSelected()"
														class="cursor-pointer"
													>
														<i class="far fa-trash-alt fa-lg"></i> Delete Selected
													</a>
												</li>
												</cfif>

												<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_IMPORT" )>
												<li>
													<a
														@click="importContent()"
														class="cursor-pointer"
													>
														<i class="fas fa-file-import fa-lg"></i> Import
													</a>
												</li>
												</cfif>

												<!--- Export All + Selected --->
												<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_EXPORT" )>
													<li>
														<a href="#event.buildLink ( prc.xehExportAll )#.json" target="_blank">
															<i class="fas fa-file-export fa-lg"></i> Export All
														</a>
													</li>
													<li>
														<a
															@click="exportSelected()"
															class="cursor-pointer"
														>
															<i class="fas fa-file-export fa-lg"></i> Export Selected
														</a>
													</li>
												</cfif>
											</ul>
										</div>
									</cfif>

									<!--- Create Template --->
									<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" )>
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
						<div class="text-center m20" x-show="isLoading">
							<i class="fas fa-spinner fa-spin fa-lg"></i><br/>
						</div>

						<!--- Table --->
						<table id="categories" class="table table-striped-removed table-hover " cellspacing="0" width="100%" x-show="!isLoading">
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
									<th>Template</th>
									<th>Slug</th>
									<th width="75" class="text-center">Visibility</th>
									<th width="75" class="text-center">Pages</th>
									<th width="75" class="text-center">Entries</th>
									<th width="75" class="text-center">ContentStore</th>
									<th width="100" class="text-center">Actions</th>
								</tr>
							</thead>
							<tbody>

								<template x-for="(template, index) in categories" :key="template.templateID">

									<tr>
										<!--- check box selector --->
										<td class="text-center">
											<input
												type="checkbox"
												name="templateID"
												id="templateID"
												:value="template.templateID"
												x-model="selectedTemplates"
											/>
										</td>

										<!--- Template --->
										<td>
											<a
												@click="editTemplate( template )"
												class="cursor-pointer"
												title="Edit"
												x-text="template.template"
											>
											</a>
										</td>

										<!--- Slug --->
										<td x-text="template.slug"></td>

										<!--- Public or Private --->
										<td class="text-center">
											<i
												class="text-green far fa-check-circle"
												title="Public"
												x-show="template.isPublic"></i>
											<i
												class="fas fa-lock"
												title="Private"
												x-show="!template.isPublic"></i>
										</td>

										<!--- Pages --->
										<td class="text-center">
											<span class="badge badge-info" x-text="template.numberOfPages"></span>
										</td>

										<!--- Entries --->
										<td class="text-center">
											<span class="badge badge-info" x-text="template.numberOfEntries"></span>
										</td>

										<!--- Content Store --->
										<td class="text-center">
											<span class="badge badge-info" x-text="template.numberOfContentStore"></span>
										</td>

										<!--- Actions --->
										<td class="text-center">
											<div class="btn-group">
												<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" )>

												<div class="btn-group btn-group-sm">
													<a
														class="btn btn-default btn-more dropdown-toggle"
														data-toggle="dropdown"
														href="##">
														<i class="fas fa-ellipsis-v fa-lg"></i>
													</a>
													<ul class="dropdown-menu text-left pull-right">
														<!--- Edit --->
														<li>
															<a
																@click="editTemplate( template )"
																class="cursor-pointer"
																title="Edit"
															>
																<i class="fas fa-pen fa-lg"></i> Edit
															</a>
														</li>

														<!--- Export --->
														<cfif prc.oCurrentAuthor.checkPermission( "TOOLS_EXPORT" )>
															<li>
																<a
																	:href="`#event.buildLink( prc.xehExport )#/templateID/${template.templateID}.json`"
																	target="_blank"
																>
																	<i class="fas fa-file-export fa-lg"></i> Export
																</a>
															</li>
														</cfif>

														<!--- Delete Command --->
														<li>
															<a
																@click="deleteTemplate( `${template.templateID}`, index )"
																data-title="Delete Template?"
																data-message="Delete the template and all of its associations"
															>
																<i class="far fa-trash-alt fa-lg"></i> Delete
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
						</table>
					</div>
				</div>
			</div>
		</div>

		<!--- **************************************************************************** --->
		<!--- CATEGORY EDITOR MODAL UI --->
		<!--- **************************************************************************** --->
		<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" )>
			<div class="alpine-overlay" x-show="isEditorOpen" x-cloak></div>
			<div
				class="alpine-modal"
				role="dialog"
				tabindex="-1"
				aria-labelledby="templateLabel"
				aria-hidden="true"
				x-show="isEditorOpen"
				x-cloak
				x-transition
			>
				<!--- We add a form to have html 5 validations --->
				<form method="post" @submit.prevent="saveTemplate()">
					<div
						class="alpine-modal-inner"
						@click.away="closeEditor"
						@keyup.escape.window="closeEditor"
					>
						<div class="alpine-modal-header">
							<h3 x-show="!templateForm.templateID.length">Create Template</h3>
							<h3 x-show="templateForm.templateID.length">Editing : <span x-text="templateForm.template"></span></h3>
							<button
								class="close"
								aria-label="Close"
								@click.prevent="closeEditor">✖</button>
						</div>

						<div class="alpine-modal-body">

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

							<!--- Template --->
							<div class="form-group">
								<label field="template">Template:</label>
								<div class="controls">
									#html.textField(
										name		 	= "template",
										maxlength	 	= "200",
										required 		= "true",
										size		 	= "30",
										placeholder	 	= "Awesome Template",
										class		 	= "form-control",
										x 				= {
											model : "templateForm.template"
										}
									)#
								</div>
							</div>

							<!--- Slug --->
							<div class="form-group">
								<label field="template">Slug (blank to generate it):</label>
								<div class="controls">
									#html.textField(
										name		 	= "slug",
										maxlength	 	= "200",
										size		 	= "30",
										placeholder	 	= "awesome-template",
										class		 	= "form-control",
										x 				= {
											model : "templateForm.slug"
										}
									)#
								</div>
							</div>

							<div class="form-group">
								#cbAdminComponent(
									"ui/Toggle",
									{
										name : "isPublic",
										label : "Public: ",
										xmodel : "templateForm.isPublic"
									}
								)#
							</div>

						</div>

						<!--- Footer --->
						<div class="alpine-modal-footer">
							<button
								class="btn btn-default"
								@click.prevent="closeEditor"
								:disabled="isSubmitting"
							>
								Cancel
							</button>

							<button
								type="submit"
								class="btn btn-primary"
								:disabled="isSubmitting"
							>
								Save
							</button>
						</div>
					</div>
				</form>
			</div>
		</cfif>
	</div>

	<!---only show if user has rights to categories admin and tool import--->
	<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_IMPORT" )>
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