<cfoutput>
<h2>ContentBox Editor Widget Selector</h2>
<div>
	<p>Which ContentBox widget would you like to insert in to your editor:</p>
	<!--- Filter Bar --->
	<div class="filterBar">
		<div>
			#html.label(field="widgetFilter",content="Quick Filter:",class="inline")#
			#html.textField(name="widgetFilter",size="30",class="textfield")#
		</div>
	</div>
	<!--- widgets --->
	<table name="widgets" id="widgets" class="tablesorter" width="98%">
		<thead>
			<tr>
				<th>Widget</th>
				<th>Description</th>
				<th>Type</th>
				<th width="75" class="center {sorter:false}">Actions</th>
			</tr>
		</thead>				
		<tbody>
			<cfloop query="prc.widgets">
				<cfscript>
					p = prc.widgets.plugin;
					widgetName = prc.widgets.name;
					widgetSelector = prc.widgets.name;
					switch( prc.widgets.widgettype ) {
						case 'module':
                        	widgetName &= "@" & prc.widgets.module;
                        	break;
                       	case 'layout':
                       		widgetName = "~" & widgetName;
                       		break;
					}
				</cfscript>					
			<cfif isSimpleValue(p)>
				<tr class="selected">
					<td colspan="4">There is a problem creating widget: '#widgetName#', please check the application log files.</td>
				</tr>
			<cfelse>
			<tr>
				<td>
					<strong>#p.getPluginName()#</strong>
				</td>
				<td>
					#p.getPluginDescription()#
					<!--- Widget Argument Form --->
					<div id="widgetArgs_#widgetName#" style="display:none">#renderWidgetArgs(p.renderit,widgetName)#</div>
					
				</td>
                <td>
                	<strong>#prc.widgets.widgettype#</strong>    
                </td>
				<td class="center">
					<button class="button" onclick="selectCBWidget('#widgetName#')">Select</button>
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