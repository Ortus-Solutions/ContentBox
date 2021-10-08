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

						<div class="col-xs-9 pull-left">
							<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
							</svg>
							Tags: #cb.quickCategoryLinks( prc.entry )#
						</div>
	
						<div class="col-xs-3 pull-right text-right">
							<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
							</svg>
							<a href="#cb.linkEntry( prc.entry )###comments" title="View Comments"> #prc.entry.getNumberOfApprovedComments()# Comments</a>
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
				<div class="col-md-8 offset-md-2 mb-5">
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
								<!--- Featured image --->
								<div class="row">
									<div class="col-md-8 offset-md-2">
										<cfif !isEmpty(entry.getFeaturedImageURL()) >
											<img class="img-fluid m-2 rounded-3" src="#entry.getFeaturedImageURL()#">
											<cfelse>
											<img class="img-fluid m-2 rounded-3" src="#cb.themeRoot()#/includes/images/default-post.jpg">
										</cfif>
									</div>
								</div>
								<div class="mt-4">
									#prc.entry.renderContent()#
								</div>
								
							</div>

						</div>

						<div class="post-comments text-center p-4 m-2">
							<div class="infoBar">
								<cfif NOT cb.isCommentsEnabled( prc.entry )>
									<i class="icon-warning-sign icon-2x"></i>
			
									Comments are currently closed
								<cfelse>
									<p>
										<button class="btn btn-primary" onclick="toggleCommentForm()">
											<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
												<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
											</svg>
											Add Comment (#prc.entry.getNumberOfApprovedComments()#)
										</button>
									</p>
								</cfif>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
		<div class="bg-light bg-darken-xs">
			<div class="container">
				<div class="row">
					<div class="col-md-8 offset-md-2 mb-5">
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
					</div>
				</div>
				
		
				<hr />
		
				<!--- Display Comments --->
				<div id="comments">
					<div class="row">
						<div class="col-md-8 offset-md-2">
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
