<cfoutput>
<!--- Page Form  --->
#html.startForm(
    action=prc.xehPageSave,
    name="pageForm",
    novalidate="novalidate",
    class="form-vertical"
)#
    <div class="row">
        <div class="col-md-12">
            <h1 class="h1"><i class="fa fa-edit"></i> Page Editor</h1>
        </div>
    </div>
    <div class="row">
        <div class="col-md-8">
            <!--- MessageBox --->
            #getModel( "messagebox@cbMessagebox" ).renderit()#

            <!--- id --->
            #html.hiddenField(name="contentID",bind=prc.page)#
            #html.hiddenField(name="contentType",bind=prc.page)#

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">&nbsp;</h3>
                    <div class="actions pull-right">
                        <div class="btn-group btn-group-sm">
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
                    </div>
                </div>
                <div class="panel-body">
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
                    <cfset markupArgs = { content=prc.page }>
                    #renderView(view="_tags/content/markup",args=markupArgs)#
                    
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
                <!--- Event --->
                #announceInterception( "cbadmin_pageEditorInBody" )#
            </div>
            <!--- Custom Fields --->
            <!--- I have to use the json garbage as CF9 Blows up on the implicit structs, come on man! --->
            <cfset mArgs = {fieldType="Page", customFields=prc.page.getCustomFields()}>
            #renderView(view="_tags/customFields",args=mArgs)#
            <!---Loaded Panels--->
            <cfif prc.page.isLoaded()>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-clock-o fa-lg"></i> Versions</h3>
                    </div>
                    <div class="panel-body">
                        #prc.versionsViewlet#
                    </div>
                </div>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-comment fa-lg"></i> Comments</h3>
                    </div>
                    <div class="panel-body">
                        #prc.commentsViewlet#
                    </div>
                </div>
            </cfif>
            <!--- Event --->
            #announceInterception( "cbadmin_pageEditorFooter" )#
        </div>
        <div class="col-md-4">
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
                                    <table class="table table-hover table-condensed table-striped" width="100%">
                                        <tr>
                                            <th width="85" class="textRight">Created By:</th>
                                            <td>
                                                <a href="mailto:#prc.page.getCreatorEmail()#">#prc.page.getCreatorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Created On:</th>
                                            <td>
                                                #prc.page.getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Published On:</th>
                                            <td>
                                                #prc.page.getDisplayPublishedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Version:</th>
                                            <td>
                                                #prc.page.getActiveContent().getVersion()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="85" class="textRight">Last Edit By:</th>
                                            <td>
                                                <a href="mailto:#prc.page.getAuthorEmail()#">#prc.page.getAuthorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="85" class="textRight">Last Edit On:</th>
                                            <td>
                                                #prc.page.getActiveContent().getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Child Pages:</th>
                                            <td>
                                                #prc.page.getNumberOfChildren()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Views:</th>
                                            <td>
                                                #prc.page.getNumberOfHits()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Comments:</th>
                                            <td>
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
                                            selectedValue=yesNoFormat(prc.page.getShowInMenu())
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
                                        <i class="fa-hdd-o fa-lg"></i> Cache Settings
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
                                        <label class="checkbox">
                                        #html.checkbox(
                                            name="category_#x#",
                                            value="#prc.categories[ x ].getCategoryID()#",
                                            checked=prc.page.hasCategories( prc.categories[ x ] )
                                        )#
                                        #prc.categories[ x ].getCategory()#
                                        </label>
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
                            
                        <!---Begin HTML Attributes--->
                        <cfif prc.oAuthor.checkPermission( "EDITORS_HTML_ATTRIBUTES" )>   
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##htmlattributes">
                                        <i class="fa fa-cloud fa-lg"></i> HTML Attributes
                                    </a>
                                </h4>
                            </div>
                            <div id="htmlattributes" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <div class="form-group">
                                        #html.textArea(
                                            name="htmlKeywords",
                                            label="Keywords: (<span id='html_keywords_count'>0</span>/160 characters left)", 
                                            bind=prc.page,
                                            class="form-control",
                                            maxlength="160"
                                        )#
                                    </div>
                                    <div class="form-group">
                                        #html.textArea(
                                            name="htmlDescription",
                                            label="Description: (<span id='html_description_count'>0</span>/160 characters left)", 
                                            bind=prc.page,
                                            class="form-control",
                                            maxlength="160"
                                        )#
                                    </div>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End HTML Attributes--->    
                        
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