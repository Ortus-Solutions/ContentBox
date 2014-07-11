<cfoutput>
<!--- pages --->
<table name="pages" id="pages" class="tablesorter table table-condensed table-striped table-hover" width="98%">
	<thead>
		<tr>
			<th>Page Name</th>
			<th width="40" class="center"><i class="icon-globe icon-large"></i></th>
			<th width="120" class="center">Select</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.pages#" index="page">
		<tr id="contentID-#page.getContentID()#" <cfif NOT page.getIsPublished()>class="alert"</cfif>>
			<td>
				<!--- Title --->
				<strong>#page.getTitle()#</strong><br>
				<span class="label label-success">#page.getSlug()#</span>
			</td>
			<td class="center">
				<cfif page.getIsPublished()>
					<i class="icon-ok icon-large textGreen"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="icon-remove icon-large textRed"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">
				<div class="btn-group">
				<button class="btn" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'pagessl' )" title="SSL Link"><i class="icon-lock icon-large"></i></button>
				<button class="btn" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'page' )" title="Link"><i class="icon-link icon-large"></i></button>
				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.pagingPlugin.renderit(foundRows=prc.pagesCount, link=prc.pagingLink, asList=true)#
</cfoutput>