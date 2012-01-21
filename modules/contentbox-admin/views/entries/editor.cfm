<cfoutput>
<!--- Entry Form  --->
#html.startForm(action=prc.xehEntrySave,name="entryForm",novalidate="novalidate")#
	
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Entry Details
		</div>
		<div class="body">
			<cfif prc.entry.isLoaded()>
			<!--- Persisted Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/eye.png" alt="publish" width="16"/> Info')#
			<table class="tablelisting" width="100%">
				<tr>
					<th width="85" class="textRight">Created By:</th>
					<td>
						<a href="mailto:#prc.entry.getAuthor().getEmail()#">#prc.entry.getAuthorName()#</a>
					</td>
				</tr>
				<tr>
					<th class="textRight">Published On:</th>
					<td>
						#prc.entry.getDisplayPublishedDate()#
					</td>
				</tr>
				<tr>
					<th class="textRight">Created On:</th>
					<td>
						#prc.entry.getDisplayCreatedDate()#
					</td>
				</tr>
				<tr>
					<th class="textRight">Views:</th>
					<td>
						#prc.entry.getHits()#
					</td>
				</tr>	
				<tr>
					<th class="textRight">Comments:</th>
					<td>
						#prc.entry.getNumberOfComments()#
					</td>
				</tr>					
			</table>	
			<div class="center">
				<button class="button2" onclick="window.open('#prc.CBHelper.linkEntry(prc.entry)#');return false;" title="Open entry in site">Open In Site</button>
			</div>
			#html.endFieldset()#
			</cfif>
			
			<!--- Publish Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/calendar.png" alt="publish" width="16"/> Publishing')#
				<!--- is Published --->
				#html.hiddenField(name="isPublished",value=true)#
				<!--- publish date --->
				#html.inputField(size="9",type="date",name="publishedDate",label="Publish Date",value=prc.entry.getPublishedDateForEditor(),class="textfield")#
				@
				#html.inputField(type="number",name="publishedHour",value=prc.ckHelper.ckHour( prc.entry.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield")#
				#html.inputField(type="number",name="publishedMinute",value=prc.ckHelper.ckMinute( prc.entry.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield")#
			
				<!--- Action Bar --->
				<div class="actionBar">
					&nbsp;<input type="submit" class="button2" value="Save Draft" title="Save this masterpiece as a draft!" onclick="toggleDraft()">
					&nbsp;<input type="submit" class="buttonred" value="Publish" title="Let's publish this masterpiece!">
				</div>
			
			#html.endFieldSet()#
			
			<!--- Entry Modifiers --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/settings.png" alt="modifiers" width="16"/> Modifiers')#
				<!--- Allow Comments --->
				<cfif prc.cbSettings.cb_comments_enabled>
				<img src="#prc.cbRoot#/includes/images/comments_black.png" alt="comments" />
				#html.label(field="allowComments",content="Allow Comments:",class="inline")#
				#html.select(name="allowComments",options="Yes,No",bind=prc.entry)#
				<br/>
				</cfif>
				<!--- Password Protection --->
				<label for="passwordProtection"><img src="#prc.cbRoot#/includes/images/lock.png" alt="lock" /> Password Protection:</label>
				#html.textfield(name="passwordProtection",bind=prc.entry,title="Password protect your entry, leave empty for none",class="textfield",size="25",maxlength="100")#
			#html.endFieldSet()#
			
			<!--- Categories --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/category_black.png" alt="category" width="16"/> Categories')#
				
				<!--- Display categories --->
				<div id="categoriesChecks">
				<cfloop from="1" to="#arrayLen(prc.categories)#" index="x">
					#html.checkbox(name="category_#x#",value="#prc.categories[x].getCategoryID()#",checked=prc.entry.hasCategories( prc.categories[x] ))#
					#html.label(field="category_#x#",content="#prc.categories[x].getCategory()#",class="inline")#<br/>
				</cfloop>
				</div>
				
				<!--- New Categories --->
				#html.textField(name="newCategories",label="New Categories",size="30",title="Comma delimited list of new categories to create",class="textfield")#
			#html.endFieldSet()#
			
			<!--- HTML Attributes --->
			#html.startFieldSet(legend='<img src="#prc.cbRoot#/includes/images/world.png" alt="world" width="16"/> HTML Attributes')#
				#html.textField(name="htmlKeywords",label="Keywords: (Max 160 characters)",title="HTML Keywords Comma Delimited (Good for SEO)",bind=prc.entry,class="textfield width95",maxlength="160")#
				#html.textArea(name="htmlDescription",label="Description: (Max 160 characters)",title="HTML Description (Good for SEO)",bind=prc.entry,class="textfield",maxlength="160")#
			#html.endFieldSet()#
			
			<!--- Event --->
			#announceInterception("cbadmin_entryEditorSidebar")#
		</div>
	</div>		
	<!--- Event --->
	#announceInterception("cbadmin_entryEditorSidebarFooter")#
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/blog.png" alt="entry editor" width="30" height="30" />
			Entry Editor
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- id --->
			#html.hiddenField(name="entryID",bind=prc.entry)#
			#html.hiddenField(name="sluggerURL",value=event.buildLink(prc.xehSlugify))#
			
			<!--- title --->
			#html.textfield(label="Title:",name="title",bind=prc.entry,maxlength="100",required="required",title="The title for this entry",class="textfield width98")#
			<!--- slug --->
			<cfif prc.entry.isLoaded()>
			<label for="slug">Permalink: 
				<img src='#prc.cbroot#/includes/images/link.png' alt='permalink' title="Convert title to permalink" onclick="createPermalink()"/>
				<small> #event.buildLink('')#</small>
			</label>
			#html.textfield(name="slug",bind=prc.entry,maxlength="100",class="textfield width98",title="The URL permalink for this entry")#
			</cfif>
			
			<!--- content --->
			#html.textarea(label="Content:",name="content",bind=prc.entry,rows="25")#
			<!--- excerpt --->
			#html.textarea(label="Excerpt:",name="excerpt",bind=prc.entry)#	
			
			<!--- Custom Fields --->
			<!--- I have to use the json garbage as CF9 Blows up on the implicit structs, come on man! --->
			<cfset mArgs = {fieldType="Entry", customFields=prc.entry.getCustomFields()}>
			#renderView(view="_tags/customFields",args=mArgs)#
			
			<!--- Event --->
			#announceInterception("cbadmin_entryEditorInBody")#
		</div>	
	</div>
	
	<!--- Entry Comments --->
	<div class="box">	
		<cfif structKeyExists(rc,"commentsViewlet")> 
			<div class="header">
				<img src="#prc.cbroot#/includes/images/comments_32.png" alt="entry editor" width="30" height="30" />
				Entry Comments
			</div>
			<div class="body">
				#prc.commentsViewlet#
			</div>
		</cfif>
	</div>
	
	<!--- Event --->
	#announceInterception("cbadmin_entryEditorFooter")#
</div>
#html.endForm()#
</cfoutput>