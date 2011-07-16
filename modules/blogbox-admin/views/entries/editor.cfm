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
			<table class="tablelisting" width="100%">
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
			</cfif>
			
			<!--- Publish Info --->
				#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/print.png" alt="publish" width="16"/> Publish Status')#
					<!--- is Published --->
					#html.label(field="none",content="Status")#
					#html.radioButton(name="isPublished",value=true,checked=rc.entry.getIsPublished(),title="Publish Immediately or at Publish Date")#
					Publish
					#html.radioButton(name="isPublished",value=false,checked=(NOT rc.entry.getIsPublished()),title="Save as Draft")#
					Draft
					<!--- publish date --->
					#html.inputField(size="9",type="date",name="publishedDate",label="Publish Date",value=rc.entry.getPublishedDateForEditor(),class="textfield")#
					@
					#html.inputField(type="number",name="publishedHour",value=ckHour( rc.entry.getPublishedDateForEditor() ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield")#
					#html.inputField(type="number",name="publishedMinute",value=ckMinute( rc.entry.getPublishedDateForEditor() ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield")#
				#html.endFieldSet()#
				
				<!--- Entry Modifiers --->
				#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/settings.png" alt="modifiers" width="16"/> Entry Modifiers')#
					<!--- Allow Comments --->
					<img src="#prc.bbRoot#/includes/images/comments.png" alt="comments" />
					#html.label(field="allowComments",content="Allow Comments",class="inline")#
					#html.checkbox(name="allowComments",value="true",class="inline",checked=rc.entry.getAllowComments())#
					<!--- Password Protection --->
					<br/>
					<label for="passwordProtection"><img src="#prc.bbRoot#/includes/images/lock.png" alt="lock" /> Password Protection:</label>
					#html.textfield(name="passwordProtection",bind=rc.entry,title="Password protect your entry, leave empty for none",class="textfield",size="25")#
				#html.endFieldSet()#
				
				<!--- Categories --->
				#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/category_black.png" alt="category" width="16"/> Entry Categories')#
					<cfloop from="1" to="#arrayLen(rc.categories)#" index="x">
						#html.checkbox(name="category_#x#",value="#rc.categories[x].getCategoryID()#")#
						#html.label(field="category_#x#",content="#rc.categories[x].getCategory()#",class="inline")#<br/>
					</cfloop>
					
					<!--- New Categories --->
					#html.textField(name="newCategories",label="New Categories",size="25",title="Comma delimited list of new categories to create",class="textfield")#
				#html.endFieldSet()#
				
				<!--- Action Bar --->
				<div class="actionBar">
					<a href="#event.buildLink(rc.xehEntries)#"><button class="button">Cancel</button></a> or
					<input type="submit" class="button2">
				</div>
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.bbroot#/includes/images/entry.png" alt="entry editor" width="30" height="30" />
			Entry Editor
		</div>
		<!--- Body --->
		<div class="body">
			<!--- id --->
			#html.hiddenField(name="entryID",bind=rc.entry)#
			<!--- title --->
			#html.textfield(label="title",name="title",bind=rc.entry,maxlength="100",size="100",required="required",title="The title for this entry",class="textfield")#
			<!--- slug --->
			<cfif rc.entry.isLoaded()>
			#html.textfield(label="slug",name="slug",bind=rc.entry,maxlength="100",size="100",class="textfield")#
			</cfif>
			<!--- content --->
			#html.textarea(label="Content",name="content",bind=rc.entry,rows="25")#	
		</div>	
	</div>
</div>
#html.endForm()#

<!--- Load Assets --->
#html.addAsset(prc.bbroot&"/includes/ckeditor/ckeditor.js")#
#html.addAsset(prc.bbroot&"/includes/ckeditor/adapters/jquery.js")#
#html.addAsset(prc.bbroot&"/includes/js/blogbox.editor.js")#
#html.addAsset(prc.bbroot&"/includes/css/date.css")#
</cfoutput>