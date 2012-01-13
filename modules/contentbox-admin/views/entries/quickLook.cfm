<cfoutput>
<h2>#rc.entry.getTitle()#</h2>
<div>
#rc.entry.renderContent()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
		<button class="button2" onclick="return to('#event.buildLink(rc.xehEntryEditor)#/entryID/#rc.entry.getEntryID()#')"> Edit </button>
	</cfif>
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>