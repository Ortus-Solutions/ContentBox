<cfoutput>
<!--- content --->
<table name="content" id="content" class="table table-condensed table-striped table-hover" width="100%">
	<thead>
		<tr>
			<th>Title</th>
			<th width="40" class="text-center"><i class="fa fa-globe fa-lg"></i></th>
			<th width="120" class="text-center">Insert</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.content#" index="entry">
		<tr id="contentID-#entry.getContentID()#" <cfif NOT entry.getIsPublished()>class="warning"</cfif>
			ondblclick="return insertContentStore('#entry.getSlug()#')">
			<td>
				<!--- Title --->
				<strong>#entry.getTitle()#</strong><br>
				#entry.getDescription()#
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
				<button class="btn btn-sm btn-default" onclick="return insertContentStore('#entry.getSlug()#')">Insert</button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.oPaging.renderit(foundRows=prc.contentCount, link=prc.pagingLink, asList=true)#
</cfoutput>