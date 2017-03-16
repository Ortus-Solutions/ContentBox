<cfoutput>
<!--- entries --->
<table name="entries" id="entries" class="table table-condensed table-striped table-hover" width="100%">
	<thead>
		<tr>
			<th>Entry Title</th>
			<th width="40" class="text-center"><i class="fa fa-globe fa-lg"></i></th>
			<th width="120" class="text-center">Select</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.entries#" index="entry">
		<tr id="contentID-#entry.getContentID()#" <cfif NOT entry.getIsPublished()>class="warning"</cfif>>
			<td>
				<!--- Title --->
				<strong>#entry.getTitle()#</strong>
				<br>
				<span class="label label-primary">Published: #entry.getDisplayPublishedDate()#</label>
			</td>
			<td class="text-center">
				<cfif entry.getIsPublished()>
					<i class="fa fa-check fa-lg textGreen"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="fa fa-times fa-lg textRed"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="text-center">
				<button class="btn" onclick="return selectCBContent( '#JSStringFormat( entry.getSlug() )#', '#JSStringFormat( entry.getTitle() )#', 'entryssl' )" title="SSL Link"><i class="fa fa-lock"></i></button>
				<button class="btn" onclick="return selectCBContent( '#JSStringFormat( entry.getSlug() )#','#JSStringFormat( entry.getTitle() )#','entry' )" title="Link"><i class="fa fa-link"></i></button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.oPaging.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
</cfoutput>