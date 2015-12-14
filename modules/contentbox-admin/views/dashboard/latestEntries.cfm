<cfoutput>
#html.anchor(name="recentEntries" )#
<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN" )>
    <div class="pull-right">
    	<button class="btn btn-sm btn-primary" id="btnCreateEntry" onclick="return to('#event.buildLink(prc.xehBlogEditor)#')"><i class="fa fa-plus"></i> #$r( "dashboard.latestEntries.head@admin" )#</button>
    </div>				
</cfif>
<h3><i class="fa fa-quote-left"></i> #$r( "dashboard.latestEntries.head@admin" )#</h3>		
#prc.entriesViewlet#
</cfoutput>