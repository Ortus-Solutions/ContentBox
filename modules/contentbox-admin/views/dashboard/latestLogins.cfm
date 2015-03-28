<cfoutput>
<table class="table table-condensed table-hover table-striped tablesorter" width="100%">
	<thead>
		<tr>
			<th>User</th>
			<th >Date</th>
			<th width="40" class="center">IP</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.lastLogins#" index="lastlogin">
			<tr>
				<td>
				#lastlogin.getValue()#
				</td>
				<td>#LSDateFormat(lastlogin.getCreatedDate())# #LSTimeFormat(lastlogin.getCreatedDate())#</td>
				<td class="center">#lastlogin.getLastLoginSuccessIP()#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>