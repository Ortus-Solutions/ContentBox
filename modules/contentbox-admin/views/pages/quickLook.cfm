<cfoutput>
<h2>#prc.page.getTitle()#</h2>
<div>
#prc.page.renderContent()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
	<button class="btn btn-primary" onclick="return to('#event.buildLink(prc.xehPageEditor)#/contentID/#prc.page.getContentID()#')"> Edit </button>
	</cfif>
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>