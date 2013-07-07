<cfoutput>
#html.startForm(name="contentEditForm", action=prc.xehContentSave, novalidate="novalidate")#
<!--- contentid --->
#html.hiddenField(name="contentID", bind=prc.content)#
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-tasks icon-large"></i>
				Custom HTML Editor
			</div>
			<!--- Body --->
			<div class="body">
	
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
	
				<!--- fields --->
				#html.hiddenField(name="contentType",value="CustomHTML")#
				#html.textField(name="title",label="Title:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="A human friendly name for the content piece",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
				<div id='slugCheckErrors'></div>
				#html.textField(name="slug",label="Slug:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="The slug used to retrieve this content piece",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
				#html.textarea(name="description",label="Short Description:",bind=prc.content,rows=3,class="width98",title="A short description for metadata purposes",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
				
				<!---ContentToolBar --->
				<div id="contentToolBar">
					
					<!--- editor selector --->
					<label for="contentEditorChanger" class="inline">Editor: </label>
					<cfif prc.oAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
					#html.select(name="contentEditorChanger", 
								 options=prc.editors,
								 class="input-medium",
								 column="name",
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
				#html.textarea(name="content", bind=prc.content, required="required", rows="25", class="width98")#
			</div>
		</div>
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
				#html.startFieldset(legend='<i class="icon-calendar"></i> Publishing',class="#prc.content.getIsPublished()?'':'selected'#")#
					
					<!--- Published? --->
					<cfif prc.content.isLoaded()>
					<label class="inline">Status: </label>
					<cfif !prc.content.getIsPublished()><div class="textRed inline">Draft!</div><cfelse>Published</cfif>
					</cfif>
					
					<!--- is Published --->
					#html.hiddenField(name="isPublished",value=true)#
					<!--- publish date --->
					<div class="control-group">
					    #html.label(class="control-label", field="publishedDate", content="Publish Date (<a href='javascript:publishNow()'>Now</a>)")#
					    <div class="controls">
					        #html.inputField(size="9", name="publishedDate",value=prc.content.getPublishedDateForEditor(),class="textfield")#
        					@
        					#html.inputField(type="number",name="publishedHour",value=prc.ckHelper.ckHour( prc.content.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
        					#html.inputField(type="number",name="publishedMinute",value=prc.ckHelper.ckMinute( prc.content.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#
					    </div>
					</div>
					<!--- expire date --->
					<div class="control-group">
					    #html.label(class="control-label",field="expireDate",content="")#
                        <div class="controls">
                            #html.inputField(size="9", name="expireDate",value=prc.content.getExpireDateForEditor(),class="textfield")#
        					@
        					#html.inputField(type="number",name="expireHour",value=prc.ckHelper.ckHour( prc.content.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
        					#html.inputField(type="number",name="expireMinute",value=prc.ckHelper.ckMinute( prc.content.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#
                        </div>
					</div>
	
					<!--- Action Bar --->
					<div class="actionBar">
						<div class="btn-group">
						&nbsp;<input type="submit" class="btn" value="Save" data-keybinding="ctrl+s" onclick="return quickSave()">
						&nbsp;<input type="submit" class="btn" value="&nbsp; Draft &nbsp;" onclick="toggleDraft()">
						<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
						&nbsp;<input type="submit" class="btn btn-danger" value="Publish">
						</cfif>
						</div>
					</div>
					
					<!--- Loader --->
					<div class="loaders" id="uploadBarLoader">
						<i class="icon-spinner icon-spin icon-large icon-2x"></i>
						<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
					</div>
					
					#html.hiddenField(name="changelog", value="Custom HTML")#
	
				#html.endFieldSet()#
				
				<!---Begin Accordion--->
				<div id="accordion" class="accordion">
					
					<!---Begin content info--->
                    <cfif prc.content.isLoaded()>
					<div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##contentinfo">
                        		<i class="icon-info-sign icon-large"></i> Content Info
                      		</a>
                    	</div>
                    	<div id="contentinfo" class="accordion-body collapse in">
                      		<div class="accordion-inner">
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
        						</table>
                      		</div>
                    	</div>
					</div>
					</cfif>
					
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
								<cfif prc.content.isLoaded() and prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
								<i class="icon-user icon-large"></i>
								#html.label(field="creatorID", content="Creator:", class="inline")#
								<select name="creatorID" id="creatorID" class="input-block-level">
									<cfloop array="#prc.authors#" index="author">
									<option value="#author.getAuthorID()#" <cfif prc.content.hasCreator() and prc.content.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
									</cfloop>
								</select>
								</cfif>
                        	</div>
                    	</div>
                  	</div>
                    </cfif>
                    <!---End Modifiers--->
					
				    <!---Begin Cache Content--->
					<cfif prc.oAuthor.checkPermission("EDITORS_CACHING")>
				    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##cachecontent">
                        		<i class="icon-hdd icon-large"></i> Cache Settings
                      		</a>
                    	</div>
                    	<div id="cachecontent" class="accordion-body collapse">
                      		<div class="accordion-inner">
        						<!--- Cache Settings --->
        						#html.label(field="cache",content="Cache Content:",class="inline")#
        						#html.select(name="cache", options="Yes,No", selectedValue=yesNoFormat(prc.content.getCache()), class="input-block-level")#
        						#html.inputField(name="cacheTimeout",label="Cache Timeout (0=Use Global):",bind=prc.content,title="Enter the number of minutes to cache your content, 0 means use global default",class="input-block-level",size="10",maxlength="100")#
        						#html.inputField(name="cacheLastAccessTimeout",label="Idle Timeout: (0=Use Global)",bind=prc.content,title="Enter the number of minutes for an idle timeout for your content, 0 means use global default",class="input-block-level",size="10",maxlength="100")#
                      		</div>
                    	</div>
                  	</div>
                    <!---End Cache Content--->
					</cfif>
				</div>
                <!---End Accordion--->	
			</div>
		</div>
	</div>
</div>
#html.endForm()#
</cfoutput>