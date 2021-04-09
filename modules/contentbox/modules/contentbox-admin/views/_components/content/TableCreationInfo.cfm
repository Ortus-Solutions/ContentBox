<cfparam name="args.showDescription" default="false">
<cfoutput>
	<!--- Trigger --->
	<button
		class="btn btn-more btn-sm"
		onclick="toggleMoreInfoPanel( '#args.content.getId()#' ); return false"
		title="Click for More Info"
	>
		<i id="moreInfoOpenButton-#args.content.getId()#" class="fas fa-ellipsis-h"></i>
		<i id="moreInfoCloseButton-#args.content.getId()#" class="far fa-times-circle hidden"></i>
	</button>

	<!--- More Panel --->
	<div
		class="textMuted hidden"
		id="moreInfo-#args.content.getId()#"
	>
		<!--- Authors --->
		<div class="mt10 mb5">
			<a
				href="mailto:#args.content.getCreatorEmail()#"
				class="textMuted"
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

			<span title="Created Date">
				<i class="fas fa-calendar mr5"></i> #args.content.getDisplayCreatedDate()#
			</span>


		</div>

		<!--- Categories --->
		<div class="mt10 mb5 ml5">
			<div class="textMuted">
				<span title="Categories">
					<i class="fas fa-tags"></i> #args.content.getCategoriesList()#
				</span>
			</div>
		</div>

		<!--- Permalink --->
		<div class="mt5">
			<div class="textMuted">
				<span title="Permalink">
					<i class="fas fa-sitemap mr5"></i>
					<span class="label label-success">#args.content.getSlug()#</span>
				</span>
			</div>
		</div>

		<!--- Description --->
		<cfif args.showDescription>
			<div class="mt10 mb5 ml5">
				<div class="textMuted">
					<i class="fas fa-info-circle mr5"></i> #args.content.getDescription()#
				</div>
			</div>
		</cfif>
	</div>
</cfoutput>