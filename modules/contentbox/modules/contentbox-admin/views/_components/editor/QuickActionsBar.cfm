<cfoutput>
	<!--- Back Button --->
	<button
		type="button"
		class="btn btn-link"
		<cfif len( prc.parentContentID )>
			onclick="location.href='#event.buildLink( prc.xehContentList )#/?parent=#prc.parentcontentID#'"
		<cfelse>
			onclick="location.href='#event.buildLink( prc.xehContentList )#'"
		</cfif>
	>
		#cbAdminComponent( "ui/Icon", { name : "ArrowLeftCircle" } )#
		Back
	</button>
	
	<!--- Drop Actions --->
	<cfif prc.oContent.isLoaded()>
		<div class="btn-group">
			<button
				class="btn btn-link dropdown-toggle"
				data-toggle="dropdown"
				title="Quick Actions"
			>
				#cbAdminComponent( "ui/Icon", { name : "EllipsisHorizontalCircle" } )#
				Actions 
				#cbAdminComponent( "ui/Icon", { name : "ChevronDown", size : "sm" } )#
		
			</button>
			<ul class="dropdown-menu">
				<li>
					<a href="#prc.CBHelper.linkContent( prc.oContent )#" target="_blank">
						<i class="fa fa-eye fa-lg"></i> Open In Site
					</a>
				</li>
			</ul>
		</div>
	</cfif>
	</cfoutput>