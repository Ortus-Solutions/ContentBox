<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3><i class="icon-eye-open"></i> Version: #prc.contentVersion.getVersion()# - Active: #yesNoFormat( prc.contentVersion.getIsActive() )#</h3>
</div>
<div class="modal-body">
	#prc.contentVersion.renderContent()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>