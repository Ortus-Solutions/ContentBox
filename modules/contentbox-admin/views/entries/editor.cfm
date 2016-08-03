<cfoutput>
<div class="btn-group btn-group-xs">
    <button class="btn btn-sm btn-info" onclick="window.location.href='#event.buildLink(prc.xehentries)#';return false;">
        <i class="fa fa-reply"></i> Back
    </button>
    <button class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" title="Quick Actions">
        <span class="fa fa-cog"></span>
    </button>
    <ul class="dropdown-menu">
        <li><a href="javascript:quickPublish( false )"><i class="fa fa-globe"></i> Publish</a></li>
        <li><a href="javascript:quickPublish( true )"><i class="fa fa-eraser"></i> Publish as Draft</a></li>
        <li><a href="javascript:quickSave()"><i class="fa fa-save"></i> Quick Save</a></li>
        <cfif prc.entry.isLoaded()>
        <li><a href="#prc.CBHelper.linkEntry( prc.entry )#" target="_blank"><i class="fa fa-eye"></i> Open In Site</a></li>
        </cfif>
    </ul>
</div>
<!--- Entry Form  --->
#html.startForm(
    action=prc.xehEntrySave,
    name="entryForm",
    novalidate="novalidate",
    class="form-vertical"
)#
    <div class="row">
        <div class="col-md-8" id="main-content-slot">
            <!--- MessageBox --->
            #getModel( "messagebox@cbMessagebox" ).renderit()#

            <!--- id --->
            #html.hiddenField(name="contentID",bind=prc.entry)#
            #html.hiddenField(name="contentType",bind=prc.entry)#
            #html.hiddenField(name="sluggerURL",value=event.buildLink(prc.xehSlugify))#

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
                        <cfif prc.entry.isLoaded()>
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
                            bind=prc.entry,
                            maxlength="100",
                            required="required",
                            title="The title for this entry",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
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
                                        name="slug", 
                                        bind=prc.entry, 
                                        maxlength="100", 
                                        class="form-control", 
                                        title="The URL permalink for this entry", 
                                        disabled="#prc.entry.isLoaded() && prc.entry.getIsPublished() ? 'true' : 'false'#"
                                    )#
                                    <a title="" class="input-group-addon" href="javascript:void(0)" onclick="togglePermalink(); return false;" data-original-title="Lock/Unlock Permalink" data-container="body">
                                        <i id="togglePermalink" class="fa fa-#prc.entry.isLoaded() && prc.entry.getIsPublished() ? 'lock' : 'unlock'#"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <!---ContentToolBar --->
                        #renderView(view="_tags/content/markup",args={ content=prc.entry })#
                        
                        <!--- content --->
                        #html.textarea(
                            name="content", 
                            value=htmlEditFormat( prc.entry.getContent() ), 
                            rows="25", 
                            class="form-control"
                        )#
                        <!--- excerpt --->
                        #html.textarea(
                            label="Excerpt:", 
                            name="excerpt", 
                            bind=prc.entry, 
                            rows="10", 
                            class="form-control"
                        )#
                    </div>
                    
                    <!--- Custom Fields --->
                    <div role="tabpanel" class="tab-pane" id="custom_fields">
                        #renderView( view="_tags/customFields", args={ fieldType="Entry", customFields=prc.entry.getCustomFields() } )#
                    </div>

                    <!--- SEO --->
                    <div role="tabpanel" class="tab-pane" id="seo">
                        <div class="form-group">
                            #html.textfield(
                                name="htmlTitle",
                                label="Title: (Leave blank to use blog entry title)", 
                                bind=prc.entry,
                                class="form-control",
                                maxlength="255"
                            )#
                        </div>
                        <div class="form-group">
                            #html.textArea(
                                name="htmlKeywords",
                                label="Keywords: (<span id='html_keywords_count'>0</span>/160 characters left)", 
                                bind=prc.entry,
                                class="form-control",
                                maxlength="160",
                                rows="5"
                            )#
                        </div>
                        <div class="form-group">
                            #html.textArea(
                                name="htmlDescription",
                                label="Description: (<span id='html_description_count'>0</span>/160 characters left)", 
                                bind=prc.entry,
                                class="form-control",
                                maxlength="160",
                                rows="5"
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

                </div>
                <!--- Event --->
                #announceInterception( "cbadmin_entryEditorInBody" )#
            </div>
            <!--- Event --->
            #announceInterception( "cbadmin_entryEditorFooter" )#
        </div>
        <div class="col-md-4" id="main-content-sidebar">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fa fa-info-circle"></i> Entry Details</h3>
                </div>
                <div class="panel-body">
                    <cfset pArgs = { content=prc.entry }>
                    #renderView( view="_tags/content/publishing", args=pArgs )#

                    <!--- Accordion --->
                    <div id="accordion" class="panel-group accordion" data-stateful="entry-sidebar">
                        
                        <!---Begin Page Info--->
                        <cfif prc.entry.isLoaded()> 
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##pageinfo">
                                        <i class="fa fa-info-circle fa-lg"></i> Entry Info
                                    </a>
                                </h4>
                            </div>
                            <div id="pageinfo" class="panel-collapse collapse in">
                                <div class="panel-body">
                                    <!--- Persisted Info --->
                                    <table class="table table-hover table-condensed table-striped">
                                        <tr>
                                            <th class="col-md-4">Created By:</th>
                                            <td class="col-md-6">
                                                <a href="mailto:#prc.entry.getCreatorEmail()#">#prc.entry.getCreatorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Created On:</th>
                                            <td>
                                                #prc.entry.getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Published On:</th>
                                            <td>
                                                #prc.entry.getDisplayPublishedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Version:</th>
                                            <td>
                                                #prc.entry.getActiveContent().getVersion()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Last Edit By:</th>
                                            <td class="col-md-6">
                                                <a href="mailto:#prc.entry.getAuthorEmail()#">#prc.entry.getAuthorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Last Edit On:</th>
                                            <td class="col-md-6">
                                                #prc.entry.getActiveContent().getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Views:</th>
                                            <td>
                                                #prc.entry.getNumberOfHits()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="col-md-4">Comments:</th>
                                            <td>
                                                #prc.entry.getNumberOfComments()#
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Page Info--->

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
                                    <cfset rcArgs = { linkedContent=prc.linkedContent, contentType=prc.entry.getContentType() }>
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
                                    <cfif prc.entry.isLoaded() and prc.oAuthor.checkPermission( "ENTRIES_ADMIN" )>
                                        <div class="form-group">
                                            <i class="fa fa-user fa-lg"></i>
                                            #html.label(
                                                field="creatorID",
                                                content="Creator:",
                                                class="inline"
                                            )#
                                            <select name="creatorID" id="creatorID" class="form-control input-sm">
                                                <cfloop array="#prc.authors#" index="author">
                                                <option value="#author.getAuthorID()#" <cfif prc.entry.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
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
                                                selectedValue=yesNoFormat( prc.entry.getAllowComments() ), 
                                                class="form-control input-sm"
                                            )#
                                        </div>
                                    </cfif>

                                    <div class="form-group">
                                        <!--- Show in Search --->
                                        #html.select(
                                            name="showInSearch",
                                            label="Show In Search:",
                                            class="form-control input-sm",
                                            options="Yes,No",
                                            selectedValue=yesNoFormat( prc.entry.getShowInSearch() )
                                        )#
                                    </div>
                
                                    <!--- Password Protection --->
                                    <div class="form-group">
                                        <label for="passwordProtection"><i class="fa fa-lock fa-lg"></i> Password Protection:</label>
                                        #html.textfield(
                                            name="passwordProtection",
                                            bind=prc.entry,
                                            title="Password protect your entry, leave empty for none", 
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
                                            selectedValue=yesNoFormat(prc.entry.getCache()), 
                                            class="form-control input-sm"
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
                                        <a class="featured-image <cfif !len( prc.entry.getFeaturedImageURL() )>hide</cfif> btn btn-danger" href="javascript:cancelFeaturedImage()">Clear</a>
                                        <!--- Featured Image Selection --->
                                        <div class="<cfif !len( prc.entry.getFeaturedImageURL() )>hide</cfif> form-group" id="featuredImageControls">
                                            #html.textField(
                                            	name 		= "featuredImage",
                                            	bind 		= prc.entry,
                                            	class 		= "form-control",
                                            	readonly 	= true
                                            )#
                                            #html.hiddenField(
                                            	name = "featuredImageURL",
                                            	bind = prc.entry
                                            )#
                                            <!--- Image Preview --->
                                            <div class="margin10">
                                            	<cfif len( prc.entry.getFeaturedImageURL() )>
                                            		<img id="featuredImagePreview" src="#prc.entry.getFeaturedImageURL()#" class="img-thumbnail" height="75">
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
                        #announceInterception( "cbadmin_entryEditorSidebarAccordion" )#           
                    </div>  
                    <!--- End Accordion --->
        
                    <!--- Event --->
                    #announceInterception( "cbadmin_entryEditorSidebar" )#
                </div>
            </div>
            <!--- Event --->
            #announceInterception( "cbadmin_entryEditorSidebarFooter" )#   
        </div>
    </div>
#html.endForm()#
</cfoutput>
