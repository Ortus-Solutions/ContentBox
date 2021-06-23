<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">

        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3>Cached Settings</h3>
		</div>

        <div class="modal-body">
            <h4>Cached Metadata</h4>
            <!--- settings --->
            <table class="table table-hover  table-striped-removed" >
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

            <h4>Cached Data</h4>
            <div style="overflow: auto">
				<cfdump var="#prc.settings#">
			</div>
        </div>
        <!--- Button Bar --->
        <div class="modal-footer">
        	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
        </div>
    </div>
</div>
</cfoutput>
