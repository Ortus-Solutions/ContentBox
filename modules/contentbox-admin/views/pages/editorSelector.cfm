<cfoutput>
<h2>Link To A ContentBox Page</h2>
<div>
#html.startForm(name="pageEditorSelectorForm")#

	<!--- Loader --->
	<div class="loaders floatRight" id="pageLoader">
		<i class="icon-spinner icon-spin icon-large"></i>
	</div>

	<!--- Content Bar --->
	<div class="well well-small" id="contentBar">

		<!--- Filter Bar --->
		<div class="filterBar">
			<div>
				#html.label(field="pageFilter",content="Quick Filter:",class="inline")#
				#html.textField(name="pageFilter",size="30",class="textfield")#
			</div>
		</div>
	</div>

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
					<strong>#page.getSlug()#</strong>
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
					<button class="btn" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'pagessl' )"><i class="icon-lock icon-large"></i></button>
					<button class="btn" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'page' )"><i class="icon-link icon-large"></i></button>
					</div>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>
	
	<!--- Paging --->
	#prc.pagingPlugin.renderit(foundRows=prc.pagesCount, link=prc.pagingLink, asList=true)#

#html.endForm()#
</div>
<!--- Button Bar --->
<div class="text-center form-actions">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>