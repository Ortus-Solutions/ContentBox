<cfoutput>
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_prePageDisplay" )#

	<section id="body-main">

		<!--- search Results --->
		<div class="container">
			<h2>Search Results</h2>

			<!--- Search Results --->
			#cb.getSearchResultsContent()#

			<!--- Search paging --->
			#cb.quickSearchPaging()#
		</div>

	</section>

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_postPageDisplay" )#
</cfoutput>