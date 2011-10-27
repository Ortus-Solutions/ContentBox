<cfoutput>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_prePageDisplay")#
	
	<!--- breadcrumbs --->
	<div class="infoBar">> <a href="#cb.linkHome()#">Home</a> #cb.breadCrumbs()#</div>
	
	<!--- top gap --->
	<div class="post-top-gap"></div>
	
	<!--- post --->
	<div class="post" id="post_#prc.page.getPageID()#">
		
		<!--- Title --->
		<div class="post-title">
						
			<!--- Title --->
			<h1>#prc.page.getTitle()#</h1>
			
			<!--- content --->
			#prc.page.getContent()#
		</div>
				
		<!--- Comments Bar --->
		<cfif cb.isCommentsEnabled(prc.page)>
					
			#html.anchor(name="comments")#
			<div class="post-comments">
				<div class="infoBar">
					<button class="button2" onclick="toggleCommentForm()"> Add Comment </button>
					<img src="#cb.layoutRoot()#/includes/images/comments_32.png" alt="comments" /> #prc.page.getNumberOfApprovedComments()#
				</div>
				<br/>										
			</div>
			
			<!--- Separator --->	
			<div class="separator"></div>
			
			<!--- Comment Form: I can build it or I can quick it? --->
			<div id="commentFormShell">
			#cb.quickCommentForm(prc.page)#
			</div>
			
			<!--- clear --->
			<div class="clr"></div>
			
			<!--- Display Comments --->
			<div id="comments">
				#cb.quickComments()#
			</div>
		
		</cfif>
		
	</div>
		
	<!--- ContentBoxEvent --->
	#cb.event("cbui_postPageDisplay")#
	

<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
 	// form validator
	$("##commentForm").validator({position:'top left'});
	<cfif cb.isCommentFormError()>
	toggleCommentForm();
	</cfif>
});
function toggleCommentForm(){
	$("##commentForm").slideToggle();
}
</script>
</cfoutput>