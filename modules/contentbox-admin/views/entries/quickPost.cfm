<cfoutput>
<div id="quickPostModal" class="modal hide fade">
		<!--- Entry Form  --->
		#html.startForm(action=prc.xehQPEntrySave,name="quickPostForm",novalidate="novalidate",class="form-vertical" )#
			<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h3>Quick Post</h3>
            </div>
            <div class="modal-body" id="quickPostContent">
			<!--- Hidden Fields --->
			#html.hiddenField(name="contentID",value="" )#
			#html.hiddenField(name="isPublished",value="true" )#
			
				<!--- title --->
				#html.textfield(name="title", maxlength="100", required="required", title="The title for this entry",class="input-block-level", placeholder="Title Here",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group" )#
				<!--- content --->
				#html.textarea(name="quickcontent",required="required" )#
			
			<!--- Categories --->
			#html.startFieldset(legend='<i class="icon-tags fa-lg"></i> Categories')#
				<div class="controls">
				<cfloop from="1" to="#arrayLen(prc.qpCategories)#" index="x">
					<label class="checkbox inline control-label">
					#html.checkbox(name="category_#x#",value="#prc.qpCategories[ x ].getCategoryID()#" )#
					#prc.qpCategories[ x ].getCategory()#
					</label>
				</cfloop>
				</div>
				<!--- New Categories --->
				#html.textField(name="newCategories",label="New Categories (Comma delimited)", title="Comma delimited list of new categories to create",class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group" )#
			#html.endFieldSet()#
			</div>
			<!--- Button Bar --->
			<div class="modal-footer">
				<div class="btn-group">
    				<button class="btn" onclick="return closeQuickPost()"> Cancel </button>
    				&nbsp;<button type="submit" class="btn" onclick="qpSaveDraft()">Save Draft</button>
    				<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN" )>
    				&nbsp;<button type="submit" class="btn btn-danger">Publish</button>
    				</cfif>
    			</div>
			</div>
		#html.endForm()#
</div>
</cfoutput>