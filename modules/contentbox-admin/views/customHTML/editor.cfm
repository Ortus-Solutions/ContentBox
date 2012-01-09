<cfoutput>
#html.startForm(name="contentEditForm",action=prc.xehContentSave,novalidate="novalidate")#
<!--- contentid --->
#html.hiddenField(name="contentID",bind=prc.content)#
	
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Actions
		</div>
		<div class="body">
				
			<!--- Action Bar --->
			<div class="actionBar center">
				<button class="button2" onclick="return to('#event.buildLink(prc.xehCustomHTML)#')">Cancel</button>
				&nbsp;<input type="submit" class="buttonred" value="Save">
			</div>
			
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->

<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/html_32.png" alt="customHTML" width="30" height="30" />
			Custom HTML Editor
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#

			<!--- fields --->
			#html.textField(name="title",label="Title:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="A human friendly name for the content piece")#
			#html.textField(name="slug",label="Slug:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="The slug used to retrieve this content piece")#
			#html.textarea(name="description",label="Short Description:",bind=prc.content,rows=3,class="width98",title="A short description for metadata purposes")#
			
			<!--- content --->
			#html.textarea(name="content",label="Content (HTML,JS,plain,or whatever):",bind=prc.content,required="required")#
		</div>	
	</div>
</div>	

#html.endForm()#

<script type="text/javascript">
$(document).ready(function() {
	$contentEditForm = $("##contentEditForm");
	// form validators
	$contentEditForm.validator({grouped:true,position:'top left'});
	// blur slugify
	var $title = $contentEditForm.find("##title");
	$title.blur(function(){ 
		createPermalink( $title.val() );
	});
	
	activateCustomEditor();
});

function activateCustomEditor(){
	// toolbar config
	var ckToolbar =
	[
	    { name: 'document',    items : [ 'Source'] },
	    { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','-','TextColor','BGColor'] },
	    { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
	    { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
	    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar' ] },
		{ name: 'tools',       items : [ 'Maximize' ] }
	];
	// Activate ckeditor
	$contentEditForm.find("##content").ckeditor( function(){}, { toolbar:ckToolbar, height:250 } );
}
function createPermalink(){
	var slugger = '#event.buildLink(prc.xehSlugify)#';
	$slug = $contentEditForm.find("##slug").fadeOut();
	$.get(slugger,{slug:$contentEditForm.find("##title").val()},function(data){ 
		$slug.fadeIn().val($.trim(data)); 		
	} );
}
</script>
</cfoutput>