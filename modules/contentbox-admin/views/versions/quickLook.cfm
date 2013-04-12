<cfoutput>
<h2><i class="icon-eye-open"></i> Version: #prc.contentVersion.getVersion()# - Active: #yesNoFormat( prc.contentVersion.getIsActive() )#</h2>
<div>
#prc.contentVersion.renderContent()#
</div>
<!--- Button Bar --->
<div class="text-center form-actions">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>