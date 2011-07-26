<cfoutput>

<!--- Entry Form  --->
#html.startForm(action=rc.xehEntrySave,name="entryForm",novalidate="novalidate")#
			
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Entry Details
		</div>
		<div class="body">
			<cfif rc.entry.isLoaded()>
			<!--- Persisted Info --->
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/eye.png" alt="publish" width="16"/> Info')#
			<table class="tablelisting" width="100%">
				<tr>
					<th width="75" class="textRight">Created By:</th>
					<td>
						<a href="mailto:#rc.entry.getAuthor().getEmail()#">#rc.entry.getAuthorName()#</a>
					</td>
				</tr>
				<tr>
					<th width="75" class="textRight">Published On:</th>
					<td>
						#rc.entry.getDisplayPublishedDate()#
					</td>
				</tr>
				<tr>
					<th width="75" class="textRight">Created On:</th>
					<td>
						#rc.entry.getDisplayCreatedDate()#
					</td>
				</tr>						
			</table>	
			<div class="center">
				<button class="button2" onclick="return to('')" title="Open entry in site">Open In Site</button>
			</div>
			#html.endFieldset()#
			</cfif>
			
			<!--- Publish Info --->
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/calendar.png" alt="publish" width="16"/> Publish')#
				<!--- is Published --->
				#html.label(field="none",content="Status")#
				#html.radioButton(name="isPublished",value=true,checked=rc.entry.getIsPublished(),title="Publish Immediately or at Publish Date")#
				Publish
				#html.radioButton(name="isPublished",value=false,checked=(NOT rc.entry.getIsPublished()),title="Save as Draft or Un-Publish Entry")#
				Draft
				<!--- publish date --->
				#html.inputField(size="9",type="date",name="publishedDate",label="Publish Date",value=rc.entry.getPublishedDateForEditor(),class="textfield")#
				@
				#html.inputField(type="number",name="publishedHour",value=ckHour( rc.entry.getPublishedDateForEditor() ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield")#
				#html.inputField(type="number",name="publishedMinute",value=ckMinute( rc.entry.getPublishedDateForEditor() ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield")#
			
				<!--- Action Bar --->
				<div class="actionBar">
					<a href="#event.buildLink(rc.xehEntries)#"><button class="button">Cancel</button></a> or
					&nbsp;<input type="submit" class="buttonred" value="Save">
				</div>
			
			#html.endFieldSet()#
			
			<!--- Entry Modifiers --->
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/settings.png" alt="modifiers" width="16"/> Modifiers')#
				<!--- Allow Comments --->
				<cfif prc.bbSettings.bb_comments_enabled>
				<img src="#prc.bbRoot#/includes/images/comments_black.png" alt="comments" />
				#html.label(field="allowComments",content="Allow Comments",class="inline")#
				#html.checkbox(name="allowComments",value="true",class="inline",checked=rc.entry.getAllowComments())#
				<br/>
				</cfif>
				<!--- Password Protection --->
				<label for="passwordProtection"><img src="#prc.bbRoot#/includes/images/lock.png" alt="lock" /> Password Protection:</label>
				#html.textfield(name="passwordProtection",bind=rc.entry,title="Password protect your entry, leave empty for none",class="textfield",size="25",maxlength="100")#
			#html.endFieldSet()#
			
			<!--- Categories --->
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/category_black.png" alt="category" width="16"/> Categories')#
				
				<!--- Display categories --->
				<div id="categoriesChecks">
				<cfloop from="1" to="#arrayLen(rc.categories)#" index="x">
					#html.checkbox(name="category_#x#",value="#rc.categories[x].getCategoryID()#",checked=rc.entry.hasCategories( rc.categories[x] ))#
					#html.label(field="category_#x#",content="#rc.categories[x].getCategory()#",class="inline")#<br/>
				</cfloop>
				</div>
				
				<!--- New Categories --->
				#html.textField(name="newCategories",label="New Categories",size="25",title="Comma delimited list of new categories to create",class="textfield")#
			#html.endFieldSet()#
			
			<!--- HTML Attributes --->
			#html.startFieldSet(legend='<img src="#prc.bbRoot#/includes/images/world.png" alt="world" width="16"/> HTML Attributes')#
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
			<img src="#prc.bbroot#/includes/images/blog.png" alt="entry editor" width="30" height="30" />
			Entry Editor
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- id --->
			#html.hiddenField(name="entryID",bind=rc.entry)#
			
			<!--- title --->
			#html.textfield(label="Title:",name="title",bind=rc.entry,maxlength="100",required="required",title="The title for this entry",class="textfield width98")#
			<!--- slug --->
			<cfif rc.entry.isLoaded()>
			<label for="slug">Permalink: 
				<img src='#prc.bbroot#/includes/images/link.png' alt='permalink' title="Convert title to permalink" onclick="createPermalink('#event.buildLink(rc.xehSlugify)#')"/>
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
				<img src="#prc.bbroot#/includes/images/comments_32.png" alt="entry editor" width="30" height="30" />
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
#html.addAsset(prc.bbroot&"/includes/ckeditor/ckeditor.js")#
#html.addAsset(prc.bbroot&"/includes/ckeditor/adapters/jquery.js")#
#html.addAsset(prc.bbroot&"/includes/js/blogbox.editor.js")#
#html.addAsset(prc.bbroot&"/includes/css/date.css")#
</cfoutput>