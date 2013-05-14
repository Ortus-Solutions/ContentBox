<cfoutput>
<!--- entries --->
<table name="entries" id="entries" class="tablesorter table table-condensed table-striped table-hover" width="98%">
	<thead>
		<tr>
			<th>CustomHTML</th>
			<th width="40" class="center">Select</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.entries#" index="entry">
		<tr id="contentID-#entry.getContentID()#">
			<td>
				<!--- Title --->
				<strong>#entry.getTitle()#</strong>
				<br/>
				#entry.getDescription()#
			</td>
			<td class="center">
				<button class="btn btn-primary" onclick="return insertCustomHTML('#entry.getSlug()#')">Select</button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.pagingPlugin.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
</cfoutput>