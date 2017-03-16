<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		    <h3>WireBox Mapping For: #rc.id#</h3>
		</div>
		<div class="modal-body">
			<cfdump var="#prc.mapping.getMemento()#" expand="false">
		</div>
		<!--- Button Bar --->
		<div class="modal-footer">
			<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
		</div>
	</div>
</div>
</cfoutput>