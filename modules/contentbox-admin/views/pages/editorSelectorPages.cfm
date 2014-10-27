<cfoutput>
<!--- pages --->
<table name="pages" id="pages" class="table table-bordered table-condensed table-striped table-hover" width="100%">
	<thead>
		<tr class="info">
			<th>Page Name</th>
			<th width="40" class="text-center"><i class="icon-globe icon-large"></i></th>
			<th width="120" class="text-center">Select</th>
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
			<td class="text-center">
				<cfif page.getIsPublished()>
					<i class="fa fa-check icon-large textGreen"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="fa fa-times icon-large textRed"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="text-center">
				<button class="btn btn-sm" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'pagessl' )" title="SSL Link"><i class="fa fa-lock icon-large"></i></button>
				<button class="btn btn-sm" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'page' )" title="Link"><i class="fa fa-link icon-large"></i></button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.pagingPlugin.renderit(foundRows=prc.pagesCount, link=prc.pagingLink, asList=true)#
</cfoutput>