<cfoutput>
<h2>Link To A ContentBox Page</h2>
<div>
#html.startForm(name="pageEditorSelectorForm")#

	<!--- Loader --->
	<div class="loaders floatRight" id="pageLoader">
		<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
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
				<th width="15" class="center {sorter:false}"></th>
				<th>Page Name</th>
				<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/publish.png" alt="publish" title="Published"/></th>
				<th width="40" class="center">Select</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#prc.pages#" index="page">
			<tr id="contentID-#page.getContentID()#" <cfif NOT page.getIsPublished()>class="selected"</cfif>>
				<td class="middle">
					<img src="#prc.cbRoot#/includes/images/page.png" alt="child"/>
				</td>
				<td>
					<!--- Title --->
					<strong>#page.getSlug()#</strong>
				</td>
				<td class="center">
					<cfif page.getIsPublished()>
						<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Page Published!" />
						<span class="hidden">published</span>
					<cfelse>
						<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="draft" title="Page Draft!" />
						<span class="hidden">draft</span>
					</cfif>
				</td>
				<td class="center">
					<button class="button2" onclick="return selectCBContent('#page.getSlug()#','#page.getTitle()#','page')">Select</button>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>

#html.endForm()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>