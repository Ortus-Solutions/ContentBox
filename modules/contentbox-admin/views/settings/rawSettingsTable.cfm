<cfoutput>
<!--- settings --->
<table name="settings" id="settings" class="tablesorter table table-striped table-hover table-condensed" width="98%">
	<thead>
		<tr>
			<th width="250">Name</th>
			<th>Value</th>
			<th width="125" class="center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.settings#" index="setting">
		<tr>
			<td><a href="javascript:edit('#setting.getSettingId()#',
										 '#HTMLEditFormat( setting.getName() )#',
										 '#HTMLEditFormat( JSStringFormat( setting.getValue() ) )#')" title="Edit Setting">#setting.getName()#</a></td>
			<td>
				<cfif len( setting.getValue() ) gt 90 >
					#html.textarea(value=setting.getValue(), rows="5", cols="5")#
				<cfelse>
					#htmlEditFormat( setting.getValue() )#
				</cfif>
			</td>
			<td class="center">
				<!--- Edit Command --->
				<a href="javascript:edit('#setting.getSettingId()#',
										 '#HTMLEditFormat( setting.getName() )#',
										 '#HTMLEditFormat( JSStringFormat( setting.getValue() ) )#')" title="Edit Setting"><i class="icon-edit icon-large"></i></a>
				<!--- Delete Command --->
				<a title="Delete Setting" href="javascript:remove('#setting.getsettingID()#')" class="confirmIt" data-title="Delete Setting?"><i class="icon-trash icon-large" id="delete_#setting.getsettingID()#"></i></a>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.viewAll>
#prc.pagingPlugin.renderit(foundRows=prc.settingsCount, link=prc.pagingLink, asList=true)#
</cfif>
</cfoutput>