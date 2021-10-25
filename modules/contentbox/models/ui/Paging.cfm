<cfoutput>
<div class="row pagingrow">
	<div class="col-xs-12">
		<cfset start = ( ( currentPage*maxRows ) - maxRows ) + 1 />
		<cfset end = currentPage*maxRows GT foundRows ? foundRows : currentPage*maxRows />
		<div class="dataTables_info" role="alert" aria-live="polite" aria-relevant="all">
			Showing #start# to #end# of #arguments.FoundRows# entries (#totalPages# pages)
		</div>
	</div>

	<div class="col-xs-12">

			<cfif arguments.asList><ul class="pagination my-3"></cfif>

			<!--- PREVIOUS PAGE --->
			<cfif currentPage-1 gt 0>
				<cfif arguments.asList><li class=" previous" tabindex="0" id="pages_previous"></cfif>
				<a class="btn mx-2 btn-link mx-1" href="#replace(theLink,"@page@",currentPage-1)#" title="Previous Page">
					<svg xmlns="http://www.w3.org/2000/svg" width="14" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
					</svg>
				</a>
				<cfif arguments.asList></li></cfif>
			</cfif>

			<!--- Calcualte PageFrom Carrousel --->
			<cfset pageFrom=1 />

			<cfif (currentPage-bandGap) gt 1>
				<cfset pageFrom=currentPage-bandgap>
				<cfif arguments.asList><li tabindex="0"></cfif>
				<a href="#replace(theLink,"@page@",1)#">1</a>
				<a href="javascript:void(0)">…</a>
				<cfif arguments.asList></li></cfif>
			</cfif>

			<!--- Page TO of Carrousel --->
			<cfset pageTo=currentPage+bandgap />

			<cfif (currentPage+bandgap) gt totalPages>
				<cfset pageTo=totalPages />
			</cfif>

			<cfloop index="pageIndex" from="#pageFrom#" to="#pageTo#">
				<cfif arguments.asList><li class="<cfif currentPage eq pageIndex>active"</cfif>" tabindex="0"></cfif>
				<a href="#replace(theLink,"@page@",pageIndex)#"
					<cfif currentPage eq pageIndex>class="selected active btn btn-secondary mx-1"</cfif>>#pageIndex#</a>
				<cfif arguments.asList></li></cfif>
			</cfloop>

			<!--- End Token --->
			<cfif (currentPage+bandgap) lt totalPages>
				<cfif arguments.asList><li tabindex="0"></cfif>
				<a href="javascript:void(0)">…</a>
				<a href="#replace(theLink,"@page@",totalPages)#" class="btn-link mx-1">#totalPages#</a>
				<cfif arguments.asList></li></cfif>
			</cfif>

			<!--- NEXT PAGE --->
			<cfif currentPage lt totalPages>
				<cfif arguments.asList><li class="next" tabindex="0" id="pages_next"></cfif>
				<a class="btn mx-2 btn-link mx-1" href="#replace(theLink,"@page@",currentPage+1)#" title="Next Page"> <svg xmlns="http://www.w3.org/2000/svg" width="14" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
				  </svg> </a>
				<cfif arguments.asList></li></cfif>
			</cfif>

			<cfif arguments.asList></ul></cfif>
		</div>
	</div>
</cfoutput>