<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Comment Editor</h3>
</div>
#html.startForm(name="commentEditForm",action=prc.xehCommentsave)#
<div class="modal-body">
	<!--- commentid --->
	#html.hiddenField(name="commentID",bind=rc.comment)#
	<!--- fields --->
	#html.textField(name="author",label="Author:",bind=rc.comment,required="required",maxlength="100",class="textfield",size="50")#
	#html.textField(name="authorEmail",label="Author Email:",bind=rc.comment,required="required",maxlength="255",class="textfield",size="50")#
	#html.textField(name="authorURL",label="Author URL:",bind=rc.comment,maxlength="255",class="textfield",size="50")#
	<!--- content --->
	#html.textarea(name="content",label="Content:",bind=rc.comment,rows=8,required="required")#   
</div>
<!--- Button Bar --->
<div class="modal-footer">
    <button class="btn" onclick="closeRemoteModal();return false;" title="Close Modal"> Close </button>
    <button type="submit" class="btn btn-danger">Save</button>
</div>
#html.endForm()#   
</cfoutput>