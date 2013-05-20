<cfoutput>
#html.anchor(name="recentEntries")#
<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
<div class="buttonBar">
	<button class="btn" id="btnCreateEntry" onclick="return to('#event.buildLink(prc.xehBlogEditor)#')"><i class="icon-plus-sign"></i> Create New Entry</button>
</div>				
</cfif>
<div class="filterBar">
	<h3><i class="icon-quote-left"></i> Recent Entries</h3>
</div>				
#prc.entriesViewlet#
</cfoutput>