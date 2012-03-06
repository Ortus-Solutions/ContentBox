<cfoutput>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_prePageDisplay")#

	<!--- breadcrumbs only if not home page. --->
	<cfif cb.getCurrentPage().getSlug() NEQ cb.getHomePage() AND cb.getCustomField("breadcrumb",true)>
	<div class="breadcrumbs"><a href="#cb.linkHome()#">Home</a> #cb.breadCrumbs()#</div>
	</cfif>

	<!--- Title --->
	<h2 class="inner">#cb.getCurrentPage().getTitle()#</h2>
	<!--- Render Content --->
	#cb.getCurrentPage().renderContent()#

	<!--- Comments Bar --->
	<cfif cb.isCommentsEnabled(cb.getCurrentPage())>
		<div id="pageComments">
			#html.anchor(name="comments")#
			<!--- Display Comments --->
			<div id="comments">
				#cb.quickComments()#
			</div>

			<div class="clr"></div>

			<!--- Comment Form: I can build it or I can quick it? --->
			<div id="commentFormShell">
				#cb.quickCommentForm(prc.page)#
			</div>

			<div class="clr"></div>
		</div>
	</cfif>


	<!--- ContentBoxEvent --->
	#cb.event("cbui_postPageDisplay")#

</cfoutput>