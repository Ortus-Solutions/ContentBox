﻿<cfoutput>
<!--- Page Form  --->
#html.startForm(action=prc.xehPageSave,name="pageForm",novalidate="novalidate",class="form-vertical")#
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-edit icon-large"></i>
			Page Editor
			<!--- Quick Actions --->
			<div class="btn-group pull-right" style="margin-top:5px">
			    <button class="btn btn-inverse" onclick="window.location.href='#event.buildLink(prc.xehPages)#/parent/#prc.parentcontentID#';return false;"><i class="icon-reply"></i> Back</button>
			    <button class="btn btn-inverse dropdown-toggle" data-toggle="dropdown" title="Quick Actions">
			    	<span class="icon-cog"></span>
			    </button>
		   		<ul class="dropdown-menu">
					<li><a href="javascript:quickPublish( false )"><i class="icon-globe"></i> Publish</a></li>
					<li><a href="javascript:quickPublish( true )"><i class="icon-eraser"></i> Publish as Draft</a></li>
					<li><a href="javascript:quickSave()"><i class="icon-save"></i> Quick Save</a></li>
					<cfif prc.page.isLoaded()>
					<li><a href="#prc.CBHelper.linkPage( prc.page )#" target="_blank"><i class="icon-eye-open"></i> View In Site</a></li>
					</cfif>
		    	</ul>
		    </div>
		</div>
		<!--- Body --->
		<div class="body">

			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#

			<!--- id --->
			#html.hiddenField(name="contentID",bind=prc.page)#
			#html.hiddenField(name="contentType",bind=prc.page)#

			<!--- title --->
			#html.textfield(label="Title:",name="title",bind=prc.page,maxlength="100",required="required",title="The title for this page",class="textfield width98",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			<!--- slug --->
            <div class="control-group">
            	<label for="slug" class="control-label">Permalink:
				<i class="icon-cloud hand-cursor" title="Convert title to permalink" onclick="createPermalink()"></i>
				<small> #prc.CBHelper.linkPageWithSlug('')#</small><cfif prc.page.hasParent()><small>#prc.page.getParent().getSlug()#/</small></cfif>
				</label>
			</div>
			<div class="controls">
	            <div id='slugCheckErrors'></div>
	            <div class="input-append" style="display:inline">
					#html.textfield(name="slug",value=listLast(prc.page.getSlug(),"/"),maxlength="100",class="textfield width94",title="The URL permalink for this page", disabled="#prc.page.isLoaded() && prc.page.getIsPublished() ? 'true' : 'false'#")#
					<a title="" class="btn" href="javascript:void(0)" onclick="togglePermalink(); return false;" data-original-title="Lock/Unlock permalink">
						<i id="togglePermalink" class="icon-#prc.page.isLoaded() && prc.page.getIsPublished() ? 'lock' : 'unlock'#"></i>
					</a>
				</div>
			</div>

			<!---ContentToolBar --->
			<div id="contentToolBar">

				<!--- editor selector --->
				<cfif prc.oAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
				<div class="btn-group">
					<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
						Editor
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<cfloop array="#prc.editors#" index="thisEditor">
							<li><a href="javascript:switchEditor( '#thisEditor.name#' )">#thisEditor.displayName#</li>
						</cfloop>
					</ul>
				</div>
				</cfif>
				<!--- markup --->
				#html.hiddenField(name="markup", value=prc.page.isLoaded() ? prc.page.getMarkup() : prc.defaultMarkup)#
				<div class="btn-group">
					<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
						Markup : <span id="markupLabel">#prc.page.isLoaded() ? prc.page.getMarkup() : prc.defaultMarkup#</span>
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<cfloop array="#prc.markups#" index="thismarkup">
							<li><a href="javascript:switchMarkup( '#thismarkup#' )">#thismarkup#</li>
						</cfloop>
					</ul>
				</div>

				<!---Right References Panel --->
				<div class="floatRight">
					<a href="javascript:previewContent()" class="btn" title="Quick Preview (ctrl+p)" data-keybinding="ctrl+p">
						<i class="icon-eye-open icon-large"></i>
					</a>
				</div>
			</div>

			<!---Content TextArea --->
			#html.textarea(name="content", value=htmleditFormat( prc.page.getContent() ), rows="25", class="width98 content")#
			<cfif prc.cbSettings.cb_page_excerpts>
				<!--- excerpt --->
				#html.textarea(label="Excerpt:", name="excerpt", bind=prc.page, rows="10", class="width98")#
			</cfif>

			<!--- Custom Fields --->
			<!--- I have to use the json garbage as CF9 Blows up on the implicit structs, come on man! --->
			<cfset mArgs = {fieldType="Page", customFields=prc.page.getCustomFields()}>
			#renderView(view="_tags/customFields",args=mArgs)#

			<!--- Event --->
			#announceInterception("cbadmin_pageEditorInBody")#
		</div>
	</div>

	<!---Loaded Panels--->
	<cfif prc.page.isLoaded()>
		<!--- Versions --->
		<div class="box">
			<div class="header">
				<i class="icon-time icon-large"></i>
				Versions
			</div>
			<div class="body">
				#prc.versionsViewlet#
			</div>
		</div>

		<!--- Page Comments --->
		<cfif prc.page.getallowComments()>
		<div class="box">
			<cfif structKeyExists(prc,"commentsViewlet")>
				<div class="header">
					<i class="icon-comments icon-large"></i>
					Comments
				</div>
				<div class="body">
					#prc.commentsViewlet#
				</div>
			</cfif>
		</div>
		</cfif>

		<!--- Sub Pages --->
		<div class="box">
			<div class="header">
				<i class="icon-sitemap icon-large"></i>
				Child Pages
			</div>
			<div class="body">
				#prc.childPagesViewlet#
			</div>
		</div>
	</cfif>

	<!--- Event --->
	#announceInterception("cbadmin_pageEditorFooter")#
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-info-sign"></i>
				Page Details
			</div>
			<div class="body">

				<!--- Publish Info --->
				#html.startFieldset(legend='<i class="icon-calendar"></i> Publishing',class="#prc.page.getIsPublished()?'':'selected'#")#

					<!--- Published? --->
					<cfif prc.page.isLoaded()>
					<label class="inline">Status: </label>
					<cfif !prc.page.getIsPublished()><div class="textRed inline">Draft!</div><cfelse>Published</cfif>
					</cfif>

					<!--- is Published --->
					#html.hiddenField(name="isPublished",value=true)#
					<!--- publish date --->
					<div class="control-group">
					    #html.label(class="control-label",field="publishedDate",content="Publish Date (<a href='javascript:publishNow()'>Now</a>)")#
					    <div class="controls">
					        #html.inputField(size="9", name="publishedDate",value=prc.page.getPublishedDateForEditor(), class="textfield datepicker")#
        					@
        					#html.inputField(type="number",name="publishedHour",value=prc.ckHelper.ckHour( prc.page.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
        					#html.inputField(type="number",name="publishedMinute",value=prc.ckHelper.ckMinute( prc.page.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#
					    </div>
					</div>
					<!--- expire date --->
					<div class="control-group">
					    #html.label(class="control-label",field="expireDate",content="")#
                        <div class="controls">
                            #html.inputField(size="9", name="expireDate",value=prc.page.getExpireDateForEditor(), class="textfield datepicker")#
        					@
        					#html.inputField(type="number",name="expireHour",value=prc.ckHelper.ckHour( prc.page.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
        					#html.inputField(type="number",name="expireMinute",value=prc.ckHelper.ckMinute( prc.page.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#
                        </div>
					</div>
					<!--- Changelog --->
					#html.textField(name="changelog",label="Commit Changelog",class="textfield width95",title="A quick description of what this commit is all about.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#

					<!--- Action Bar --->
					<div class="actionBar">
						<div class="btn-group">
						&nbsp;<input type="button" class="btn" value="Save" data-keybinding="ctrl+s" onclick="quickSave()">
						&nbsp;<input type="submit" class="btn" value="&nbsp; Draft &nbsp;" onclick="toggleDraft()">
						&nbsp;<input type="submit" class="btn btn-danger" value="Publish">
						</div>
					</div>

					<!--- Loader --->
					<div class="loaders" id="uploadBarLoader">
						<i class="icon-spinner icon-spin icon-large icon-2x"></i>
						<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
					</div>

				#html.endFieldSet()#

				<!---Begin Accordion--->
				<div class="accordion" id="accordion" data-stateful="page-sidebar">
				    <!---Begin Page info--->
                    <cfif prc.page.isLoaded()>
					<div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##pageinfo">
                        		<i class="icon-info-sign icon-large"></i> Page Info
                      		</a>
                    	</div>
                    	<div id="pageinfo" class="accordion-body collapse in">
                      		<div class="accordion-inner">
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
                    <!---End Page Info--->

                    <!---Begin Display Options--->
                    <cfif prc.oAuthor.checkPermission("EDITORS_DISPLAY_OPTIONS")>
                  	<div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##displayoptions">
                        		<i class="icon-picture icon-large"></i> Display Options
                      		</a>
                    	</div>
                    	<div id="displayoptions" class="accordion-body collapse">
                      		<div class="accordion-inner">
                        		<!--- Parent Page --->
        						#html.label(field="parentPage",content='Parent:')#
        						<select name="parentPage" id="parentPage" class="input-block-level">
        							<option value="null">No Parent</option>
        							#html.options(values=prc.pages,column="contentID",nameColumn="slug",selectedValue=prc.parentcontentID)#
        						</select>

        						<!--- layout --->
        						#html.label(field="layout",content='Layout:')#
        						<select name="layout" id="layout" class="width98">
        							<!--- Core Layouts --->
        							<option value="-inherit-" <cfif prc.page.getLayoutWithDefault() eq "-inherit-">selected="selected"</cfif>>-inherit-</option>
        							<option value="-no-layout-" <cfif prc.page.getLayoutWithDefault() eq "-no-layout-">selected="selected"</cfif>>-no-layout-</option>
        							<!--- Custom Layouts --->
        							#html.options(values=prc.availableLayouts, selectedValue=prc.page.getLayoutWithDefault())#
        						</select>

        						<!--- mobile layout --->
        						#html.label(field="mobileLayout",content='Mobile Layout:')#
        						<select name="mobileLayout" id="mobileLayout" class="input-block-level">
        							<option value="" <cfif prc.page.getMobileLayout() eq "">selected="selected"</cfif>>-None-</option>
        							<option value="-inherit-" <cfif prc.page.getMobileLayout() eq "-inherit-">selected="selected"</cfif>>-inherit-</option>
        							#html.options(values=prc.availableLayouts, selectedValue=prc.page.getMobileLayout())#
        						</select>

        						<!--- Show in Menu Builders --->
        						#html.select(name="showInMenu",label="Show In Menus:",class="input-block-level",options="Yes,No",selectedValue=yesNoFormat(prc.page.getShowInMenu()))#

        						<!--- Show in Search --->
        						#html.select(name="showInSearch",label="Show In Search:",class="input-block-level",options="Yes,No",selectedValue=yesNoFormat(prc.page.getShowInSearch()))#

        						<!--- menu order --->
        						#html.inputfield(type="number",label="Menu Order: (0-99)",name="order",bind=prc.page,title="The ordering index used when building menus",class="input-block-level",size="5",maxlength="2",min="0",max="99")#
                      		</div>
                    	</div>
                  	</div>
                    <cfelse>
						#html.hiddenField(name="parentPage", value=prc.parentcontentID)#
                    </cfif>
                    <!---End Display Options--->

                    <!---Begin Related Content--->
                    <cfif prc.oAuthor.checkPermission("EDITORS_RELATED_CONTENT")>
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##relatedcontent">
                                <i class="icon-sitemap icon-large"></i> Related Content
                            </a>

                        </div>
                        <div id="relatedcontent" class="accordion-body collapse">
                            <div class="accordion-inner">
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
                    <cfif prc.oAuthor.checkPermission("EDITORS_LINKED_CONTENT")>
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##linkedcontent">
                                <i class="icon-link icon-large"></i> Linked Content
                            </a>

                        </div>
                        <div id="linkedcontent" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <cfset rcArgs = { linkedContent=prc.linkedContent, contentType=prc.page.getContentType() }>
                                #renderView( view="_tags/linkedContent", args=rcArgs )#
                            </div>
                        </div>
                    </div>
                    </cfif>
                    <!---End Linked Content--->

                    <!---Begin Modifiers--->
                    <cfif prc.oAuthor.checkPermission("EDITORS_MODIFIERS")>
                    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##modifiers">
                        		<i class="icon-cogs icon-large"></i> Modifiers
                      		</a>
                    	</div>
                    	<div id="modifiers" class="accordion-body collapse">
                      		<div class="accordion-inner">
                      			<!--- Creator --->
								<cfif prc.page.isLoaded() and prc.oAuthor.checkPermission("PAGES_ADMIN")>
								<i class="icon-user icon-large"></i>
								#html.label(field="creatorID",content="Creator:",class="inline")#
								<select name="creatorID" id="creatorID" class="input-block-level">
									<cfloop array="#prc.authors#" index="author">
									<option value="#author.getAuthorID()#" <cfif prc.page.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
									</cfloop>
								</select>
								</cfif>

                        		<!--- Allow Comments --->
        						<cfif prc.cbSettings.cb_comments_enabled>
        						<i class="icon-comments icon-large"></i>
        						#html.label(field="allowComments",content="Allow Comments:",class="inline")#
        						#html.select(name="allowComments",options="Yes,No",selectedValue=yesNoFormat(prc.page.getAllowComments()), class="input-block-level")#
        						</cfif>

        						<!--- SSL Only --->
        						<i class="icon-shield icon-large"></i>
        						#html.label(field="sslOnly",content="SSL Only:",class="inline")#
        						#html.select(name="sslOnly",options="Yes,No", selectedValue=yesNoFormat( prc.page.getSSLOnly() ), class="input-block-level")#

        						<!--- Password Protection --->
        						<label for="passwordProtection"><i class="icon-lock icon-large"></i> Password Protection:</label>
        						#html.textfield(name="passwordProtection",bind=prc.page,title="Password protect your page, leave empty for none",class="input-block-level",size="25",maxlength="100")#
                      		</div>
                    	</div>
                  	</div>
                    </cfif>
                    <!---End Modifiers--->

                    <!---Begin Cache Settings--->
                    <cfif prc.oAuthor.checkPermission("EDITORS_CACHING")>
                    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##cachesettings">
                        		<i class="icon-hdd icon-large"></i> Cache Settings
                      		</a>
                    	</div>
                    	<div id="cachesettings" class="accordion-body collapse">
                      		<div class="accordion-inner">
                        		<!--- Cache Settings --->
        						#html.label(field="cache",content="Cache Page Content: (fast)")#
        						<small>Caches content translation only</small><Br/>
        						#html.select(name="cache",options="Yes,No",selectedValue=yesNoFormat(prc.page.getCache()), class="input-block-level")#

        						#html.label(field="cacheLayout",content="Cache Page Layout: (faster)")#
        						<small>Caches all generated page+layout HTML</small><br/>
        						#html.select(name="cacheLayout",options="Yes,No",selectedValue=yesNoFormat(prc.page.getCacheLayout()), class="input-block-level")#

        						#html.inputField(type="numeric",name="cacheTimeout",label="Cache Timeout (0=Use Global):",bind=prc.page,title="Enter the number of minutes to cache your content, 0 means use global default",class="input-block-level",size="10",maxlength="100")#
        						#html.inputField(type="numeric",name="cacheLastAccessTimeout",label="Idle Timeout: (0=Use Global)",bind=prc.page,title="Enter the number of minutes for an idle timeout for your content, 0 means use global default",class="input-block-level",size="10",maxlength="100")#
                      		</div>
                    	</div>
                  	</div>
                    </cfif>
                    <!---End Cache Settings--->

                    <!---Begin Categories--->
					<cfif prc.oAuthor.checkPermission("EDITORS_CATEGORIES")>
                    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##categories">
                        		<i class="icon-tags icon-large"></i> Categories
                      		</a>
                    	</div>
                    	<div id="categories" class="accordion-body collapse">
                      		<div class="accordion-inner">
                        		<!--- Display categories --->
        						<div id="categoriesChecks">
        						<cfloop from="1" to="#arrayLen(prc.categories)#" index="x">
        							<label class="checkbox">
        							#html.checkbox(name="category_#x#",value="#prc.categories[x].getCategoryID()#",checked=prc.page.hasCategories( prc.categories[x] ))#
        							#prc.categories[x].getCategory()#
        							</label>
        						</cfloop>
        						</div>

        						<!--- New Categories --->
        						#html.textField(name="newCategories",label="New Categories",size="30",title="Comma delimited list of new categories to create",class="input-block-level")#
                      		</div>
                    	</div>
                  	</div>
					</cfif>
                    <!---End HTML categories--->

                    <!---Begin HTML Attributes--->
                    <cfif prc.oAuthor.checkPermission("EDITORS_HTML_ATTRIBUTES")>
					<div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##htmlattributes">
                        		<i class="icon-cloud icon-large"></i> HTML Attributes
                      		</a>
                    	</div>
                    	<div id="htmlattributes" class="accordion-body collapse">
                      		<div class="accordion-inner">
                        		#html.textArea(name="htmlKeywords",label="Keywords: (<span id='html_keywords_count'>0</span>/160 characters left)", bind=prc.page,class="input-block-level",maxlength="160")#
								#html.textArea(name="htmlDescription",label="Description: (<span id='html_description_count'>0</span>/160 characters left)", bind=prc.page,class="input-block-level",maxlength="160")#
                      		</div>
                    	</div>
                  	</div>
					</cfif>
                    <!---End HTML Attributes--->

                    <!--- Event --->
					#announceInterception("cbadmin_pageEditorSidebarAccordion")#
				</div>
				<!--- End Accordion --->

				<!--- Event --->
				#announceInterception("cbadmin_pageEditorSidebar")#
			</div>
		</div>
		<!--- Event --->
		#announceInterception("cbadmin_pageEditorSidebarFooter")#
	</div>
</div>
#html.endForm()#
</cfoutput>