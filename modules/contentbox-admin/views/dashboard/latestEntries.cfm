<cfoutput>
#html.anchor(name="recentEntries" )#
<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN" )>
    <div class="pull-right">
    	<button class="btn btn-sm btn-primary" id="btnCreateEntry" onclick="return to('#event.buildLink(prc.xehBlogEditor)#')"><i class="fa fa-plus"></i> Create New Entry</button>
    </div>				
</cfif>
<h3><i class="fa fa-quote-left"></i> Recent Entries</h3>		
#prc.entriesViewlet#
</cfoutput>