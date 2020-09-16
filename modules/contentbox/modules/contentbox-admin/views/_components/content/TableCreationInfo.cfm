<cfoutput>
	<div class="text-muted size12">

		<!--- Authors --->
		<div class="mt10 mb5">
			<a
				href="mailto:#args.content.getCreatorEmail()#"
				class="text-muted"
				title="Created by #args.content.getCreatorName()#"
			>
				#getInstance( "Avatar@cb" ).renderAvatar(
					email	= args.content.getCreatorEmail(),
					size	= "20",
					class	= "img img-circle"
				)#
				<span class="ml5">
					#args.content.getCreatorName()#
				</span>
			</a>

			<cfif args.content.getAuthorEmail() neq args.content.getCreatorEmail()>
			<a
				href="mailto:#args.content.getAuthorEmail()#"
				class="text-muted ml5"
				title="Last edit by #args.content.getAuthorName()#"
			>
				#getInstance( "Avatar@cb" ).renderAvatar(
					email	= args.content.getAuthorEmail(),
					size	= "20",
					class	= "img img-circle"
				)#
				<span class="ml5">
					#args.content.getAuthorName()#
				</span>
			</a>
			</cfif>
		</div>

		<!--- Created Date --->
		<div class="mt10 mb5 ml5">
			<span title="Created Date">
				<i class="fas fa-calendar mr5"></i> #args.content.getDisplayCreatedDate()#
			</span>
		</div>

		<!--- Categories --->
		<div class="mt10 mb5 ml5">
			<div class="text-muted">
				<span title="Categories">
					<i class="fas fa-tags"></i> #args.content.getCategoriesList()#
				</span>
			</div>
		</div>
	</div>
</cfoutput>