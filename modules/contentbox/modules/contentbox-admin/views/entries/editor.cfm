<cfoutput>
	<div class="btn-group btn-group-sm">
		<button
			class="btn btn-sm btn-primary"
			onclick="window.location.href='#event.buildLink( prc.xehentries )#';return false;">
			<i class="fas fa-chevron-left"></i> Back
		</button>

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
            <cfif prc.entry.isLoaded()>
				<li>
					<a href="#prc.CBHelper.linkEntry( prc.entry )#" target="_blank">
						<i class="far fa-eye fa-lg"></i> Open In Site
					</a>
				</li>
            </cfif>
        </ul>
	</div>

	<!--- Entry Form  --->
	#html.startForm(
        action      = prc.xehEntrySave,
        name        = "entryForm",
        novalidate  = "novalidate",
        class       = "form-vertical mt5"
	)#

	<div class="row">

		<!--- ******************************************************************************** --->
		<!--- Content Area --->
		<!--- ******************************************************************************** --->
        <div class="col-md-8" id="main-content-slot">
            <!--- MessageBox --->
            #cbMessageBox().renderit()#

            <!--- id --->
            #html.hiddenField( name="contentID",	bind=prc.entry )#
            #html.hiddenField( name="contentType",	bind=prc.entry )#
            #html.hiddenField( name="sluggerURL",	value=event.buildLink( prc.xehSlugify ) )#

            <div class="panel panel-default">

                <!-- Nav tabs -->
                <div class="tab-wrapper m0">
                    <ul class="nav nav-tabs" role="tablist">

                        <li role="presentation" class="active">
                            <a href="##editor" aria-controls="editor" role="tab" data-toggle="tab">
                                <i class="fas fa-pen"></i> Editor
                            </a>
                        </li>

                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_CUSTOM_FIELDS" )>
                            <li role="presentation">
                                <a href="##custom_fields" aria-controls="custom_fields" role="tab" data-toggle="tab">
                                    <i class="fas fa-microchip"></i> Custom Fields
                                </a>
                            </li>
                        </cfif>

                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_HTML_ATTRIBUTES" )>
                            <li role="presentation">
                                <a href="##seo" aria-controls="seo" role="tab" data-toggle="tab">
                                    <i class="fa fa-cloud"></i> SEO
                                </a>
                            </li>
                        </cfif>

                        <!---Loaded Panels--->
                        <cfif prc.entry.isLoaded()>
                            <li role="presentation">
                                <a href="##history" aria-controls="history" role="tab" data-toggle="tab">
                                    <i class="fa fa-history"></i> History
                                </a>
                            </li>

                            <li role="presentation">
                                <a href="##comments" aria-controls="comments" role="tab" data-toggle="tab">
                                    <i class="far fa-comments"></i> Comments
                                </a>
                            </li>
						</cfif>

						<!--- Event --->
						#announce( "cbadmin_entryEditorNav" )#
                    </ul>
                </div>

                <div class="panel-body tab-content">

                    <!--- Editor --->
                    <div role="tabpanel" class="tab-pane active" id="editor">
                        <!--- title --->
                        #html.textfield(
                            label    	= "Title:",
                            name     	= "title",
                            bind     	= prc.entry,
                            maxlength	= "100",
                            required 	= "required",
                            title    	= "The title for this entry",
                            class    	= "form-control",
                            wrapper  	= "div class=controls",
                            labelClass	= "control-label",
                            groupWrapper= "div class=form-group"
                        )#

                        <!--- slug --->
                        <div class="form-group">
                            <label for="slug" class="control-label">Permalink:
                                <i class="fa fa-cloud" title="Convert title to permalink" onclick="createPermalink()"></i>
                                <small> #prc.CBHelper.linkEntryWithSlug('')#</small>
                            </label>
                            <div class="controls">
                                <div id='slugCheckErrors'></div>
                                <div class="input-group">
                                    #html.textfield(
                                        name      = "slug",
                                        bind      = prc.entry,
                                        maxlength = "100",
                                        class     = "form-control",
                                        title     = "The URL permalink for this entry",
                                        disabled  = "#prc.entry.isLoaded() && prc.entry.getIsPublished() ? 'true' : 'false'#"
                                    )#
                                    <a title="" class="input-group-addon" href="javascript:void(0)" onclick="togglePermalink(); return false;" data-original-title="Lock/Unlock Permalink" data-container="body">
                                        <i id="togglePermalink" class="fa fa-#prc.entry.isLoaded() && prc.entry.getIsPublished() ? 'lock' : 'unlock'#"></i>
                                    </a>
                                </div>
                            </div>
						</div>

                        <!---ContentToolBar --->
                        #renderView(
							view 			= "_tags/content/toolbar",
							args 			= { content : prc.entry },
							prePostExempt 	= true
						)#

                        <!--- content --->
                        #html.textarea(
                            name 	= "content",
                            value	= htmlEditFormat( prc.entry.getContent() ),
                            rows 	= "25",
                            class	= "form-control"
                        )#
                        <!--- excerpt --->
                        #html.textarea(
                            label	= "Excerpt:",
                            name 	= "excerpt",
                            bind 	= prc.entry,
                            rows 	= "10",
                            class	= "form-control"
                        )#
                    </div>

                    <!--- Custom Fields --->
                    <div role="tabpanel" class="tab-pane" id="custom_fields">
                        #renderView(
							view = "_tags/customFields",
							args = {
								fieldType 	 = "Entry",
								customFields = prc.entry.getCustomFields()
							}
						)#
                    </div>

                    <!--- SEO --->
					<div role="tabpanel" class="tab-pane" id="seo">

                        <div class="form-group">
                            #html.textfield(
                                name      = "htmlTitle",
                                label     = "Title: (Leave blank to use blog entry title)",
                                bind      = prc.entry,
                                class     = "form-control",
                                maxlength = "255"
                            )#
						</div>

						<div class="form-group">
							<label for="htmlKeywords">
								Keywords: (<span id='html_keywords_count'>0</span>/160 characters left)
							</label>
                            #html.textArea(
                                name 		= "htmlKeywords",
                                bind     	= prc.entry,
                                class    	= "form-control",
                                maxlength	= "160",
                                rows     	= "5"
                            )#
						</div>

						<div class="form-group">
							<label for="htmlKeywords">
								Description: (<span id='html_description_count'>0</span>/160 characters left)
							</label>
                            #html.textArea(
                                name 		= "htmlDescription",
                                bind 		= prc.entry,
                                class    	= "form-control",
                                maxlength	= "160",
                                rows     	= "5"
                            )#
                        </div>
                    </div>

                    <!---Loaded Panels--->
                    <cfif prc.entry.isLoaded()>
                        <!--- History --->
                        <div role="tabpanel" class="tab-pane" id="history">
                            #prc.versionsViewlet#
                        </div>

                         <!--- Comments --->
                        <div role="tabpanel" class="tab-pane" id="comments">
                            #prc.commentsViewlet#
                        </div>
					</cfif>

					<!--- Custom tab content --->
					#announce( "cbadmin_entryEditorNavContent" )#

				</div>

                <!--- Event --->
				#announce( "cbadmin_entryEditorInBody" )#

            </div>

			<!--- Event --->
			#announce( "cbadmin_entryEditorFooter" )#

		</div>

		<!--- ******************************************************************************** --->
		<!--- SideBar Area --->
		<!--- ******************************************************************************** --->
        <div class="col-md-4" id="main-content-sidebar">
            <div class="panel panel-primary">

				<div class="panel-heading">
                    <h3 class="panel-title"><i class="fa fa-info-circle"></i> Entry Details</h3>
				</div>

				<div class="panel-body">

					<!--- Publishing Panel --->
                    #renderView(
						view 			= "_tags/content/publishing",
						args 			= { content = prc.entry },
						prePostExempt 	= true
					)#

                    <!--- Accordion --->
                    <div id="accordion" class="panel-group accordion" data-stateful="entry-sidebar">

                        <!---Begin Info--->
                        <cfif prc.entry.isLoaded()>
                            #renderView(
                                view    		= "_tags/content/infotable",
								args    		= { content = prc.entry },
								prePostExempt 	= true
                            )#
                        </cfif>

                        <!---Begin Related Content--->
                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_RELATED_CONTENT" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##relatedcontent">
                                        <i class="fas fa-sitemap"></i> Related Content
                                    </a>

                                </h4>
                            </div>
                            <div id="relatedcontent" class="panel-collapse collapse">
                                <div class="panel-body">
                                    #renderView(
										view 			= "_tags/relatedContent",
										args 			= { relatedContent=prc.relatedContent },
										prePostExempt 	= true
									)#
                                </div>
                            </div>
                        </div>
                        <cfelse>
                            #html.hiddenField( name="relatedContentIDs", value=prc.relatedContentIDs )#
                        </cfif>
                        <!---End Related Content--->

                        <!---Begin Linked Content--->
                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_LINKED_CONTENT" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##linkedcontent">
                                        <i class="fa fa-link"></i> Linked Content
                                    </a>

                                </h4>
                            </div>
                            <div id="linkedcontent" class="panel-collapse collapse">
                                <div class="panel-body">
                                    #renderView(
										view 			= "_tags/linkedContent",
										args 			= {
											linkedContent : prc.linkedContent,
											contentType   : prc.entry.getContentType()
										},
										prePostExempt 	= true
									)#
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Linked Content--->

                        <!---Begin Modifiers--->
                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_MODIFIERS" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a
                                    	class="accordion-toggle collapsed block"
                                    	data-toggle="collapse"
                                    	data-parent="##accordion"
                                    	href="##modifiers">
                                        <i class="fas fa-toolbox"></i> Modifiers
                                    </a>
                                </h4>
                            </div>
                            <div id="modifiers" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <!--- Creator --->
                                    <cfif prc.entry.isLoaded() and prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN" )>
                                        <div class="form-group">
                                            <i class="fas fa-user-astronaut"></i>
                                            #html.label(
                                                field   = "creatorID",
                                                content = "Creator:",
                                                class   = "inline"
                                            )#
                                            <select name="creatorID" id="creatorID" class="form-control input-sm">
                                                <cfloop array="#prc.authors#" index="author">
                                                <option
                                                	value="#author.getAuthorID()#"
													<cfif prc.entry.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>
												>
													#author.getName()#
												</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </cfif>

                                    <!--- Allow Comments --->
                                    <cfif prc.cbSiteSettings.cb_comments_enabled>
                                        <div class="form-group">
                                            <i class="far fa-comments"></i>
                                            #html.label(
                                                field   = "allowComments",
                                                content = "Allow Comments:",
                                                class   = "inline"
                                            )#
                                            #html.select(
                                                name          = "allowComments",
                                                options       = "Yes,No",
                                                selectedValue = yesNoFormat( prc.entry.getAllowComments() ),
                                                class         = "form-control input-sm"
                                            )#
                                        </div>
                                    </cfif>

									<div class="form-group">
										<label for="showInSearch">
											<i class="fab fa-searchengin"></i> Show in Search:
										</label>
                                        <!--- Show in Search --->
                                        #html.select(
                                            name          = "showInSearch",
                                            class         = "form-control input-sm",
                                            options       = "Yes,No",
                                            selectedValue = yesNoFormat( prc.entry.getShowInSearch() )
                                        )#
                                    </div>

                                    <!--- Password Protection --->
                                    <div class="form-group">
										<label for="passwordProtection">
											<i class="fas fa-key"></i> Password Protection:
										</label>
                                        #html.textfield(
                                            name      = "passwordProtection",
                                            bind      = prc.entry,
                                            title     = "Password protect your entry, leave empty for none",
                                            class     = "form-control",
                                            maxlength = "100"
                                        )#
                                    </div>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Modfiers--->

                        <!---Begin Cache Settings--->
                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_CACHING" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##cachesettings">
                                        <i class="fas fa-database"></i> Cache Settings
                                    </a>
                                </h4>
                            </div>
                            <div id="cachesettings" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <div class="form-group">
										<!--- Cache Settings --->
										#html.label(
											field	= "cacheLayout",
											content	= "Cache Entire Page: (faster)"
										)#

										<br />
										<small>Caches the entire page output including translations</small><Br/>

										#html.select(
											name			= "cacheLayout",
											options			= "Yes,No",
											selectedValue	= yesNoFormat( prc.entry.getCacheLayout() ),
											class			= "form-control input-sm"
										)#
									</div>

									<div class="form-group">
										<!--- Cache Settings --->
										#html.label(
											field	= "cache",
											content	= "Cache Content: (fast)"
										)#
										<br /><small>Caches content translation only</small><Br/>
										#html.select(
											name          = "cache",
											options       = "Yes,No",
											selectedValue = yesNoFormat( prc.entry.getCache() ),
											class         = "form-control input-sm"
										)#
									</div>
                                    <div class="form-group">
                                        #html.inputField(
                                            type="numeric",
                                            name="cacheTimeout",
                                            label="Cache Timeout (0=Use Global):",
                                            bind=prc.entry,
                                            title="Enter the number of minutes to cache your content, 0 means use global default",
                                            class="form-control",
                                            size="10",
                                            maxlength="100"
                                        )#
                                    </div>
                                    <div class="form-group">
                                        #html.inputField(
                                            type="numeric",
                                            name="cacheLastAccessTimeout",
                                            label="Idle Timeout: (0=Use Global)",
                                            bind=prc.entry,
                                            title="Enter the number of minutes for an idle timeout for your content, 0 means use global default",
                                            class="form-control",
                                            size="10",
                                            maxlength="100"
                                        )#
                                    </div>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Cache Settings--->

                        <!---Begin Categories--->
                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_CATEGORIES" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##categories">
                                        <i class="fas fa-tags"></i> Categories
                                    </a>
                                </h4>
                            </div>
                            <div id="categories" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <!--- Display categories --->
                                    <cfloop from="1" to="#arrayLen(prc.categories)#" index="x">
                                        <div class="checkbox">
                                        <label>
                                        #html.checkbox(
                                            name="category_#x#",
                                            value="#prc.categories[ x ].getCategoryID()#",
                                            checked=prc.entry.hasCategories( prc.categories[ x ] )
                                        )#
                                        #prc.categories[ x ].getCategory()#
                                        </label>
                                        </div>
                                    </cfloop>

                                    <!--- New Categories --->
                                    #html.textField(
                                        name="newCategories",
                                        label="New Categories",
                                        size="30",
                                        title="Comma delimited list of new categories to create",
                                        class="form-control"
                                    )#
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Categories--->

                        <!---Begin Featured Image --->
                        <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_FEATURED_IMAGE" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##featuredImagePanel">
                                        <i class="fas fa-photo-video"></i> Featured Image
                                    </a>
                                </h4>
                            </div>
                            <div id="featuredImagePanel" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <div class="form-group text-center">
                                        <!--- Select and Cancel Buttons --->
                                        <a
                                        	class="btn btn-primary"
											href="javascript:loadAssetChooser( 'featuredImageCallback' )"
										>
											Select Image
										</a>
                                        <!--- Featured Image Selection --->
                                        <div class="<cfif !len( prc.entry.getFeaturedImageURL() )>hide</cfif> form-group" id="featuredImageControls">
											#html.textField(
                                            	name 		= "featuredImage",
                                            	bind 		= prc.entry,
                                            	class 		= "form-control",
												readonly 	= true,
												title 		= "The actual image path to deliver"
                                            )#
                                            #html.hiddenField(
                                            	name = "featuredImageURL",
                                            	bind = prc.entry
											)#

                                            <!--- Image Preview --->
                                            <div class="m10">
                                            	<cfif len( prc.entry.getFeaturedImageURL() )>
                                            		<img id="featuredImagePreview" src="#prc.entry.getFeaturedImageURL()#" class="img-thumbnail" height="75">
                                            	<cfelse>
                                            		<img id="featuredImagePreview" class="img-thumbnail" height="75">
                                            	</cfif>
											</div>

											<!--- Clear Image --->
											<a class="btn btn-danger" href="javascript:cancelFeaturedImage()">Clear Image</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Featured Image--->

                        <!--- Event --->
                        #announce( "cbadmin_entryEditorSidebarAccordion" )#
                    </div>
                    <!--- End Accordion --->

                    <!--- Event --->
                    #announce( "cbadmin_entryEditorSidebar" )#
                </div>
            </div>
            <!--- Event --->
            #announce( "cbadmin_entryEditorSidebarFooter" )#
        </div>
    </div>
#html.endForm()#
</cfoutput>
