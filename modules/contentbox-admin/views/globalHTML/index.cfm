<cfoutput>
#html.startForm(name="globalHTMLForm",action=prc.xehSaveHTML)#		
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<cfif prc.oAuthor.checkPermission("GLOBALHTML_ADMIN")>
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<div class="actionBar">
				#html.submitButton(value="Save Global HTML",class="buttonred",title="Save Global HTML content")#
			</div>
		</div>
		</cfif>
	</div>	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/web.png" alt="globalHTML" />
			Global HTML
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<p>
			The global HTML snippets will be rendered by your theme's layouts at specific points during the HTML page.
			If your layout is not rendering out the content, then it might be that your layout was not implemented correctly.
			Please remember to save your work.
		</p>
		
		<!--- Vertical Nav --->
		<div class="body_vertical_nav clearfix">
			
			<!--- Documentation Navigation Bar --->
			<ul class="vertical_nav">
				<li class="active"><a href="##global"><img src="#prc.cbRoot#/includes/images/world.png" alt="modifiers"/> Global Layout</a></li>
				<li><a href="##entry"><img src="#prc.cbRoot#/includes/images/pen.png" alt="modifiers"/> Blog Entries</a></li>
				<li><a href="##comments"><img src="#prc.cbRoot#/includes/images/comments_black.png" alt="modifiers"/> Comments</a></li>
				<li><a href="##pages"><img src="#prc.cbRoot#/includes/images/page.png" alt="modifiers"/> Pages</a></li>
			</ul>
			<!--- Documentation Panes --->	
			<div class="main_column">
				<!-- Content area that wil show the form and stuff -->
				<div class="panes_vertical">
					<!--- Global HTML Page --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/world.png" alt="modifiers"/> <strong>Global Layout</strong></legend>
							#html.textarea(name="cb_html_beforeHeadEnd",label="Before Head End: ",rows="6",value=prc.cbSettings.cb_html_beforeHeadEnd)#
							#html.textarea(name="cb_html_afterBodyStart",label="After Body Start: ",rows="6",value=prc.cbSettings.cb_html_afterBodyStart)#
							#html.textarea(name="cb_html_beforeBodyEnd",label="Before Body End: ",rows="6",value=prc.cbSettings.cb_html_beforeBodyEnd)#
							#html.textarea(name="cb_html_beforeContent",label="Before Any Content: ",rows="6",value=prc.cbSettings.cb_html_beforeContent)#
							#html.textarea(name="cb_html_afterContent",label="After Any Content: ",rows="6",value=prc.cbSettings.cb_html_afterContent)#
							#html.textarea(name="cb_html_beforeSideBar",label="Before SideBar: ",rows="6",value=prc.cbSettings.cb_html_beforeSideBar)#
							#html.textarea(name="cb_html_afterSideBar",label="After SideBar: ",rows="6",value=prc.cbSettings.cb_html_afterSideBar)#
							#html.textarea(name="cb_html_afterFooter",label="After Footer: ",rows="6",value=prc.cbSettings.cb_html_afterFooter)#
						</fieldset>
					</div>
					<!--- Entry --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/pen.png" alt="modifiers"/> <strong>Blog Entries</strong></legend>
							#html.textarea(name="cb_html_preEntryDisplay",label="Before A Blog Entry: ",rows="6",value=prc.cbSettings.cb_html_preEntryDisplay)#
							#html.textarea(name="cb_html_postEntryDisplay",label="After A Blog Entry: ",rows="6",value=prc.cbSettings.cb_html_postEntryDisplay)#
							#html.textarea(name="cb_html_preIndexDisplay",label="Before Blog Index: ",rows="6",value=prc.cbSettings.cb_html_preIndexDisplay)#
							#html.textarea(name="cb_html_postIndexDisplay",label="After Blog Index: ",rows="6",value=prc.cbSettings.cb_html_postIndexDisplay)#
							#html.textarea(name="cb_html_preArchivesDisplay",label="Before Blog Archives: ",rows="6",value=prc.cbSettings.cb_html_preArchivesDisplay)#
							#html.textarea(name="cb_html_postArchivesDisplay",label="After Blog Archives: ",rows="6",value=prc.cbSettings.cb_html_postArchivesDisplay)#
						</fieldset>
					</div>
					<!--- Comments --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/comments_black.png" alt="modifiers"/> <strong>Comments</strong></legend>
							#html.textarea(name="cb_html_preCommentForm",label="Before The Comment Form: ",rows="6",value=prc.cbSettings.cb_html_preCommentForm)#
							#html.textarea(name="cb_html_postCommentForm",label="After The Comment Form: ",rows="6",value=prc.cbSettings.cb_html_postCommentForm)#
						</fieldset>
					</div>
					<!--- Pages --->
					<div>
						<fieldset>
						<legend><img src="#prc.cbRoot#/includes/images/page.png" alt="modifiers"/> <strong>Pages</strong></legend>
							#html.textarea(name="cb_html_prePageDisplay",label="Before Any Page: ",rows="6",value=prc.cbSettings.cb_html_prePageDisplay)#
							#html.textarea(name="cb_html_postPageDisplay",label="After Any Page: ",rows="6",value=prc.cbSettings.cb_html_postPageDisplay)#
						</fieldset>						
					</div>
				</div>
			</div>
	
		</div>
	</div>
</div>
#html.endForm()#
</cfoutput>