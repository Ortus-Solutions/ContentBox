<cfoutput>
<h2>Comment Editor</h2>
#html.startForm(name="commentEditForm",action=rc.xehCommentSave)#
	
	#html.hiddenField(name="commentID",bind=rc.comment)#
	
	#html.textField(name="author",label="Author:",bind=rc.comment,required="required",maxlength="100",class="textfield",size="50")#
	#html.textField(name="authorEmail",label="Author Email:",bind=rc.comment,required="required",maxlength="255",class="textfield",size="50")#
	#html.textField(name="authorURL",label="Author URL:",bind=rc.comment,maxlength="255",class="textfield",size="50")#
	
	#html.textarea(name="content",label="Content:",bind=rc.comment,rows=8,required="required")#
	
	<hr/>
	
	<!--- Button Bar --->
	<div id="bottomCenteredBar" class="textRight">
		<button class="button" onclick="return closeRemoteModal()"> Cancel </button>
		&nbsp;<input type="submit" class="buttonred" value="Save">
	</div>
#html.endForm()#

<script type="text/javascript">
$(document).ready(function() {
	// form validators
	$("##commentEditForm").validator({grouped:true});
});
</script>
</cfoutput>