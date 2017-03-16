<cfoutput>
<!--- pages --->
<table name="pages" id="pages" class="table table-condensed table-striped table-hover" width="100%">
	<thead>
		<tr>
			<th>Page Name</th>
			<th width="40" class="text-center"><i class="fa fa-globe fa-lg"></i></th>
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
					<i class="fa fa-check fa-lg textGreen"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="fa fa-times fa-lg textRed"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="text-center">
				<button class="btn" onclick="return selectCBContent( '#JSStringFormat( page.getSlug() )#', '#JSStringFormat( page.getTitle() )#', 'pagessl' )" title="SSL Link"><i class="fa fa-lock"></i></button>
				<button class="btn" onclick="return selectCBContent( '#JSStringFormat( page.getSlug() )#', '#JSStringFormat( page.getTitle() )#', 'page' )" title="Link"><i class="fa fa-link"></i></button>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
#prc.oPaging.renderit(foundRows=prc.pagesCount, link=prc.pagingLink, asList=true)#
</cfoutput>