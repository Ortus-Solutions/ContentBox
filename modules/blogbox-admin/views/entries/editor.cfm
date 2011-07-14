<cfoutput>
<!--- Entry Form  --->
#html.startForm(action=rc.xehEntrySave,name="entryForm")#
	<h1>Entry Editor</h1>
	<!--- id --->
	#html.hiddenField(name="entryID",bind=rc.entry)#
	<!--- title --->
	#html.textfield(label="title",name="title",bind=rc.entry,maxlength="100",size="100",required="required",title="The title for this entry")#
	<!--- slug --->
	<cfif rc.entry.isLoaded()>
	#html.textfield(label="slug",name="slug",bind=rc.entry,maxlength="100",size="100")#
	</cfif>
	<!--- content --->
	#html.textarea(name="content",bind=rc.entry,rows="20")#	
	
	<!--- Publish Info --->
	#html.startFieldset(legend="Publish Status")#
		<!--- is Published --->
		#html.label(field="none",content="Status")#
		#html.radioButton(name="isPublished",value=true,checked=rc.entry.getIsPublished(),title="Publish Immediately or at Publish Date")#
		Publish
		#html.radioButton(name="isPublished",value=false,checked=(NOT rc.entry.getIsPublished()),title="Save as Draft")#
		Draft
		<!--- publish date --->
		#html.inputField(size="10",type="date",name="publishedDate",label="Publish Date",value=rc.entry.getDisplayPublishedDate())#
		@
		#html.inputField(type="number",name="publishedHour",value=ckHour( rc.entry.getPublishedDate() ),size=4,maxlength="2",min="1",max="24",title="Hour in 24 format")#
		#html.inputField(type="number",name="publishedMinute",value=ckMinute( rc.entry.getPublishedDate() ),size=4,maxlength="2",min="0",max="60", title="Minute")#
	#html.endFieldSet()#
	
	<!--- Entry Modifiers --->
	#html.startFieldset(legend="Entry Modifiers")#
		<!--- Allow Comments --->
		#html.checkbox(name="allowComments",value="true",class="inline",checked=rc.entry.getAllowComments())#
		#html.label(field="allowComments",content="Allow Comments",class="inline")#
		<!--- Password Protection --->
		#html.textfield(label="Password Protection",name="passwordProtection",bind=rc.entry,title="Password protect your entry, leave empty for none")#
	#html.endFieldSet()#
	
	<!--- Categories --->
	#html.startFieldset(legend="Entry Categories")#
		<cfloop from="1" to="#arrayLen(rc.categories)#" index="x">
			#html.checkbox(name="category_#x#",value="#rc.categories[x].getCategoryID()#")#
			#html.label(field="category_#x#",content="#rc.categories[x].getCategory()#",class="inline")#<br/>
		</cfloop>
		
		<!--- New Categories --->
		#html.textField(name="newCategories",label="New Categories",size="30",title="Comma delimited list of new categories to create")#
	#html.endFieldSet()#
	
	<!--- Submit Bar --->
	<div id="formSubmitBar">
		#html.href(href=rc.xehEntries,text="Cancel")#
		or
		#html.submitButton()#
	</div>
	
#html.endForm()#

<!--- Load Assets --->
#html.addAsset(rc.bbroot&"/includes/ckeditor/ckeditor.js")#
#html.addAsset(rc.bbroot&"/includes/ckeditor/adapters/jquery.js")#
#html.addAsset(rc.bbroot&"/includes/js/blogbox.editor.js")#
#html.addAsset(rc.bbroot&"/includes/css/date.css")#
<script type="text/javascript">
</script>
</cfoutput>