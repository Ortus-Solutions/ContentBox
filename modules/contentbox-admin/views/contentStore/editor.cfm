<cfoutput>
<!--- content Form  --->
#html.startForm(
    action=prc.xehContentSave,
    name="contentForm",
    novalidate="novalidate",
    class="form-vertical", 
    role="form"
)#
    <div class="row">
        <div class="col-md-12">
            <h1 class="h1"><i class="fa fa-edit"></i> Content Store Editor</h1>
        </div>
    </div>
    <div class="row">
        <div class="col-md-8">
            <!--- MessageBox --->
            #getModel( "messagebox@cbMessagebox" ).renderit()#
            <!--- form --->
            #html.hiddenField(name="contentID",bind=prc.content)#
            #html.hiddenField(name="contentType",bind=prc.content)#
            #html.hiddenField(name="sluggerURL",value=event.buildLink(prc.xehSlugify))#

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">&nbsp;</h3>
                    <div class="actions pull-right">
                        <div class="btn-group btn-group-sm">
                            <button class="btn btn-sm btn-info" onclick="window.location.href='#event.buildLink(prc.xehContentStore)#';return false;"><i class="fa fa-reply"></i> Back</button>
                            <button class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" title="Quick Actions">
                                <span class="fa fa-cog"></span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="javascript:quickPublish( false )"><i class="fa fa-globe"></i> Publish</a></li>
                                <li><a href="javascript:quickPublish( true )"><i class="fa fa-eraser"></i> Publish as Draft</a></li>
                                <li><a href="javascript:quickSave()"><i class="fa fa-save"></i> Quick Save</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <!--- title --->
                    #html.textfield(
                        label="Title:",
                        name="title",
                        bind=prc.content,
                        maxlength="100",
                        required="required",
                        title="The title for this content",
                        class="form-control",
                        wrapper="div class=controls",
                        labelClass="control-label",
                        groupWrapper="div class=form-group"
                    )#
                    
                    <!--- slug --->
                    <div class="form-group">
                        <label for="slug" class="control-label">Slug:</label>
                        <div class="controls">
                            <div id='slugCheckErrors'></div>
                            <div class="input-group">
                                #html.textfield(
                                    name="slug", 
                                    bind=prc.content, 
                                    maxlength="100", 
                                    class="form-control", 
                                    title="The unique slug for this content, this is how they are retreived",
                                    disabled="#prc.content.isLoaded() && prc.content.getIsPublished() ? 'true' : 'false'#"
                                )#
                                <a title="" class="input-group-addon" href="javascript:void(0)" onclick="togglePermalink(); return false;" data-original-title="Lock/Unlock permalink" data-container="body">
                                        <i id="togglePermalink" class="fa fa-#prc.content.isLoaded() && prc.content.getIsPublished() ? 'lock' : 'unlock'#"></i>
                                </a>
                            </div>
                        </div>
                    </div>      

                    <!--- Description --->
                    #html.textarea(
                        name="description",
                        label="Short Description:",
                        bind=prc.content,
                        rows=3,
                        class="form-control",
                        title="A short description for metadata purposes",
                        wrapper="div class=controls",
                        labelClass="control-label",
                        groupWrapper="div class=form-group"
                    )# 

                    <!---ContentToolBar --->
                    <div id="contentToolBar">
                        <!--- editor selector --->
                        <cfif prc.oAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
                            <div class="btn-group btn-group-sm">
                                <a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
                                    Editor
                                    <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu">
                                    <cfloop array="#prc.editors#" index="thisEditor">
                                        <li>
                                            <a href="javascript:switchEditor( '#thisEditor.name#' )">
                                                #thisEditor.displayName#
                                            </a>
                                        </li>
                                    </cfloop>
                                </ul>
                            </div>
                        </cfif>
                        <!--- markup --->
                        #html.hiddenField(name="markup", value=prc.content.isLoaded() ? prc.content.getMarkup() : prc.defaultMarkup)#
                        <div class="btn-group btn-group-sm">
                            <a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
                                Markup : <span id="markupLabel">#prc.content.isLoaded() ? prc.content.getMarkup() : prc.defaultMarkup#</span>
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <cfloop array="#prc.markups#" index="thismarkup">
                                    <li>
                                        <a href="javascript:switchMarkup( '#thismarkup#' )">#thismarkup#</a>
                                    </li>
                                </cfloop>
                            </ul>
                        </div>
                        <!---Right References Panel --->
                        <div class="pull-right">
                            <a href="javascript:previewContent()" class="btn btn-sm btn-info" title="Quick Preview (ctrl+p)" data-keybinding="ctrl+p">
                                <i class="fa fa-eye fa-lg"></i>
                            </a>
                        </div>
                        
                        <!--- content --->
                        #html.textarea(
                            name="content", 
                            value=htmlEditFormat( prc.content.getContent() ), 
                            rows="25", 
                            class="form-control"
                        )#
                    </div>
                </div>
                <!--- Event --->
                #announceInterception( "cbadmin_contentStoreEditorInBody" )#
            </div>
            <!--- Custom Fields --->
            <!--- I have to use the json garbage as CF9 Blows up on the implicit structs, come on man! --->
            <cfset mArgs = {fieldType="content", customFields=prc.content.getCustomFields()}>
            #renderView(view="_tags/customFields",args=mArgs)#
            <!---Loaded Panels--->
            <cfif prc.content.isLoaded()>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-clock-o fa-lg"></i> Versions</h3>
                    </div>
                    <div class="panel-body">
                        #prc.versionsViewlet#
                    </div>
                </div>
            </cfif>
        
            <!--- Event --->
            #announceInterception( "cbadmin_contentStoreEditorFooter" )#
        </div>
        <div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="fa fa-info-circle"></i> Content Details</h3>
                </div>
                <div class="panel-body">
                    <cfset pArgs = { content=prc.content }>
                    #renderView( view="_tags/content/publishing", args=pArgs )#
                   
        
                    <!--- Accordion --->
                    <div id="accordion" class="panel-group accordion" data-stateful="contentstore-sidebar">
                        
                        <!---Begin Page Info--->
                        <cfif prc.content.isLoaded()>   
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##pageinfo">
                                        <i class="fa fa-info-circle fa-lg"></i> Content Info
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
                                                <a href="mailto:#prc.content.getCreatorEmail()#">#prc.content.getCreatorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Created On:</th>
                                            <td>
                                                #prc.content.getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Published On:</th>
                                            <td>
                                                #prc.content.getDisplayPublishedDate()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="textRight">Version:</th>
                                            <td>
                                                #prc.content.getActiveContent().getVersion()#
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="85" class="textRight">Last Edit By:</th>
                                            <td>
                                                <a href="mailto:#prc.content.getAuthorEmail()#">#prc.content.getAuthorName()#</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="85" class="textRight">Last Edit On:</th>
                                            <td>
                                                #prc.content.getActiveContent().getDisplayCreatedDate()#
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End content Info--->
                        
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
                                    <cfset rcArgs = { linkedContent=prc.linkedContent, contentType=prc.content.getContentType() }>
                                    #renderView( view="_tags/linkedContent", args=rcArgs )#
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <!---End Linked Content--->

                        <!---Begin Modifiers--->
                        <cfif prc.oAuthor.checkPermission( "EDITORS_MODIFIERS" ) AND prc.content.isLoaded()>
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

									<!--- Parent Content --->
									<div class="form-group">
										<i class="fa fa-sitemap fa-lg"></i>
		         						#html.label( field="parentContent",content='Parent:' )#
		         						<select name="parentContent" id="parentContent" class="form-control input-sm">
		         							<option value="null">No Parent</option>
		        							#html.options(
		        								values=prc.allContent,
		        								column="contentID",
		        								nameColumn="title",
		        								selectedValue=prc.parentcontentID
		        							)#>
		        							#html.options(
		        								values=prc.allContent,
		        								column="contentID",
		        								nameColumn="slug",
		        								selectedValue=prc.parentcontentID
		        							)#
		         						</select>
	         						</div>

                                    <!--- Creator --->
                                    <cfif prc.content.isLoaded() and prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN" )>
                                        <div class="form-group">
                                            <i class="fa fa-user fa-lg"></i>
                                            #html.label(field="creatorID",content="Creator:",class="inline" )#
                                            <select name="creatorID" id="creatorID" class="form-control input-sm">
                                                <cfloop array="#prc.authors#" index="author">
                                                <option value="#author.getAuthorID()#" <cfif prc.content.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </cfif>
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
                                        <i class="fa fa-hdd-o fa-lg"></i> Cache Settings
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
                                            selectedValue=yesNoFormat(prc.content.getCache()), 
                                            class="form-control input-sm"
                                        )#
                                    </div>
                                    <div class="form-group">
                                        #html.inputField(
                                            type="numeric",
                                            name="cacheTimeout",
                                            label="Cache Timeout (0=Use Global):",
                                            bind=prc.content,
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
                                            bind=prc.content,
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
                                            checked=prc.content.hasCategories( prc.categories[ x ] )
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
                            
                        <!--- Event --->
                        #announceInterception( "cbadmin_contentStoreEditorSidebarAccordion" )#     
                    </div>  
                    <!--- End Accordion --->
        
                    <!--- Event --->
                    #announceInterception( "cbadmin_contentStoreEditorSidebar" )#
                </div>
            </div>
            <!--- Event --->
            #announceInterception( "cbadmin_contentStoreEditorSidebarFooter" )#
        </div>
    </div>
#html.endForm()#
</cfoutput>