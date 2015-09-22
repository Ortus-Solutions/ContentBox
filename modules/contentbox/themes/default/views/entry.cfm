<cfoutput>
<div class="row">
	<div class="col-sm-9">
		<!--- ContentBoxEvent --->
		#cb.event("cbui_preEntryDisplay")#

		<!--- post --->
		<div class="post" id="post_#prc.entry.getContentID()#">

			<!--- Title --->
			<div class="post-title">

				<!--- Title --->
				<h2><a href="#cb.linkEntry(prc.entry)#" rel="bookmark" title="#prc.entry.getTitle()#">#prc.entry.getTitle()#</a></h2>

				<!--- Post detail --->
				<!---<p>Posted by <i class="icon-user"></i> <a href="##">#prc.entry.getAuthorName()#</a>
					on <i class="fa fa-calendar"></i> #prc.entry.getDisplayPublishedDate()#
				 	| <i class="fa fa-comment"></i> <a href="#cb.linkEntry(prc.entry)###comments" title="View Comments"> #prc.entry.getNumberOfApprovedComments()# Comments</a>
					<i class="fa fa-tag"></i> #cb.quickCategoryLinks(prc.entry)#
				</p>--->
				<div class="row">
					<div class="col-sm-7 pull-left"><span class="text-muted">Posted by</span> <i class="icon-user"></i> <a href="##">#prc.entry.getAuthorName()#</a></div>  
					<div class="col-sm-5 pull-right text-right"><i class="fa fa-calendar"></i> #prc.entry.getDisplayPublishedDate()#</div>
				</div>

				<!--- content --->
				<div class="post-content">
					#prc.entry.renderContent()#
				</div>
				
				<div class="row">
					<div class="col-xs-9 pull-left">
						<i class="fa fa-tag"></i> Tags: #cb.quickCategoryLinks(prc.entry)#
					</div>
					<div class="col-xs-3 pull-right text-right">
						<i class="fa fa-comment"></i> <a href="#cb.linkEntry(prc.entry)###comments" title="View Comments"> #prc.entry.getNumberOfApprovedComments()# Comments</a>
					</div>
				</div>
				
			</div>

			<!--- Comments Bar --->
			#html.anchor(name="comments")#
			<div class="post-comments">
				<div class="infoBar">
					<cfif NOT cb.isCommentsEnabled(prc.entry)>
					<i class="icon-warning-sign icon-2x"></i>
					Comments are currently closed
					<cfelse>
						<p>							
							<button class="btn btn-primary" onclick="toggleCommentForm()"><i class="fa fa-comments"></i> Add Comment (#prc.entry.getNumberOfApprovedComments()#)</button>
						</p>
					</cfif>
				</div>
			</div>

			<!--- Separator --->
			<div class="separator"></div>

			<!--- Comment Form: I can build it or I can quick it? --->
			<div id="commentFormShell">
				<div class="row">
					<div class="col-sm-12">
						#cb.quickCommentForm(prc.entry)#
					</div>
				</div>
			</div>

			<div class="clr"></div>

			<!--- Display Comments --->
			<div id="comments">
				<div class="row">	
					<div class="col-sm-9">						
						#cb.quickComments()#
					</div>				
				</div>
			</div>

		</div>

		<!--- ContentBoxEvent --->
		#cb.event("cbui_postEntryDisplay")#

	</div>

	<div class="col-sm-3">
		<div class="well">
			#cb.quickView(view='_blogsidebar')#
		</div>
	</div>
</div>

<!--- Custom JS --->
<script type="text/javascript">
	$(document).ready(function() {
	 	// form validator
		$("##commentForm").validator({position:'top left'});
		<!---<cfif cb.isCommentFormError()>--->
		toggleCommentForm();
		<!---</cfif>--->
	});
	function toggleCommentForm(){
		$("##commentForm").slideToggle();
	}
</script>
</cfoutput>