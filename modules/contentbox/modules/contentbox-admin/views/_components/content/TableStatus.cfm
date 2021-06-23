<cfoutput>
	<cfif args.content.isExpired()>
		<i
			class="fas fa-history fa-lg text-red"
			title="Expired #args.content.getDisplayExpireDate()#"
		></i>
		<span class="hidden">expired</span>
	<cfelseif args.content.isPublishedInFuture()>
		<i
			class="fa fa-space-shuttle fa-lg text-blue"
			title="Publishes #args.content.getDisplayPublishedDate()#"
		></i>
		<span class="hidden">published in future</span>
	<cfelseif args.content.isContentPublished()>
		<i
			class="fas fa-satellite-dish fa-lg text-green"
			title="Published #args.content.getDisplayPublishedDate()#"
		></i>
		<span class="hidden">published</span>
	<cfelse>
		<i
			class="far fa-dot-circle fa-lg text-gray"
			title="Content is in Draft!"
		></i>
		<span class="hidden">draft</span>
	</cfif>
</cfoutput>