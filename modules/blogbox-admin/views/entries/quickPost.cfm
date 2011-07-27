<cfoutput>
<div id="quickPost">
	<div id="quickPostContent">
		<!--- Entry Form  --->
		#html.startForm(action=prc.xehQPEntrySave,name="quickPostForm",novalidate="novalidate")#
			<h2>Quick Post</h2>
			<!--- published Date --->
			#html.hiddenField(name="entryID",value="")#
			
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/pen.png" alt="post" width="16"/> Post')#
				<!--- title --->
				#html.textfield(label="Title:",name="title",maxlength="100",required="required",title="The title for this entry",class="textfield width98")#
				<!--- content --->
				#html.textarea(label="Content:",name="content",required="required")#
			#html.endFieldSet()#
			
			<!--- Categories --->
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/category_black.png" alt="category" width="16"/> Categories')#
				<cfloop from="1" to="#arrayLen(prc.qpCategories)#" index="x">
					#html.checkbox(name="category_#x#",value="#prc.qpCategories[x].getCategoryID()#")#
					#html.label(field="category_#x#",content="#prc.qpCategories[x].getCategory()#",class="inline")#
				</cfloop>
			#html.endFieldSet()#
			<!--- Button Bar --->
			<div id="bottomCenteredBar" class="textRight">
				<button class="buttonred" onclick="return closeQuickPost()"> Close </button>
				&nbsp;<input type="submit" class="buttonred" value="Save">
			</div>
		#html.endForm()#
	</div>
</div>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
 	// pointers
	$quickPost 			= $("##quickPost");
	$quickPostForm 		= $("##quickPostForm");
	$quickEntryContent 	= $quickPostForm.find("##content");
	// Activate ckeditor
	$quickEntryContent.ckeditor( function(){}, { toolbar:'Basic',height:130 } );
	// form validator
	$quickPostForm.validator({position:'top left'});
});
function showQuickPost(){
	$quickPost.overlay({
			mask: {
			color: '##fff',
			loadSpeed: 200,
			opacity: 0.6
		},
		closeOnClick : false,
		onClose: function(){ closeQuickPost(); }
	});
	// load it
	$quickPost.data("overlay").load();
}
function closeQuickPost(){
	$quickPost.data("overlay").close();
	$(".error").hide();
	return false;
}
</script>
</cfoutput>