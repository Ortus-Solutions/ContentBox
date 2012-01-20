<cfoutput>
<h2>ContentBox Editor Widget Selector</h2>
<div>
	<p>Which ContentBox widget would you like to insert in to your editor:</p>
	<!--- widgets --->
	<table name="widgets" id="widgets" class="tablesorter" width="98%">
		<thead>
			<tr>
				<th>Widget</th>
				<th>Description</th>
				<th width="75" class="center {sorter:false}">Actions</th>
			</tr>
		</thead>				
		<tbody>
			<cfloop query="prc.widgets">
			<cfset p = prc.widgets.plugin>
			<cfif isSimpleValue(p)>
				<tr class="selected">
					<td colspan="4">There is a problem creating widget: '#prc.widgets.name#', please check the application log files.</td>
				</tr>
			<cfelse>
			<tr>
				<td>
					<strong>#p.getPluginName()#</strong>
				</td>
				<td>
					#p.getPluginDescription()#
					<!--- Widget Argument Form --->
					<div id="widgetArgs_#prc.widgets.name#" style="display:none">#renderWidgetArgs(p.renderit,prc.widgets.name)#</div>
					
				</td>
				<td class="center">
					<button class="button" onclick="selectCBWidget('#prc.widgets.name#')">Select</button>
				</td>
			</tr>
			</cfif>
			</cfloop>
		</tbody>
	</table>
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Cancel </button>
</div>
</cfoutput>