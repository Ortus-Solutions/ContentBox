<cfoutput>
	<!--- Quick Actions Left Button Bar --->
	<div class="btn-group btn-group-sm">

		<!--- Back Button --->
        <button
			class="btn btn-sm btn-primary"
			onclick="window.location.href='#event.buildLink( prc.xehContentStore )#/?parent=#prc.parentcontentID#';return false;">
			<i class="fas fa-chevron-left"></i> Back
        </button>

		<!--- Drop Actions --->
        <button
			class="btn btn-sm btn-default dropdown-toggle"
			data-toggle="dropdown"
			title="Quick Actions">
			<span class="caret"></span>
        </button>

			<ul class="dropdown-menu">
				<li>
					<a href="javascript:quickPublish( false )">
						<i class="fas fa-satellite-dish fa-lg"></i> Publish Now
					</a>
				</li>
				<li>
					<a href="javascript:quickPublish( true )">
						<i class="fas fa-eraser fa-lg"></i> Save as Draft
					</a>
				</li>
				<li>
					<a href="javascript:quickSave()">
						<i class="far fa-save fa-lg"></i> Quick Save
					</a>
				</li>
			</ul>
	</div>

	<!--- Content Form --->
	#html.startForm(
		action      = prc.xehContentSave,
		name        = "contentForm",
		novalidate  = "novalidate",
		class       = "form-vertical mt5",
		role        = "form"
	)#

		<div class="row">

			<!--- Content Editor --->
			<div class="col-md-8" id="main-content-slot">
				<!--- MessageBox --->
				#cbMessageBox().renderit()#

				<!--- Hidden Values --->
				#html.hiddenField( name="contentID", bind=prc.oContent )#
				#html.hiddenField( name="contentType", bind=prc.oContent )#
				#html.hiddenField( name="sluggerURL", value=event.buildLink( prc.xehSlugify ) )#

				<div class="panel panel-default">

					<!-- Nav Tabs -->
					<div class="tab-wrapper m0">
						<ul class="nav nav-tabs" role="tablist">

							<!--- Main Editor --->
							<li role="presentation" class="active">
								<a href="##editor" aria-controls="editor" role="tab" data-toggle="tab">
									<i class="fas fa-pen"></i> Editor
								</a>
							</li>

							<!--- Custom Fields --->
							<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_CUSTOM_FIELDS" )>
								<li role="presentation">
									<a href="##custom_fields" aria-controls="custom_fields" role="tab" data-toggle="tab">
										<i class="fas fa-microchip"></i> Custom Fields
									</a>
								</li>
							</cfif>

							<!--- Version History --->
							<cfif prc.oContent.isLoaded()>
								<li role="presentation">
									<a href="##history" aria-controls="history" role="tab" data-toggle="tab">
										<i class="fa fa-history"></i> History
									</a>
								</li>
							</cfif>

							<!--- Event --->
							#announce( "cbadmin_ContentEditorNav" )#
						</ul>
					</div>

					<!--- Nav Content --->
					<div class="panel-body tab-content">

						<!--- Editor Tab --->
						<div role="tabpanel" class="tab-pane active" id="editor">
							<!--- title --->
							<div class="form-group">
								<label class="control-label" for="title">Title:</label>
								<div class="controls">
									#html.textfield(
										name     	= "title",
										bind     	= prc.oContent,
										maxlength	= "500",
										required 	= "required",
										title    	= "The title for this content",
										class    	= "form-control"
									)#
								</div>
							</div>

							<!--- slug --->
							<div class="form-group">
								<label for="slug" class="control-label">Slug:</label>
								<div class="controls">
									<div id='slugCheckErrors'></div>
									<div class="input-group">
										#html.textfield(
											name      = "slug",
											bind      = prc.oContent,
											maxlength = "500",
											class     = "form-control",
											title     = "The unique slug for this content, this is how they are retreived",
											disabled  = "#prc.oContent.isLoaded() && prc.oContent.getIsPublished() ? 'true' : 'false'#"
										)#
										<a title=""
											class="input-group-addon"
											href="javascript:void(0)"
											onclick="togglePermalink(); return false;"
											data-original-title="Lock/Unlock permalink"
											data-container="body"
										>
											<i id="togglePermalink" class="fa fa-#prc.oContent.isLoaded() && prc.oContent.getIsPublished() ? 'lock' : 'unlock'#"></i>
										</a>
									</div>
								</div>
							</div>

							<!--- Description --->
							<cfif structKeyExists( prc.oContent, "getDescription" )>
								<div class="form-group">
									<label class="control-label" for="description">Short Description:</label>
									<div class="controls">
										#html.textarea(
											name   		= "description",
											bind   		= prc.oContent,
											rows   		= 1,
											class  		= "form-control",
											title  		= "A short description for metadata purposes"
										)#
									</div>
								</div>
							</cfif>

							<!---ContentToolBar --->
							<div id="contentToolBar">

								<!--- editor selector --->
								<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
									<div class="btn-group btn-group-sm">
										<a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
											<i class="fa fa-keyboard-o"></i>
											Editor
											<span class="caret"></span>
										</a>
										<ul class="dropdown-menu">
											<cfloop array="#prc.editors#" index="thisEditor">
												<li <cfif thisEditor.name eq prc.defaultEditor>class="active"</cfif>>
													<a href="javascript:switchEditor( '#thisEditor.name#' )">
														#thisEditor.displayName#
													</a>
												</li>
											</cfloop>
										</ul>
									</div>
								</cfif>

								<!--- markup --->
								#html.hiddenField(
									name	= "markup",
									value	= prc.oContent.isLoaded() ? prc.oContent.getMarkup() : prc.defaultMarkup
								)#

								<div class="btn-group btn-group-sm">
									<a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
										<i class="fa fa-code"></i>
										Markup : <span id="markupLabel">#prc.oContent.isLoaded() ? prc.oContent.getMarkup() : prc.defaultMarkup#</span>
										<span class="caret"></span>
									</a>
									<ul class="dropdown-menu">
										<cfloop array="#prc.markups#" index="thismarkup">
											<li <cfif thisMarkup eq prc.oContent.getMarkup()>class="active"</cfif>>
												<a href="javascript:switchMarkup( '#thismarkup#' )">#thismarkup#</a>
											</li>
										</cfloop>
									</ul>
								</div>

								<!--- Auto Save Operations --->
								<div class="btn-group btn-group-sm" id="contentAutoSave">
									<a class="btn btn-info btn-sm dropdown-toggle autoSaveBtn" data-toggle="dropdown" href="##">
										<i class="far fa-save"></i>
										Auto Saved
										<span class="caret"></span>
									</a>
									<ul class="dropdown-menu autoSaveMenu">

									</ul>
								</div>

								<!--- Preview Panel --->
								<div class="pull-right">
									<a href="javascript:previewContent()" class="btn btn-sm btn-info" title="Quick Preview (ctrl+p)" data-keybinding="ctrl+p">
										<i class="far fa-eye fa-lg"></i>
									</a>
								</div>
							</div>

							<!--- content --->
							<div class="form-group">
								<div class="controls">
									#html.textarea(
										name 	= "content",
										value	= htmlEditFormat( prc.oContent.getContent() ),
										rows	= "25",
										class	= "form-control"
									)#
								</div>
							</div>
						</div>

						<!--- Custom Fields Tab --->
						<div role="tabpanel" class="tab-pane" id="custom_fields">
							<!--- Custom Fields Component --->
							#cbAdminComponent(
								"editor/CustomFields",
								{ fieldType : "content", customFields : prc.oContent.getCustomFields() }
							)#
						</div>

						<!--- Version History Tab --->
						<cfif prc.oContent.isLoaded()>
							<div role="tabpanel" class="tab-pane" id="history">
								#prc.versionsViewlet#
							</div>
						</cfif>

						<!--- Custom tab content --->
						#announce( "cbadmin_contentEditorNavContent" )#

					</div>

					<!--- Event --->
					#announce( "cbadmin_contentEditorInBody" )#
				</div>

				<!--- Event --->
				#announce( "cbadmin_contentEditorFooter" )#
			</div>

			<!--- Content SideBar --->
			<div class="col-md-4" id="main-content-sidebar">

				<div class="panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title"><i class="fa fa-info-circle"></i> Content Details</h3>
					</div>
					<div class="panel-body">
						<!--- Publishing Panel --->
						#cbAdminComponent(
							"editor/PublishingPanel"
						)#

						<!--- Accordion --->
						<div id="accordion" class="panel-group accordion" data-stateful="contentstore-sidebar">

							<!---Info Table If Loaded--->
							<cfif prc.oContent.isLoaded()>
								#cbAdminComponent(
									"editor/InfoTable"
								)#
							</cfif>

							<!---Related Content--->
							#cbAdminComponent(
								"editor/RelatedContent"
							)#

							<!--- Linked Content--->
							#cbAdminComponent(
								"editor/LinkedContent"
							)#

							<!---Modifiers--->
							#cbAdminComponent(
								"editor/Modifiers"
							)#

							<!--- Cache Settings--->
							#cbAdminComponent(
								"editor/CacheSettings"
							)#

							<!---Begin Categories--->
							#cbAdminComponent(
								"editor/Categories"
							)#

							<!--- Event --->
							#announce( "cbadmin_contentEditorSidebarAccordion" )#
						</div>
						<!--- End Accordion --->

						<!--- Event --->
						#announce( "cbadmin_contentEditorSidebar" )#
					</div>
				</div>
				<!--- Event --->
				#announce( "cbadmin_contentEditorSidebarFooter" )#
			</div>
		</div>

	<!--- End Form --->
	#html.endForm()#
</cfoutput>