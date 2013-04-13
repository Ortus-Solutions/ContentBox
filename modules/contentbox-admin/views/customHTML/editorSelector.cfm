<cfoutput>
<h2><i class="icon-tasks"></i> CustomHTML Chooser</h2>
<div>
#html.startForm(name="entryEditorSelectorForm")#

	<!--- Loader --->
	<div class="loaders floatRight" id="entryLoader">
		<i class="icon-spinner icon-spin icon-large icon-2x"></i>
	</div>
	
	<!--- Content Bar --->
	<div class="well well-small" id="contentBar">

		<!--- Filter Bar --->
		<div class="filterBar">
			<div>
				#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
				#html.textField(name="entryFilter",size="30",class="textfield")#
			</div>
		</div>
	</div>

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
			
#html.endForm()#
</div>
<!--- Button Bar --->
<div class="text-center form-actions">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>