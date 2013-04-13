<cfoutput>
<div id="quickPost">
	<div id="quickPostContent">
		<!--- Entry Form  --->
		#html.startForm(action=prc.xehQPEntrySave,name="quickPostForm",novalidate="novalidate")#
			<h2>Quick Post</h2>
			<!--- Hidden Fields --->
			#html.hiddenField(name="contentID",value="")#
			#html.hiddenField(name="isPublished",value="true")#
			
				<!--- title --->
				#html.textfield(name="title", maxlength="100", required="required", title="The title for this entry",class="input-block-level", placeholder="Title Here")#
				<!--- content --->
				#html.textarea(name="quickcontent",required="required")#
			
			<!--- Categories --->
			#html.startFieldset(legend='<i class="icon-tags icon-large"></i> Categories')#
				<cfloop from="1" to="#arrayLen(prc.qpCategories)#" index="x">
					<label class="checkbox inline">
					#html.checkbox(name="category_#x#",value="#prc.qpCategories[x].getCategoryID()#")#
					#prc.qpCategories[x].getCategory()#
					</label>
				</cfloop>
				<!--- New Categories --->
				#html.textField(name="newCategories",label="New Categories (Comma delimited)", title="Comma delimited list of new categories to create",class="input-block-level")#
			#html.endFieldSet()#
			
			<!--- Button Bar --->
			<div class="text-center form-actions">
				<button class="btn" onclick="return closeQuickPost()" title="Change your mind hugh?"> Cancel </button>
				&nbsp;<button type="submit" class="btn btn-primary" onclick="qpSaveDraft()" title="Not ready for primetime!">Save Draft</button>
				<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
				&nbsp;<button type="submit" class="btn btn-danger" title="Yeahaww! Let's Publish It!">Publish</button>
				</cfif>
			</div>
		#html.endForm()#
	</div>
</div>
</cfoutput>