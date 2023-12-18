<cfoutput>
	<cfif args.content.getShowInSearch()>
		<i class="fa fa-dot-circle fa-lg text-green" title="Searchable!"></i>
	<cfelse>
		<i class="fa fa-dot-circle fa-lg text-gray" title="Excluded!"></i>
	</cfif>
</cfoutput>