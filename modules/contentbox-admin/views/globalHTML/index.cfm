<cfoutput>
#html.startForm(name="globalHTMLForm",action=prc.xehSaveHTML)#		
<div class="main" id="main">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-globe icon-large"></i>
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
				<li class="active"><a href="##global"><i class="icon-globe icon-large"></i> Global Layout</a></li>
				<li><a href="##entry"><i class="icon-quote-left icon-large"></i> Blog Entries</a></li>
				<li><a href="##comments"><i class="icon-comments icon-large"></i> Comments</a></li>
				<li><a href="##pages"><i class="icon-pencil icon-large"></i> Pages</a></li>
			</ul>
			<!--- Documentation Panes --->	
			<div class="main_column">
				<!-- Content area that wil show the form and stuff -->
				<div class="panes_vertical">
					<!--- Global HTML Page --->
					<div>
						<fieldset>
						<legend><i class="icon-globe icon-large"></i> <strong>Global Layout</strong></legend>
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
						<legend><i class="icon-quote-left icon-large"></i> <strong>Blog Entries</strong></legend>
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
						<legend><i class="icon-comments icon-large"></i> <strong>Comments</strong></legend>
							#html.textarea(name="cb_html_preCommentForm",label="Before The Comment Form: ",rows="6",value=prc.cbSettings.cb_html_preCommentForm)#
							#html.textarea(name="cb_html_postCommentForm",label="After The Comment Form: ",rows="6",value=prc.cbSettings.cb_html_postCommentForm)#
						</fieldset>
					</div>
					<!--- Pages --->
					<div>
						<fieldset>
						<legend><i class="icon-pencil icon-large"></i> <strong>Pages</strong></legend>
							#html.textarea(name="cb_html_prePageDisplay",label="Before Any Page: ",rows="6",value=prc.cbSettings.cb_html_prePageDisplay)#
							#html.textarea(name="cb_html_postPageDisplay",label="After Any Page: ",rows="6",value=prc.cbSettings.cb_html_postPageDisplay)#
						</fieldset>						
					</div>
				</div>
				
				<!---Button Bar --->
				<div class="buttonBar">
					#html.submitButton(value="Save Global HTML",class="btn btn-danger",title="Save Global HTML content")#
				</div>
			</div>
		</div>
	</div>
</div>
#html.endForm()#
</cfoutput>