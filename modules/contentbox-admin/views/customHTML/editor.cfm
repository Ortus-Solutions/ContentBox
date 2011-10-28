<cfoutput>
<h2>Content Editor</h2>
#html.startForm(name="contentEditForm",action=rc.xehContentSave,novalidate="novalidate")#
	<!--- contentid --->
	#html.hiddenField(name="contentID",bind=rc.content)#
	<!--- fields --->
	#html.textField(name="title",label="Title:",bind=rc.content,required="required",maxlength="200",class="textfield",size="50")#
	#html.textField(name="slug",label="Slug:",bind=rc.content,required="required",maxlength="200",class="textfield",size="50")#
	#html.textarea(name="description",label="Short Description:",bind=rc.content,rows=2)#
	
	<!--- content --->
	#html.textarea(name="content",label="Content (HTML,JS,plain,or whatever):",bind=rc.content,rows=15,required="required")#
	
	<hr/>
	
	<!--- Button Bar --->
	<div id="bottomCenteredBar" class="textRight">
		<button class="button" onclick="closeRemoteModal();return false;" title="Close Modal"> Cancel </button>
		&nbsp;
		<input type="submit" class="buttonred" value="Save" title="Save Content">
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
});
function createPermalink(){
	var slugger = '#event.buildLink(rc.xehSlugify)#';
	$slug = $contentEditForm.find("##slug").fadeOut();
	$.get(slugger,{slug:$contentEditForm.find("##title").val()},function(data){ 
		$slug.fadeIn().val($.trim(data)); 		
	} );
}
</script>
</cfoutput>