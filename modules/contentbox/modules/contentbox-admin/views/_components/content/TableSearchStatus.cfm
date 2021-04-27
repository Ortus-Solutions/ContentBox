<cfoutput>
	<cfif args.content.getShowInSearch()>
		<i class="far fa-dot-circle fa-lg text-green" title="Searchable!"></i>
	<cfelse>
		<i class="far fa-dot-circle fa-lg text-gray" title="Excluded!"></i>
	</cfif>
</cfoutput>