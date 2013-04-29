<cfoutput>
#html.startForm(name="globalHTMLForm",action=prc.xehSaveHTML,class="form-vertical")#		
<div class="row-fluid" id="main-content">
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
    		<div class="tabbable tabs-left">
    			
    			<!--- Documentation Navigation Bar --->
    			<ul class="nav nav-tabs">
    				<li class="active"><a href="##global" data-toggle="tab"><i class="icon-globe icon-large"></i> Global Layout</a></li>
    				<li><a href="##entry" data-toggle="tab"><i class="icon-quote-left icon-large"></i> Blog Entries</a></li>
    				<li><a href="##comments" data-toggle="tab"><i class="icon-comments icon-large"></i> Comments</a></li>
    				<li><a href="##pages" data-toggle="tab"><i class="icon-pencil icon-large"></i> Pages</a></li>
    			</ul>
    			<!--- Tab Content --->
    			<div class="tab-content">
    				<!--- Global HTML Page --->
    				<div class="tab-pane active" id="global">
    					<fieldset>
    					<legend><i class="icon-globe icon-large"></i> <strong>Global Layout</strong></legend>
    						#html.textarea(name="cb_html_beforeHeadEnd",label="Before Head End: ",rows="6",value=prc.cbSettings.cb_html_beforeHeadEnd,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_afterBodyStart",label="After Body Start: ",rows="6",value=prc.cbSettings.cb_html_afterBodyStart,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_beforeBodyEnd",label="Before Body End: ",rows="6",value=prc.cbSettings.cb_html_beforeBodyEnd,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_beforeContent",label="Before Any Content: ",rows="6",value=prc.cbSettings.cb_html_beforeContent,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_afterContent",label="After Any Content: ",rows="6",value=prc.cbSettings.cb_html_afterContent,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_beforeSideBar",label="Before SideBar: ",rows="6",value=prc.cbSettings.cb_html_beforeSideBar,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_afterSideBar",label="After SideBar: ",rows="6",value=prc.cbSettings.cb_html_afterSideBar,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_afterFooter",label="After Footer: ",rows="6",value=prc.cbSettings.cb_html_afterFooter,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					</fieldset>
    				</div>
    				<!--- Entry --->
    				<div class="tab-pane" id="entry">
    					<fieldset>
    					<legend><i class="icon-quote-left icon-large"></i> <strong>Blog Entries</strong></legend>
    						#html.textarea(name="cb_html_preEntryDisplay",label="Before A Blog Entry: ",rows="6",value=prc.cbSettings.cb_html_preEntryDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_postEntryDisplay",label="After A Blog Entry: ",rows="6",value=prc.cbSettings.cb_html_postEntryDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_preIndexDisplay",label="Before Blog Index: ",rows="6",value=prc.cbSettings.cb_html_preIndexDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_postIndexDisplay",label="After Blog Index: ",rows="6",value=prc.cbSettings.cb_html_postIndexDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_preArchivesDisplay",label="Before Blog Archives: ",rows="6",value=prc.cbSettings.cb_html_preArchivesDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_postArchivesDisplay",label="After Blog Archives: ",rows="6",value=prc.cbSettings.cb_html_postArchivesDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					</fieldset>
    				</div>
    				<!--- Comments --->
    				<div class="tab-pane" id="comments">
    					<fieldset>
    					<legend><i class="icon-comments icon-large"></i> <strong>Comments</strong></legend>
    						#html.textarea(name="cb_html_preCommentForm",label="Before The Comment Form: ",rows="6",value=prc.cbSettings.cb_html_preCommentForm,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_postCommentForm",label="After The Comment Form: ",rows="6",value=prc.cbSettings.cb_html_postCommentForm,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					</fieldset>
    				</div>
    				<!--- Pages --->
    				<div class="tab-pane" id="pages">
    					<fieldset>
    					<legend><i class="icon-pencil icon-large"></i> <strong>Pages</strong></legend>
    						#html.textarea(name="cb_html_prePageDisplay",label="Before Any Page: ",rows="6",value=prc.cbSettings.cb_html_prePageDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textarea(name="cb_html_postPageDisplay",label="After Any Page: ",rows="6",value=prc.cbSettings.cb_html_postPageDisplay,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    					</fieldset>						
    				</div>
                    <!---Button Bar --->
        			<div class="form-actions">
        				#html.submitButton(value="Save Global HTML",class="btn btn-danger",title="Save Global HTML content")#
        			</div>
    			</div>
                <!---End Tab Content--->
			</div>
            <!---End Vertical Nav--->
    	</div>
        <!---End Body--->
	</div>
</div>
#html.endForm()#
</cfoutput>