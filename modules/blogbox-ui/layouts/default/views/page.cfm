<cfoutput>
<!--- Main Content Goes Here --->
<div class="left">
	<!--- BlogBoxEvent --->
	#bb.event("bbui_prePageDisplay")#
	
	<!--- top gap --->
	<div class="post-top-gap"></div>
	
	<!--- post --->
	<div class="post" id="post_#prc.page.getPageID()#">
		
		<!--- Title --->
		<div class="post-title">
			
			<!--- content Author --->
			<div class="post-content-author">
				#bb.quickAvatar(author=prc.page.getAuthor(),size=30)# #prc.page.getAuthorName()#
			</div>
			
			<!--- Title --->
			<h1><a href="#bb.linkPage(prc.page)#" rel="bookmark" title="#prc.page.getTitle()#">#prc.page.getTitle()#</a></h1>
			
			<!--- content --->
			<div class="post-content">
				#prc.page.getContent()#
			</div>
		</div>
				
		<!--- Comments Bar --->
		#html.anchor(name="comments")#
		<div class="post-comments">
			<div class="infoBar">
				<cfif NOT bb.isCommentsEnabled(prc.page)>
				<img src="#bb.layoutRoot()#/includes/images/important.png" alt="warning" />
				Comments are currently closed
				<cfelse>
				<button class="button2" onclick="toggleCommentForm()"> Add Comment </button>
				<img src="#bb.layoutRoot()#/includes/images/comments_32.png" alt="comments" /> #prc.page.getNumberOfApprovedComments()#
				</cfif>
			</div>
			<br/>										
		</div>
		
		<!--- Separator --->	
		<div class="separator"></div>
		
		<!--- Comment Form: I can build it or I can quick it? --->
		<div id="commentFormShell">
		#bb.quickCommentForm(prc.page)#
		</div>
		
		<div class="clr"></div>
		
		<!--- Display Comments --->
		<div id="comments">
			#bb.quickComments()#
		</div>
		
	</div>
		
	<!--- BlogBoxEvent --->
	#bb.event("bbui_postPageDisplay")#
	
</div> 



<!--- SideBar: That's right, I can render any layout views by using quickView() or coldbo'x render methods --->
<div class="right">#bb.quickView(view='sidebar')#</div> 	

<!--- Separator --->
<div class="clr"></div>

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