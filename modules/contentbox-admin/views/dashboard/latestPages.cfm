<cfoutput>
#html.anchor(name="recentPages" )#
<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN" )>
    <div class="pull-right">
    	<button class="btn btn-sm btn-primary" id="btnCreateEntry" onclick="return to('#event.buildLink(prc.xehPageEditor)#')"><i class="fa fa-plus"></i> #$r( "dashboard.latestPages.button@admin" )#</button>
    </div>				
</cfif>
<h3><i class="fa fa-pencil"></i> #$r( "dashboard.latestPages.head@admin" )#</h3>			
#prc.pagesViewlet#	
</cfoutput>