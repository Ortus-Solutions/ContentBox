<cfoutput>
<h2>#rc.entry.getTitle()#</h2>
<div>
#rc.entry.getContent()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="button2" onclick="return to('#event.buildLink(rc.xehEntryEditor)#/entryID/#rc.entry.getEntryID()#')"> Edit </button>
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>