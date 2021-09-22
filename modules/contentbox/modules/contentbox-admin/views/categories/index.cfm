<cfoutput>
<!--- Setup alpine component --->
<div x-data="categoriesCrud()">

	<!--- TITLE --->
	<div class="row">
		<div class="col-md-12">
			<h1 class="h1">
				<i class="fas fa-tags"></i> Content Categories (<span x-text="pagination.totalRecords"></span>)
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
									name="categorySearch"
									class="form-control rounded quicksearch"
									placeholder="Quick Search"
									x-model="searchQuery"
									@input.debounce="searchCategories()"
								>
							</div>

							<!--- Is Public Filter --->
							<div class="form-group m0">
								<select
									name="isPublicFilter"
									id="isPublicFilter"
									class="form-control text-light-gray"
									title="Filter by Public/Private/All"
									x-model="isPublicFilter"
									@change="searchCategories()"
								>
									<option value="">-- All Visibilities --</option>
									<option :value="true">Public</option>
									<option :value="false">Private</option>
								</select>
							</div>
						</div>

						<div class="col-md-6 col-xs-8">
							<div class="text-right">
								<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group">
										<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
										<ul class="dropdown-menu">
											<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN" )>
											<li>
												<a
													@click="deleteSelected()"
													class="cursor-pointer"
												>
													<i class="far fa-trash-alt fa-lg"></i> Delete Selected
												</a>
											</li>
											</cfif>

											<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT" )>
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
											<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_EXPORT" )>
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

								<!--- Create Category --->
								<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN" )>
									<button
										type="button"
										@click.prevent="editCategory()"
										class="btn btn-primary"
									>
										Create Category
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
								<th>Category</th>
								<th>Slug</th>
								<th width="75" class="text-center">Visibility</th>
								<th width="75" class="text-center">Pages</th>
								<th width="75" class="text-center">Entries</th>
								<th width="75" class="text-center">ContentStore</th>
								<th width="100" class="text-center">Actions</th>
							</tr>
						</thead>
						<tbody>

							<template x-for="(category, index) in categories" :key="category.categoryID">

								<tr>
									<!--- check box selector --->
									<td class="text-center">
										<input
											type="checkbox"
											name="categoryID"
											id="categoryID"
											:value="category.categoryID"
											x-model="selectedCategories"
										/>
									</td>

									<!--- Category --->
									<td>
										<a
											@click="editCategory( category )"
											class="cursor-pointer"
											title="Edit"
											x-text="category.category"
										>
										</a>
									</td>

									<!--- Slug --->
									<td x-text="category.slug"></td>

									<!--- Public or Private --->
									<td class="text-center">
										<i
											class="text-green far fa-check-circle"
											title="Public"
											x-show="category.isPublic"></i>
										<i
											class="fas fa-lock"
											title="Private"
											x-show="!category.isPublic"></i>
									</td>

									<!--- Pages --->
									<td class="text-center">
										<span class="badge badge-info" x-text="category.numberOfPages"></span>
									</td>

									<!--- Entries --->
									<td class="text-center">
										<span class="badge badge-info" x-text="category.numberOfEntries"></span>
									</td>

									<!--- Content Store --->
									<td class="text-center">
										<span class="badge badge-info" x-text="category.numberOfContentStore"></span>
									</td>

									<!--- Actions --->
									<td class="text-center">
										<div class="btn-group">
											<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN" )>

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
															@click="editCategory( category )"
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
																:href="`#event.buildLink( prc.xehExport )#/categoryID/${category.categoryID}.json`"
																target="_blank"
															>
																<i class="fas fa-file-export fa-lg"></i> Export
															</a>
														</li>
													</cfif>

													<!--- Delete Command --->
													<li>
														<a
															@click="deleteCategory( `${category.categoryID}`, index )"
															data-title="Delete Category?"
															data-message="Delete the category and all of its associations"
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
	<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN" )>
		<div class="alpine-overlay" x-show="isEditorOpen" x-cloak></div>
		<div
			class="alpine-modal"
			role="dialog"
			tabindex="-1"
			aria-labelledby="categoryLabel"
			aria-hidden="true"
			x-show="isEditorOpen"
			x-cloak
			x-transition
		>
			<!--- We add a form to have html 5 validations --->
			<form method="post" @submit.prevent="saveCategory()">
				<div
					class="alpine-modal-inner"
					@click.away="closeEditor"
					@keyup.escape.window="closeEditor"
				>
					<div class="alpine-modal-header">
						<h3 x-show="!categoryForm.categoryID.length">Create Category</h3>
						<h3 x-show="categoryForm.categoryID.length">Editing : <span x-text="categoryForm.category"></span></h3>
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
							id="categoryID"
							name="categoryID"
							x-model="categoryForm.categoryID">

						<!--- Category --->
						<div class="form-group">
							<label field="category">Category:</label>
							<div class="controls">
								#html.textField(
									name		 	= "category",
									maxlength	 	= "200",
									required 		= "true",
									size		 	= "30",
									placeholder	 	= "Awesome Category",
									class		 	= "form-control",
									x 				= {
										model : "categoryForm.category"
									}
								)#
							</div>
						</div>

						<!--- Slug --->
						<div class="form-group">
							<label field="category">Slug (blank to generate it):</label>
							<div class="controls">
								#html.textField(
									name		 	= "slug",
									maxlength	 	= "200",
									size		 	= "30",
									placeholder	 	= "awesome-category",
									class		 	= "form-control",
									x 				= {
										model : "categoryForm.slug"
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
									xmodel : "categoryForm.isPublic"
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
<cfif prc.oCurrentAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view 	= "_tags/dialog/import",
		args 	= {
			title 		= "Import Categories",
			contentArea = "category",
			action 		= prc.xehImportAll,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> file to import."
		},
		prePostExempt = true
	)#
</cfif>
</cfoutput>