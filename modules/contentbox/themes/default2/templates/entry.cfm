<cfoutput>
	<!--- Post --->
	<div class="post" id="post_#entry.getContentID()#">
		<div class="post-title">
			<!--- Title --->
			<h2>
				<a
					href="#cb.linkEntry( entry )#"
					rel="bookmark"
					title="#entry.getTitle()#"
				>
					#entry.getTitle()#
				</a>
			</h2>

			<!--- Post detail --->
			<div class="row">
				<div class="col-sm-7 pull-left">
					<span class="text-muted">Posted by</span>

					<i class="icon-user"></i>

					<a href="##">#entry.getAuthorName()#</a>
				</div>

				<div class="col-sm-5 pull-right text-right">
					<i class="fa fa-calendar"></i> #entry.getDisplayPublishedDate()#
				</div>
			</div>

			<!--- Content --->
			<div class="post-content">
				<!--- Excerpt or content --->
				<cfif entry.hasExcerpt()>
					#entry.renderExcerpt()#

					<div class="post-more">
						<a href="#cb.linkEntry( entry )#" title="Read The Full Entry!">
							<button class="btn btn-success">Read More...</button>
						</a>
					</div>
				<cfelse>
					#entry.renderContent()#
				</cfif>
			</div>

			<div class="row">
				<div class="col-xs-9 pull-left">
					<i class="fa fa-tag"></i> Tags: #cb.quickCategoryLinks( entry )#
				</div>

				<div class="col-xs-3 pull-right text-right">
					<i class="fa fa-comment"></i>

					<a href="#cb.linkEntry( entry )###comments" title="View Comments">
						#entry.getNumberOfApprovedComments()# Comments
					</a>
				</div>
			</div>
		</div>
	</div>
</cfoutput>
