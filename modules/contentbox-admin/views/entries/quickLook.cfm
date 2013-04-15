<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3><i class="icon-eye-open"></i> #prc.entry.getTitle()#</h3>
</div>
<div class="modal-body">
	#prc.entry.renderContent()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
	<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
		<button class="btn btn-primary" onclick="return to('#event.buildLink(prc.xehEntryEditor)#/contentID/#prc.entry.getContentID()#')"> Edit </button>
	</cfif>
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>