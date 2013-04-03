<cfoutput>
<h2>Link To A ContentBox Entry</h2>
<div>
#html.startForm(name="entryEditorSelectorForm")#

	<!--- Loader --->
	<div class="loaders floatRight" id="entryLoader">
		<i class="icon-spinner icon-spin icon-large"></i>
	</div>

	<!--- Content Bar --->
	<div class="contentBar" id="contentBar">

		<!--- Filter Bar --->
		<div class="filterBar">
			<div>
				#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
				#html.textField(name="entryFilter",size="30",class="textfield")#
			</div>
		</div>
	</div>

	<!--- Paging --->
	#prc.pagingPlugin.renderit(prc.entriesCount,prc.pagingLink)#

	<!--- entries --->
	<table name="entries" id="entries" class="tablesorter" width="98%">
		<thead>
			<tr>
				<th>Entry Title</th>
				<th width="40" class="center"><i class="icon-globe icon-large"></i></th>
				<th width="120" class="center">Select</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#prc.entries#" index="entry">
			<tr id="contentID-#entry.getContentID()#" <cfif NOT entry.getIsPublished()>class="selected"</cfif>>
				<td>
					<!--- Title --->
					<strong>#entry.getTitle()#</strong>
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
					<button class="button2" onclick="return selectCBContent( '#entry.getSlug()#', '#entry.getTitle()#', 'entryssl' )" title="SSL Link"><i class="icon-lock icon-large"></i></button>
					<button class="button2" onclick="return selectCBContent( '#entry.getSlug()#','#entry.getTitle()#','entry' )" title="Link"><i class="icon-link icon-large"></i></button>
				</td>
			</tr>
			</cfloop>
		</tbody>
	</table>
	
	<!--- Paging --->
	#prc.pagingPlugin.renderit(prc.entriesCount,prc.pagingLink)#


#html.endForm()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>