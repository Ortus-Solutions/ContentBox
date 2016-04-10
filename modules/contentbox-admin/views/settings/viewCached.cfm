<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3>Cached Settings</h3>
        </div>
        <div class="modal-body">
            <h2>Cached Metadata</h2>
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
            			<td class="text-center">#prc.metadata.hits#</td>
            			<td class="text-center">#prc.metadata.isExpired#</td>
            			<td class="text-center">#prc.metadata.created#</td>
            			<td class="text-center">#prc.metadata.lastAccessed#</td>
            			<td class="text-center">#prc.metadata.timeout#</td>
            			<td class="text-center">#prc.metadata.lastAccessTimeout#</td>
            		</tr>
            	</tbody>
            </table>
            
            <h2>Cached Data</h2>
            <!--- settings --->
            <table name="settings" id="settings" class="table table-hover table-condensed table-striped" width="98%">
            	<thead>
            		<tr>
            			<th width="250">Name</th>
            			<th>Value</th>
            		</tr>
            	</thead>
            	<tbody>
            		<cfloop query="prc.settings">
            		<tr>
            			<td>#HTMLEditFormat( prc.settings.name )#</td>
            			<td>#HTMLEditFormat( prc.settings.value )#</td>
            		</tr>
            		</cfloop>
            	</tbody>
            </table>
        </div>
        <!--- Button Bar --->
        <div class="modal-footer">
        	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
        </div>
    </div>
</div>
</cfoutput>