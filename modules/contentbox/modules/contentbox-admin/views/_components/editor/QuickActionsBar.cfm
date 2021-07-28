<cfoutput>
<div class="btn-group btn-group-sm">
	<!--- Back Button --->
	<button
		type="button"
		class="btn btn-sm btn-primary"
		<cfif len( prc.parentContentID )>
			onclick="location.href='#event.buildLink( prc.xehContentList )#/?parent=#prc.parentcontentID#'"
		<cfelse>
			onclick="location.href='#event.buildLink( prc.xehContentList )#'"
		</cfif>
	>
		<i class="fas fa-chevron-left"></i> Back
	</button>

	<!--- Drop Actions --->
	<button
		class="btn btn-sm btn-primary dropdown-toggle"
		data-toggle="dropdown"
		title="Quick Actions"
	>
		<span class="caret"></span>
	</button>
	<ul class="dropdown-menu">
		<li>
			<a href="javascript:quickPublish( false )">
				<i class="fas fa-satellite-dish fa-lg"></i> Publish Now
			</a>
		</li>
		<li>
			<a href="javascript:quickPublish( true )">
				<i class="fas fa-eraser fa-lg"></i> Save as Draft
			</a>
		</li>
		<li>
			<a href="javascript:quickSave()">
				<i class="far fa-save fa-lg"></i> Quick Save
			</a>
		</li>
		<cfif prc.oContent.isLoaded()>
			<li>
				<a href="#prc.CBHelper.linkContent( prc.oContent )#" target="_blank">
					<i class="far fa-eye fa-lg"></i> Open In Site
				</a>
			</li>
		</cfif>
	</ul>
</div>
</cfoutput>