<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_preEntryDisplay")#

<!--- SideBar --->
<div id="sidebar">#cb.quickView(view='_sidebar')#</div>

<!--- content --->
<div id="text" >
	
	<!--- entry goes here --->
	#cb.quickEntry(args={addComments=true})#
	
	<!--- Comment Form: I can build it or I can quick it? --->
	<div id="commentFormShell">
	#cb.quickCommentForm(prc.entry)#
	</div>
	
	<!--- Separator --->
	<div class="clr"></div>
	
	<!--- Display Comments --->
	<div id="comments">
		#cb.quickComments()#
	</div>
	
</div> 

<!--- ContentBoxEvent --->
#cb.event("cbui_postEntryDisplay")#

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