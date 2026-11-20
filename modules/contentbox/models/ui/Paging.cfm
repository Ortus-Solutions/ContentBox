<cfoutput>
	<div class="row pagingrow">
<div class="col-xs-12">
	<cfset start = ( ( currentPage * maxRows ) - maxRows ) + 1>
	<cfset end = currentPage * maxRows GT foundRows ? foundRows : currentPage * maxRows>
	<div class="dataTables_info" role="alert" aria-live="polite" aria-relevant="all">Showing #start# to #end# of #arguments.FoundRows# entries (#totalPages# pages)
	</div>
</div>
<div class="col-xs-12">

	<cfif arguments.asList>
		<ul class="pagination">
	</cfif>
	<cfif currentPage - 1 GT 0>
		<cfif arguments.asList>
			<li class=" previous"  tabindex="0" id="pages_previous">
		</cfif>
		
		
		
		
		
				<a href="#replace(
	theLink,
	"@page@",
	currentPage - 1
)#" title="Previous Page">&lt;&lt;</a>





		<cfif arguments.asList>
			</li>
		</cfif>
	</cfif>
	<cfset pageFrom = 1>
	<cfif ( currentPage - bandGap ) GT 1>
		<cfset pageFrom = currentPage - bandgap>
		<cfif arguments.asList>
			<li class=""  tabindex="0">
		</cfif>
		
		
		
		
		
				<a href="#replace(
	theLink,
	"@page@",
	1
)#">1</a>
				<a href="javascript:void(0)">...</a>





		<cfif arguments.asList>
			</li>
		</cfif>
	</cfif>
	<cfset pageTo = currentPage + bandgap>
	<cfif ( currentPage + bandgap ) GT totalPages>
		<cfset pageTo = totalPages>
	</cfif>
	<cfloop index="pageIndex" from="#pageFrom#" to="#pageTo#">
		<cfif arguments.asList>
			<li class="
			<cfif currentPage EQ pageIndex>
				active"
			</cfif>
			
			
			
			
			"  tabindex="0">




		</cfif>
		
		
		
		
		
				<a href="#replace(
	theLink,
	"@page@",
	pageIndex
)#"





		<cfif currentPage EQ pageIndex>
			class="selected active"
		</cfif>
		
		
		
		
		>#pageIndex#</a>





		<cfif arguments.asList>
			</li>
		</cfif>
	</cfloop>
	<cfif ( currentPage + bandgap ) LT totalPages>
		<cfif arguments.asList>
			<li  tabindex="0">
		</cfif>
		
		
		
		
		
				<a href="javascript:void(0)">...</a>
				<a href="#replace(
	theLink,
	"@page@",
	totalPages
)#">#totalPages#</a>





		<cfif arguments.asList>
			</li>
		</cfif>
	</cfif>
	<cfif currentPage LT totalPages>
		<cfif arguments.asList>
			<li class="next"  tabindex="0" id="pages_next">
		</cfif>
		
		
		
		
		
				<a href="#replace(
	theLink,
	"@page@",
	currentPage + 1
)#" title="Next Page">&gt;&gt;</a>





		<cfif arguments.asList>
			</li>
		</cfif>
	</cfif>
	<cfif arguments.asList>
		</ul>
	</cfif>
	
	
	
	
	
		</div>
	</div>





</cfoutput>