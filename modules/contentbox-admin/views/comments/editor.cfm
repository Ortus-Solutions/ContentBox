<cfoutput>
<h2>Comment Editor</h2>
#html.startForm(name="commentEditForm",action=prc.xehCommentsave)#
	<!--- commentid --->
	#html.hiddenField(name="commentID",bind=rc.comment)#
	<!--- fields --->
	#html.textField(name="author",label="Author:",bind=rc.comment,required="required",maxlength="100",class="textfield",size="50")#
	#html.textField(name="authorEmail",label="Author Email:",bind=rc.comment,required="required",maxlength="255",class="textfield",size="50")#
	#html.textField(name="authorURL",label="Author URL:",bind=rc.comment,maxlength="255",class="textfield",size="50")#
	<!--- content --->
	#html.textarea(name="content",label="Content:",bind=rc.comment,rows=8,required="required")#
	
	<hr/>
	
	<!--- Button Bar --->
	<div id="bottomCenteredBar" class="textRight">
		<button class="button" onclick="closeRemoteModal();return false;" title="Close Modal"> Close </button>
		&nbsp;<input type="submit" class="buttonred" value="Save" title="Save Comment">
	</div>
#html.endForm()#
</cfoutput>