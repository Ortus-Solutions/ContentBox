<cfoutput>
	<cfif args.content.getShowInSearch()>
		<i class="far fa-dot-circle fa-lg textGreen" title="Searchable!"></i>
	<cfelse>
		<i class="far fa-dot-circle fa-lg textGray" title="Excluded!"></i>
	</cfif>
</cfoutput>