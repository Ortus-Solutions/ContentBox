<cfoutput>
<table name="content" id="content" class="table  table-striped-removed table-hover">
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
		<cfloop array="#prc.content#" index="thisContent">
		<tr
			id="contentID-#thisContent.getContentID()#"
			<cfif NOT thisContent.getIsPublished()>class="warning"</cfif>
		>
			<td>
				<!--- Title --->
				<div class="size16">
					#thisContent.getTitle()#
				</div>

				<!--- Title --->
				<div class="mt5">
					<div class="text-muted">
					<cfif structKeyExists( thisContent, "getDescription" )>
						#thisContent.getDescription()#
					<cfelse>
						<cfif thisContent.hasExcerpt()>
							#prc.cbHelper.stripHTML( left( thisContent.getExcerpt(), 100 ) )#
						<cfelse>
							#prc.cbHelper.stripHTML( left( thisContent.getContent(), 100 ) )#
						</cfif>
						...
					</cfif>
					</div>
				</div>
			</td>

			<td class="text-center">
				#renderView(
					view : "_components/content/TableStatus",
					args : { content : thisContent },
					prepostExempt : true
				)#
			</td>

			<td class="text-center">
				<button
					class="btn btn-more btn-sm"
					onclick="return selectCBContent(
						'#JSStringFormat( thisContent.getSlug() )#',
						'#JSStringFormat( thisContent.getTitle() )#',
						'#thisContent.getContentType().lcase()#ssl'
					)"
					title="SSL Link">
					<i class="fas fa-key"></i>
				</button>
				<button
					class="btn btn-more btn-sm"
					onclick="return selectCBContent(
						'#JSStringFormat( thisContent.getSlug() )#',
						'#JSStringFormat( thisContent.getTitle() )#',
						'#thisContent.getContentType().lcase()#'
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
#prc.oPaging.renderit(
	foundRows : prc.contentCount,
	link      : prc.pagingLink,
	asList    : true
)#
</cfoutput>