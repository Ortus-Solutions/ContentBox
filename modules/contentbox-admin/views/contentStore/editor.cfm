<cfoutput>
<!--- content Form  --->
#html.startForm(action=prc.xehContentSave,name="contentForm",novalidate="novalidate",class="form-vertical")#
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-edit icon-large"></i>
				Content Store Editor
				<!--- Quick Actions  --->
				<div class="btn-group pull-right" style="margin-top:5px">
				    <button class="btn btn-inverse" onclick="window.location.href='#event.buildLink(prc.xehContentStore)#';return false;"><i class="icon-reply"></i> Back</button>
					<button class="btn btn-inverse dropdown-toggle" data-toggle="dropdown" title="Quick Actions">
			    	<span class="icon-cog"></span>
				    </button>
			   		<ul class="dropdown-menu">
			   			<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN")>
						<li><a href="javascript:quickPublish(false)"><i class="icon-globe"></i> Publish</a></li>
						</cfif>
						<li><a href="javascript:quickPublish(true)"><i class="icon-eraser"></i> Publish as Draft</a></li>
						<li><a href="javascript:quickSave()"><i class="icon-save"></i> Quick Save</a></li>
			   		</ul>
			    </div>
			</div>
			<!--- Body --->
			<div class="body">
	
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
	
				<!--- id --->
				#html.hiddenField(name="contentID",bind=prc.content)#
				#html.hiddenField(name="contentType",bind=prc.content)#
				#html.hiddenField(name="sluggerURL",value=event.buildLink(prc.xehSlugify))#
	
				<!--- title --->
				#html.textfield(label="Title:",name="title",bind=prc.content,maxlength="100",required="required",title="The title for this content",class="textfield width98",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
				<!--- slug --->
                <div class="control-group">
                    <label for="slug" class="control-label">Slug:</label>
                    <div class="controls">
                        <div id='slugCheckErrors'></div>
						#html.textfield(name="slug",bind=prc.content,maxlength="100",class="textfield width98",title="The unique slug for this content, this is how they are retreived")#
                    </div>
                </div>		
				#html.textarea(name="description",label="Short Description:",bind=prc.content,rows=3,class="width98",title="A short description for metadata purposes",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#	
				<!---ContentToolBar --->
				<div id="contentToolBar">
					
					<!--- editor selector --->
					<label for="contentEditorChanger" class="inline">Editor: </label>
					<cfif prc.oAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
					#html.select(name="contentEditorChanger", 
								 options=prc.editors,
								 column="name",
								 class="input-medium",
								 nameColumn="displayName",
								 selectedValue=prc.defaultEditor,
								 onchange="switchEditor(this.value)")#
					</cfif>
					<!--- markup --->
					<label for="markup" class="inline">Markup: </label>
					#html.select(name="markup", 
								 class="input-medium",
								 options=prc.markups,
								 selectedValue=( prc.content.isLoaded() ? prc.content.getMarkup() : prc.defaultMarkup ))#
					
					<!---Right References Panel --->
					<div class="floatRight">
						<a href="javascript:previewContent()" class="btn" title="Quick Preview (ctrl+p)" data-keybinding="ctrl+p">
							<i class="icon-eye-open icon-large"></i>
						</a>
					</div>
				</div>
				
				<!--- content --->
				#html.textarea(name="content", value=htmlEditFormat( prc.content.getContent() ), rows="25", class="width98 content")#
	
				<!--- Custom Fields --->
				<!--- I have to use the json garbage as CF9 Blows up on the implicit structs, come on man! --->
				<cfset mArgs = {fieldType="content", customFields=prc.content.getCustomFields()}>
				#renderView(view="_tags/customFields",args=mArgs)#
	
				<!--- Event --->
				#announceInterception("cbadmin_contentStoreEditorInBody")#
			</div>
		</div>
	
		<!---Loaded Panels--->
		<cfif prc.content.isLoaded()>
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
		</cfif>
	
		<!--- Event --->
		#announceInterception("cbadmin_contentStoreEditorFooter")#
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-info-sign"></i>
				Content Details
			</div>
			<div class="body">
				<!--- Publish Info --->
				#html.startFieldset(legend='<i class="icon-calendar"></i> Publishing',
					class="#prc.content.getIsPublished()?'':'selected'#")#
	
					<!--- Published? --->
					<cfif prc.content.isLoaded()>
					<label class="inline">Status: </label>
					<cfif !prc.content.getIsPublished()><div class="textRed inline">Draft!</div><cfelse>Published</cfif>
					</cfif>
	
					<!--- is Published --->
					#html.hiddenField(name="isPublished",value=true)#
					<!--- publish date --->
					<div class="control-group">
					    #html.label(class="control-label",field="publishedDate",content="Publish Date (<a href='javascript:publishNow()'>Now</a>)")#
					    <div class="controls">
					        #html.inputField(size="9", name="publishedDate",value=prc.content.getPublishedDateForEditor(), class="textfield datepicker")#
        					@
        					#html.inputField(type="number",name="publishedHour",value=prc.ckHelper.ckHour( prc.content.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
        					#html.inputField(type="number",name="publishedMinute",value=prc.ckHelper.ckMinute( prc.content.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#
					    </div>
					</div>
					<!--- expire date --->
					<div class="control-group">
					    #html.label(class="control-label",field="expireDate",content="")#
                        <div class="controls">
                            #html.inputField(size="9", name="expireDate",value=prc.content.getExpireDateForEditor(), class="textfield datepicker")#
        					@
        					#html.inputField(type="number",name="expireHour",value=prc.ckHelper.ckHour( prc.content.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
        					#html.inputField(type="number",name="expireMinute",value=prc.ckHelper.ckMinute( prc.content.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#
                        </div>
					</div>	
					<!--- Changelog --->
					#html.textField(name="changelog",label="Commit Changelog",class="textfield width95",title="A quick description of what this commit is all about.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	
					<!--- Action Bar --->
					<div class="actionBar">
						<div class="btn-group">
						&nbsp;<input type="button" class="btn" value="Save" data-keybinding="ctrl+s" onclick="quickSave()">
						&nbsp;<input type="submit" class="btn" value="&nbsp; Draft &nbsp;" onclick="toggleDraft()">
						<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN")>
						&nbsp;<input type="submit" class="btn btn-danger" value="Publish">
						</cfif>
						</div>
					</div>
	
					<!--- Loader --->
					<div class="loaders" id="uploadBarLoader">
						<i class="icon-spinner icon-spin icon-large icon-2x"></i>
						<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
					</div>
	
				#html.endFieldSet()#
	
				<!--- Accordion --->
				<div id="accordion" class="accordion">
				    
                    <!---Begin Page Info--->
					<cfif prc.content.isLoaded()>	
				    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##pageinfo">
                        		<i class="icon-info-sign icon-large"></i> Content Info
                      		</a>
                    	</div>
                    	<div id="pageinfo" class="accordion-body collapse in">
                      		<div class="accordion-inner">
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
						
					<!---Begin Modifiers--->
					<cfif prc.oAuthor.checkPermission("EDITORS_MODIFIERS") AND prc.content.isLoaded()>
                    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##modifiers">
                        		<i class="icon-cogs icon-large"></i> Modifiers
                      		</a>
                    	</div>
                    	<div id="modifiers" class="accordion-body collapse">
                      		<div class="accordion-inner">
                        		<!--- Creator --->
								<cfif prc.content.isLoaded() and prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN")>
								<i class="icon-user icon-large"></i>
								#html.label(field="creatorID",content="Creator:",class="inline")#
								<select name="creatorID" id="creatorID" class="input-block-level">
									<cfloop array="#prc.authors#" index="author">
									<option value="#author.getAuthorID()#" <cfif prc.content.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
									</cfloop>
								</select>
								</cfif>
                      		</div>
                    	</div>
                  	</div>
                    </cfif>
                    <!---End Modfiers--->
						
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
        						#html.label(field="cache",content="Cache Content: (fast)")#
        						<small>Caches content translation only</small><Br/>
        						#html.select(name="cache",options="Yes,No",selectedValue=yesNoFormat(prc.content.getCache()), class="input-block-level")#
        						#html.inputField(type="numeric",name="cacheTimeout",label="Cache Timeout (0=Use Global):",bind=prc.content,title="Enter the number of minutes to cache your content, 0 means use global default",class="input-block-level",size="10",maxlength="100")#
        						#html.inputField(type="numeric",name="cacheLastAccessTimeout",label="Idle Timeout: (0=Use Global)",bind=prc.content,title="Enter the number of minutes for an idle timeout for your content, 0 means use global default",class="input-block-level",size="10",maxlength="100")#
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
        							#html.checkbox(name="category_#x#",value="#prc.categories[x].getCategoryID()#",checked=prc.content.hasCategories( prc.categories[x] ))#
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
                    <!---End Categories--->
						
                    <!--- Event --->
					#announceInterception("cbadmin_contentStoreEditorSidebarAccordion")#			
				</div>	
				<!--- End Accordion --->
	
				<!--- Event --->
				#announceInterception("cbadmin_contentStoreEditorSidebar")#
			</div>
		</div>
		<!--- Event --->
		#announceInterception("cbadmin_contentStoreEditorSidebarFooter")#
	</div>
</div>
#html.endForm()#
</cfoutput>