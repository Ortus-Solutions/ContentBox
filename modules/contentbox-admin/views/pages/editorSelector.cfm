<cfoutput>
<h2>Link To A ContentBox Page</h2>
<div>
#html.startForm(name="pageEditorSelectorForm")#

	<!--- Loader --->
	<div class="loaders floatRight" id="pageLoader">
		<i class="icon-spinner icon-spin icon-large"></i>
	</div>

	<!--- Content Bar --->
	<div class="contentBar" id="contentBar">

		<!--- Filter Bar --->
		<div class="filterBar">
			<div>
				#html.label(field="pageFilter",content="Quick Filter:",class="inline")#
				#html.textField(name="pageFilter",size="30",class="textfield")#
			</div>
		</div>
	</div>

	<!--- Paging --->
	#prc.pagingPlugin.renderit(prc.pagesCount,prc.pagingLink)#

	<!--- pages --->
	<table name="pages" id="pages" class="tablesorter" width="98%">
		<thead>
			<tr>
				<th>Page Name</th>
				<th width="40" class="center"><i class="icon-globe icon-large"></i></th>
				<th width="120" class="center">Select</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#prc.pages#" index="page">
			<tr id="contentID-#page.getContentID()#" <cfif NOT page.getIsPublished()>class="selected"</cfif>>
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
					<button class="button2" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'pagessl' )"><i class="icon-lock icon-large"></i></button>
					<button class="button2" onclick="return selectCBContent( '#page.getSlug()#', '#page.getTitle()#', 'page' )"><i class="icon-link icon-large"></i></button>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>
	
	<!--- Paging --->
	#prc.pagingPlugin.renderit(prc.pagesCount,prc.pagingLink)#

#html.endForm()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>