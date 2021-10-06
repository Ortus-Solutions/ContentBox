<cfoutput>
		<div id="post-list" class="col p-4">
			<div class="card shadow-sm border-0 h-100">
				<div class="card-body px-4">
					<div class="card-title py-4">
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
					<div class="card-body">
						<!--- Excerpt or content --->
						<cfif entry.hasExcerpt()>
							#entry.renderExcerpt()#
							<cfelse>
								#entry.renderContent()#
							</cfif>
						<div class="mb-3">
							<a class="btn btn-secondary" href="http://127.0.0.1:8589/blog/disk-queues-77caf">Read entry
								<svg xmlns="http://www.w3.org/2000/svg" width="20" fill="currentColor" viewBox="0 0 24 24" stroke="currentColor">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
								</svg>
							</a>
						</div>	
					</div>
					<div class="card-footer">
						
						<small class="text-muted">
							<div class="col-xs-9 float-left">
								<i class="fa fa-tag"></i> Tags: #cb.quickCategoryLinks( entry )#
							</div>
							<div class="col-xs-3 pull-right text-right">
								<i class="fa fa-comment"></i>
								<a href="#cb.linkEntry( entry )###comments" title="View Comments">
									#entry.getNumberOfApprovedComments()# Comments
								</a>
							</div>
						</small>
					</div>
				</div>
			</div>
		</div>
	
</cfoutput>
