<cfparam name="args.showDescription" default="false">
<cfoutput>
	<!--- Trigger --->
	<button
		class="btn btn-more btn-sm"
		onclick="toggleMoreInfoPanel( '#args.content.getContentId()#' ); return false"
		title="Click for More Info"
	>
		<i id="moreInfoOpenButton-#args.content.getContentId()#" class="fas fa-ellipsis-h"></i>
		<i id="moreInfoCloseButton-#args.content.getContentId()#" class="far fa-times-circle hidden"></i>
	</button>

	<!--- More Panel --->
	<div
		class="text-muted hidden"
		id="moreInfo-#args.content.getContentId()#"
	>
		<!--- Authors --->
		<div class="mt10 mb5">
			<a
				href="mailto:#args.content.getCreatorEmail()#"
				class="text-muted"
				title="Created by #args.content.getCreatorName()#"
			>
				#getInstance( "Avatar@contentbox" ).renderAvatar(
					email	= args.content.getCreatorEmail(),
					size	= "20",
					class	= "img img-circle"
				)#
				<span class="ml5">
					#args.content.getCreatorName()#
				</span>
			</a>
		</div>

		<!--- Created Date --->
		<div
			class="mt10 mb5 ml5"
			title="Created Date"
		>
			<i class="fas fa-calendar mr5"></i> #args.content.getDisplayCreatedDate()#
		</div>

		<!--- Categories --->
		<cfif args.content.hasCategories()>
			<div class="mt10 mb5">
				<div class="text-muted">
					<span title="Categories">
						<i class="fas fa-tags"></i> #args.content.getCategoriesList()#
					</span>
				</div>
			</div>
		</cfif>

		<!--- Slug --->
		<div class="mt5">
			<div class="text-muted">
				<span title="Slug">
					<i class="fas fa-sitemap mr5"></i>
					<span class="label label-success">#args.content.getSlug()#</span>
				</span>
			</div>
		</div>

		<!--- Description --->
		<cfif args.showDescription && len( args.content.getDescription() )>
			<div class="mt10 mb5 ml5">
				<div class="text-muted">
					<i class="fas fa-info-circle mr5"></i> #args.content.getDescription()#
				</div>
			</div>
		</cfif>
	</div>
</cfoutput>