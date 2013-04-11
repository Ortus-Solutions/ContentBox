<cfoutput>
<h2>#prc.entry.getTitle()#</h2>
<div>
#prc.entry.renderContent()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
		<button class="btn btn-primary" onclick="return to('#event.buildLink(prc.xehEntryEditor)#/contentID/#prc.entry.getContentID()#')"> Edit </button>
	</cfif>
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>