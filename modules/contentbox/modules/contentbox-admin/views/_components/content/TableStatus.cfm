<cfoutput>
	<cfif args.content.isExpired()>
		<span class="text-red" title="Expired #args.content.getDisplayExpireDate()#">
			#cbAdminComponent( "ui/Icon", { name : "ClockWarning" } )#
		</span>
		<span class="hidden">expired</span>
	<cfelseif args.content.isPublishedInFuture()>
		<span class="text-blue" title="Publishes #args.content.getDisplayPublishedDate()#">
			#cbAdminComponent( "ui/Icon", { name : "ClockArrowPath" } )#
		</span>
		<span class="hidden">published in future</span>
	<cfelseif args.content.isContentPublished()>
		<span class="text-green" title="Published #args.content.getDisplayPublishedDate()#">
			#cbAdminComponent( "ui/Icon", { name : "SignalCircle" } )#
		</span>
		<span class="hidden">published</span>
	<cfelse>
		<span class="text-gray" title="Content is in Draft!">
			#cbAdminComponent( "ui/Icon", { name : "ClockDashedHalf" } )#
		</span>
		<span class="hidden">draft</span>
	</cfif>
</cfoutput>