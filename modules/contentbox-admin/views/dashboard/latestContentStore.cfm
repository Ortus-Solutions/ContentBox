<cfoutput>
#html.anchor(name="recentContentStore" )#
<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN" )>
    <div class="pull-right">
    	<button class="btn btn-sm btn-primary" id="btnCreateContent" onclick="return to('#event.buildLink( prc.xehContentStoreEditor )#')"><i class="fa fa-plus"></i> #$r( "dashboard.latestContentStore.button@admin" )#</button>
    </div>				
</cfif>
<h3><i class="fa fa-hdd-o"></i> #$r( "dashboard.latestContentStore.head@admin" )#</h3>			
#prc.contentStoreViewlet#
</cfoutput>