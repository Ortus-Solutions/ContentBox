<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		    <h3><i class="fa fa-eye fa-lg"></i> Version: #prc.contentVersion.getVersion()# - Active: #yesNoFormat( prc.contentVersion.getIsActive() )#</h3>
		</div>
		<div class="modal-body">
			#prc.contentVersion.renderContent()#
		</div>
		<!--- Button Bar --->
		<div class="modal-footer">
			<button class="btn" onclick="closeRemoteModal()"> Close </button>
		</div>
	</div>
</div>
</cfoutput>