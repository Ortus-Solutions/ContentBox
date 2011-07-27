<cfoutput>
<div id="quickPost">
	<div id="quickPostContent">
		<!--- Entry Form  --->
		#html.startForm(action=prc.xehQPEntrySave,name="quickPostForm",novalidate="novalidate")#
			<h2>Quick Post</h2>
			<!--- Hidden Fields --->
			#html.hiddenField(name="entryID",value="")#
			#html.hiddenField(name="isPublished",value="true")#
			
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/pen.png" alt="post" width="16"/> Post')#
				<!--- title --->
				#html.textfield(name="title",maxlength="100",required="required",title="The title for this entry",class="textfield width98",
				value="Title Here",onclick="if( this.value='Title Here' ){ this.value = '';}")#
				<!--- content --->
				#html.textarea(name="content",required="required")#
			#html.endFieldSet()#
			
			<!--- Categories --->
			#html.startFieldset(legend='<img src="#prc.bbRoot#/includes/images/category_black.png" alt="category" width="16"/> Categories')#
				<cfloop from="1" to="#arrayLen(prc.qpCategories)#" index="x">
					#html.checkbox(name="category_#x#",value="#prc.qpCategories[x].getCategoryID()#")#
					#html.label(field="category_#x#",content="#prc.qpCategories[x].getCategory()#",class="inline")#
				</cfloop>
				<!--- New Categories --->
				#html.textField(name="newCategories",label="New Categories (Comma delimited)",size="45",title="Comma delimited list of new categories to create",class="textfield")#
			#html.endFieldSet()#
			<!--- Button Bar --->
			<div id="bottomCenteredBar" class="textRight">
				<button class="button" onclick="return closeQuickPost()" title="Change your mind hugh?"> Cancel </button>
				&nbsp;<input type="submit" class="button2" value="Save Draft" onclick="qpSaveDraft()" title="Not ready for primetime!">
				&nbsp;<input type="submit" class="buttonred" value="Publish" title="Yeahaww! Let's Publish It!">
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
	// toolbar config
	var ckToolbar =
	[
	    { name: 'document',    items : [ 'Source'] },
	    { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','-','TextColor','BGColor'] },
	    { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
	    { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
	    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar' ] }
	];
	// Activate ckeditor
	// Activate ckeditor
	$quickEntryContent.ckeditor( function(){}, { toolbar:ckToolbar,height:180 } );
	// form validator
	$quickPostForm.validator({position:'top left'});
});
function qpSaveDraft(){
	$quickPostForm.find("##isPublished").val('false');
}
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