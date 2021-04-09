<cfoutput>
<!--- content --->
<table name="content" id="content" class="table table-striped-removed table-hover">
	<thead>
		<tr>
			<th>
				Title
			</th>
			<th width="60" class="text-center">
				Status
			</th>
			<th width="60" class="text-center">
				Insert
			</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.content#" index="entry">
		<tr
			id="contentID-#entry.getId()#"
			<cfif NOT entry.getIsPublished()>class="warning"</cfif>
			ondblclick="return insertContent( '#entry.getSlug()#' )"
			title="Double click to insert"
		>
			<td>
				<!--- Title --->
				<div class="size16">
					#entry.getTitle()#
				</div>

				<!--- Title --->
				<div class="mt5">
					<div class="textMuted">
					<cfif entry.getContentType() eq "contentStore">
						#entry.getDescription()#
					<cfelse>
						<cfif entry.hasExcerpt()>
							#prc.cbHelper.stripHTML( left( entry.getExcerpt(), 100 ) )#
						<cfelse>
							#prc.cbHelper.stripHTML( left( entry.getContent(), 100 ) )#
						</cfif>
						...
					</cfif>
					</div>
				</div>
			</td>

			<td class="text-center">
				#renderView(
					view : "_components/content/TableStatus",
					args : { content : entry },
					prepostExempt : true
				)#
			</td>

			<td class="text-center">
				<button
					class="btn btn-sm btn-more"
					onclick="return insertContent( '#entry.getSlug()#' )"
					title="Insert"
				>
					<i class="far fa-check-circle fa-lg"></i>
				</button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.oPaging.renderit(
	foundRows = prc.contentCount,
	link      = prc.pagingLink,
	asList    = true
)#
</cfoutput>