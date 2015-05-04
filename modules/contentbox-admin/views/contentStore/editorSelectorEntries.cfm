<cfoutput>
<!--- content --->
<table name="content" id="content" class="tablesorter table table-hover table-striped table-condensed" width="98%">
	<thead>
		<tr>
			<th>Title</th>
			<th width="40" class="center"><i class="icon-globe icon-large"></i></th>
			<th width="120" class="center">Insert</th>
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
			<td class="center">
				<cfif entry.getIsPublished()>
					<i class="icon-ok icon-large textGreen"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="icon-remove icon-large textRed"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">
				<div class="btn-group">
				<button class="btn btn-primary" onclick="return insertContentStore('#entry.getSlug()#')">Insert</button>
				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.pagingPlugin.renderit(foundRows=prc.contentCount, link=prc.pagingLink, asList=true)#
</cfoutput>