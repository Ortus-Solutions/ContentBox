<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_prePageDisplay")#
	
<!--- SideBar --->
<div id="sidebar">#bb.quickView(view='pagesidebar')#</div>

<!--- content --->
<div id="text" >
	
	<!--- post --->
	<div class="post" id="page_#prc.page.getPageID()#">
		
		<div class="infoBar">> <a href="#bb.linkHome()#">Home</a> #bb.breadCrumbs()#</div>
	
		<!--- Title --->
		<div class="post-title">
						
			<!--- Title --->
			<h1>#prc.page.getTitle()#</h1>
			
			<!--- content --->
			#prc.page.getContent()#
		</div>
				
		<!--- Comments Bar --->
		<cfif bb.isCommentsEnabled(prc.page)>
					
			#html.anchor(name="comments")#
			<div class="post-comments">
				<div class="infoBar">
					<button class="button2" onclick="toggleCommentForm()"> Add Comment </button>
					<img src="#bb.layoutRoot()#/includes/images/comments_32.png" alt="comments" /> #prc.page.getNumberOfApprovedComments()#
				</div>
				<br/>										
			</div>
			
			<!--- Separator --->	
			<div class="separator"></div>
			
			<!--- Comment Form: I can build it or I can quick it? --->
			<div id="commentFormShell">
			#bb.quickCommentForm(prc.page)#
			</div>
			
			<!--- clear --->
			<div class="clr"></div>
			
			<!--- Display Comments --->
			<div id="comments">
				#bb.quickComments()#
			</div>
		
		</cfif>
		
	</div>
		
	<!--- BlogBoxEvent --->
	#bb.event("bbui_postPageDisplay")#
	

<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
 	// form validator
	$("##commentForm").validator({position:'top left'});
	<cfif bb.isCommentFormError()>
	toggleCommentForm();
	</cfif>
});
function toggleCommentForm(){
	$("##commentForm").slideToggle();
}
</script>
</cfoutput>