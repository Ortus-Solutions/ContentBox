<cfoutput>
<div class="btn-group btn-group-xs">
    <button class="btn btn-sm btn-info" onclick="window.location.href='#event.buildLink(prc.xehPages)#/parent/#prc.parentcontentID#';return false;">
        <i class="fa fa-reply"></i> Back
    </button>
    <button class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" title="Quick Actions">
        <span class="fa fa-cog"></span>
    </button>
    <ul class="dropdown-menu">
        <li><a href="javascript:quickPublish( false )"><i class="fa fa-globe"></i> Publish</a></li>
        <li><a href="javascript:quickPublish( true )"><i class="fa fa-eraser"></i> Publish as Draft</a></li>
        <li><a href="javascript:quickSave()"><i class="fa fa-save"></i> Quick Save</a></li>
        <cfif prc.page.isLoaded()>
            <li><a href="#prc.CBHelper.linkPage( prc.page )#" target="_blank"><i class="fa fa-eye"></i> Open In Site</a></li>
        </cfif>
    </ul>
</div>
<!--- Page Form  --->
#html.startForm(
    action      = prc.xehPageSave,
    name        = "pageForm",
    novalidate  = "novalidate",
    class       = "form-vertical"
)#

    <div class="row">
        <div class="col-md-8" id="main-content-slot">
            <!--- MessageBox --->
            #getModel( "messagebox@cbMessagebox" ).renderit()#

            <!--- id --->
            #html.hiddenField(name="contentID",bind=prc.page)#
            #html.hiddenField(name="contentType",bind=prc.page)#

            <div class="panel panel-default">
                <!-- Nav tabs -->
                <div class="tab-wrapper margin0">
                    <ul class="nav nav-tabs" role="tablist">

                        <li role="presentation" class="active">
                            <a href="##editor" aria-controls="editor" role="tab" data-toggle="tab">
                                <i class="fa fa-edit"></i> Editor
                            </a>
                        </li>

                        <cfif prc.oAuthor.checkPermission( "EDITORS_CUSTOM_FIELDS" )>
                            <li role="presentation">
                                <a href="##custom_fields" aria-controls="custom_fields" role="tab" data-toggle="tab">
                                    <i class="fa fa-truck"></i> Custom Fields
                                </a>
                            </li>
                        </cfif>

                        <cfif prc.oAuthor.checkPermission( "EDITORS_HTML_ATTRIBUTES" )>
                            <li role="presentation">
                                <a href="##seo" aria-controls="seo" role="tab" data-toggle="tab">
                                    <i class="fa fa-cloud"></i> SEO
                                </a>
                            </li>
                        </cfif>

                        <!---Loaded Panels--->
                        <cfif prc.page.isLoaded()>
                            <li role="presentation">
                                <a href="##history" aria-controls="history" role="tab" data-toggle="tab">
                                    <i class="fa fa-history"></i> History
                                </a>
                            </li>

                            <li role="presentation">
                                <a href="##comments" aria-controls="comments" role="tab" data-toggle="tab">
                                    <i class="fa fa-comments"></i> Comments
                                </a>
                            </li>
                        </cfif>
                    </ul>
                </div>

                <div class="panel-body tab-content">
                    
                    <!--- Editor --->
                    <div role="tabpanel" class="tab-pane active" id="editor">
                        <!--- title --->
                        #html.textfield(
                            label="Title:",
                            name="title",
                            bind=prc.page,
                            maxlength="100",
                            required="required",
                            title="The title for this page",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        <!--- slug --->
                        <div class="form-group">
                            <label for="slug" class="control-label">Permalink:
                                <i class="fa fa-cloud" title="Convert title to permalink" onclick="createPermalink()"></i>
                                <small> #prc.CBHelper.linkPageWithSlug('')#</small>
                                <cfif prc.page.hasParent()>
                                    <small>#prc.page.getParent().getSlug()#/</small>
                                </cfif>
                            </label>
                            <div class="controls">
                                <div id='slugCheckErrors'></div>
                                <div class="input-group">
                                    #html.textfield(
                                        name="slug", 
                                        bind=prc.page, 
                                        maxlength="100", 
                                        class="form-control", 
                                        title="The URL permalink for this page", 
                                        disabled="#prc.page.isLoaded() && prc.page.getIsPublished() ? 'true' : 'false'#"
                                    )#
                                    
                                    <a title="" class="input-group-addon" href="javascript:void(0)" onclick="togglePermalink(); return false;" data-original-title="Lock/Unlock Permalink" data-container="body">
                                        <i id="togglePermalink" class="fa fa-#prc.page.isLoaded() && prc.page.getIsPublished() ? 'lock' : 'unlock'#"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <!---ContentToolBar --->
                        #renderView( view="_tags/content/markup", args={ content = prc.page } )#
                        
                        <!--- content --->
                        #html.textarea(
                            name="content", 
                            value=htmlEditFormat( prc.page.getContent() ), 
                            rows="25", 
                            class="form-control"
                        )#
                        <cfif prc.cbSettings.cb_page_excerpts>
                            <!--- excerpt --->
                            #html.textarea(
                                label="Excerpt:", 
                                name="excerpt", 
                                bind=prc.page, 
                                rows="10", 
                                class="form-control"
                            )#
                        </cfif>
                    </div>
                    
                    <!--- Custom Fields --->
                     <div role="tabpanel" class="tab-pane" id="custom_fields">
                         #renderView( view="_tags/customFields", args={ fieldType="Page", customFields=prc.page.getCustomFields() } )#
                    </div>

                    <!--- SEO --->
                    <div role="tabpanel" class="tab-pane" id="seo">
                        <div class="form-group">
                            #html.textfield(
                                name="htmlTitle",
                                label="Title: (Leave blank to use the page name)", 
                                bind=prc.page,
                                class="form-control",
                                maxlength="255"
                            )#
                        </div>
                        <div class="form-group">
                            #html.textArea(
                                name="htmlKeywords",
                                label="Keywords: (<span id='html_keywords_count'>0</span>/160 characters left)", 
                                bind=prc.page,
                                class="form-control",
                                maxlength="160",
                                rows="5"
                            )#
                        </div>
                        <div class="form-group">
                            #html.textArea(
                                name="htmlDescription",
                                label="Description: (<span id='html_description_count'>0</span>/160 characters left)", 
                                bind=prc.page,
                                class="form-control",
                                maxlength="160",
                                rows="5"
                            )#
                        </div>
                    </div>
                    
                    <cfif prc.page.isLoaded()>
                        <!--- History --->
                        <div role="tabpanel" class="tab-pane" id="history">
                            #prc.versionsViewlet#
                        </div>
                        
                        <!--- Comments --->
                        <div role="tabpanel" class="tab-pane" id="comments">
                            #prc.commentsViewlet#
                        </div>
                    </cfif>
                </div>
                <!--- Event --->
                #announceInterception( "cbadmin_pageEditorInBody" )#
            </div>
                
            <!--- Event --->
            #announceInterception( "cbadmin_pageEditorFooter" )#
        </div>
        <div class="col-md-4" id="main-content-sidebar">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fa fa-info-circle"></i> Page Details</h3>
                </div>
                <div class="panel-body">
                    <cfset pArgs = { content=prc.page }>
                    #renderView( view="_tags/content/publishing", args=pArgs )#

                    <!--- Accordion --->
                    <div id="accordion" class="panel-group accordion" data-stateful="page-sidebar">
                        <!---Begin Page Info--->
                        <cfif prc.page.isLoaded()> 
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##pageinfo">
                                        <i class="fa fa-info-circle fa-lg"></i> Page Info
                                    </a>
                                </h4>
                            </div>
                            <div id="pageinfo" class="panel-collapse collapse in">
                                <div class="panel-body">
                                    <!--- Persisted Info --->
                                    <table class="table table-hover table-condensed table-striped">
                                        <tr>
                                            <th class="col-md-4">Created By:</th>
                                            <td class="col-md-8">
                                                <a href="mailto:#prc.page.getCreatorEmail()#">#prc.page.getCreatorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Created On:</th>
                                            <td class="col-md-8">
                                                #prc.page.getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Published On:</th>
                                            <td class="col-md-8">
                                                #prc.page.getDisplayPublishedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Version:</th>
                                            <td class="col-md-8">
                                                #prc.page.getActiveContent().getVersion()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Last Edit By:</th>
                                            <td class="col-md-8">
                                                <a href="mailto:#prc.page.getAuthorEmail()#">#prc.page.getAuthorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Last Edit On:</th>
                                            <td class="col-md-8">
                                                #prc.page.getActiveContent().getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Child Pages:</th>
                                            <td class="col-md-8">
                                                #prc.page.getNumberOfChildren()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Views:</th>
                                            <td class="col-md-8">
                                                #prc.page.getNumberOfHits()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Comments:</th>
                                            <td class="col-md-8">
                                                #prc.page.getNumberOfComments()#
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End page Info--->
                        
                        <!---Begin Display Options--->
                        <cfif prc.oAuthor.checkPermission( "EDITORS_DISPLAY_OPTIONS" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##displayoptions">
                                    <i class="fa fa-picture-o fa-lg"></i> Display Options
                                    </a>
                                </h4>
                            </div>
                            <div id="displayoptions" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <div class="form-group">
                                        <!--- Parent Page --->
                                        #html.label(
                                            field="parentPage",
                                            content='Parent:',
                                            class="control-label"
                                        )#
                                        <select name="parentPage" id="parentPage" class="form-control input-sm">
                                            <option value="null">No Parent</option>
                                            #html.options(
                                                values=prc.pages,
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
                                            <option value="-inherit-" <cfif prc.page.getLayoutWithDefault() eq "-inherit-">selected="selected"</cfif>>-inherit-</option>
                                            <option value="-no-layout-" <cfif prc.page.getLayoutWithDefault() eq "-no-layout-">selected="selected"</cfif>>-no-layout-</option>
                                            <!-- Custom Layouts -->
                                            #html.options(
                                                values=prc.availableLayouts, 
                                                selectedValue=prc.page.getLayoutWithDefault()
                                            )#
                                        </select>
                                    </div>
                                    <div class="form-group">
                                    <!--- mobile layout --->
                                        #html.label(field="mobileLayout",content='Mobile Layout:',
                                            class="control-label" )#
                                        <select name="mobileLayout" id="mobileLayout" class="form-control input-sm">
                                            <option value="" <cfif prc.page.getMobileLayout() eq "">selected="selected"</cfif>>-None-</option>
                                            <option value="-inherit-" <cfif prc.page.getMobileLayout() eq "-inherit-">selected="selected"</cfif>>-inherit-</option>
                                            #html.options(
                                                values=prc.availableLayouts, 
                                                selectedValue=prc.page.getMobileLayout()
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
                                            selectedValue=yesNoFormat( prc.page.getShowInMenu() )
                                        )#
                                    </div>
                                    <div class="form-group">
                                        <!--- Show in Search --->
                                        #html.select(
                                            name="showInSearch",
                                            label="Show In Search:",
                                            class="form-control input-sm",
                                            options="Yes,No",
                                            selectedValue=yesNoFormat( prc.page.getShowInSearch() )
                                        )#
                                    </div>
                                    <div class="form-group">
                                        <!--- menu order --->
                                        #html.inputfield(
                                            type="number",
                                            label="Menu Order: (0-99)",
                                            name="order",
                                            bind=prc.page,
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
                            #html.hiddenField(name="parentPage", value=prc.parentcontentID)#
                        </cfif>
                        <!---End Display Options--->

                        <!---Begin Related Content--->
                        <cfif prc.oAuthor.checkPermission( "EDITORS_RELATED_CONTENT" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##relatedcontent">
                                        <i class="fa fa-sitemap fa-lg"></i> Related Content                                
                                    </a>

                                </h4>
                            </div>
                            <div id="relatedcontent" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <cfset rcArgs = { relatedContent=prc.relatedContent }>
                                    #renderView( view="_tags/relatedContent", args=rcArgs )#
                                </div>
                            </div>
                        </div>
                        <cfelse>
                            #html.hiddenField( name="relatedContentIDs", value=prc.relatedContentIDs )#
                        </cfif>
                        <!---End Related Content--->

                        <!---Begin Linked Content--->
                        <cfif prc.oAuthor.checkPermission( "EDITORS_LINKED_CONTENT" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##linkedcontent">
                                        <i class="fa fa-link fa-lg"></i> Linked Content                                
                                    </a>

                                </h4>
                            </div>
                            <div id="linkedcontent" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <cfset rcArgs = { linkedContent=prc.linkedContent, contentType=prc.page.getContentType() }>
                                    #renderView( view="_tags/linkedContent", args=rcArgs )#
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Linked Content--->

                        <!---Begin Modifiers--->
                        <cfif prc.oAuthor.checkPermission( "EDITORS_MODIFIERS" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##modifiers">
                                        <i class="fa fa-cogs fa-lg"></i> Modifiers
                                    </a>
                                </h4>
                            </div>
                            <div id="modifiers" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <!--- Creator --->
                                    <cfif prc.page.isLoaded() and prc.oAuthor.checkPermission( "ENTRIES_ADMIN" )>
                                        <div class="form-group">
                                            <i class="fa fa-user fa-lg"></i>
                                            #html.label(
                                                field="creatorID",
                                                content="Creator:",
                                                class="inline"
                                            )#
                                            <select name="creatorID" id="creatorID" class="form-control input-sm">
                                                <cfloop array="#prc.authors#" index="author">
                                                <option value="#author.getAuthorID()#" <cfif prc.page.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </cfif>
                                    
                                    <!--- Allow Comments --->
                                    <cfif prc.cbSettings.cb_comments_enabled>
                                        <div class="form-group">
                                            <i class="fa fa-comments fa-lg"></i> 
                                            #html.label(
                                                field="allowComments",
                                                content="Allow Comments:",
                                                class="inline"
                                            )#
                                            #html.select(
                                                name="allowComments",
                                                options="Yes,No",
                                                selectedValue=yesNoFormat(prc.page.getAllowComments()), 
                                                class="form-control input-sm"
                                            )#
                                        </div>
                                    </cfif>

                                    <!--- SSL Only --->
                                    <div class="form-group">
                                        <i class="icon-shield icon-large"></i>
                                        #html.label(
                                            field="sslOnly",
                                            content="SSL Only:",
                                            class="inline"
                                        )#
                                        #html.select(
                                            name="sslOnly",
                                            options="Yes,No", 
                                            selectedValue=yesNoFormat( prc.page.getSSLOnly() ), 
                                            class="form-control input-sm"
                                        )#
                                    </div>
                                    
                                    <!--- Password Protection --->
                                    <div class="form-group">
                                        <label for="passwordProtection"><i class="fa fa-lock fa-lg"></i> Password Protection:</label>
                                        #html.textfield(
                                            name="passwordProtection",
                                            bind=prc.page,
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
                        <cfif prc.oAuthor.checkPermission( "EDITORS_CACHING" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##cachesettings">
                                        <i class="fa fa-rocket fa-lg"></i> Cache Settings
                                    </a>
                                </h4>
                            </div>
                            <div id="cachesettings" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <div class="form-group">
                                        <!--- Cache Settings --->
                                        #html.label(
                                            field="cache",
                                            content="Cache Content: (fast)"
                                        )#
                                        <br /><small>Caches content translation only</small><Br/>
                                        #html.select(
                                            name="cache",
                                            options="Yes,No",
                                            selectedValue=yesNoFormat(prc.page.getCache()), 
                                            class="form-control input-sm"
                                        )#
                                    </div>
                                    <div class="form-group">
                                        #html.inputField(
                                            type="numeric",
                                            name="cacheTimeout",
                                            label="Cache Timeout (0=Use Global):",
                                            bind=prc.page,
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
                                            bind=prc.page,
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
                        <cfif prc.oAuthor.checkPermission( "EDITORS_CATEGORIES" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##categories">
                                        <i class="fa fa-tags fa-lg"></i> Categories
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
                                                checked=prc.page.hasCategories( prc.categories[ x ] )
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
                        <cfif prc.oAuthor.checkPermission( "EDITORS_FEATURED_IMAGE" )>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##featuredImagePanel">
                                        <i class="fa fa-picture-o fa-lg"></i> Featured Image
                                    </a>
                                </h4>
                            </div>
                            <div id="featuredImagePanel" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <div class="form-group text-center">
                                        <!--- Select and Cancel Buttons --->
                                        <a class="btn btn-primary" href="javascript:loadAssetChooser( 'featuredImageCallback' )">Select Image</a>
                                        <!--- Featured Image Selection --->
                                        <div class="<cfif !len( prc.page.getFeaturedImageURL() )>hide</cfif> form-group" id="featuredImageControls">
                                        	<a class="btn btn-danger" href="javascript:cancelFeaturedImage()">Clear Image</a>
                                            #html.hiddenField(
                                            	name 		= "featuredImage",
                                            	bind 		= prc.page
                                            )#
                                            #html.hiddenField(
                                            	name = "featuredImageURL",
                                            	bind = prc.page
                                            )#
                                            <!--- Image Preview --->
                                            <div class="margin10">
                                            	<cfif len( prc.page.getFeaturedImageURL() )>
                                            		<img id="featuredImagePreview" src="#prc.page.getFeaturedImageURL()#" class="img-thumbnail" height="75">
                                            	<cfelse>
                                            		<img id="featuredImagePreview" class="img-thumbnail" height="75">
                                            	</cfif>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>        
                        </cfif>
                        <!---End Featured Image--->
                        
                        <!--- Event --->
                        #announceInterception( "cbadmin_pageEditorSidebarAccordion" )#
                    </div>
                    <!--- End Accordion --->
        
                    <!--- Event --->
                    #announceInterception( "cbadmin_pageEditorSidebar" )#
                </div>
            </div>
            <!--- Event --->
            #announceInterception( "cbadmin_pageEditorSidebarFooter" )# 
        </div>
    </div>

#html.endForm()#
</cfoutput>
