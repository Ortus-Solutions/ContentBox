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
				<cfif len( prc.entries )>
					<cfset counter = 0 />
					<cfset counterEntries = 0 />
					<cfset totalEntries = ArrayLen( prc.entries ) />

					<!--- Pagination --->
					<cfif prc.entriesCount>
						<div class="contentBar">
							#cb.quickPaging()#
						</div>
					</cfif>

					<cfloop array="#prc.entries#" item="entry" index="x">
						<cfset template = "entry" />
						<cfset counter = counter + 1 />
						<cfset counterEntries = counterEntries + 1 />

						<cfif x eq 1 && len( prc.entries ) gt 1 && rc.page eq 1 && len( rc.q ) eq 0 && len( rc.category ) eq 0>
							<cfset template = "latestEntry" />
							<cfset counter = 0 />
						</cfif>
						
						<cfif counter eq 1 >
							<div class='row row-cols-1 row-cols-md-3 g-4'>
						</cfif>
						
						#cb.quickView(
							view = "../templates/#template#",
							collection = [ entry ],
							collectionAs = "entry"
						)#

						<cfif counter eq 3 || counterEntries eq totalEntries>
							</div>
							
							<cfset counter = 0 />
						</cfif>
						
					</cfloop>
				<cfelse>
					<div class="container">
						No Results Found
					</div>
				</cfif>	
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
