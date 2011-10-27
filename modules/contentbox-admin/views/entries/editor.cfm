<cfoutput>

<!--- Entry Form  --->
#html.startForm(action=rc.xehEntrySave,name="entryForm",novalidate="novalidate")#
	
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Entry Details
		</div>
		<div class="body">
			<cfif rc.entry.isLoaded()>
			<!--- Persisted Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/eye.png" alt="publish" width="16"/> Info')#
			<table class="tablelisting" width="100%">
				<tr>
					<th width="85" class="textRight">Created By:</th>
					<td>
						<a href="mailto:#rc.entry.getAuthor().getEmail()#">#rc.entry.getAuthorName()#</a>
					</td>
				</tr>
				<tr>
					<th class="textRight">Published On:</th>
					<td>
						#rc.entry.getDisplayPublishedDate()#
					</td>
				</tr>
				<tr>
					<th class="textRight">Created On:</th>
					<td>
						#rc.entry.getDisplayCreatedDate()#
					</td>
				</tr>
				<tr>
					<th class="textRight">Views:</th>
					<td>
						#rc.entry.getHits()#
					</td>
				</tr>	
				<tr>
					<th class="textRight">Comments:</th>
					<td>
						#rc.entry.getNumberOfComments()#
					</td>
				</tr>					
			</table>	
			<div class="center">
				<button class="button2" onclick="window.open('#prc.CBHelper.linkEntry(rc.entry)#');return false;" title="Open entry in site">Open In Site</button>
			</div>
			#html.endFieldset()#
			</cfif>
			
			<!--- Publish Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/calendar.png" alt="publish" width="16"/> Publishing')#
				<!--- is Published --->
				#html.hiddenField(name="isPublished",value=true)#
				<!--- publish date --->
				#html.inputField(size="9",type="date",name="publishedDate",label="Publish Date",value=rc.entry.getPublishedDateForEditor(),class="textfield")#
				@
				#html.inputField(type="number",name="publishedHour",value=ckHour( rc.entry.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield")#
				#html.inputField(type="number",name="publishedMinute",value=ckMinute( rc.entry.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield")#
			
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
				#html.select(name="allowComments",options="Yes,No",bind=rc.entry)#
				<br/>
				</cfif>
				<!--- Password Protection --->
				<label for="passwordProtection"><img src="#prc.cbRoot#/includes/images/lock.png" alt="lock" /> Password Protection:</label>
				#html.textfield(name="passwordProtection",bind=rc.entry,title="Password protect your entry, leave empty for none",class="textfield",size="25",maxlength="100")#
			#html.endFieldSet()#
			
			<!--- Categories --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/category_black.png" alt="category" width="16"/> Categories')#
				
				<!--- Display categories --->
				<div id="categoriesChecks">
				<cfloop from="1" to="#arrayLen(rc.categories)#" index="x">
					#html.checkbox(name="category_#x#",value="#rc.categories[x].getCategoryID()#",checked=rc.entry.hasCategories( rc.categories[x] ))#
					#html.label(field="category_#x#",content="#rc.categories[x].getCategory()#",class="inline")#<br/>
				</cfloop>
				</div>
				
				<!--- New Categories --->
				#html.textField(name="newCategories",label="New Categories",size="30",title="Comma delimited list of new categories to create",class="textfield")#
			#html.endFieldSet()#
			
			<!--- HTML Attributes --->
			#html.startFieldSet(legend='<img src="#prc.cbRoot#/includes/images/world.png" alt="world" width="16"/> HTML Attributes')#
				#html.textField(name="htmlKeywords",label="Keywords: (Max 160 characters)",title="HTML Keywords Comma Delimited (Good for SEO)",bind=rc.entry,class="textfield width95",maxlength="160")#
				#html.textArea(name="htmlDescription",label="Description: (Max 160 characters)",title="HTML Description (Good for SEO)",bind=rc.entry,class="textfield",maxlength="160")#
			#html.endFieldSet()#
			
		</div>
	</div>		
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
			#html.hiddenField(name="entryID",bind=rc.entry)#
			#html.hiddenField(name="sluggerURL",value=event.buildLink(rc.xehSlugify))#
			
			<!--- title --->
			#html.textfield(label="Title:",name="title",bind=rc.entry,maxlength="100",required="required",title="The title for this entry",class="textfield width98")#
			<!--- slug --->
			<cfif rc.entry.isLoaded()>
			<label for="slug">Permalink: 
				<img src='#prc.cbroot#/includes/images/link.png' alt='permalink' title="Convert title to permalink" onclick="createPermalink()"/>
				<small> #event.buildLink('')#</small>
			</label>
			#html.textfield(name="slug",bind=rc.entry,maxlength="100",class="textfield width98",title="The URL permalink for this entry")#
			</cfif>
			
			<!--- content --->
			#html.textarea(label="Content:",name="content",bind=rc.entry,rows="25")#
			<!--- excerpt --->
			#html.textarea(label="Excerpt:",name="excerpt",bind=rc.entry)#	
		
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
				#rc.commentsViewlet#
			</div>
		</cfif>
	</div>
</div>
#html.endForm()#

<!--- Load Assets --->
#html.addAsset(prc.cbroot&"/includes/ckeditor/ckeditor.js")#
#html.addAsset(prc.cbroot&"/includes/ckeditor/adapters/jquery.js")#
#html.addAsset(prc.cbroot&"/includes/js/contentbox.editor.js")#
#html.addAsset(prc.cbroot&"/includes/css/date.css")#
</cfoutput>