<cfoutput>
#html.anchor(name="recentContentStore")#
<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN")>
<div class="buttonBar">
	<button class="btn" id="btnCreateContent" onclick="return to('#event.buildLink( prc.xehContentStoreEditor )#')"><i class="icon-plus-sign"></i> Create New Content</button>
</div>				
</cfif>
<div class="filterBar">
	<h3><i class="icon-quote-left"></i> Recent Content Store</h3>
</div>				
#prc.contentStoreViewlet#
</cfoutput>