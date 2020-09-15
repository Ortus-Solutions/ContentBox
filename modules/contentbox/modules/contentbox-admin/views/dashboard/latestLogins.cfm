<cfoutput>
<table class="table table-hover table-striped-removed" width="100%">
	<thead>
		<tr>
			<th>#$r( "dashboard.latestLogins.table.head1@admin" )#</th>
			<th >#$r( "dashboard.latestLogins.table.head2@admin" )#</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.lastLogins#" index="lastlogin">
			<tr>
				<td>#lastlogin.getValue()#</td>
				<td>#lastLogin.getDisplayCreatedDate()#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>