<cfoutput>
	<div id="body-header" class="bg-light bg-darken-xs">
		<div class="container">
			<!--- Title --->
			<div class="py-5 text-center">
				<h1>Blog</h1>
			</div>
		</div>
	</div>

	<!--- Body Main --->
	<section id="body-main" class="bg-light bg-darken-xs">
		<div class="container">
			<div class="row">
				<!--- Content --->
				<div class="col-sm-12">

					<!--- ContentBoxEvent --->
					#cb.event( "cbui_preIndexDisplay" )#

					<!--- Are we filtering by category? --->
					<cfif len( rc.category )>
						<p class="infoBar">
							Category Filtering: '#encodeForHTML( rc.category )#'
						</p>

						<p class="buttonBar">
							<a href="#cb.linkBlog()#" class="btn btn-info" title="Remove filter and view all entries">Remove Filter</a>
						</p>

						<br />
					</cfif>

					<!--- Are we searching --->
					<cfif len( rc.q )>
						<p class="buttonBar">
							<a class="btn btn-primary" href="#cb.linkBlog()#" title="Clear search and view all entries">Clear Search</a>
						</p>

						<div class="infoBar">
							Searching by: '#encodeForHTML( rc.q )#'
						</div>

						<br />
					</cfif>
				</div>
			</div>
			<div class="row">
				<!--- Entries displayed here --->
				<div class="col-md-12">
					#cb.quickEntries()#
				</div>
			</div>
			<div>
				<!--- Pagination --->
				<cfif prc.entriesCount>
					<div class="contentBar">
						#cb.quickPaging()#
					</div>
				</cfif>

				<!--- ContentBoxEvent --->
				#cb.event( "cbui_postIndexDisplay" )#
			</div>
		</div>
	</section>
</cfoutput>
