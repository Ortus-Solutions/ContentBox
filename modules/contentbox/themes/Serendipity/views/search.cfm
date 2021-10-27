<cfoutput>
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_prePageDisplay" )#

	<section id="body-main" class="bg-light bg-darken-xs">

		<!--- search Results --->
		<div class="container">
			<div class="py-4 text-center">
				<h2>Search Results</h2>
				<!---<cfif !isNull( "prc.page" ) AND prc.page.getSlug() neq cb.getHomePage()>
					 BreadCrumbs 
					<div id="body-breadcrumbs" class="col-sm-12 text-muted">
						<small>
							<svg xmlns="http://www.w3.org/2000/svg" width="15" viewBox="0 0 20 20" fill="currentColor">
								<path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
							  </svg> #cb.breadCrumbs( separator=" / " )#
						</small>
					</div>
				</cfif>--->
			</div>
			
			<!--- Search Results --->
			#cb.getSearchResultsContent()#

			<!--- Search paging --->
			#cb.quickSearchPaging()#
		</div>

	</section>

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_postPageDisplay" )#
</cfoutput>