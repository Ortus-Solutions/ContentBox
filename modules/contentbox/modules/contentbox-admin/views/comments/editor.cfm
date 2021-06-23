<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4><i class="far fa-comments"></i> Comment Editor</h4>
        </div>
        #html.startForm( name="commentEditForm",action=prc.xehCommentsave,class="form-vertical" )#
            <div class="modal-body">
            	<!--- commentid --->
				#html.hiddenField(name="commentID",bind=rc.comment)#

            	<!--- fields --->
            	#html.textField(
                    name="author",
                    label="Author:",
                    bind=rc.comment,
                    required="required",
                    maxlength="100",
                    class="form-control",
                    size="50",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=form-group"
				)#

            	#html.textField(
                    name="authorEmail",
                    label="Author Email:",
                    bind=rc.comment,
                    required="required",
                    maxlength="255",
                    class="email form-control",
                    size="50",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=form-group"
				)#

            	#html.textField(
                    name="authorURL",
                    label="Author URL:",
                    bind=rc.comment,
                    maxlength="255",
                    class="form-control",
                    size="50",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=form-group"
				)#

            	#html.textarea(
                    name="content",
                    label="Content:",
                    bind=rc.comment,
                    rows=8,
                    required="required",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    class="form-control",
                    groupWrapper="div class=form-group"
                )#
			</div>

            <!--- Button Bar --->
            <div class="modal-footer">
                <button class="btn btn-default" onclick="closeRemoteModal();return false;" title="Close Modal"> Close </button>
                <button type="submit" class="btn btn-success">Save</button>
            </div>
        #html.endForm()#
    </div>
</div>
</cfoutput>