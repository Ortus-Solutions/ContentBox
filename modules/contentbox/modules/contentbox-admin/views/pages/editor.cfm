<cfoutput>

    <!--- Page Form  --->
    #html.startForm(
        action      = prc.xehContentSave,
        name        = "pageForm",
        novalidate  = "novalidate",
        class       = "form-vertical mt5"
    )#

        <div class="row">
            <div class="col-md-8" id="main-content-slot">
                <!--- MessageBox --->
                #cbMessageBox().renderit()#

                <!--- ids --->
				#html.hiddenField( name="contentID", bind=prc.oContent )#
                #html.hiddenField( name="contentType", bind=prc.oContent )#

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
                            <cfif prc.oContent.isLoaded()>
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
                            #announce( "cbadmin_pageEditorNav" )#

                        </ul>
                    </div>

                    <div class="panel-body tab-content">

                        <!--- Editor --->
                        <div role="tabpanel" class="tab-pane active" id="editor">
                            <!--- title --->
                            #html.textfield(
                                label           = "Title:",
                                name            = "title",
                                bind            = prc.oContent,
                                maxlength       = "100",
                                required        = "required",
                                title           = "The title for this page",
                                class           = "form-control",
                                wrapper         = "div class=controls",
                                labelClass      = "control-label",
                                groupWrapper    = "div class=form-group"
                            )#

                            <!--- slug --->
                            <div class="form-group">
                                <label for="slug" class="control-label">Permalink:
                                    <i class="fa fa-cloud" title="Convert title to permalink" onclick="createPermalink()"></i>
                                    <small> #prc.CBHelper.linkPageWithSlug('')#</small>
                                    <cfif prc.oContent.hasParent()>
                                        <small>#prc.oContent.getParent().getSlug()#/</small>
                                    </cfif>
                                </label>
                                <div class="controls">
                                    <div id='slugCheckErrors'></div>
                                    <div class="input-group">
                                        #html.textfield(
                                            name="slug",
                                            bind=prc.oContent,
                                            maxlength="100",
                                            class="form-control",
                                            title="The URL permalink for this page",
                                            disabled="#prc.oContent.isLoaded() && prc.oContent.getIsPublished() ? 'true' : 'false'#"
                                        )#

                                        <a title="" class="input-group-addon" href="javascript:void(0)" onclick="togglePermalink(); return false;" data-original-title="Lock/Unlock Permalink" data-container="body">
                                            <i id="togglePermalink" class="fa fa-#prc.oContent.isLoaded() && prc.oContent.getIsPublished() ? 'lock' : 'unlock'#"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!--- ContentToolBar --->
                            #renderView(
								view 			= "_tags/content/toolbar",
								args 			= { content = prc.oContent },
								prePostExempt 	= true
							)#

                            <!--- content --->
                            #html.textarea(
                                name    = "content",
                                value   = htmlEditFormat( prc.oContent.getContent() ),
                                rows    = "25",
                                class   = "form-control"
                            )#

                            <cfif prc.cbSettings.cb_page_excerpts>
                                <!--- excerpt --->
                                #html.textarea(
                                    label   = "Excerpt:",
                                    name    = "excerpt",
                                    bind    = prc.oContent,
                                    rows    = "10",
                                    class   = "form-control"
                                )#
                            </cfif>
                        </div>

                        <!--- Custom Fields --->
                         <div role="tabpanel" class="tab-pane" id="custom_fields">
                             #renderView(
                                view 			= "_tags/customFields",
								args 			= { fieldType="Page", customFields=prc.oContent.getCustomFields() },
								prePostExempt 	= true
                            )#
                        </div>



                        <cfif prc.oContent.isLoaded()>
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
						#announce( "cbadmin_pageEditorNavContent" )#
					</div>

                    <!--- Event --->
                    #announce( "cbadmin_pageEditorInBody" )#
                </div>

                <!--- Event --->
                #announce( "cbadmin_pageEditorFooter" )#
            </div>

            <!---- SIDEBAR --->
            <div class="col-md-4" id="main-content-sidebar">
                <div class="panel panel-primary">

                    <div class="panel-heading">
						<h3 class="panel-title">
							<i class="fa fa-info-circle"></i> Details
						</h3>
                    </div>

                    <div class="panel-body">

                        #renderView(
                            view    		= "_tags/content/publishing",
							args    		= { content = prc.oContent },
							prePostExempt 	= true
                        )#

                        <!--- Accordion --->
                        <div id="accordion" class="panel-group accordion" data-stateful="page-sidebar">

                            <!---Begin Page Info--->
                            <cfif prc.oContent.isLoaded()>
                                #renderView(
                                    view    		= "_tags/content/infotable",
									args    		= { content = prc.oContent },
									prePostExempt 	= true
                                )#
                            </cfif>

                            <!---Begin Display Options--->
                            <cfif prc.oCurrentAuthor.checkPermission( "EDITORS_DISPLAY_OPTIONS" )>
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                        <a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##displayoptions">
                                        <i class="fas fa-photo-video"></i> Display Options
                                        </a>
                                    </h4>
                                </div>
                                <div id="displayoptions" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <!--- Parent Page --->
                                            #html.label(
                                                field="parentContent",
                                                content='Parent:',
                                                class="control-label"
                                            )#
                                            <select name="parentContent" id="parentContent" class="form-control input-sm">
                                                <option value="null">No Parent</option>
                                                #html.options(
                                                    values=prc.allContent,
                                                    column="contentID",
                                                    nameColumn="slug",
                                                    selectedValue=prc.parentcontentID
                                                )#
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <!--- layout --->
                                            #html.label(field="layout",content='Layout:',
                                                class="control-label" )#
                                            <select name="layout" id="layout" class="form-control input-sm">
                                                <!--- Core Layouts --->
                                                <option value="-inherit-" <cfif prc.oContent.getLayoutWithDefault() eq "-inherit-">selected="selected"</cfif>>-inherit-</option>
                                                <option value="-no-layout-" <cfif prc.oContent.getLayoutWithDefault() eq "-no-layout-">selected="selected"</cfif>>-no-layout-</option>
                                                <!-- Custom Layouts -->
                                                #html.options(
                                                    values=prc.availableLayouts,
                                                    selectedValue=prc.oContent.getLayoutWithDefault()
                                                )#
                                            </select>
                                        </div>
                                        <div class="form-group">
                                        <!--- mobile layout --->
                                            #html.label(field="mobileLayout",content='Mobile Layout:',
                                                class="control-label" )#
                                            <select name="mobileLayout" id="mobileLayout" class="form-control input-sm">
                                                <option value="" <cfif prc.oContent.getMobileLayout() eq "">selected="selected"</cfif>>-None-</option>
                                                <option value="-inherit-" <cfif prc.oContent.getMobileLayout() eq "-inherit-">selected="selected"</cfif>>-inherit-</option>
                                                #html.options(
                                                    values=prc.availableLayouts,
                                                    selectedValue=prc.oContent.getMobileLayout()
                                                )#
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <!--- Show in Menu Builders --->
                                            #html.select(
                                                name="showInMenu",
                                                label="Show In Menus:",
                                                class="form-control input-sm",
                                                options="Yes,No",
                                                selectedValue=yesNoFormat( prc.oContent.getShowInMenu() )
                                            )#
                                        </div>
                                        <div class="form-group">
                                            <!--- Show in Search --->
                                            #html.select(
                                                name="showInSearch",
                                                label="Show In Search:",
                                                class="form-control input-sm",
                                                options="Yes,No",
                                                selectedValue=yesNoFormat( prc.oContent.getShowInSearch() )
                                            )#
                                        </div>
                                        <div class="form-group">
                                            <!--- menu order --->
                                            #html.inputfield(
                                                type="number",
                                                label="Menu Order: (0-99)",
                                                name="order",
                                                bind=prc.oContent,
                                                title="The ordering index used when building menus",
                                                class="form-control",
                                                size="5",
                                                maxlength="2",
                                                min="0",
                                                max="99"
                                            )#
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <cfelse>
                                #html.hiddenField( name="parentContent", value=prc.parentcontentID )#
                            </cfif>
                            <!---End Display Options--->

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
											args 			= { relatedContent : prc.relatedContent },
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
											args 			= { linkedContent : prc.linkedContent, contentType : prc.oContent.getContentType() },
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
                                        <a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##modifiers">
                                            <i class="fas fa-toolbox"></i> Modifiers
                                        </a>
                                    </h4>
                                </div>
                                <div id="modifiers" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <!--- Creator --->
                                        <cfif prc.oContent.isLoaded() and prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN" )>
                                            <div class="form-group">
                                                <i class="fa fa-user"></i>
                                                #html.label(
                                                    field="creatorID",
                                                    content="Creator:",
                                                    class="inline"
                                                )#
                                                <select name="creatorID" id="creatorID" class="form-control input-sm">
                                                    <cfloop array="#prc.authors#" index="author">
                                                    <option value="#author.getAuthorID()#" <cfif prc.oContent.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getFullName()#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </cfif>

                                        <!--- Allow Comments --->
                                        <cfif prc.cbSiteSettings.cb_comments_enabled>
                                            <div class="form-group">
                                                <i class="far fa-comments"></i>
                                                #html.label(
                                                    field="allowComments",
                                                    content="Allow Comments:",
                                                    class="inline"
                                                )#
                                                #html.select(
                                                    name="allowComments",
                                                    options="Yes,No",
                                                    selectedValue=yesNoFormat( prc.oContent.getAllowComments() ),
                                                    class="form-control input-sm"
                                                )#
                                            </div>
                                        </cfif>

                                        <!--- SSL Only --->
                                        <div class="form-group">
                                            <i class="fas fa-user-shield"></i>
                                            #html.label(
                                                field="sslOnly",
                                                content="SSL Only:",
                                                class="inline"
                                            )#
                                            #html.select(
                                                name="sslOnly",
                                                options="Yes,No",
                                                selectedValue=yesNoFormat( prc.oContent.getSSLOnly() ),
                                                class="form-control input-sm"
                                            )#
                                        </div>

                                        <!--- Password Protection --->
                                        <div class="form-group">
                                            <label for="passwordProtection"><i class="fas fa-key"></i> Password Protection:</label>
                                            #html.textfield(
                                                name="passwordProtection",
                                                bind=prc.oContent,
                                                title="Password protect your page, leave empty for none",
                                                class="form-control",
                                                maxlength="100"
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
                                                selectedValue	= yesNoFormat( prc.oContent.getCacheLayout() ),
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
                                                selectedValue = yesNoFormat( prc.oContent.getCache() ),
                                                class         = "form-control input-sm"
                                            )#
										</div>

                                        <div class="form-group">
                                            #html.inputField(
                                                type="numeric",
                                                name="cacheTimeout",
                                                label="Cache Timeout (0=Use Global):",
                                                bind=prc.oContent,
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
                                                bind=prc.oContent,
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
                                        <div id="categoriesChecks">
                                        <cfloop from="1" to="#arrayLen(prc.categories)#" index="x">
                                            <div class="checkbox">
                                                <label>
                                                #html.checkbox(
                                                    name="category_#x#",
                                                    value="#prc.categories[ x ].getCategoryID()#",
                                                    checked=prc.oContent.hasCategories( prc.categories[ x ] )
                                                )#
                                                #prc.categories[ x ].getCategory()#
                                                </label>
                                            </div>
                                        </cfloop>
                                        </div>

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
                                            <div class="<cfif !len( prc.oContent.getFeaturedImageURL() )>hide</cfif> form-group" id="featuredImageControls">
												#html.hiddenField(
                                                    name 		= "featuredImage",
													bind 		= prc.oContent,
													class 		= "form-control",
													readonly 	= true,
													title 		= "The actual image path to deliver"
                                                )#
                                                #html.hiddenField(
                                                    name = "featuredImageURL",
                                                    bind = prc.oContent
												)#

                                                <!--- Image Preview --->
                                                <div class="m10">
                                                    <cfif len( prc.oContent.getFeaturedImageURL() )>
                                                        <img id="featuredImagePreview" src="#prc.oContent.getFeaturedImageURL()#" class="img-thumbnail" height="75">
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
                            #announce( "cbadmin_pageEditorSidebarAccordion" )#
                        </div>
                        <!--- End Accordion --->

                        <!--- Event --->
                        #announce( "cbadmin_pageEditorSidebar" )#
                    </div>
                </div>
                <!--- Event --->
                #announce( "cbadmin_pageEditorSidebarFooter" )#
            </div>
        </div>

    #html.endForm()#
    </cfoutput>
