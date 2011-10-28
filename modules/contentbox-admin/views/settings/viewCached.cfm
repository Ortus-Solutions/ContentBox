<cfoutput>
<h2>Cached Settings</h2>

<h3>Cached Metadata</h3>
<!--- settings --->
<table class="tablelisting" width="98%">
	<thead>
		<tr>
			<th>Hits</th>
			<th>Expired</th>
			<th>Created</th>
			<th>Last Accessed</th>
			<th>Timeout</th>
			<th>Last Access Timeout</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="center">#rc.metadata.hits#</td>
			<td class="center">#rc.metadata.isExpired#</td>
			<td class="center">#rc.metadata.created#</td>
			<td class="center">#rc.metadata.lastAccesed#</td>
			<td class="center">#rc.metadata.timeout#</td>
			<td class="center">#rc.metadata.lastAccessTimeout#</td>
		</tr>
	</tbody>
</table>

<h3>Cached Data</h3>
<!--- settings --->
<table name="settings" id="settings" class="tablelisting" width="98%">
	<thead>
		<tr>
			<th width="250">Name</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="rc.settings">
		<tr>
			<td>#rc.settings.name#</td>
			<td>#rc.settings.value#</td>
		</tr>
		</cfloop>
	</tbody>
</table>
	
<hr/>

<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>