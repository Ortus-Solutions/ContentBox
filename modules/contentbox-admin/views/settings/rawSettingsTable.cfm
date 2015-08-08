<cfoutput>
<!--- settings --->
<table name="settings" id="settings" class="table-bordered table table-striped table-hover table-condensed" width="100%">
	<thead>
		<tr class="info">
			<th width="280">Name</th>
			<th>Value</th>
			<th width="80" class="text-center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.settings#" index="setting">
		<tr>
			<td>
				<a href="javascript:edit(
					'#setting.getSettingId()#',
					'#HTMLEditFormat( setting.getName() )#',
					'#HTMLEditFormat( JSStringFormat( setting.getValue() ) )#')" title="Edit Setting">#setting.getName()#</a>
			</td>
			<td>
				<cfif len( setting.getValue() ) gt 90 >
					#html.textarea(
						value=setting.getValue(), 
						rows="5",
						class="form-control"
					)#
				<cfelse>
					#htmlEditFormat( setting.getValue() )#
				</cfif>
			</td>
			<td class="text-center">
				<div class="btn-group btn-group-sm">
					<!--- Edit Command --->
					<a class="btn btn-sm btn-primary" href="javascript:edit('#setting.getSettingId()#',
											 '#HTMLEditFormat( setting.getName() )#',
											 '#HTMLEditFormat( JSStringFormat( setting.getValue() ) )#')" title="Edit Setting"><i class="fa fa-edit fa-lg"></i></a>
					<!--- Delete Command --->
					<a class="btn btn-sm btn-danger" title="Delete Setting" href="javascript:remove('#setting.getsettingID()#')" class="confirmIt" data-title="<i class='fa fa-trash-o'></i> Delete Setting?"><i class="fa fa-trash-o fa-lg" id="delete_#setting.getsettingID()#"></i></a>
				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.viewAll>
	#prc.oPaging.renderit(
		foundRows=prc.settingsCount, 
		link=prc.pagingLink, 
		asList=true
	)#
</cfif>
</cfoutput>