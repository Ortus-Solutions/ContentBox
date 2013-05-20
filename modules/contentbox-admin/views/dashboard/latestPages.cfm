<cfoutput>
#html.anchor(name="recentPages")#
<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
<div class="buttonBar">
	<button class="btn" id="btnCreateEntry" onclick="return to('#event.buildLink(prc.xehPageEditor)#')"><i class="icon-plus-sign"></i> Create New Page</button>
</div>				
</cfif>
<div class="filterBar">
	<h3><i class="icon-pencil"></i> Recent Pages</h3>
</div>				
#prc.pagesViewlet#	
</cfoutput>