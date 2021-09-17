<cfoutput>
	<!--- View Arguments --->
	<cfparam name="args.print" 		default="false" />
	<cfparam name="args.sidebar" 	default="true" />

	<!--- If homepage, present homepage jumbotron --->
	<cfif cb.isHomePage()>
	<cfelse>
		<div id="body-header">
			<div class="container-fluid">
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

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_prePageDisplay" )#

	<!--- Body Main --->
	<section id="body-main">
		<div class="container-fluid">

			<!--- Export and Breadcrumbs Symbols --->
			<cfif !args.print AND !isNull( "prc.page" ) AND prc.page.getSlug() neq cb.getHomePage()>
				<!--- Exports --->
				<div class="btn-group pull-right">
					<button type="button" class="btn btn-success btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Export Page...">
						<i class="fa fa-print"></i> <span class="caret"></span>
					</button>

					<ul class="dropdown-menu">
						<li><a href="#cb.linkPage( cb.getCurrentPage() )#.print" target="_blank">Print Format</a></li>

						<li><a href="#cb.linkPage( cb.getCurrentPage() )#.pdf" target="_blank">PDF</a></li>
					</ul>
				</div>

				<!--- BreadCrumbs --->
				<div id="body-breadcrumbs" class="col-sm-12">
					<i class="fa fa-home"></i> #cb.breadCrumbs( separator="<i class='fa fa-angle-right'></i> " )#
				</div>
			</cfif>

			<!--- Determine span length due to sidebar or homepage
			<cfif cb.isHomePage() OR !args.sidebar>
				<cfset variables.span = 12>
			<cfelse>
				<cfset variables.span = 9>
			</cfif> --->

			<div>

				<!--- Render Content --->
				#prc.page.renderContent()#

				<!--- Comments Bar --->
				<cfif cb.isCommentsEnabled( prc.page )>
					<section id="comments">
						#html.anchor( name="comments" )#

						<div class="post-comments">
							<div class="infoBar">
								<p>
									<button class="button2" onclick="toggleCommentForm()"> <i class="icon-comments"></i> Add Comment (#prc.page.getNumberOfApprovedComments()#)</button>
								</p>
							</div>

							<br />
						</div>

						<!--- Separator --->
						<div class="separator"></div>

						<!--- Comment Form: I can build it or I can quick it? --->
						<div id="commentFormShell">
							<div class="row">
								<div class="col-sm-12">
									#cb.quickCommentForm( prc.page )#
								</div>
							</div>
						</div>

						<!--- Clear --->
						<hr />

						<!--- Display Comments --->
						<div id="comments">
							#cb.quickComments()#
						</div>
					</section>
				</cfif>
			</div>
		</div>
	</section>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_postPageDisplay")#
</cfoutput>