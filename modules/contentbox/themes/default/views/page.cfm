<cfoutput>
	<cfif cb.getCurrentPage().getSlug() EQ cb.getHomePage()>
		<div class="body-header-jumbotron jumbotron #cb.themeSetting('hpHeaderBg')#-bg">
			<div class="container">
				<h1>#cb.themeSetting('hpHeaderTitle')#</h1>
				<p>#cb.themeSetting('hpHeaderText')#</p>
				<p><a class="btn btn-primary btn-lg" href="#cb.themeSetting('hpHeaderLink')#" role="button">Learn more</a></p>
			</div>
		</div>
	<cfelse>
		<div id="body-header" class="shortcodes">
			<div class="container">
				<!--- Title --->
				<div class="underlined-title">
					<h1>#prc.page.getTitle()#</h1>
					<div class="text-divider5">
						<span></span>
					</div>
				</div>
			</div>
		</div>
	</cfif>
	<section id="body-main">
		<div class="container">
			<cfif isdefined("prc.page") and prc.page.getNumberOfChildren()>
				<cfset variables.span = 9>
			<cfelse>
				<cfset variables.span = 12>
			</cfif>
			<div class="col-sm-#variables.span#">
				<!--- ContentBoxEvent --->
				#cb.event("cbui_prePageDisplay")#
				<!--- post --->
				<div class="post" id="post_#prc.page.getContentID()#">
					<!--- Title --->
					<div class="post-title">
						<!--- Render Content --->
						#prc.page.renderContent()#
					</div>

					<!--- Comments Bar --->
					<cfif cb.isCommentsEnabled(prc.page)>

						#html.anchor(name="comments")#
						<div class="post-comments">
							<div class="infoBar">
								<p>
									<button class="button2" onclick="toggleCommentForm()"> <i class="icon-comments"></i> Add Comment (#prc.page.getNumberOfApprovedComments()#)</button>						
								</p>
							</div>
							<br/>
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

						<!--- clear --->
						<div class="clr"></div>

						<!--- Display Comments --->
						<div id="comments">
							#cb.quickComments()#
						</div>

					</cfif>
				</div>
	    	</div>
	    	<cfif isdefined("prc.page") and prc.page.getNumberOfChildren()>
				<div class="col-sm-3 sidenav">
					#cb.quickView(view='_pagesidebar')#
				</div>
			</cfif>
		</div>
	</section>
	<!--- ContentBoxEvent --->
	#cb.event("cbui_postPageDisplay")#

	<!--- Custom JS --->
	<!---<script type="text/javascript">
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
	</script>--->
</cfoutput>