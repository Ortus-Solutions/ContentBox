<cfoutput>
<!--- entries --->
<table name="entries" id="entries" class="table  table-striped-removed table-hover">
	<thead>
		<tr>
			<th>
				Title
			</th>
			<th width="60" class="text-center">
				Status
			</th>
			<th width="100" class="text-center">
				Insert
			</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.entries#" index="entry">
		<tr
			id="contentID-#entry.getContentID()#"
			<cfif NOT entry.getIsPublished()>class="warning"</cfif>
		>
			<td>
				<!--- Title --->
				<div class="size16">
					#entry.getTitle()#
				</div>

				<br>
				<!--- Title --->
				<div class="mt5">
					<div class="text-muted">
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
					class="btn btn-more btn-sm"
					onclick="return selectCBContent(
						'#JSStringFormat( entry.getSlug() )#',
						'#JSStringFormat( entry.getTitle() )#',
						'#entry.getContentType().lcase()#ssl'
					)"
					title="SSL Link">
					<i class="fas fa-key"></i>
				</button>
				<button
					class="btn btn-more btn-sm"
					onclick="return selectCBContent(
						'#JSStringFormat( entry.getSlug() )#',
						'#JSStringFormat( entry.getTitle() )#',
						'#entry.getContentType().lcase()#'
					)"
					title="Link">
					<i class="fa fa-link"></i>
				</button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.oPaging.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
</cfoutput>