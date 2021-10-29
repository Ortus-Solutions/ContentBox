<cfoutput>
	<!--- View Arguments --->
	<cfparam name="args.print" 		default="false" />
	<cfparam name="args.sidebar" 	default="false" />

	<!--- If homepage, present homepage jumbotron --->
	<cfif cb.isHomePage()>
	<cfelse>
		<div id="body-header" class="bg-light bg-darken-xs">
			<div class="container">
				<!--- Title --->
				<div class="py-4 text-center">
					<h1>#prc.page.getTitle()#</h1>
					<!--- Export and Breadcrumbs Symbols --->
					<cfif !args.print AND !isNull( "prc.page" ) AND prc.page.getSlug() neq cb.getHomePage()>
						<!--- Exports 
						<div class="btn-group pull-right">
							<button type="button" class="btn btn-success btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Export Page...">
								<i class="fa fa-print"></i> <span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li><a href="#cb.linkPage( cb.getCurrentPage() )#.print" target="_blank">Print Format</a></li>
								<li><a href="#cb.linkPage( cb.getCurrentPage() )#.pdf" target="_blank">PDF</a></li>
							</ul>
						</div>--->
						<!--- BreadCrumbs --->
						<div id="body-breadcrumbs" class="col-sm-12 text-muted">
							<small>
								<svg xmlns="http://www.w3.org/2000/svg" width="15" viewBox="0 0 20 20" fill="currentColor">
									<path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
							  	</svg> #cb.breadCrumbs( separator=" / " )#
							</small>
						</div>
					</cfif>
				</div>
			</div>
		</div>
	</cfif>

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_prePageDisplay" )#

	<!--- Body Main --->
	<section id="body-main">
		<!--- Determine span length due to sidebar or homepage--->
		<cfif cb.isHomePage() OR !args.sidebar>
			<cfset variables.span = 12>
		<cfelse>
			<cfset variables.span = 9>
		</cfif> 
		<div class="#(variables.span == 9) ? 'container' : '' #">
			<div class="#(variables.span == 9) ? 'row' : '' #">
				<div class="col-sm-#variables.span#">
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
				<!--- Sidebar --->
				<cfif args.sidebar and !cb.isHomePage()>
					<div class="col-sm-3 sidenav">
						#cb.quickView( view='_pagesidebar' )#
					</div>
				</cfif>
			</div>
		</div>
		
	</section>
	<!--- ContentBoxEvent --->
	#cb.event("cbui_postPageDisplay")#
</cfoutput>