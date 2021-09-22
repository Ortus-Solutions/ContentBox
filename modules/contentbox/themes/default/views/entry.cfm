<cfoutput>
<cfset bodyHeaderStyle = "">
<cfset bodyHeaderH1Style = "">
<cfif cb.themeSetting( 'overrideHeaderColors' )>
	<cfif len( cb.themeSetting( 'overrideHeaderBGColor' ) )>
		<cfset bodyHeaderStyle = bodyHeaderStyle & 'background-color: ' & cb.themeSetting( 'overrideHeaderBGColor' ) & ';'>
	</cfif>

	<cfif len( cb.themeSetting( 'overrideHeaderTextColor' ) )>
		<cfset bodyHeaderH1Style = bodyHeaderH1Style & 'color: ' & cb.themeSetting( 'overrideHeaderTextColor' ) & ';'>
	</cfif>
</cfif>
<div id="body-header" style="#bodyHeaderStyle#">
	<div class="container">
		<!--- Title --->
		<div class="underlined-title">
			<h1 style="#bodyHeaderH1Style#">#prc.entry.getTitle()#</h1>
		</div>
	</div>
</div>

<!--- Body Main --->
<section id="body-main">
	<div class="container">
		<div class="row">
			<div class="<cfif args.sidebar>col-sm-9<cfelse>col-sm-12</cfif>">
				<!--- ContentBoxEvent --->
				#cb.event( "cbui_preEntryDisplay" )#

				<!--- Export and Breadcrumbs Symbols --->
				<cfif !args.print AND !isNull( "prc.entry" )>
					<!--- Exports --->
					<div class="btn-group pull-right">
						<button
							type="button"
							class="btn btn-success btn-sm dropdown-toggle"
							data-toggle="dropdown"
							aria-haspopup="true"
							aria-expanded="false"
							title="Export Page..."
						>
							<i class="fa fa-print"></i> <span class="caret"></span>
						</button>
						<ul class="dropdown-menu">
							<li>
								<a href="#cb.linkEntry( prc.entry )#.print" target="_blank">Print Format</a>
							</li>
							<li>
								<a href="#cb.linkEntry( prc.entry )#.pdf" target="_blank">PDF</a>
							</li>
						</ul>
					</div>
				</cfif>

				<!--- post --->
				<div class="post" id="post_#prc.entry.getContentID()#">

					<!--- Title --->
					<div class="post-title">

						<!--- Title --->
						<h2>
							<a
								href="#cb.linkEntry( prc.entry )#"
								rel="bookmark"
								title="#prc.entry.getTitle()#"
							>
								#prc.entry.getTitle()#
							</a>
						</h2>

						<!--- Post detail --->
						<!---<p>Posted by <i class="icon-user"></i> <a href="##">#prc.entry.getAuthorName()#</a>
							on <i class="fa fa-calendar"></i> #prc.entry.getDisplayPublishedDate()#
						 	| <i class="fa fa-comment"></i> <a href="#cb.linkEntry( prc.entry )###comments" title="View Comments"> #prc.entry.getNumberOfApprovedComments()# Comments</a>
							<i class="fas fa-tags"></i> #cb.quickCategoryLinks( prc.entry )#
						</p>--->

						<div class="row">
							<div class="col-sm-7 pull-left">
								<span class="text-muted">Posted by</span>
								<i class="fa fa-user"></i>
								<a href="##">#prc.entry.getAuthorName()#</a>
							</div>
							<div class="col-sm-5 pull-right text-right">
								<i class="fa fa-calendar"></i> #prc.entry.getDisplayPublishedDate()#
							</div>
						</div>

						<!--- content --->
						<div class="post-content">
							#prc.entry.renderContent()#
						</div>

						<div class="row">
							<div class="col-xs-9 pull-left">
								<i class="fa fa-tags"></i> Tags: #cb.quickCategoryLinks( prc.entry )#
							</div>
							<div class="col-xs-3 pull-right text-right">
								<i class="fa fa-comment"></i> <a href="#cb.linkEntry( prc.entry )###comments" title="View Comments"> #prc.entry.getNumberOfApprovedComments()# Comments</a>
							</div>
						</div>

					</div>

					<cfif !args.print>

						<p>&nbsp;</p>

						<!--- Comments Bar --->
						#html.anchor(name="comments")#
						<div class="post-comments">
							<div class="infoBar">
								<cfif NOT cb.isCommentsEnabled( prc.entry )>
									<i class="icon-warning-sign icon-2x"></i>
									Comments are currently closed
								<cfelse>
									<p>
										<button class="btn btn-primary" onclick="toggleCommentForm()">
											<i class="fa fa-comments"></i> Add Comment (#prc.entry.getNumberOfApprovedComments()#)
										</button>
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
									#cb.quickCommentForm( prc.entry )#
								</div>
							</div>
						</div>
					</cfif>

					<hr>

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
				#cb.event( "cbui_postEntryDisplay" )#

			</div>

			<cfif args.sidebar>
				<div class="col-sm-3" id="blog-sidenav">
					#cb.quickView( view='_blogsidebar', args=args )#
				</div>
			</cfif>
		</div>
	</div>
</section>

<!--- Custom JS --->
<script type="text/javascript">
	document.addEventListener( "DOMContentLoaded", () => {
		<cfif !cb.isCommentFormError()>
			toggleCommentForm();
		</cfif>
	});
	function toggleCommentForm(){
		$( "##commentForm" ).slideToggle();
	}
</script>
</cfoutput>