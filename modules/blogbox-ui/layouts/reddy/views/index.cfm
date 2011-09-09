<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_preIndexDisplay")#

<!--- SideBar --->
<div id="sidebar">#bb.quickView(view='sidebar')#</div>

<!--- content --->
<div id="text" >
	
	<!--- Are we filtering by category? --->
	<cfif len(rc.category)>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#bb.linkHome()#')" title="Remove filter and view all entries">Remove Filter</button>
		</div>
		<div class="infoBar">
			Category Filtering: '#rc.category#'
		</div>
		<br/>
	</cfif>
	
	<!--- Are we searching --->
	<cfif len(rc.q)>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#bb.linkHome()#')" title="Clear search and view all entries">Clear Search</button>
		</div>
		<div class="infoBar">
			Searching by: '#rc.q#'
		</div>
		<br/>
	</cfif>
	
	<!--- 
		Display Entries using BlogBox collection template rendering
		The default convention for the template is "entry.cfm" you can change it via the quickEntries() 'template' argument.
		I could have done it manually, but why?
	 --->
	#bb.quickEntries()#
	
	<!--- Paging via BlogBox via quick HTML, again I could have done it manually, but why? --->
	<cfif prc.entriesCount>
		<div class="contentBar">#bb.quickPaging()#</div>
	</cfif>
	
</div>
<!--- BlogBoxEvent --->
#bb.event("bbui_postIndexDisplay")#	
</cfoutput>