<cfoutput>
<!--- Page Form  --->
#html.startForm(action=prc.xehPageSave,name="pageForm",novalidate="novalidate")#
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Page Details
		</div>
		<div class="body">
			<cfif prc.page.isLoaded()>
			<!--- Persisted Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/eye.png" alt="publish" width="16"/> Info')#
			<table class="tablelisting" width="100%">
				<tr>
					<th width="85" class="textRight">Created By:</th>
					<td>
						<a href="mailto:#prc.page.getAuthor().getEmail()#">#prc.page.getAuthorName()#</a>
					</td>
				</tr>
				<tr>
					<th class="textRight">Published On:</th>
					<td>
						#prc.page.getDisplayPublishedDate()#
					</td>
				</tr>
				<tr>
					<th class="textRight">Created On:</th>
					<td>
						#prc.page.getDisplayCreatedDate()#
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
						#prc.page.getHits()#
					</td>
				</tr>	
				<tr>
					<th class="textRight">Comments:</th>
					<td>
						#prc.page.getNumberOfComments()#
					</td>
				</tr>					
			</table>	
			<div class="center">
				<button class="button2" onclick="window.open('#prc.CBHelper.linkPage( prc.page )#');return false;" title="Open page in site">Open In Site</button>
			</div>
			#html.endFieldset()#
			</cfif>
			
			<!--- Publish Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/calendar.png" alt="publish" width="16"/> Publishing',class="#prc.page.getIsPublished()?'':'selected'#")#
				
				<!--- Published? --->
				<cfif !prc.page.getIsPublished()><div class="textRed">Page is a draft!</div></cfif>
				
				<!--- is Published --->
				#html.hiddenField(name="isPublished",value=true)#
				<!--- publish date --->
				#html.inputField(size="9",type="date",name="publishedDate",label="Publish Date",value=prc.page.getPublishedDateForEditor(),class="textfield")#
				@
				#html.inputField(type="number",name="publishedHour",value=prc.ckHelper.ckHour( prc.page.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield")#
				#html.inputField(type="number",name="publishedMinute",value=prc.ckHelper.ckMinute( prc.page.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield")#
			
				<!--- Action Bar --->
				<div class="actionBar">
					&nbsp;<input type="submit" class="button2" value="Quick Save" title="Quickly save your work as a draft & continue working!" onclick="return quickSave()">
					&nbsp;<input type="submit" class="button2" value="Save Draft" title="Save this masterpiece as a draft!" onclick="toggleDraft()">
					&nbsp;<input type="submit" class="buttonred" value="Publish" title="Let's publish this masterpiece!">
				</div>
				
				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
					<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
				</div>
			
			#html.endFieldSet()#
			
			<!--- Page Options --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/page.png" alt="modifiers" width="16"/> Page Options')#
				<!--- Parent Page --->
				#html.label(field="parentPage",content='Parent:')#
				<select name="parentPage" id="parentPage" class="width98">
					<option value="">No Parent</option>
					#html.options(values=prc.pages,column="contentID",nameColumn="title",selectedValue=prc.parentcontentID)#
				</select>
				
				<!--- layout --->
				#html.label(field="layout",content='Layout:')#
				<select name="layout" id="layout" class="width98">
					#html.options(values=prc.availableLayouts,selectedValue=prc.page.getLayoutWithDefault())#
				</select>
				
				<!--- order --->
				#html.inputfield(type="number",label="Order: (0-99)",name="order",bind=prc.page,title="The ordering index used when building menus",class="textfield",size="5",maxlength="2",min="0",max="99")#
			
			#html.endFieldSet()#
			
			<!--- Page Modifiers --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/settings.png" alt="modifiers" width="16"/> Modifiers')#
				<!--- Allow Comments --->
				<cfif prc.cbSettings.cb_comments_enabled>
				<img src="#prc.cbRoot#/includes/images/comments_black.png" alt="comments" />
				#html.label(field="allowComments",content="Allow Comments:",class="inline")#
				#html.select(name="allowComments",options="Yes,No",bind=prc.page)#
				<br/>
				</cfif>
				<!--- Show in Menu Builders --->
				<img src="#prc.cbRoot#/includes/images/source.png" alt="showInMenu" />
				#html.label(field="showInMenu",content="Show In Menu:",class="inline")#
				#html.select(name="showInMenu",options="Yes,No",bind=prc.page)#
				<br/>
				<!--- Password Protection --->
				<label for="passwordProtection"><img src="#prc.cbRoot#/includes/images/lock.png" alt="lock" /> Password Protection:</label>
				#html.textfield(name="passwordProtection",bind=prc.page,title="Password protect your page, leave empty for none",class="textfield",size="25",maxlength="100")#
			#html.endFieldSet()#
			
			<!--- HTML Attributes --->
			#html.startFieldSet(legend='<img src="#prc.cbRoot#/includes/images/world.png" alt="world" width="16"/> HTML Attributes')#
				#html.textField(name="htmlKeywords",label="Keywords: (Max 160 characters)",title="HTML Keywords Comma Delimited (Good for SEO)",bind=prc.page,class="textfield width95",maxlength="160")#
				#html.textArea(name="htmlDescription",label="Description: (Max 160 characters)",title="HTML Description (Good for SEO)",bind=prc.page,class="textfield",maxlength="160")#
			#html.endFieldSet()#
			<!--- Event --->
			#announceInterception("cbadmin_pageEditorSidebar")#
		</div>
	</div>		
	<!--- Event --->
	#announceInterception("cbadmin_pageEditorSidebarFooter")#	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/page_big.png" alt="editor" width="30" height="30" />
			Page Editor
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- id --->
			#html.hiddenField(name="contentID",bind=prc.page)#
			#html.hiddenField(name="sluggerURL",value=event.buildLink(prc.xehSlugify))#
			
			<!--- title --->
			#html.textfield(label="Title:",name="title",bind=prc.page,maxlength="100",required="required",title="The title for this page",class="textfield width98")#
			<!--- slug --->
			<label for="slug">Permalink: 
				<img src='#prc.cbroot#/includes/images/link.png' alt='permalink' title="Convert title to permalink" onclick="createPermalink()"/>
				<small> #event.buildLink('')#</small>
			</label>
			#html.textfield(name="slug",bind=prc.page,maxlength="100",class="textfield width98",title="The URL permalink for this page")#
			
			<!--- content --->
			#html.textarea(label="Content:",name="content",bind=prc.page,rows="25")#
			
			<!--- Custom Fields --->
			<!--- I have to use the json garbage as CF9 Blows up on the implicit structs, come on man! --->
			<cfset mArgs = {fieldType="Page", customFields=prc.page.getCustomFields()}>
			#renderView(view="_tags/customFields",args=mArgs)#
			
			<!--- Event --->
			#announceInterception("cbadmin_pageEditorInBody")#
		</div>	
	</div>
	
	<cfif prc.page.getallowComments()>
	<!--- Page Comments --->
	<div class="box">	
		<cfif structKeyExists(prc,"commentsViewlet")> 
			<div class="header">
				<img src="#prc.cbroot#/includes/images/comments_32.png" alt="editor" width="30" height="30" />
				Comments
			</div>
			<div class="body">
				#prc.commentsViewlet#
			</div>
		</cfif>
	</div>
	</cfif>
	
	<!--- Sub Pages --->
	<cfif prc.page.isLoaded()>
		<div class="box">	
			<div class="header">
				<img src="#prc.cbroot#/includes/images/parent_color.png" alt="editor" width="30" height="30" />
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
#html.endForm()#
</cfoutput>