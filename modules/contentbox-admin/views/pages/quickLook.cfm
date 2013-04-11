<cfoutput>
<h2><i class="icon-eye-open"></i> #prc.page.getTitle()#</h2>
<div>
#prc.page.renderContent()#
</div>
<!--- Button Bar --->
<div class="text-center form-actions">
	<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
	<button class="btn btn-primary" onclick="return to('#event.buildLink(prc.xehPageEditor)#/contentID/#prc.page.getContentID()#')"> Edit </button>
	</cfif>
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>