<cfoutput>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_prePageDisplay")#
	
	<!--- breadcrumbs only if not home page. --->
	<cfif cb.getCurrentPage().getSlug() NEQ cb.getHomePage() AND cb.getCustomField("breadcrumb",true)>
	<div class="infoBar">> <a href="#cb.linkHome()#">Home</a> #cb.breadCrumbs()#</div>
	</cfif>
	
	<!--- top gap --->
	<div class="post-top-gap"></div>
	
	<!--- post --->
	<div class="post" id="post_#cb.getCurrentPage().getContentID()#">
		
		<!--- Title --->
		<div class="post-title">
						
			<!--- Title --->
			<h1>#cb.getCurrentPage().getTitle()#</h1>
			
			<!--- Render Content --->
			#cb.getCurrentPage().renderContent()#
		</div>
				
		<!--- Comments Bar --->
		<cfif cb.isCommentsEnabled(cb.getCurrentPage())>
					
			#html.anchor(name="comments")#
			<div class="post-comments">
				<div class="infoBar">
					<button class="button2" onclick="toggleCommentForm()"> Add Comment </button>
					<img src="#cb.layoutRoot()#/includes/images/comments_32.png" alt="comments" /> #cb.getCurrentPage().getNumberOfApprovedComments()#
				</div>
				<br/>										
			</div>
			
			<!--- Separator --->	
			<div class="separator"></div>
			
			<!--- Comment Form: I can build it or I can quick it? --->
			<div id="commentFormShell">
			#cb.quickCommentForm(cb.getCurrentPage())#
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
	
<!--- Custom JS For Comments--->
<cfif cb.isCommentsEnabled()>
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
</cfif>
</cfoutput>