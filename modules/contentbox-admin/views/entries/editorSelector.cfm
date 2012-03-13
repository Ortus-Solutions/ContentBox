<cfoutput>
<h2>Link To A ContentBox Entry</h2>
<div>
#html.startForm(name="entryEditorSelectorForm")#

	<!--- Loader --->
	<div class="loaders floatRight" id="entryLoader">
		<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
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
				<th width="15" class="center {sorter:false}"></th>
				<th>Entry Name</th>
				<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/publish.png" alt="publish" title="Published"/></th>
				<th width="40" class="center">Select</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#prc.entries#" index="entry">
			<tr id="contentID-#entry.getContentID()#" <cfif NOT entry.getIsPublished()>class="selected"</cfif>>
				<td class="middle">
					<img src="#prc.cbRoot#/includes/images/pen.png" alt="child"/>
				</td>
				<td>
					<!--- Title --->
					<strong>#entry.getTitle()#</strong>
				</td>
				<td class="center">
					<cfif entry.getIsPublished()>
						<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Published!" />
						<span class="hidden">published</span>
					<cfelse>
						<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="draft" title="Draft!" />
						<span class="hidden">draft</span>
					</cfif>
				</td>
				<td class="center">
					<button class="button2" onclick="return selectCBContent('#entry.getSlug()#','#entry.getTitle()#','entry')">Select</button>
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