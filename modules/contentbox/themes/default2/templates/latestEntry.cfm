<cfoutput>
	<div id="featuredPost" class="card mb-5 shadow-sm border-0" id="post_#entry.getContentID()#">
		<div class="card-body">
			<div class="row">
				<div class="col-md-8">
					<!--- Title --->
					<div class="card-title ">
						<h2>
							<a
								href="#cb.linkEntry( entry )#"
								rel="bookmark"
								class="link-unstyled"
								title="#entry.getTitle()#"
							>
								#entry.getTitle()#
							</a>
						</h2>
						<!--- Post detail --->
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
					<!--- Content --->
					<div class="card-text">
							<!--- Excerpt or content --->
							<cfif entry.hasExcerpt()>
								#entry.renderExcerpt()#
							<cfelse>
								#entry.renderContent()#
							</cfif>
					</div>
				</div>
				<div class="col-md-4">
					<!--- Featured image --->
					<cfif !isEmpty(entry.getFeaturedImageURL()) >
						<img class="img-fluid m-2 rounded-3" src="#entry.getFeaturedImageURL()#">
						<cfelse>
						<img class="img-fluid m-2 rounded-3" src="#cb.themeRoot()#/includes/images/default-post.jpg">
					</cfif>
				</div>
			</div>
		</div>
		<div class="card-footer">
			<div class="post-more float-end">
				<a href="#cb.linkEntry( entry )#" title="Read The Full Entry!">
					<button class="btn btn-secondary">Read 
						<svg xmlns="http://www.w3.org/2000/svg" width="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
						</svg>
					</button>
				</a>
			</div>
			<small class="text-muted">
				<div class="col-xs-9 float-left">
					<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
					</svg>
					Tags: #cb.quickCategoryLinks( entry )#
				</div>
				<div class="col-xs-3 pull-right text-right">
					<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
					</svg>
					<a href="#cb.linkEntry( entry )###comments" title="View Comments">
						#entry.getNumberOfApprovedComments()# Comments
					</a>
				</div>
			</small>
		</div>
	</div>
</cfoutput>
