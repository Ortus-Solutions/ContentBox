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

			<!--- Publish Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/calendar.png" alt="publish" width="16"/> Publishing',class="#prc.page.getIsPublished()?'':'selected'#")#

				<!--- Published? --->
				<cfif prc.page.isLoaded()>
				<label class="inline">Status: </label>
				<cfif !prc.page.getIsPublished()><div class="textRed inline">Draft!</div><cfelse>Published</cfif>
				</cfif>

				<!--- is Published --->
				#html.hiddenField(name="isPublished",value=true)#
				<!--- publish date --->
				#html.inputField(size="9",type="date",name="publishedDate",label="Publish Date",value=prc.page.getPublishedDateForEditor(),class="textfield")#
				@
				#html.inputField(type="number",name="publishedHour",value=prc.ckHelper.ckHour( prc.page.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
				#html.inputField(type="number",name="publishedMinute",value=prc.ckHelper.ckMinute( prc.page.getPublishedDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#

				<!--- expire date --->
				#html.inputField(size="9",type="date",name="expireDate",label="Expire Date",value=prc.page.getExpireDateForEditor(),class="textfield")#
				@
				#html.inputField(type="number",name="publishedHour",value=prc.ckHelper.ckHour( prc.page.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="24",title="Hour in 24 format",class="textfield editorTime")#
				#html.inputField(type="number",name="publishedMinute",value=prc.ckHelper.ckMinute( prc.page.getExpireDateForEditor(showTime=true) ),size=2,maxlength="2",min="0",max="60", title="Minute",class="textfield editorTime")#

				<!--- Changelog --->
				#html.textField(name="changelog",label="Commit Changelog",class="textfield width95",title="A quick description of what this commit is all about.")#

				<!--- Action Bar --->
				<div class="actionBar">
					&nbsp;<input type="submit" class="button2" value="Quick Save" title="Quickly save your work as a draft & continue working!" onclick="return quickSave()">
					&nbsp;<input type="submit" class="button2" value="&nbsp; Draft &nbsp;" title="Save this masterpiece as a draft!" onclick="toggleDraft()">
					<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
					&nbsp;<input type="submit" class="buttonred" value="Publish" title="Let's publish this masterpiece!">
					</cfif>
				</div>

				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
					<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
				</div>

			#html.endFieldSet()#

			<!--- Accordion --->
			<div id="accordion">
				<!--- Stats Panel --->
				<cfif prc.page.isLoaded()>
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<img src="#prc.cbroot#/includes/images/eye.png" alt="info" /> Page Info </h2>
				<div class="pane">
					<table class="tablelisting" width="100%">
						<tr>
							<th width="85" class="textRight">Created By:</th>
							<td>
								<a href="mailto:#prc.page.getAuthorEmail()#">#prc.page.getAuthorName()#</a>
							</td>
						</tr>
						<tr>
							<th class="textRight">Published On:</th>
							<td>
								#prc.page.getDisplayPublishedDate()#
							</td>
						</tr>
						<tr>
							<th class="textRight">Page Version:</th>
							<td>
								#prc.page.getActiveContent().getVersion()#
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
				</div>
				</cfif>
				<!--- Page Options Panel --->
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<img src="#prc.cbroot#/includes/images/page.png" alt="info" /> Display Options </h2>
				<div class="pane">
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

					<!--- Show in Menu Builders --->
					#html.select(name="showInMenu",label="Show In Menus:",class="width98",options="Yes,No",selectedValue=yesNoFormat(prc.page.getShowInMenu()))#

					<!--- menu order --->
					#html.inputfield(type="number",label="Menu Order: (0-99)",name="order",bind=prc.page,title="The ordering index used when building menus",class="textfield",size="5",maxlength="2",min="0",max="99")#

				</div>

				<!--- Page Modifiers Panel --->
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<img src="#prc.cbroot#/includes/images/settings_black.png" alt="info" /> Modifiers </h2>
				<div class="pane">
					<!--- Allow Comments --->
					<cfif prc.cbSettings.cb_comments_enabled>
					<img src="#prc.cbRoot#/includes/images/comments_black.png" alt="comments" />
					#html.label(field="allowComments",content="Allow Comments:",class="inline")#
					#html.select(name="allowComments",options="Yes,No",selectedValue=yesNoFormat(prc.page.getAllowComments()))#
					<br/>
					</cfif>
					<!--- Password Protection --->
					<label for="passwordProtection"><img src="#prc.cbRoot#/includes/images/lock.png" alt="lock" /> Password Protection:</label>
					#html.textfield(name="passwordProtection",bind=prc.page,title="Password protect your page, leave empty for none",class="textfield",size="25",maxlength="100")#
					<br>
				</div>

				<!--- Page Cache Panel --->
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<img src="#prc.cbroot#/includes/images/database_black.png" alt="info" /> Cache Settings </h2>
				<div class="pane">
					<!--- Cache Settings --->
					#html.label(field="cache",content="Cache Page Content: (fast)")#
					<small>Caches content translation only</small><Br/>
					#html.select(name="cache",options="Yes,No",selectedValue=yesNoFormat(prc.page.getCache()))#<br/>

					#html.label(field="cacheLayout",content="Cache Page Layout: (faster)")#
					<small>Caches all generated page+layout HTML</small><br/>
					#html.select(name="cacheLayout",options="Yes,No",selectedValue=yesNoFormat(prc.page.getCacheLayout()))#<br/>

					#html.inputField(type="numeric",name="cacheTimeout",label="Cache Timeout (0=Use Global):",bind=prc.page,title="Enter the number of minutes to cache your content, 0 means use global default",class="textfield",size="10",maxlength="100")#
					#html.inputField(type="numeric",name="cacheLastAccessTimeout",label="Idle Timeout: (0=Use Global)",bind=prc.page,title="Enter the number of minutes for an idle timeout for your content, 0 means use global default",class="textfield",size="10",maxlength="100")#
				</div>

				<!--- Categories --->
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<img src="#prc.cbroot#/includes/images/category_black.png" alt="info" /> Categories </h2>
				<div class="pane">
					<!--- Display categories --->
					<div id="categoriesChecks">
					<cfloop from="1" to="#arrayLen(prc.categories)#" index="x">
						#html.checkbox(name="category_#x#",value="#prc.categories[x].getCategoryID()#",checked=prc.page.hasCategories( prc.categories[x] ))#
						#html.label(field="category_#x#",content="#prc.categories[x].getCategory()#",class="inline")#<br/>
					</cfloop>
					</div>

					<!--- New Categories --->
					#html.textField(name="newCategories",label="New Categories",size="30",title="Comma delimited list of new categories to create",class="textfield")#
				</div>

				<!--- HTML Modifiers Panel --->
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<img src="#prc.cbroot#/includes/images/world.png" alt="info" /> HTML Attributes </h2>
				<div class="pane">
					#html.textField(name="htmlKeywords",label="Keywords: (Max 160 characters)",title="HTML Keywords Comma Delimited (Good for SEO)",bind=prc.page,class="textfield width95",maxlength="160")#
					#html.textArea(name="htmlDescription",label="Description: (Max 160 characters)",title="HTML Description (Good for SEO)",bind=prc.page,class="textfield",maxlength="160")#
				</div>
				<!--- Event --->
				#announceInterception("cbadmin_pageEditorSidebarAccordion")#
			</div>
			<!--- end accordion --->

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

			<div class="floatRight">
				<!--- View Page In Site --->
					<button class="button2" onclick="return to('#event.buildLink(prc.xehPages)#/parent/#prc.page.getParentID()#')" title="Back To Page Listing">Back To Listing</button>
				<cfif prc.page.isLoaded()>
					<!--- View Page In Site --->
					<button class="button2" onclick="window.open('#prc.CBHelper.linkPage( prc.page )#');return false;" title="Open page in site">View Page In Site</button>
				</cfif>
			</div>
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
				<cfif prc.page.hasParent()> <small>/#prc.page.getParent().getSlug()#/</small></cfif>
			</label>
			#html.textfield(name="slug",value=listLast(prc.page.getSlug(),"/"),maxlength="100",class="textfield width98",title="The URL permalink for this page")#

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

	<!---Loaded Panels--->
	<cfif prc.page.isLoaded()>
		<!--- Versions --->
		<div class="box">
			<div class="header">
				<img src="#prc.cbroot#/includes/images/clock.png" alt="editor" width="30" height="30" />
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