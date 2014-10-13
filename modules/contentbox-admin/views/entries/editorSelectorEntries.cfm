<cfoutput>
<!--- entries --->
<table name="entries" id="entries" class="table table-bordered table-condensed table-striped table-hover" width="100%">
	<thead>
		<tr class="info">
			<th>Entry Title</th>
			<th width="40" class="center"><i class="icon-globe icon-large"></i></th>
			<th width="120" class="center">Select</th>
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
			<td class="center">
				<cfif entry.getIsPublished()>
					<i class="fa fa-check icon-large textGreen"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="fa fa-times icon-large textRed"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">
				<button class="btn btn-sm" onclick="return selectCBContent( '#entry.getSlug()#', '#entry.getTitle()#', 'entryssl' )" title="SSL Link"><i class="fa fa-lock icon-large"></i></button>
				<button class="btn btn-sm" onclick="return selectCBContent( '#entry.getSlug()#','#entry.getTitle()#','entry' )" title="Link"><i class="fa fa-link icon-large"></i></button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.pagingPlugin.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
</cfoutput>