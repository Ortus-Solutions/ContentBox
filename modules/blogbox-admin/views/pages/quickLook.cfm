<cfoutput>
<h2>#prc.page.getTitle()#</h2>
<div>
#prc.page.getContent()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="button2" onclick="return to('#event.buildLink(prc.xehPageEditor)#/pageID/#prc.page.getPageID()#')"> Edit </button>
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>