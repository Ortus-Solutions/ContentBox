<cfoutput>
	<div id="body-header" class="bg-light bg-darken-xs">
		<div class="container">
			<!--- Title --->
			<div class="py-5 text-center">
				<h1>#prc.entry.getTitle()#</h1>
				<div>
					<small class="text-muted">
						<span>Posted by</span>
						<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
						</svg>
						<a href="##">#entry.getAuthorName()#</a>
						<div>
							<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
							</svg>
							 #entry.getDisplayPublishedDate()#
						</div>
					</small>
				</div>
			</div>
		</div>
	</div>

	<!--- Body Main --->
	<section id="body-main">
		<div class="container">
			<div class="row">
				<div class="<cfif args.sidebar>col-sm-9<cfelse>col-sm-12</cfif> mb-5">
					<!--- ContentBoxEvent --->
					#cb.event( "cbui_preEntryDisplay" )#

					<!--- Export and Breadcrumbs Symbols --->
					<cfif !args.print AND !isNull( "prc.entry" )>
						<!--- Exports 
						<div class="btn-group pull-right">
							<button
								type="button"
								class="btn btn-success btn-sm dropdown-toggle"
								data-toggle="dropdown"
								aria-haspopup="true"
								aria-expanded="false"
								title="Export Page…"
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
						</div>--->
					</cfif>

					<!--- post --->
					<div class="post" id="post_#prc.entry.getContentID()#">

						<!--- Title --->
						<div class="post-title">

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

					</div>
				</div>
			</div>
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
		</div>
		<div class="bg-light bg-darken-xs">
			<div class="container">
				<cfif !args.print>
					<p>&nbsp;</p>
		
					<!--- Comments Bar --->
					#html.anchor(name="comments")#
					<div>
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
					</div>
				</cfif>
		
				<hr />
		
				<!--- Display Comments --->
				<div id="comments">
					<div class="row">
						<div class="col-sm-9">
							#cb.quickComments()#
						</div>
					</div>
				</div>
		
				<!--- ContentBoxEvent --->
				#cb.event( "cbui_postEntryDisplay" )#
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
