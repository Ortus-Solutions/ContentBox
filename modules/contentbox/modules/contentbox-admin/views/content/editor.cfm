<cfoutput>
	<!--- Quick Actions Left Button Bar --->
	#cbAdminComponent( "editor/QuickActionsBar" )#

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
				#html.hiddenField( name="siteID", 		bind=prc.oContent )#
				#html.hiddenField( name="contentID", 	bind=prc.oContent )#
				#html.hiddenField( name="contentType", 	bind=prc.oContent )#
				#html.hiddenField( name="isPublished", 	bind=prc.oContent )#
				#html.hiddenField( name="sluggerURL", 	value=event.buildLink( prc.xehSlugify ) )#

				<div class="panel panel-default">

					<!-- Nav Tabs -->
					<div class="tab-wrapper m0">
						<ul class="nav nav-tabs" role="tablist">

							<!--- Main Editor --->
							<li role="presentation" class="active">
								<a href="##editor" aria-controls="editor" role="tab" data-toggle="tab">
									<i class="fas fa-pen"></i> #prc.oContent.getContentType()#
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

							<!--- SEO Panel --->
							<cfif !prc.oContent.isContentStore() and prc.oCurrentAuthor.checkPermission( "EDITORS_HTML_ATTRIBUTES" )>
                                <li role="presentation">
                                    <a href="##seo" aria-controls="seo" role="tab" data-toggle="tab">
                                        <i class="fa fa-cloud"></i> SEO
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
								<cfif prc.oContent.commentsAllowed()>
									<li role="presentation">
										<a href="##comments" aria-controls="comments" role="tab" data-toggle="tab">
											<i class="far fa-comments"></i> Comments
										</a>
									</li>
								</cfif>
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

								<label for="slug" class="control-label">
									Slug:
									<i class="fa fa-cloud" title="Convert title to slug" onclick="createPermalink()"></i>
									<cfif !prc.oContent.isContentStore()>
										<small> #prc.CBHelper.siteRoot()#/</small>
									</cfif>
                                    <cfif prc.oContent.hasParent()>
                                        <small>#prc.oContent.getParent().getSlug()#/</small>
                                    </cfif>
								</label>

								<div class="controls">
									<div id='slugCheckErrors'></div>
									<div class="input-group">
										#html.textfield(
											name      = "slug",
											bind      = prc.oContent,
											maxlength = "1000",
											class     = "form-control",
											title     = "The unique slug for this content",
											disabled  = "#prc.oContent.isLoaded() && prc.oContent.getIsPublished() ? 'true' : 'false'#"
										)#
										<a title=""
											class="input-group-addon"
											href="javascript:void(0)"
											onclick="togglePermalink(); return false;"
											data-original-title="Lock/Unlock Slug"
											data-container="body"
										>
											<i
												id="togglePermalink"
												class="fa fa-#prc.oContent.isLoaded() && prc.oContent.getIsPublished() ? 'lock' : 'unlock'#"
											></i>
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
							#cbAdminComponent( "editor/ContentToolBar" )#

							<!--- CONTENT EDITOR --->
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

							<!--- EXCERPT EDITOR --->
							<cfif structKeyExists( prc.oContent, "getExcerpt" )>
								<div class="form-group">
									<label class="control-label" for="description">Excerpt:</label>
									<div class="controls">
										#html.textarea(
											name 	= "excerpt",
											value	= htmlEditFormat( prc.oContent.getExcerpt() ),
											rows	= "10",
											class	= "form-control"
										)#
									</div>
								</div>
							</cfif>
						</div>

						<!--- Custom Fields Tab --->
						<div role="tabpanel" class="tab-pane" id="custom_fields">
							<!--- Custom Fields Component --->
							#cbAdminComponent(
								"editor/CustomFields",
								{ fieldType : "content", customFields : prc.oContent.getCustomFields() }
							)#
						</div>

						<!--- SEO --->
                        <div role="tabpanel" class="tab-pane" id="seo">
                            #cbAdminComponent( "editor/SEOPanel" )#
                        </div>

						<!--- Persisted ONLY panels --->
						<cfif prc.oContent.isLoaded()>
							<!--- Version History Tab --->
							<div role="tabpanel" class="tab-pane" id="history">
								#prc.versionsViewlet#
							</div>
							<!--- Comments --->
                            <cfif prc.oContent.commentsAllowed()>
								<div role="tabpanel" class="tab-pane" id="comments">
									#prc.commentsViewlet#
								</div>
							</cfif>
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
						<h3 class="panel-title"><i class="fa fa-info-circle"></i> #prc.oContent.getContentType()# Details</h3>
					</div>
					<div class="panel-body">
						<!--- Publishing Panel --->
						#cbAdminComponent(
							"editor/sidebar/PublishingPanel"
						)#

						<!--- Accordion --->
						<div id="accordion" class="panel-group accordion" data-stateful="content-sidebar">

							<!---Info Table If Loaded--->
							<cfif prc.oContent.isLoaded()>
								#cbAdminComponent( "editor/sidebar/InfoTable" )#
							</cfif>

							<!--- Page Display Options --->
							<cfif prc.oContent.getContentType() eq "page">
								#cbAdminComponent( "editor/sidebar/DisplayOptions" )#
							</cfif>

							<!---Related Content--->
							#cbAdminComponent( "editor/sidebar/RelatedContent" )#

							<!--- Linked Content--->
							#cbAdminComponent( "editor/sidebar/LinkedContent" )#

							<!---Modifiers--->
							#cbAdminComponent( "editor/sidebar/Modifiers" )#

							<!--- Cache Settings--->
							#cbAdminComponent( "editor/sidebar/CacheSettings" )#

							<!---Categories--->
							#cbAdminComponent( "editor/sidebar/Categories" )#

							<!--- Feature Image --->
							<cfif !prc.oContent.isContentStore()>
								#cbAdminComponent( "editor/sidebar/FeaturedImage" )#
							</cfif>

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