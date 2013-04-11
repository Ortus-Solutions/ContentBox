<cfoutput>
<h2><i class="icon-eye-open"></i> #prc.entry.getTitle()#</h2>
<div>
#prc.entry.renderContent()#
</div>
<!--- Button Bar --->
<div class="text-center form-actions">
	<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
		<button class="btn btn-primary" onclick="return to('#event.buildLink(prc.xehEntryEditor)#/contentID/#prc.entry.getContentID()#')"> Edit </button>
	</cfif>
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>