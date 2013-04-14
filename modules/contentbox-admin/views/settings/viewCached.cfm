<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Cached Settings</h3>
</div>
<div class="modal-body">
    <h4>Cached Metadata</h4>
    <!--- settings --->
    <table class="table table-hover table-condensed table-striped" width="98%">
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
    			<td class="center">#rc.metadata.lastAccessed#</td>
    			<td class="center">#rc.metadata.timeout#</td>
    			<td class="center">#rc.metadata.lastAccessTimeout#</td>
    		</tr>
    	</tbody>
    </table>
    
    <h4>Cached Data</h4>
    <!--- settings --->
    <table name="settings" id="settings" class="table table-hover table-condensed table-striped" width="98%">
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
    			<td>#HTMLEditFormat( rc.settings.value )#</td>
    		</tr>
    		</cfloop>
    	</tbody>
    </table>
</div>
<!--- Button Bar --->
<div class="modal-footer">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>